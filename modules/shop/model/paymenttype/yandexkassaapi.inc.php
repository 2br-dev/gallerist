<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/

namespace Shop\Model\PaymentType;

use Catalog\Model\CurrencyApi;
use Catalog\Model\Orm\Product;
use Main\Model\Requester\ExternalRequest;
use RS\Config\Loader;
use RS\Event\Exception as EventException;
use RS\Exception as RSException;
use RS\Helper\Tools as HelperTools;
use RS\Http\Request as HttpRequest;
use RS\Orm\FormObject;
use RS\Orm\PropertyIterator;
use RS\Orm\Type;
use RS\Router\Manager as RouterManager;
use Shop\Model\Cart;
use Shop\Model\ChangeTransaction;
use Shop\Model\Orm\Order;
use Shop\Model\Orm\OrderItem;
use Shop\Model\Orm\Transaction;
use Shop\Model\TaxApi;
use Shop\Model\TransactionAction;

/**
 * Способ оплаты - Яндекс.Касса API
 */
class YandexKassaApi extends AbstractType
{
    const API_URL = 'https://payment.yandex.net/api/v3/';
    const TRANSACTION_ACTION_HOLD_CAPTURE = 'hold_capture';
    const TRANSACTION_ACTION_HOLD_CANCEL = 'hold_cancel';

    /**
     * Возвращает название расчетного модуля (типа доставки)
     *
     * @return string
     */
    public function getTitle()
    {
        return t('Яндекс.Касса API');
    }

    /**
     * Возвращает описание типа оплаты. Возможен HTML
     *
     * @return string
     */
    public function getDescription()
    {
        return t('Оплата через сервис "Яндекс.Касса" API');
    }

    /**
     * Возвращает идентификатор данного типа оплаты. (только англ. буквы)
     *
     * @return string
     */
    public function getShortName()
    {
        return 'yandexkassaapi';
    }

    /**
     * Возвращает true, если данный тип поддерживает проведение платежа через интернет
     *
     * @return bool
     */
    public function canOnlinePay()
    {
        return true;
    }

    /**
     * Возвращает ORM объект для генерации формы или null
     *
     * @return FormObject | null
     */
    public function getFormObject()
    {
        $properties = new PropertyIterator([
            '__help__' => (new Type\MixedType())
                ->setDescription(t(''))
                ->setVisible(true)
                ->setTemplate('%shop%/form/payment/yandexkassaapi/help.tpl'),
            'shop_id' => (new Type\Integer())
                ->setDescription(t('Идентификатор магазина (shopId)'))
                ->setHint(t('Можно узнать в личном кабинете Яндекс.Кассы'))
                ->setChecker(Type\Checker::CHECK_EMPTY, t('Не указан "Идентификатор магазина (shopId)"')),
            'key_secret' => (new Type\Varchar())
                ->setDescription(t('Секретный ключ'))
                ->setHint(t('Можно узнать в личном кабинете Яндекс.Кассы'))
                ->setChecker(Type\Checker::CHECK_EMPTY, t('Не указан "Секретный ключ"')),
            'is_holding' => (new Type\Integer())
                ->setDescription(t('Холдирование платежей'))
                ->setMaxLength(1)
                ->setDefault(0)
                ->setCheckboxView(1, 0),
            'enable_log' => (new Type\Integer())
                ->setDescription(t('Вести лог запросов?'))
                ->setMaxLength(1)
                ->setDefault(0)
                ->setCheckboxView(1, 0),
        ]);

        $form_object = new FormObject($properties);
        $form_object->setParentObject($this);
        $form_object->setParentParamMethod('Form');
        return $form_object;
    }

    /**
     * Возвращает URL для перехода на сайт сервиса оплаты для совершения платежа
     * Используется только для Online-платежей
     *
     * @param Transaction $transaction
     * @return string
     * @throws RSException
     */
    public function getPayUrl(Transaction $transaction)
    {
        $response = $this->createPayment($transaction);
        if (empty($response['confirmation']['confirmation_url'])) {
            // todo обработать ошибку
        }

        return $response['confirmation']['confirmation_url'];
    }

    /**
     * Возвращает ID заказа исходя из REQUEST-параметров соотвествующего типа оплаты
     * Используется только для Online-платежей
     *
     * @param HttpRequest $request
     * @return mixed
     */
    public function getTransactionIdFromRequest(HttpRequest $request)
    {
        $content = json_decode($request->getStreamInput(), true);
        if (!empty($content['object']['metadata']['transaction_id'])) {
            return $content['object']['metadata']['transaction_id'];
        }
        return $request->request('transaction', TYPE_INTEGER, false);
    }

    /**
     * Вызывается при оплате сервером платежной системы.
     * Возвращает строку - ответ серверу платежной системы.
     * В случае неверной подписи бросает исключение
     * Используется только для Online-платежей
     *
     * @param Transaction $transaction
     * @param HttpRequest $request
     * @return string
     * @throws RSException
     */
    public function onResult(Transaction $transaction, HttpRequest $request)
    {
        $payment_data = $transaction->getExtra(Transaction::EXTRA_KEY_PAYMENT);
        if (!empty($payment_data['id'])) {
            $response = $this->apiRequest("/payments/{$payment_data['id']}", 'GET');
            return $this->changeTransactionFromResponse($transaction, $response, true);
        } else {
            throw new RSException(t('Транзакция не содержит идентификатор платежа'));
        }
    }

    /**
     * Создаёт платёж в ЯКассе
     *
     * @param Transaction $transaction
     * @return array
     * @throws RSException
     */
    public function createPayment(Transaction $transaction)
    {
        $params = [
            'amount' => [
                'value' => $transaction['cost'],
                'currency' => CurrencyApi::getBaseCurrency()['title'],
            ],
            'description' => $transaction['reason'],
            'receipt' => $this->getParamsForFZ54Check($transaction),
            'confirmation' => [
                'type' => 'redirect',
                'return_url' => RouterManager::obj()->getUrl('shop-front-onlinepay', [
                    'PaymentType' => $this->getShortName(),
                    'Act' => 'status',
                    'transaction' => $transaction['id'],
                ], true),
            ],
            'save_payment_method' => false, // todo заменить на true, реализовать сохранение способов оплаты
            'capture' => ($this->getOption('is_holding')) ? false : true,
            'metadata' => [
                'transaction_id' => $transaction['id'],
            ],
        ];
        $response = $this->apiRequest('payments', 'POST', $params, $transaction['id']);
        $transaction->setExtra(Transaction::EXTRA_KEY_PAYMENT, ['id' => $response['id']]);
        $transaction->update();

        return $response;
    }

    /**
     * Возвращает дополнительные параметры для печати чека по ФЗ-54
     *
     * @param Transaction $transaction - объект транзакции
     * @return array
     * @throws EventException
     * @throws RSException
     */
    protected function getParamsForFZ54Check($transaction)
    {
        $result = [
            'customer' => $this->getFZ54CheckCustomerData($transaction),
            'items' => $this->getFZ54CheckItemsData($transaction),
        ];

        return $result;
    }

    /**
     * Возвращает данные секции "пользователь" для чека ФЗ-54
     *
     * @param Transaction $transaction - объект транзакции
     * @return array
     */
    protected function getFZ54CheckCustomerData(Transaction $transaction)
    {
        $user = $transaction->getUser();
        $full_name = ($user['is_company'] && !empty($user['company'])) ? $user['company'] : $user->getFio();

        $customer = [
            'full_name' => mb_substr($full_name, 0,256),
        ];
        if (!empty($user['company_inn'])) {
            $customer['inn'] = $user['company_inn'];
        }
        if (!empty($user['e_mail'])) {
            $customer['email'] = $user['e_mail'];
        }
        if (!empty($user['company_inn'])) {
            $customer['phone'] = preg_replace(['/[^\d]/'], [''], $user['phone']);
        }

        return $customer;
    }

    /**
     * Возвращает данные секции "список товаров" для чека ФЗ-54
     *
     * @param Transaction $transaction - объект транзакции
     * @return array
     * @throws EventException
     * @throws RSException
     */
    protected function getFZ54CheckItemsData(Transaction $transaction)
    {
        $user = $transaction->getUser();
        $base_currency = CurrencyApi::getBaseCurrency();
        $items = [];

        if ($transaction['order_id'] && !$transaction['entity']) {
            $order = $transaction->getOrder();
            $address = $order->getAddress();
            if ($cart = $order->getCart()) {
                foreach ($cart->getProductItems() as $item) {
                    /** @var OrderItem $order_item */
                    $order_item = $item[Cart::CART_ITEM_KEY];
                    /** @var Product $product */
                    $product = $order_item->getEntity();
                    $title = $order_item['title'] . (($order_item['model']) ? " ({$order_item['model']})" : '');
                    $title = str_replace(["\"", "'"],'`', HelperTools::unEntityString($title));

                    $items[] = [
                        'description' => mb_substr($title, 0, 128),
                        'quantity' => $order_item['amount'],
                        'amount' => [
                            'value' => sprintf('%0.2f', round($order_item['price'] - $order_item['discount'], 2)),
                            'currency' => $base_currency['title'],
                        ],
                        'vat_code' => $this->getNdsCode(TaxApi::getProductTaxes($product, $user, $address), $address),
                        'payment_subject' => $product['payment_subject'],
                        'payment_mode' => $product['payment_method'] ?: $order->getDefaultPaymentMethod(),
                    ];
                }

                foreach ($cart->getCartItemsByType(Cart::TYPE_DELIVERY) as $delivery_item) {
                    $delivery = $order->getDelivery();
                    $title = str_replace(["\"", "'"],'`', HelperTools::unEntityString($delivery_item['title']));

                    $items[] = [
                        'description' => mb_substr($title, 0, 128),
                        'quantity' => 1,
                        'amount' => [
                            'value' => sprintf('%0.2f', round($delivery_item['price'] - $delivery_item['discount'], 2)),
                            'currency' => $base_currency['title'],
                        ],
                        'vat_code' => $this->getNdsCode(TaxApi::getDeliveryTaxes($order->getDelivery(), $user, $address), $address),
                        'payment_subject' => 'service',
                        'payment_mode' => $delivery['payment_method'] ?: $order->getDefaultPaymentMethod(),
                    ];
                }
            }
        } elseif ($transaction['personal_account']) {
            $shop_config = Loader::byModule($this);

            $items[] = [
                'description' => mb_substr($transaction['reason'], 0, 128),
                'quantity' => 1,
                'amount' => [
                    'value' => sprintf('%0.2f', round($transaction['cost'], 2)),
                    'currency' => $base_currency['title'],
                ],
                'vat_code' => self::handbookNds()[$shop_config['nds_personal_account']] ?? self::handbookNds()[TaxApi::TAX_NDS_NONE],
                'payment_subject' => $shop_config['personal_account_payment_subject'],
                'payment_mode' => $shop_config['personal_account_payment_method'],
            ];
        }

        return $items;
    }

    /**
     * Отправляет запрос по API
     *
     * @param string $url - адрес запроса
     * @param string $method - метод запроса
     * @param array $params - параметры
     * @param string $idempotence_key - ключ идемпотентности
     * @return array
     * @throws RSException
     */
    public function apiRequest(string $url, string $method, array $params = [], string $idempotence_key = '')
    {
        $shop_id = $this->getOption('shop_id');
        $secret = $this->getOption('key_secret');

        $external_response = (new ExternalRequest('payment_' . $this->getShortName(), self::API_URL . $url))
            ->setMethod($method)
            ->setParams($params)
            ->setBasicAuth($shop_id, $secret)
            ->setContentType(ExternalRequest::CONTENT_TYPE_JSON)
            ->addHeader('Idempotence-Key', $idempotence_key)
            ->setEnableLog((bool)$this->getOption('enable_log'))
            ->setEnableCache(false)
            ->executeRequest();

        if ($external_response->getStatus()) {
            if ($external_response->getStatus() != 200) {
                throw new RSException(t("Ошибка запроса \"%0\": код %1", [$url, $external_response->getStatus()]), 0, null, $external_response->getRawResponse());
            }
        } else {
            throw new RSException(t("Ошибка запроса \"%0\": не получен код ответа", [$url]));
        }

        $result = $external_response->getResponseJson();

        if (!$result) {
            throw new RSException(t("Ошибка запроса \"%0\": получено пустое тело ответа", [$url]));
        }

        return $result;
    }

    /**
     * Возвращает список возможных действий с транзакцией
     *
     * @param Transaction $transaction
     * @param Order $order - объект заказа для которого нужно вернуть действия
     * @return TransactionAction[]
     */
    public function getAvailableTransactionActions(Transaction $transaction, Order $order): array
    {
        $result = [];
        if ($transaction['status'] == Transaction::STATUS_HOLD) {
            if ($transaction['order_id'] && $order->getTotalPrice(false) < $transaction['cost']) {
                $capture_confirm_text = t('Вы действительно хотите завершить оплату на сумму %0?', [$order->getTotalPrice()]);
            } else {
                $capture_confirm_text = t('Вы действительно хотите завершить оплату на всю сумму?');
            }
            $result[] = (new TransactionAction($transaction, self::TRANSACTION_ACTION_HOLD_CAPTURE, t('Завершить оплату')))
                ->setConfirmText($capture_confirm_text)
                ->setCssClass(' btn-primary');
            $result[] = (new TransactionAction($transaction, self::TRANSACTION_ACTION_HOLD_CANCEL, t('Отменить оплату')))
                ->setConfirmText(t('Вы действительно хотите отменить оплату?'))
                ->setCssClass(' btn-danger');
        }
        return $result;
    }

    /**
     * Исполняет действие с транзакцией
     * При успехе - возвращает текст сообщения для администратора, при неудаче - бросает исключение
     *
     * @param Transaction $transaction - транзакция
     * @param string $action - идентификатор исполняемого действия
     * @return string
     * @throws RSException
     */
    public function executeTransactionAction(Transaction $transaction, string $action): string
    {
        $external_payment = $transaction->getExtra(Transaction::EXTRA_KEY_PAYMENT);
        if (empty($external_payment['id'])) {
            throw new RSException(t('Транзакция не содержит идентификатор платежа'));
        }

        switch ($action) {
            case self::TRANSACTION_ACTION_HOLD_CAPTURE:
                if ($transaction['status'] != Transaction::STATUS_HOLD) {
                    throw new RSException(t('Списание холдирования возможно только у транзакции в статусе "%0"', [
                        Transaction::handbookStatus()[Transaction::STATUS_HOLD]
                    ]));
                }
                if ($transaction['order_id'] && $transaction['cost'] < $transaction->getOrder()->getTotalPrice(false)) {
                    throw new RSException(t('Сумма заказа превышает сумму холдирования'));
                }

                if ($transaction['order_id'] && $transaction['cost'] > $transaction->getOrder()->getTotalPrice(false)) {
                    $capture_amount = $transaction->getOrder()->getTotalPrice(false);
                } else {
                    $capture_amount = $transaction['cost'];
                }

                $request_params = [
                    'amount' => [
                        'value' => $capture_amount,
                        'currency' => CurrencyApi::getBaseCurrency()['title'],
                    ],
                    'receipt' => $this->getParamsForFZ54Check($transaction),
                ];
                $response = $this->apiRequest("payments/{$external_payment['id']}/capture", ExternalRequest::METHOD_POST, $request_params, (string)rand());

                $change = $this->changeTransactionFromResponse($transaction, $response);
                if ($capture_amount < $transaction['cost']) {
                    $change->setNewCost($capture_amount);
                }
                $change->applyChanges();

                return t('Оплата успешно завершена');
            case self::TRANSACTION_ACTION_HOLD_CANCEL:
                if ($transaction['status'] != Transaction::STATUS_HOLD) {
                    throw new RSException(t('Отмена холдирования возможна только у транзакции в статусе "%0"', [
                        Transaction::handbookStatus()[Transaction::STATUS_HOLD]
                    ]));
                }

                $response = $this->apiRequest("payments/{$external_payment['id']}/cancel", ExternalRequest::METHOD_POST, [], (string)rand());
                $this->changeTransactionFromResponse($transaction, $response)->applyChanges();

                return t('Холдирование отменено');
            default:
                throw new RSException(t('Вызванное действие не поддерживается данным типом оплаты'));
        }
    }

    /**
     * Создаёт "изменение транзакции" на основе данных о платеже
     *
     * @param Transaction $transaction - транзакция
     * @param array $response - данные о платеже
     * @param bool $is_notice - изменение вызвано уведомлением от ЯКассы
     * @return ChangeTransaction
     */
    protected function changeTransactionFromResponse(Transaction $transaction, array $response, bool $is_notice = false): ChangeTransaction
    {
        $change = new ChangeTransaction($transaction);
        $changelog = ($is_notice) ? t('Уведомление: ') : '';
        switch ($response['status']) {
            case 'succeeded':
                $change->setNewStatus(Transaction::STATUS_SUCCESS);
                if ($transaction['status'] == Transaction::STATUS_HOLD) {
                    $changelog .= t('Холдирование успешно завершено на сумму %0', [$response['amount']['value']]);
                } else {
                    $changelog .= t('Платёж успешно выполнен');
                }
                break;
            case 'waiting_for_capture':
                $change->setNewStatus(Transaction::STATUS_HOLD);
                $changelog .= t('Платёж захолдирован на сумму %0', [$transaction['cost']]);
                break;
            case 'canceled':
                $change->setNewStatus(Transaction::STATUS_FAIL)->setError(t('Оплата отменена'));
                $changelog .= t('Оплата отменена');
                break;
        }
        $change->setChangelog($changelog);
        return $change;
    }

    /**
     * Справочник кодов НДС
     * Ключи справочника должны соответствовать списку кодов НДС в TaxApi
     *
     * @return string[]
     */
    protected static function handbookNds()
    {
        static $nds = [
            TaxApi::TAX_NDS_NONE => 1,
            TaxApi::TAX_NDS_0 => 2,
            TaxApi::TAX_NDS_10 => 3,
            TaxApi::TAX_NDS_20 => 4,
            TaxApi::TAX_NDS_110 => 5,
            TaxApi::TAX_NDS_120 => 6,
        ];
        return $nds;
    }
}

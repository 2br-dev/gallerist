<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/

namespace Shop\Model\Orm;

use Catalog\Model\CurrencyApi;
use RS\Exception as RSException;
use RS\Helper\CustomView;
use RS\Http\Request as HttpRequest;
use RS\Orm\OrmObject;
use RS\Orm\Request as OrmRequest;
use RS\Orm\Type;
use Shop\Model\CashRegisterApi;
use Shop\Model\Exception as ShopException;
use Shop\Model\ChangeTransaction;
use Shop\Model\PaymentType\ResultException as PaymentTypeResultException;
use Shop\Model\TransactionApi;
use Shop\Model\TransactionChangeLogApi;
use Users\Model\Orm\User;

/**
 * --/--
 * @property integer $id Уникальный идентификатор (ID)
 * @property integer $site_id ID сайта
 * @property string $dateof Дата транзакции
 * @property integer $user_id Пользователь
 * @property integer $order_id ID заказа
 * @property integer $personal_account Транзакция изменяющая баланс лицевого счета
 * @property float $cost Сумма
 * @property float $comission Сумма комиссии платежной системы
 * @property integer $payment Тип оплаты
 * @property string $reason Назначение платежа
 * @property integer $force_create_receipt Создать чек
 * @property string $receipt_payment_subject Признак предмета товара для чека
 * @property string $error Ошибка
 * @property string $status Статус транзакции
 * @property string $receipt Последний статус получения чека
 * @property integer $refunded Дополнительное поле для данных
 * @property string $sign Подпись транзакции
 * @property string $entity Сущность к которой привязана транзакция
 * @property string $entity_id ID сущности, к которой привязана транзакция
 * @property string $extra Дополнительное поле для данных
 * @property array $extra_arr
 * @property string $cashregister_last_operation_uuid Последний уникальный идентификатор полученный в ответ от кассы
 * --\--
 */
class Transaction extends OrmObject
{
    //Статусы транзакции
    const STATUS_NEW = 'new';
    const STATUS_HOLD = 'hold';
    const STATUS_SUCCESS = 'success';
    const STATUS_FAIL = 'fail';
    //Статусы чека
    const NO_RECEIPT = 'no_receipt'; //Чека пока не создано
    const RECEIPT_IN_PROGRESS = 'receipt_in_progress'; //Чека пока не создано
    const RECEIPT_SUCCESS = 'receipt_success'; //Чек успешно выбит
    const RECEIPT_REFUND_SUCCESS = 'refund_success';
    const RECEIPT_FAIL = 'fail'; //Если была ошибка в чеке

    const ENTITY_SHIPMENT = 'shipment';
    const ENTITY_PRODUCTS_RETURN = 'products_return';
    const EXTRA_KEY_PAYMENT = 'payment';

    private $order;
    private $user;
    private $receipt;

    protected static $table = 'transaction';

    protected $cache_payment;

    public $no_need_check_sign = false; //Эта транзакция до записи новых значений

    function _init()
    {
        parent::_init()->append(array(
            'site_id' => new Type\CurrentSite(),
            'dateof' => new Type\Datetime(array(
                'description' => t('Дата транзакции'),
                'visible' => false
            )),
            'user_id' => new Type\User(array(
                'maxLength' => '11',
                'description' => t('Пользователь'),
                'template' => '%shop%/form/transaction/user.tpl'
            )),
            'order_id' => new Type\Integer(array(
                'maxLength' => '11',
                'description' => t('ID заказа'),
                'visible' => false
            )),
            'personal_account' => new Type\Integer(array(
                'maxLength' => '1',
                'description' => t('Транзакция изменяющая баланс лицевого счета'),
                'visible' => false
            )),
            'cost' => new Type\Decimal(array(
                'maxLength' => '15',
                'decimal' => 2,
                'description' => t('Сумма'),
            )),
            'comission' => new Type\Decimal(array(
                'maxLength' => 15,
                'decimal' => 2,
                'description' => t('Сумма комиссии платежной системы')
            )),
            'payment' => new Type\Integer(array(
                'description' => t('Тип оплаты'),
                'visible' => false
            )),
            'reason' => new Type\Text(array(
                'description' => t('Назначение платежа'),
            )),
            'force_create_receipt' => new Type\Integer(array(
                'description' => t('Создать чек'),
                'hint' => t('Будет создан чек, где:<br>Признак способа расчета - Полный расчет <br>Вид оплаты - Предварительная оплата (зачет аванса и (или) предыдущих платежей)'),
                'minusVisible' => true,
                'visible' => false,
                'checkboxView' => array(1, 0),
                'runtime' => true,
                'template' => '%shop%/form/transaction/force_create_receipt.tpl'
            )),
            'receipt_payment_subject' => new Type\Varchar(array(
                'description' => t('Признак предмета товара для чека'),
                'listFromArray' => array(CashRegisterApi::getStaticPaymentSubjects()),
                'default' => 'service',
                'runtime' => true,
                'minusVisible' => true,
                'visible' => false,
            )),
            'error' => new Type\Varchar(array(
                'description' => t('Ошибка'),
                'visible' => false
            )),
            'status' => new Type\Enum(array_keys(self::handbookStatus()), [
                'allowEmpty' => false,
                'description' => t('Статус транзакции'),
                'listFromArray' => [self::handbookStatus()],
                'visible' => false
            ]),
            'receipt' => new Type\Enum(array_keys(self::handbookReceipt()), [
                'allowEmpty' => false,
                'description' => t('Последний статус получения чека'),
                'listFromArray' => [self::handbookReceipt()],
                'default' => self::NO_RECEIPT,
                'visible' => false
            ]),
            'refunded' => new Type\Integer(array(
                'maxLength' => 1,
                'description' => t('Дополнительное поле для данных'),
                'checkboxview' => array(1, 0),
                'default' => 0,
                'visible' => false,
            )),
            'sign' => new Type\Varchar(array(
                'description' => t('Подпись транзакции'),
                'visible' => false
            )),
            'entity' => new Type\Varchar(array(
                'description' => t('Сущность к которой привязана транзакция'),
                'maxLength' => 50,
                'visible' => false
            )),
            'entity_id' => new Type\Varchar(array(
                'description' => t('ID сущности, к которой привязана транзакция'),
                'maxLength' => 50,
                'visible' => false
            )),
            'extra' => new Type\Varchar(array(
                'maxLength' => '4096',
                'description' => t('Дополнительное поле для данных'),
                'visible' => false,
            )),
            'extra_arr' => new Type\ArrayList(array(
                'visible' => false
            )),
            'cashregister_last_operation_uuid' => new Type\Varchar(array(
                'description' => t('Последний уникальный идентификатор полученный в ответ от кассы'),
                'visible' => false
            )),
        ));

        $this->addIndex(array('entity', 'entity_id'), self::INDEX_KEY);
    }

    /**
     * Вызывается после загрузки объекта
     * @return void
     */
    function afterObjectLoad()
    {
        if (!empty($this['extra'])) {
            $this['extra_arr'] = unserialize($this['extra']) ?: [];
        }
    }

    public function beforeWrite($save_flag)
    {
        $this['extra'] = serialize($this['extra_arr']);

        if ($save_flag == self::INSERT_FLAG || $this->no_need_check_sign) {
            return;
        }
        if (!$this->checkSign()) {
            throw new RSException(t('Неверная подпись транзакции %0. Изменение транзакции невозможно', array($this->id)));
        }
    }

    public function afterWrite($save_flag)
    {
        if ($this->no_need_check_sign) {
            return;
        }
        $user = $this->getUser();

        if ($user->id) {
            $transApi = new TransactionApi();
            $real_balance = $transApi->getBalance($user->id);

            // Перезагрузка объекта пользователя
            $user = $user->loadSingle($user->id);

            // Проверяем подпись баланса пользователя
            if (!$user->checkBalanceSign()) {
                throw new RSException(t('Неверная подпись баланса у пользователя id: %0', array($user->id)));
            }

            // Если баланс по сумме транзакций отличается от баланса, сохраненного в поле balance у пользователя
            if ($user->getBalance() != $real_balance) {
                // Проверяем верен ли старый баланс
                $old_balance = $transApi->getBalance($user->id, array($this->id));      // Получаем сумму на счету без учета этой транзакции
                $sign = TransactionApi::getBalanceSign($old_balance, $this->user_id);   // Формируем подпись к старом балансу
                if ($user->balance_sign == $sign) {                                     // Проверяем верна ли подпись
                    // Устанавливаем новый баланс пользователю
                    $user->balance = $real_balance;
                    $user->balance_sign = TransactionApi::getBalanceSign($real_balance, $this->user_id);
                    $user->update();
                } else {
                    throw new RSException(t('Нарушение целостности истории транзакций'));
                }
            }
        }

        //Отправляем уведомление о пополнении лицевого счёта
        if ($save_flag == self::INSERT_FLAG && (!$this['status'] || $this['status'] == self::STATUS_NEW) && $this['cost'] > 0 && $this['payment'] > 0) { //если новая и баланс на пополнение
            $notice = new \Shop\Model\Notice\NewTransaction();
            $notice->init($this, $user);
            \Alerts\Model\Manager::send($notice);
        }
    }

    /**
     * Проверка подписи транзакции
     *
     * @return bool
     * @throws RSException
     * @throws ShopException
     */
    public function checkSign()
    {
        if (!$this->id) throw new RSException(t('Невозможно подписать транзакцию с нулевым идентификатором'));
        $ok = $this->sign == TransactionApi::getTransactionSign($this);
        return $ok;
    }

    /**
     * Возращает объект заказа
     * @return Order
     */
    public function getOrder()
    {
        if ($this->order == null) {
            $this->order = new Order($this->order_id);
        }
        return $this->order;
    }

    /**
     * Возвращает объект пользователя
     * @return User
     */
    public function getUser()
    {
        if ($this->user == null) {
            if ($this->order_id > 0) {
                $this->user = $this->getOrder()->getUser();
            } else {
                $this->user = new User($this->user_id);
            }
        }
        return $this->user;
    }

    /**
     * Возвращает объект способа оплаты
     *
     * @return Payment
     */
    function getPayment()
    {
        if ($this->cache_payment === null) {
            $this->cache_payment = new Payment($this['payment'], true, $this->getOrder()->id ? $this->getOrder() : null, $this);
        }

        return $this->cache_payment;
    }

    /**
     * Возвращает привязанные к транзакции чеки
     *
     * @return Receipt[]
     */
    function getReceipts()
    {
        /** @var Receipt[] $receipts */
        $receipts = OrmRequest::make()
            ->from(new Receipt())
            ->where(array(
                'transaction_id' => $this->id
            ))->objects();

        return $receipts;
    }

    /**
     * Возвращает URL для перехода на сайт сервиса оплаты для совершения платежа
     *
     * @return string
     */
    function getPayUrl()
    {
        return $this->getPayment()->getTypeObject()->getPayUrl($this);
    }

    /**
     * Возвращает стоимость транзакции с учетом текущих параметров
     *
     * @param bool $use_currency - если true, то значение будет возвращено в текущей валюте, иначе в базовой
     * @param bool $format - если true, то форматировать возвращаемое значение, приписывать символ валюты
     * @return string
     */
    function getCost($use_currency = false, $format = false)
    {
        $cost = ($use_currency) ? CurrencyApi::applyCurrency($this['cost']) : $this['cost'];
        if ($use_currency) {
            return $format ? CustomView::cost($cost, CurrencyApi::getCurrecyLiter()) : $cost;
        } else {
            $base_currency = CurrencyApi::getBaseCurrency();
            return $format ? CustomView::cost($cost, $base_currency['stitle']) : $cost;
        }
    }

    /**
     * Вызывается при оплате.
     * Возвращает строку ответ серверу оплаты.
     *
     * Допускается повторный вызов метода. Действия по обновлению заказа, пробитию чека, отправке уведомлений будут
     * выполнены только при первой попытке успешной оплаты транзакции.
     *
     * @param HttpRequest $request
     * @return string
     */
    function onResult(HttpRequest $request)
    {
        try {
            $response = $this->getPayment()->getTypeObject()->onResult($this, $request);

            if (gettype($response) == 'object') {
                /** @var ChangeTransaction $change */
                $change = $response;
            } else {
                $change = new ChangeTransaction($this);
                $change->setNewStatus(Transaction::STATUS_SUCCESS)
                    ->setResponse($response)
                    ->setChangelog(t('Платёж успешно выполнен'));
            }
        } catch (\Exception $e) {
            $response = ($e instanceof PaymentTypeResultException) ? $e->getResponse() : $e->getMessage();

            if ($e instanceof PaymentTypeResultException && !$e->canUpdateTransaction()) {
                return $response; //Возвращаем ответ как есть
            }

            $change = new ChangeTransaction($this);
            $change->setNewStatus(Transaction::STATUS_FAIL)
                ->setError($e->getMessage())
                ->setResponse($response)
                ->setChangelog(t('Транзакция отменена из-за ошибки'));
        }

        $change->applyChanges();
        return $change->getResponse();
    }

    /**
     * Возвращает true если по транзакции возможно отправить чек возврата
     *
     * @return bool
     */
    public function isPossibleRefundReceipt()
    {
        return $this['personal_account'] || ($this['order_id'] && !$this['entity']);
    }

    /**
     * Возвращает список возможных действий с транзакцией
     *
     * @param Order|null $order - объект заказа для которого нужно вернуть действия, если не указан - берётся из транзакции
     * @return string[]
     */
    public function getAvailableActionsList(Order $order = null): array
    {
        if (!$order) {
            $order = $this->getOrder();
        }
        return $this->getPayment()->getTypeObject()->getAvailableTransactionActions($this, $order);
    }

    /**
     * Исполняет доступное для транзакции действие
     *
     * @param string $action
     * @return string
     * @throws RSException
     */
    public function executeAction(string $action)
    {
        return $this->getPayment()->getTypeObject()->executeTransactionAction($this, $action);
    }

    /**
     * Возвращает список "изменений транзакции"
     *
     * @return TransactionChangeLog[]
     */
    public function getChangeLogs(): array
    {
        /** @var TransactionChangeLog[] $list */
        $list = (new TransactionChangeLogApi())->setFilter(['transaction_id' => $this['id']])->setOrder('date desc')->getList();
        return $list;
    }

    /**
     * Возвращает занчение из массива дополнительных сведений по ключу
     *
     * @param string $key - ключ данных
     * @param null $default - значение по умолчанию
     * @return mixed
     */
    public function getExtra(string $key, $default = null)
    {
        return $this['extra_arr'][$key] ?? $default;
    }

    /**
     * Устанавливает занчение в массив дополнительных сведений
     *
     * @param string $key - ключ данных
     * @param mixed $value - значение
     */
    public function setExtra(string $key, $value)
    {
        $extra = $this['extra_arr'];
        $extra[$key] = $value;
        $this['extra_arr'] = $extra;
    }

    /**
     * Справочник статусов транзакции
     *
     * @return string[]
     */
    public static function handbookStatus(): array
    {
        return [
            self::STATUS_NEW => t('Платеж инициирован'),
            self::STATUS_HOLD => t('Платёж захолдирован'),
            self::STATUS_SUCCESS => t('Платеж успешно завершен'),
            self::STATUS_FAIL => t('Платеж завершен с ошибкой'),
        ];
    }

    /**
     * Справочник статусов чека
     *
     * @return string[]
     */
    protected static function handbookReceipt(): array
    {
        return [
            self::NO_RECEIPT => t('Чек пока не получен'),
            self::RECEIPT_IN_PROGRESS => t('Чек в очереди на получение'),
            self::RECEIPT_SUCCESS => t('Чек получен'),
            self::RECEIPT_REFUND_SUCCESS => t('Чек возвратата получен'),
            self::RECEIPT_FAIL => t('Ошибка в последнем чеке'),
        ];
    }
}

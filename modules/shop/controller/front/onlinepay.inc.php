<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/

namespace Shop\Controller\Front;

use Partnership\Model\Api as PartnershipApi;
use Partnership\Model\Orm\Partner;
use RS\Application\Application;
use RS\Controller\Front;
use RS\Controller\Result\Standard;
use RS\Exception as RSException;
use RS\Module\Manager as ModuleManager;
use Shop\Model\Exception as ShopException;
use Shop\Model\Orm\Transaction;
use Shop\Model\PaymentApi;
use Shop\Model\TransactionApi;

/**
 * Контроллер для обработки Online-платежей
 */
class OnlinePay extends Front
{
    /**
     * Шаг 6. Редирект на страницу оплаты (переход к сервису online-платежей)
     * Вызывается только в случае Online типа оплаты.
     * Данный action выполняется при нажатии на кнопку "Перейти к оплате"
     * Перед редиректом создается новая транзакция со статусом 'new'. Её идентификатор будет фигурировать в URL оплаты
     *
     */
    function actionDoPay()
    {
        $this->wrapOutput(false);
        $order_id = $this->url->request('order_id', TYPE_STRING);

        $transactionApi = new TransactionApi();

        try {
            $transaction = $transactionApi->createTransactionFromOrder($order_id);
        } catch (ShopException $e) {
            if ($e->getCode() == ShopException::ERR_ORDER_ALREADY_PAYED) {
                $this->app->redirect($this->router->getUrl('shop-front-myorderview', ['order_id' => $order_id]));
            } else {
                throw $e;
            }
        }

        if ($transaction->getPayment()->getTypeObject()->isPostQuery()) { //Если нужен пост запрос
            $url = $transaction->getPayUrl();
            $this->view->assign(array(
                'url' => $url,
                'transaction' => $transaction
            ));
            $this->wrapOutput(false);
            return $this->result->setTemplate("%shop%/onlinepay/post.tpl");
        } else {
            Application::getInstance()->redirect($transaction->getPayUrl());
        }
    }

    /**
     * Особый action, который вызвается с сервера online платежей
     * В REQUEST['PaymentType'] должен содержаться строковый идентификатор типа оплаты
     *
     * http://САЙТ.РУ/onlinepay/{PaymentType}/result/
     */
    function actionResult()
    {
        $request = $this->url;
        // Логируем запрос
        $log_file = \RS\Helper\Log::file(\Setup::$PATH . \Setup::$STORAGE_DIR . DS . 'logs' . DS . 'Onlinepay_Result.log');
        $log_data = 'request - ' . $request->getSelfUrl() . ' - GET: ' . serialize($request->getSource(GET)) . ' - POST: ' . serialize($request->getSource(POST)) . ' - BODY: ' . $request->getStreamInput();
        $log_file->append($log_data);

        $this->wrapOutput(false);
        $payment_api = new PaymentApi();
        $payment_type = $this->url->get('PaymentType', TYPE_STRING);
        $transactionApi = new \Shop\Model\TransactionApi();
        $response = null;
        try {
            $transaction = $transactionApi->recognizeTransactionFromRequest($payment_type, $this->url);
            if (is_array($transaction)) {
                $response_array = [];
                foreach ($transaction as $one_transaction) {
                    $response_array[] = $one_transaction->onResult($this->url);
                }
                $payment_types = $payment_api->getTypes();
                $response = $payment_types[$payment_type]->wrapOnResultArray($response_array);
            } else {
                $response = $transaction->onResult($this->url);
            }
        } catch (\Exception $e) {
            return $e->getMessage();       // Вывод ошибки
        }
        // Логируем ответ
        $log_file->append('response - ' . $response);
        return $response;
    }

    /**
     * Страница извещения об успешном совершении платежа
     * http://САЙТ.РУ/onlinepay/{PaymentType}/success/
     *
     * @return Standard|string
     * @throws RSException
     */
    function actionSuccess()
    {
        $payment_type = $this->url->get('PaymentType', TYPE_STRING);
        $transactionApi = new TransactionApi();
        try {
            $transaction = $transactionApi->recognizeTransactionFromRequest($payment_type, $this->url);
            $transaction->getPayment()->getTypeObject()->onSuccess($transaction, $this->url);
        } catch (\Exception $e) {
            return $e->getMessage();       // Вывод ошибки
        }

        $this->redirectToPartner($transaction);

        $this->view->assign('transaction', $transaction);
        //Проверим, если это заказ и у типа оплаты стоит, флаг выбивания чека
        if ($transaction->getPayment()->create_cash_receipt) {
            $this->view->assign(array(
                'need_check_receipt' => true
            ));
            $this->app->addJsVar('receipt_check_url', $this->router->getUrl('shop-front-onlinepay', array(
                'Act' => 'checktransactionreceiptstatus',
                'id' => $transaction['id'],
            )));
        }

        $this->app->setBodyClass('payment-ok', true); //Добавим класс для проверки в мобильным приложением
        return $this->result->setTemplate('onlinepay/success.tpl');
    }

    /**
     * Страница извещения о неудачи при проведении платежа (например если пользователь отказался от оплаты)
     * http://САЙТ.РУ/onlinepay/{PaymentType}/fail/
     *
     * @return Standard|string
     * @throws RSException
     */
    function actionFail()
    {
        $payment_type = $this->url->get('PaymentType', TYPE_STRING);
        $transactionApi = new TransactionApi();
        try {
            $transaction = $transactionApi->recognizeTransactionFromRequest($payment_type, $this->url);
            $transaction->getPayment()->getTypeObject()->onFail($transaction, $this->url);
        } catch (\Exception $e) {
            return $e->getMessage();       // Вывод ошибки
        }

        $this->redirectToPartner($transaction);

        $this->view->assign('transaction', $transaction);
        $this->app->setBodyClass('payment-fail', true); //Добавим класс для проверки мобильным приложением
        return $this->result->setTemplate('onlinepay/fail.tpl');
    }

    /**
     * Страница извещения о результате проведения платежа
     * http://САЙТ.РУ/onlinepay/{PaymentType}/status/
     *
     * @return Standard|string
     * @throws RSException
     */
    public function actionStatus()
    {
        $payment_type = $this->url->get('PaymentType', TYPE_STRING);
        $transactionApi = new TransactionApi();
        try {
            $transaction = $transactionApi->recognizeTransactionFromRequest($payment_type, $this->url);
            $transaction->getPayment()->getTypeObject()->onStatus($transaction, $this->url);
        } catch (\Exception $e) {
            return $e->getMessage();       // Вывод ошибки
        }

        $this->redirectToPartner($transaction);

        $this->view->assign('transaction', $transaction);
        $this->app->setBodyClass('payment-status', true); //Добавим класс для проверки мобильным приложением
        return $this->result->setTemplate('onlinepay/status.tpl');
    }

    /**
     * Проверяет статус транзакции
     *
     * @return Standard
     */
    function actionCheckTransactionStatus()
    {
        $id = $this->url->get('id', TYPE_INTEGER, 0);
        $transaction = new Transaction($id);
        if ($transaction['id']) {
            $payment_type = $transaction->getPayment()->getTypeObject();
            if ($transaction['status'] == Transaction::STATUS_NEW && $payment_type->canOnlinePay()) {
                $payment_type->checkPaymentStatus($transaction);
            }

            $this->result->setSuccess(true)->addSection('status', $transaction['status']);
        } else {
            $this->result->setSuccess(false);
        }
        return $this->result;
    }

    /**
     * Проверяет статус выбивания чека для транзакции
     *
     */
    function actionCheckTransactionReceiptStatus()
    {
        $id = $this->url->get('id', TYPE_INTEGER, 0);
        $transaction = new Transaction($id);
        $success = false;
        if ($transaction['id']) {
            if ($transaction['receipt'] == Transaction::RECEIPT_SUCCESS || $transaction['receipt'] == Transaction::RECEIPT_REFUND_SUCCESS) { //Если человек получен успешно
                $success = true;
            } elseif ($transaction['receipt'] == Transaction::RECEIPT_FAIL) {
                $success = true;
                $this->result->addSection('error', t('Ошибка при выписке чека. Пожалуйста обратитесь к менеджеру сайта.'));
            }
        }
        return $this->result->setSuccess($success);
    }

    /**
     * Перенаправляет на партнёрский сайт транзакции
     *
     * @param $transaction - объект транзакции
     * @throws RSException
     */
    protected function redirectToPartner($transaction)
    {
        if (ModuleManager::staticModuleEnabled('partnership')) {
            if (!empty($transaction['partner_id']) && $transaction['partner_id'] != PartnershipApi::getCurrentPartner()->id) {
                $partner = new Partner($transaction['partner_id']);
                Application::getInstance()->redirect($this->url->getProtocol() . '://' . $partner->getMainDomain() . $this->url->selfUri());
            }
        }
    }
}

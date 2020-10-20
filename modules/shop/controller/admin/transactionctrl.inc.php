<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/

namespace Shop\Controller\Admin;

use RS\Controller\Admin\Crud;
use RS\Exception as RSException;
use RS\Html\Table\Type as TableType;
use RS\Html\Filter;
use RS\Html\Table;
use RS\AccessControl\Rights;
use Shop\Config\ModuleRights;
use Shop\Model\HtmlFilterType as ShopFilterType;
use Shop\Model\Orm\Transaction;
use Shop\Model\PaymentApi;
use Shop\Model\TransactionApi;

/**
 * Контроллер Управление транзакциями
 */
class TransactionCtrl extends Crud
{
    function __construct()
    {
        parent::__construct(new TransactionApi());
        $this->setCrudActions('index', 'tableOptions');
    }

    function helperIndex()
    {
        $helper = parent::helperIndex();
        $helper->setTopToolbar(null);
        $helper->setBottomToolbar(null);
        $helper->setTopHelp(t('Транзакция - это попытка оплаты заказа или проведения операции с лицевым счетом. Результат попытки указан в колонке Статус. Списать или пополнить средства на лицевом счете возможно через раздел <i>Управление &rarr; Пользователи &rarr; Учетные записи</i>. В случае с online платежами транзакция создается в момент каждой попытки пользователя оплатить заказ или пополнить лицевой счет. Благодаря транзакциям, пользователи могут видеть всю историю движения средств в своем личном кабинете.'));
        $helper->setTopTitle(t('Транзакции'));
        $edit_href = $this->router->getAdminPattern('edit', array(':id' => '@id'));
        $helper->setTable(new Table\Element(array(
            'Columns' => array(
                new TableType\Text('id', t('№'), array('Sortable' => SORTABLE_BOTH, 'CurrentSort' => SORTABLE_DESC)),
                new TableType\Usertpl('user_id', t('Пользователь'), '%shop%/order_user_cell.tpl', array(
                    'href' => $this->router->getAdminPattern('edit', array(':id' => '~field~'), 'users-ctrl'),
                    'linkAttr' => array(
                        'class' => 'crud-edit'
                    )
                )),
                new TableType\Text('reason', t('Назначение')),
                new TableType\Userfunc('payment', t('Тип оплаты'), function ($value, $field) {
                    return $field->getRow()->getPayment()->title;
                }),
                new TableType\Datetime('dateof', t('Дата'), array('Sortable' => SORTABLE_BOTH)),
                new TableType\Usertpl('cost', t('Сумма'), '%shop%/transaction_cost_cell.tpl', array('Sortable' => SORTABLE_BOTH)),
                new TableType\Text('comission', t('Комиссия'), array('hidden' => true)),
                new TableType\Text('status', t('Статус')),
                new TableType\Usertpl('receipt', t('Чек'), '%shop%/transaction_receipt.tpl'),
                new TableType\Text('error', t('Ошибка'), array('hidden' => true)),
                new TableType\Usertpl('__actions__', t('Действия'), '%shop%/transaction_actions_cell.tpl'),
                new TableType\Actions('id', array(
                    new TableType\Action\DropDown(array(
                        array(
                            'title' => t('Посмотреть чеки'),
                            'attr' => array(
                                'class' => '',
                                '@href' => $this->router->getAdminPattern(null, array(':f[transaction_id]' => '~field~'), 'shop-receiptsctrl'),
                            )
                        ),
                        array(
                            'title' => t('Пополнить баланс пользователя'),
                            'attr' => array(
                                'class' => 'crud-add',
                                '@href' => $this->router->getAdminPattern('addfunds', array(':id' => '@user_id', 'writeoff' => 0), 'shop-balancectrl'),
                            )
                        ),
                        array(
                            'title' => t('Списать средства с баланса пользователя'),
                            'attr' => array(
                                'class' => 'crud-add',
                                '@href' => $this->router->getAdminPattern('addfunds', array(':id' => '@user_id', 'writeoff' => 1), 'shop-balancectrl'),
                            )
                        )
                    )),
                ),
                    array('SettingsUrl' => $this->router->getAdminUrl('tableOptions'))
                ),
            )
        )));

        $transaction = new Transaction();
        //Статусы
        $status_list = array('' => t('Любой')) + $transaction->__status->getList();
        //Чеки
        $receipt_list = array('' => t('Любой')) + $transaction->__receipt->getList();

        $payment_list = array('' => t('Любой')) + PaymentApi::staticSelectList();

        $helper->setFilter(new Filter\Control(array(
            'Container' => new Filter\Container(array(
                'Lines' => array(
                    new Filter\Line(array('Items' => array(
                        new Filter\Type\Text('id', '№'),
                        new Filter\Type\Text('reason', t('Назначение'), array('searchType' => '%like%')),
                        new Filter\Type\User('user_id', t('Пользователь')),
                        new Filter\Type\Select('status', t('Статус'), $status_list),
                        new Filter\Type\Select('receipt', t('Статус чека'), $receipt_list),
                        new Filter\Type\Select('payment', t('Тип оплаты'), $payment_list),
                        new Filter\Type\Text('cost', t('Сумма'), array('showtype' => true))
                    ))),
                ),
                'SecContainer' => new Filter\Seccontainer(array(
                    'Lines' => array(
                        new Filter\Line(array(
                            'Items' => array(
                                new Filter\Type\DateRange('dateof', t('Дата')),
                                new ShopFilterType\TransactionEntity('entity', t('Тип операции')),
                            )
                        ))
                    )
                ))
            )),
            'Caption' => t('Поиск по транзакциям')
        )));

        return $helper;
    }

    /**
     * Начисление средств на лицевой счет у новой транзакции
     * или оплата транзакции заказа
     */
    function actionSetTransactionSuccess()
    {
        if ($error = Rights::CheckRightError($this, ModuleRights::RIGHT_ADD_FUNDS)) {
            return $this->result->setSuccess(false)
                ->addEMessage($error);
        }

        $transaction_id = $this->url->get('id', TYPE_INTEGER);
        $transaction = new Transaction($transaction_id);

        if ($transaction->getPayment()->getTypeObject()->canOnlinePay()) {
            return $this->result
                ->setSuccess(false)
                ->addEMessage(t('Способ оплаты поддерживает только автоматическое проведение'));
        }

        try {
            $transaction->onResult($this->url);
        } catch (\Exception $e) {
            $this->result->setSuccess(false);
            $this->result->addEMessage($e->getMessage());
            return $this->result;
        }

        $this->result->setSuccess(true);
        $this->result->addMessage(t("Платеж успешно проведен.<br> %0<br> Сумма: %1", array($transaction->getUser()->getFio(), $transaction->cost)));
        return $this->result;
    }

    /**
     * Выбивает чек в ККТ
     *
     * @throws RSException
     */
    function actionSendReceipt()
    {
        if ($error = Rights::CheckRightError($this, ModuleRights::RIGHT_SEND_RECEIPT)) {
            return $this->result->setSuccess(false)
                ->addEMessage($error);
        }

        if (!$this->getModuleConfig()->cashregister_class) {
            return $this->result->setSuccess(false)
                ->addEMessage(t("Не назначен провайдер"));
        }

        $transaction_id = $this->url->get('id', TYPE_INTEGER);
        $transaction = new Transaction($transaction_id);

        try {
            $transaction_api = new TransactionApi();
            if (($result = $transaction_api->createReceipt($transaction)) === true) {
                return $this->result->setSuccess(true)
                    ->addMessage(t('Чек отправлен в ОФД'))
                    ->setNoAjaxRedirect($this->url->getSelfUrl());
            } else {
                return $this->result->setSuccess(false)
                    ->addEMessage($result);
            }
        } catch (\Exception $e) {
            $this->result->setSuccess(false);
            $this->result->addEMessage($e->getMessage());
            return $this->result;
        }
    }

    /**
     * Выбивает чек возврата в ККТ
     *
     * @throws RSException
     */
    function actionSendRefundReceipt()
    {
        if ($error = Rights::CheckRightError($this, ModuleRights::RIGHT_REFUND_RECEIPT)) {
            return $this->result->setSuccess(false)
                ->addEMessage($error);
        }

        if (!$this->getModuleConfig()->cashregister_class) {
            return $this->result->setSuccess(false)
                ->addEMessage(t("Не назначен провайдер"));
        }

        $transaction_id = $this->url->get('id', TYPE_INTEGER);
        $transaction = new Transaction($transaction_id);

        try {
            $transaction_api = new TransactionApi();
            if (($result = $transaction_api->createReceipt($transaction, \Shop\Model\CashRegisterType\AbstractType::OPERATION_SELL_REFUND)) === true) {
                return $this->result->setSuccess(true)
                    ->addMessage(t('Чек возврата отправлен в ОФД'))
                    ->setNoAjaxRedirect($this->url->getSelfUrl());
            } else {
                return $this->result->setSuccess(false)
                    ->addEMessage($result);
            }
        } catch (\Exception $e) {
            $this->result->setSuccess(false);
            $this->result->addEMessage($e->getMessage());
            return $this->result;
        }
    }
}

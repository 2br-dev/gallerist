<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/

namespace Shop\Controller\Front;

use Main\Model\StatisticEvents;
use RS\Application\Application;
use RS\Controller\Front;
use RS\Db\Exception as DbException;
use RS\Event\Manager as EventManager;
use RS\Exception as RSException;
use RS\Orm\Exception as OrmException;
use Shop\Model\Cart;

/**
 * Корзина с офомлением заказа
 */
class CartCheckout extends Front
{
    function init()
    {
        $this->app->title->addSection(t('Оформление заказа'));
    }

    function actionIndex()
    {
        $this->view->assign([
            'cart' => Cart::currentCart(),
        ]);

        return $this->result->setTemplate('cart_checkout.tpl');
    }
}

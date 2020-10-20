<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/

namespace Shop\Controller\Block;

use Catalog\Model\CurrencyApi;
use Catalog\Model\WareHouseApi;
use RS\Application\Application;
use RS\Application\Auth;
use RS\Application\Auth as AppAuth;
use RS\Config\Loader as ConfigLoader;
use RS\Config\UserFieldsManager;
use RS\Controller\Result\Standard as ResultStandard;
use RS\Controller\StandartBlock;
use RS\Db\Exception as DbException;
use RS\Event\Manager as EventManager;
use RS\Exception as RSException;
use RS\Helper\Tools as HelperTools;
use RS\Http\Request as HttpRequest;
use RS\Site\Manager as SiteManager;
use RS\View\Engine as ViewEngine;
use Shop\Config\File as ShopConfig;
use Shop\Model\AddressApi;
use Shop\Model\Cart;
use Shop\Model\DeliveryApi;
use Shop\Model\OrderApi;
use Shop\Model\Orm\Address;
use Shop\Model\Orm\Order;
use Shop\Model\Orm\Region;
use Shop\Model\PaymentApi;
use Shop\Model\RegionApi;
use Users\Config\File as UserConfig;
use Users\Config\File as UsersConfig;
use Users\Model\Orm\User;

/**
 * Блок контроллер Шаг оформления заказа
 */
class Checkout extends StandartBlock
{
    protected $action_var = 'action';
    /** @var Order */
    protected $order;
    /** @var OrderApi */
    protected $order_api;
    /** @var AddressApi */
    protected $address_api;
    /** @var DeliveryApi */
    protected $delivery_api;
    /** @var PaymentApi */
    protected $payment_api;
    /** @var ShopConfig */
    protected $shop_config;
    protected $use_strict_to_address_filter;

    function init()
    {
        $this->order = Order::currentOrder();
        $this->order_api = new OrderApi();
        $this->address_api = new AddressApi();
        $this->delivery_api = new DeliveryApi();
        $this->payment_api = new PaymentApi();
        $this->shop_config = ConfigLoader::byModule('shop');

        $this->order->clearErrors();
        $this->view->assign('order', $this->order);
    }

    /**
     * Контроллер предварительной привязки заказа к сессии
     *
     * @return ResultStandard
     * @throws RSException
     * @throws DbException
     * @throws \SmartyException
     */
    function actionIndex()
    {
        $logout = $this->url->request('logout', TYPE_BOOLEAN);
        if ($logout) { //Если нужно разлогинится
            Auth::logout();
            $this->order->clearErrors();
            $this->order->setAddress(new Address());
            Application::getInstance()->redirect($this->router->getUrl('shop-front-cartcheckout'));
        }

        //$this->order->clear();
        unset($this->order['id']);
        unset($this->order['order_num']);

        //Замораживаем объект "корзина" и привязываем его к заказу
        $frozen_cart = Cart::preOrderCart(null);
        $frozen_cart->splitSubProducts();
        $frozen_cart->mergeEqual();
        $this->order->linkSessionCart($frozen_cart);
        $this->order->session_cart = $frozen_cart;
        $this->order->setCurrency(CurrencyApi::getCurrentCurrency());

        $this->order['ip'] = $_SERVER['REMOTE_ADDR'];

        $this->order['expired'] = false;

        if (AppAuth::isAuthorize()) {
            $this->order['user_id'] = AppAuth::getCurrentUser()['id'];
        }

        if (!$this->order->getCart()) {
            Application::getInstance()->redirect();
        }

        if (AppAuth::isAuthorize()) {
            $this->order['user_type'] = null;
        } else {
            $this->order['__reg_phone']->setEnableVerification(true);
            if ($this->shop_config['check_captcha'] && !$this->order['__reg_phone']->isEnabledVerification()) {
                $this->order['__code']->setEnable(true);
            }

            if (empty($this->order['user_type'])) {
                $this->order['user_type'] = $this->shop_config->default_checkout_tab;
                $this->order['reg_autologin'] = 1;
            }
        }

        //Добавим временно сведения об адресе, если адрес нам передан
        $this->order->setAddress($this->getOrderRightAddress($this->order, $this->url));

        //Запрашиваем дополнительные поля формы заказа, если они определены в конфиге модуля
        $order_fields_manager = $this->order->getFieldsManager();
        $order_fields_manager->setValues($this->order['userfields_arr']);

        //Запрашиваем дополнительные поля формы регистрации, если они определены
        /** @var \Users\Config\File $user_config */
        $user_config = ConfigLoader::byModule('users');
        $reg_fields_manager = $user_config->getUserFieldsManager();
        $reg_fields_manager->setErrorPrefix('regfield_');
        $reg_fields_manager->setArrayWrapper('regfields');
        if (!empty($this->order['regfields'])) {
            $reg_fields_manager->setValues($this->order['regfields']);
        }

        // запустим событие для модификации заказа и проверим ошибки
        $this->fireConfirmEvent();
        if ($this->checkCriticalErrors()) {
            $this->view->assign([
                'has_critical_error' => true,
            ]);
            return $this->result->setTemplate('blocks/checkout/checkout.tpl');
        }

        $user = AppAuth::getCurrentUser();
        if (AppAuth::isAuthorize()) {
            $this->order['user_id'] = $user['id'];

        }

        //Получаем список адресов пользователя (для совместимости)
        $addr_list = [];
        if (AppAuth::isAuthorize()) {
            $addr_list = $this->address_api->getCheckoutUserAddresses($this->order, $user);
        }
        $this->view->assign('address_list', $addr_list);

        $user = AppAuth::getCurrentUser();
        if (AppAuth::isAuthorize()) {
            $this->order['user_id'] = $user['id'];
        }

        //Посмотрим есть ли варианты для доставки по адресу и для самовывоза
        $have_to_address_delivery = $this->delivery_api->isHaveToAddressDelivery($this->order);
        $have_pickup_points = $this->delivery_api->isHavePickUpPoints($this->order);

        $this->order['password'] = '';
        $this->order['reg_openpass'] = '';
        $this->order['reg_pass2'] = '';

        $cart = $this->order->getCart(); //Получаем сведения о корзине пользователя

        $this->view->assign([
            'have_to_address_delivery' => $have_to_address_delivery,
            'have_pickup_points' => $have_pickup_points,
            'is_auth' => AppAuth::isAuthorize(),
            'order' => $this->order,
            'cart' => $cart,
            'shop_config' => $this->shop_config,
            'user_config' => $user_config,

            'user_block' => $this->getUserBlock(),
            'address_block' => $this->getAddressBlock($this->order, $user),
            'delivery_block' => $this->getDeliveryBlock($this->order, $user),
            'payment_block' => $this->getPaymentBlock($this->order, $user),
            'product_block' => $this->getProductsBlock(),
            'total_block' => $this->getTotalBlock(),

            'user' => $user,
            'conf_userfields' => $order_fields_manager,
            'reg_userfields' => $reg_fields_manager,
            'order_extra' => !empty($this->order['order_extra']) ? $this->order['order_extra'] : array(),
        ]);

        return $this->result->setTemplate('blocks/checkout/checkout.tpl');
    }

    /**
     * Проверяет заказ на наличие ошибок, при которых дальнейшее оформление заказа невозможно
     *
     * @return bool
     * @throws RSException
     */
    protected function checkCriticalErrors()
    {
        $cart_data = $this->order['basket'] ? $this->order->getCart()->getCartData() : null;

        if ($cart_data === null || !count($cart_data['items']) || $cart_data['has_error'] || $this->order['expired']) {
            //Если корзина пуста или заказ уже оформлен или имеются ошибки в корзине, то выполняем redirect на главную сайта
            return true;
        }
        return false;
    }

    /**
     * Запускает событие для дополнительной проверки/корректировки заказа
     *
     * @return void
     */
    protected function fireConfirmEvent()
    {
        static $can_fire = true;

        if ($can_fire) { // событие сработает только 1 раз
            EventManager::fire('checkout.confirm', array(
                'order' => $this->order,
                'cart' => $this->order->getCart(),
            ));
            $can_fire = false;
        }
    }

    public function actionCreateOrder()
    {
        if (!$this->order->getCart()) {
            Application::getInstance()->redirect();
        }

        if (AppAuth::isAuthorize()) {
            $this->order['user_type'] = null;
        } else {
            $this->order['__reg_phone']->setEnableVerification(true);
            if ($this->shop_config['check_captcha'] && !$this->order['__reg_phone']->isEnabledVerification()) {
                $this->order['__code']->setEnable(true);
            }

            if (empty($this->order['user_type'])) {
                $this->order['user_type'] = $this->shop_config['default_checkout_tab'];
                $this->order['reg_autologin'] = 1;
            }
        }

        //Добавим временно сведения об адресе, если адрес нам передан
        $this->order->setAddress($this->getOrderRightAddress($this->order, $this->url));

        //Запрашиваем дополнительные поля формы заказа, если они определены в конфиге модуля
        $order_fields_manager = $this->order->getFieldsManager();
        $order_fields_manager->setValues($this->order['userfields_arr']);

        //Запрашиваем дополнительные поля формы регистрации, если они определены
        /** @var \Users\Config\File $user_config */
        $user_config = ConfigLoader::byModule('users');
        $reg_fields_manager = $user_config->getUserFieldsManager();
        $reg_fields_manager->setErrorPrefix('regfield_');
        $reg_fields_manager->setArrayWrapper('regfields');
        if (!empty($this->order['regfields'])) {
            $reg_fields_manager->setValues($this->order['regfields']);
        }



        $this->order['only_pickup_points'] = $this->request('only_pickup_points', TYPE_INTEGER, 0); //Флаг использования только самовывоза
        $this->order_api->addOrderExtraDataByStep($this->order, 'onepageorder', $this->url->request('order_extra', TYPE_ARRAY, array())); //Заносим дополнительные данные

        //Проверерим адрес и сведения о пользователе
        $this->checkUserAndAddressFields($this->order, $order_fields_manager, $reg_fields_manager);

        //Проверерим сведения о доставке
        if (!$this->shop_config['hide_delivery']) { //Если не указано скрывать доставку
            $this->checkDeliveryFields($this->order, $this->request('delivery_extra', TYPE_ARRAY, false), $this->request('warehouse', TYPE_INTEGER, 0));
        }

        //Проверерим сведения о оплате
        if (!$this->shop_config['hide_payment']) { //Если не указано скрывать доставку
            $this->checkPaymentFields($this->order);
        }

        //Проверим, если нужны условия продаж
        if ($this->shop_config['require_license_agree'] && !$this->url->post('iagree', TYPE_INTEGER)) {
            $this->order->addError(t('Подтвердите согласие с условиями предоставления услуг'));
        }

        $this->order['comments'] = $this->url->request('comments', TYPE_STRING);

        if (!$this->order->hasError()) { //Если ошибок нет, проверим данные для подтверждения
            $sysdata = array('step' => 'confirm');
            $work_fields = $this->order->useFields($sysdata + $_POST);

            $this->order->setCheckFields($work_fields);
            if ($this->order->checkData($sysdata, null, null, $work_fields)) {
                $this->order['is_payed'] = 0;
                $this->order['delivery_new_query'] = 1; //Флаг определяющий, что нужно сделать запрос к системе доставки, если требуется.

                // запустим событие для модификации заказа и проверим ошибки
                $this->fireConfirmEvent();
                $this->checkCriticalErrors();

                //Создаем заказ в БД
                if (!$this->order->hasError()) {
                    if ($this->order['use_addr'] == 0 && !$this->order['only_pickup_points']) {
                        $address = new Address();
                        $address->getFromArray($this->order->getValues(), 'addr_');
                        $address['user_id'] = Auth::getCurrentUser()['id'];
                        if ($address->insert()) {
                            $this->order->setUseAddr($address['id']);
                        }
                    }

                    if ($this->order->insert()) {
                        $this->order['expired'] = true; //заказ уже оформлен. больше нельзя возвращаться к шагам.
                        Cart::currentCart()->clean(); //Очищаем корзиу

                        $redirect = $this->router->getUrl('shop-front-checkout', ['Act' => 'finish']);
                        return $this->result->setSuccess(true)->addSection('redirect', $redirect);
                    }
                }
            }
        }
        return $this->result->setSuccess(false)->addSection('errors', $this->order->getErrors());
    }

    /**
     * Обновление блоков оформления заказа на одной странице
     *
     * @return ResultStandard
     * @throws \SmartyException
     */
    function actionUpdate()
    {
        /*if (!$this->order->getCart()) { //Если корзины нет, то перенаправим на главную
            Application::getInstance()->redirect();
        }*/

        $delivery_extra = $this->request('delivery_extra', TYPE_ARRAY, false);
        if ($delivery_extra) {
            $this->order->addExtraKeyPair('delivery_extra', $delivery_extra);
        }

        //Получим текущего пользователя
        $user = AppAuth::getCurrentUser();

        //Запишем данные о доставке
        $this->order['only_pickup_points'] = $this->request('only_pickup_points', TYPE_INTEGER, 0); //Флаг использования только самовывоза
        $this->order['delivery'] = $this->request('delivery', TYPE_INTEGER, 0);
        $this->order['payment'] = $this->request('payment', TYPE_INTEGER, 0);
        $this->order['warehouse'] = 0;
        //Только если указана доставка самовывоз мы указываем конкретный склад, если он задан
        if ($this->order['delivery'] && $this->order->getDelivery()->getTypeObject()->isMyselfDelivery()) {
            $this->order['warehouse'] = $this->request('warehouse', TYPE_INTEGER, 0);
        }

        //Добавим сведения об адресе
        $this->order->setAddress($this->getOrderRightAddress($this->order, $this->url));

        EventManager::fire('checkout.confirm', [
            'order' => $this->order,
            'cart' => $this->order->getCart()
        ]);

        return $this->result->setSuccess(true)->addSection('blocks', [
            'user' => $this->getUserBlock(),
            'address' => $this->getAddressBlock($this->order, $user),
            'delivery' => $this->getDeliveryBlock($this->order, $user),
            'payment' => $this->getPaymentBlock($this->order, $user),
            'products' => $this->getProductsBlock(),
            'total' => $this->getTotalBlock(),
        ]);
    }

    protected function getUserBlock()
    {
        $view = new ViewEngine();
        $view->assign($this->getBlocksViewData());
        return $view->fetch("%shop%/blocks/checkout/user_block.tpl");
    }

    /**
     * Получает шаблон блок с адресами
     *
     * @param Order $order - объект заказа
     * @param User $user - объект текущего пользователя
     * @return string
     * @throws \SmartyException
     */
    protected function getAddressBlock(Order $order, User $user)
    {
        $use_addr = $this->url->request('use_addr', TYPE_INTEGER);
        $addr_list = $this->address_api->getCheckoutUserAddresses($order, $user);
        $this->order['addr_country_id'] = $this->url->request('addr_country_id', TYPE_INTEGER, $this->order['addr_country_id']);
        $this->order['addr_region_id'] = $this->url->request('addr_region_id', TYPE_INTEGER, $this->order['addr_region_id']);
        $this->order['addr_region'] = $this->url->request('addr_region', TYPE_STRING, $this->order['addr_region']);
        $this->order['addr_city_id'] = $this->url->request('addr_city_id', TYPE_INTEGER, $this->order['addr_city_id']);
        $this->order['addr_city'] = $this->url->request('addr_city', TYPE_STRING, $this->order['addr_city']);
        $this->order['addr_zipcode'] = $this->url->request('addr_zipcode', TYPE_STRING, $this->order['addr_zipcode']);
        $this->order['addr_address'] = $this->url->request('addr_address', TYPE_STRING, $this->order['addr_address']);
        $this->order['addr_street'] = $this->url->request('addr_street', TYPE_STRING, $this->order['addr_street']);
        $this->order['addr_house'] = $this->url->request('addr_house', TYPE_STRING, $this->order['addr_house']);
        $this->order['addr_block'] = $this->url->request('addr_block', TYPE_STRING, $this->order['addr_block']);
        $this->order['addr_apartment'] = $this->url->request('addr_apartment', TYPE_STRING, $this->order['addr_apartment']);
        $this->order['addr_entrance'] = $this->url->request('addr_entrance', TYPE_STRING, $this->order['addr_entrance']);
        $this->order['addr_entryphone'] = $this->url->request('addr_entryphone', TYPE_STRING, $this->order['addr_entryphone']);
        $this->order['addr_floor'] = $this->url->request('addr_floor', TYPE_STRING, $this->order['addr_floor']);
        $this->order['addr_subway'] = $this->url->request('addr_subway', TYPE_STRING, $this->order['addr_subway']);
        $this->order['contact_person'] = $this->url->request('contact_person', TYPE_STRING ,$this->order['contact_person']);
        $this->order['reg_fio'] = $this->url->request('reg_fio', TYPE_STRING, $this->order['reg_fio']);
        $this->order['reg_name'] = $this->url->request('reg_name', TYPE_STRING, $this->order['reg_name']);
        $this->order['reg_surname'] = $this->url->request('reg_surname', TYPE_STRING, $this->order['reg_surname']);
        $this->order['reg_midname'] = $this->url->request('reg_midname', TYPE_STRING, $this->order['reg_midname']);
        $this->order['reg_phone'] = $this->url->request('reg_phone', TYPE_STRING, $this->order['reg_phone']);
        $this->order['reg_login'] = $this->url->request('reg_login', TYPE_STRING, $this->order['reg_login']);
        $this->order['reg_e_mail'] = $this->url->request('reg_e_mail', TYPE_STRING, $this->order['reg_e_mail']);
        $this->order['reg_autologin'] = $this->url->request('reg_autologin', TYPE_STRING, $this->order['reg_autologin']);
        $this->order['reg_login'] = $this->url->request('reg_login', TYPE_STRING, $this->order['reg_login']);
        $this->order['reg_openpass'] = $this->url->request('reg_openpass', TYPE_STRING, $this->order['reg_openpass']);
        $this->order['reg_pass2'] = $this->url->request('reg_pass2', TYPE_STRING, $this->order['reg_pass2']);
        $this->order['regfields'] = $this->url->request('regfields', TYPE_STRING, $this->order['regfields']);
        $this->order['reg_company'] = $this->url->request('reg_company', TYPE_STRING, $this->order['reg_company']);
        $this->order['reg_company_inn'] = $this->url->request('reg_company_inn', TYPE_STRING, $this->order['reg_company_inn']);
        $this->order['user_fio'] = $this->url->request('user_fio', TYPE_STRING, $this->order['user_fio']);
        $this->order['user_email'] = $this->url->request('user_email', TYPE_STRING, $this->order['user_email']);
        $this->order['user_phone'] = $this->url->request('user_phone', TYPE_STRING, $this->order['user_phone']);

        $this->order['userfields_arr'] = $this->url->request('userfields_arr', TYPE_ARRAY, $this->order['userfields_arr']);
        $this->order['code'] = $this->url->request('code', TYPE_STRING);
        $this->order['user_type'] = $this->url->request('user_type', TYPE_STRING, $this->order['user_type']);


        if ($this->order['use_addr'] !== null || $use_addr) {
            $this->order->setUseAddr($use_addr);
        } else {
            if (AppAuth::isAuthorize()) {
                if ($addr_list) {
                    $this->order->setUseAddr(reset($addr_list)['id']);
                }
            }
        }

        if ($this->order['use_addr'] === null || $this->order['use_addr'] == 0) {
            $this->order->setDefaultAddress();
        }

        /** @var UsersConfig $users_config */
        $users_config = ConfigLoader::byModule('users');

        $view = new ViewEngine();
        $view->assign([
            'have_to_address_delivery' => $this->delivery_api->isHaveToAddressDelivery($this->order),
            'have_pickup_points' => $this->delivery_api->isHavePickUpPoints($this->order),
            'address_list' => $addr_list,
            'is_auth' => AppAuth::isAuthorize(),
            'user' => $user,
            'order' => $order,
            'conf_userfields' => $order->getFieldsManager(),
            'reg_userfields' => $users_config->getUserFieldsManager(),
            'shop_config' => ConfigLoader::byModule('shop'),
            'user_config' => ConfigLoader::byModule('users'),
        ]);
        return $view->fetch('%shop%/blocks/checkout/address_block.tpl');
    }

    /**
     * Получает шаблон блок с доставками
     *
     * @param Order $order - объект заказа
     * @param User $user - объект текущего пользователя
     * @return string
     * @throws \SmartyException
     */
    protected function getDeliveryBlock(Order $order, User $user)
    {
        if (!$this->shop_config['hide_delivery']) { //Если доставку не нужно скрывать
            //Получим новый список доставок с учётом переданных параметров

            $use_addr = $this->url->request('use_addr', TYPE_INTEGER);
            $address = $order->getAddress();
            $addr_region_id = $this->url->request('addr_region_id', TYPE_INTEGER, $address['region_id']);
            $addr_country_id = $this->url->request('addr_country_id', TYPE_INTEGER, $address['country_id']);

            $address = $order->getAddress();

            if ($use_addr > 0) {
                $address = $order->getAddress();
                $addr_region_id = $address['region_id'];
                $addr_country_id = $address['country_id'];
            }

            if (!$addr_country_id) {
                //Получаем страну первую в списке
                $region_api = new RegionApi();
                $region_api->setFilter('parent_id', 0);
                $address['country_id'] = $addr_country_id = $region_api->queryObj()->limit(1)->exec()->getOneField('id');
            }

            if ($addr_country_id && !$addr_region_id) {
                //Получаем первый в списке регион
                if ($addr_country_id == 0) {
                    $addr_region_id = null;
                } else {
                    $region_api = new RegionApi();
                    $region_api->setFilter('parent_id', $addr_country_id);
                    $addr_region_id = $region_api->queryObj()->limit(1)->exec()->getOneField('id');
                }
                $address['region_id'] = $addr_region_id;
            }

            //Устанавливаем значения, которые пришли из request
            $user_type = $this->url->request('user_type', TYPE_STRING, $user['is_company'] ? 'company' : 'person');
            $user['is_company'] = $user_type == 'company';

            $view = new ViewEngine();
            $view->assign($this->getBlocksViewData());
            return $view->fetch("%shop%/blocks/checkout/delivery_block.tpl");
        }
        return '';
    }

    /**
     * Получает шаблон блок с оплатами
     *
     * @param Order $order - объект заказа
     * @param User $user - объект текущего пользователя
     * @return string
     * @throws \SmartyException
     */
    protected function getPaymentBlock(Order $order, User $user)
    {
        $user_type = $this->url->request('user_type', TYPE_STRING, $user['is_company'] ? 'company' : 'person');
        $user['is_company'] = $user_type == 'company';

        $view_data = $this->getBlocksViewData();

        if (!$this->shop_config['hide_payment']) { //Если оплату не нужно скрывать
            $view = new ViewEngine();
            $view->assign($view_data);
            return $view->fetch("%shop%/blocks/checkout/payment_block.tpl");
        }
        return '';
    }

    /**
     * Получает шаблон блок с товарами
     *
     * @return string
     * @throws \SmartyException
     */
    protected function getProductsBlock()
    {
        $view = new ViewEngine();
        $view->assign($this->getBlocksViewData());
        return $view->fetch("%shop%/blocks/checkout/products_block.tpl");
    }

    /**
     * Получает шаблон блок с итогом
     *
     * @return string
     * @throws \SmartyException
     */
    protected function getTotalBlock()
    {
        $view = new ViewEngine();
        $view->assign($this->getBlocksViewData());
        return $view->fetch("%shop%/blocks/checkout/total_block.tpl");
    }

    protected function getBlocksViewData()
    {
        static $view_data;
        if ($view_data === null) {
            $user = $this->order->getUser();

            $delivery_list = $this->delivery_api->getCheckoutDeliveryList($user, $this->order, true, $this->use_strict_to_address_filter);

            if (empty($this->order['delivery'])) {
                foreach ($delivery_list as $delivery) {
                    if ($delivery['default']) {
                        $this->order['delivery'] = $delivery['id'];
                        break;
                    }
                }
            }
            if (!empty($delivery_list) && (!isset($this->order['delivery']) || !isset($delivery_list[$this->order['delivery']]))) {
                $new_delivery = reset($delivery_list);
                $this->order['delivery'] = $new_delivery['id'];
            }

            $payment_list = $this->payment_api->getCheckoutPaymentList($user, $this->order);
            if (!$this->order['payment']) {
                foreach ($payment_list as $payment) {
                    if ($payment['default_payment']) {
                        $this->order['payment'] = $payment['id'];
                        break;
                    }
                }
            }

            $view_data = [
                'order' => $this->order,
                'cart' => $this->order->getCart(),
                'user' => $user,
                'shop_config' => $this->shop_config,
                'this_controller' => $this,
                'address_list' => $this->address_api->getCheckoutUserAddresses($this->order, $user),
                'delivery_list' => $delivery_list,
                'warehouses' => WareHouseApi::getPickupWarehousesPoints(),
                'delivery_extra' => $this->order->getExtraKeyPair('delivery_extra'),
                'payment_list' => $payment_list,
            ];
        }
        return $view_data;
    }

    /**
     * Удаление адреса при оформлении заказа
     */
    function actionDeleteAddress()
    {
        $id = $this->url->request('id', TYPE_INTEGER, 0); //id адреса доставки
        if ($id) {
            $address = new Address($id);
            if ($address['user_id'] == $this->user['id']) {
                $address['deleted'] = 1;
                $address->update();
            }
            return $this->result->setSuccess(true);
        }
        return $this->result->setSuccess(false);
    }


    /**
     * Подбирает город по совпадению в переданной строке
     */
    function actionSearchCity()
    {
        $result_json = array();
        $query = $this->request('term', TYPE_STRING, false);
        $region_id = $this->request('region_id', TYPE_INTEGER, false);
        $country_id = $this->request('country_id', TYPE_INTEGER, false);

        if ($query !== false && $this->url->isAjax()) { //Если задана поисковая фраза и это аякс
            /** @var Region[] $cities */
            $cities = $this->order_api->searchCityByRegionOrCountry($query, $region_id, $country_id);

            if (!empty($cities)) {
                foreach ($cities as $city) {
                    $region = $city->getParent();
                    $country = $region->getParent();
                    $result_json[] = array(
                        'value' => $city['title'],
                        'label' => preg_replace("%($query)%iu", '<b>$1</b>', $city['title']),
                        'id' => $city['id'],
                        'zipcode' => $city['zipcode'],
                        'region_id' => $region['id'],
                        'country_id' => $country['id']
                    );
                }
            }
        }
        $this->app->headers->addHeader('content-type', 'application/json');
        return json_encode($result_json);
    }

    /**
     * Устанавливает данные об адресе для заказа на основе входящих данных от формы
     *
     * @param Order $order - объект заказа
     * @param HttpRequest $url - объект запроса
     * @return Address
     */
    public function getOrderRightAddress(Order $order, HttpRequest $url)
    {
        $use_address = $url->request('use_addr', TYPE_STRING, false);// Флаг - использовать существующий адрес

        if ($use_address === "0") {
            $tmp_adress = new Address();
            //Установка страны
            $tmp_adress['country_id'] = $url->request('addr_country_id', TYPE_STRING, null);
            if ($tmp_adress['country_id']) {
                $country = new Region($tmp_adress['country_id']);
                $tmp_adress['country'] = $country['title'];
            }
            $tmp_adress['country_id'] = $url->request('addr_country_id', TYPE_STRING, null);
            //Установка региона
            $tmp_adress['region_id'] = $url->request('addr_region_id', TYPE_STRING, null);
            if ($tmp_adress['region_id']) {
                $region = new Region($tmp_adress['region_id']);
                $tmp_adress['region'] = $region['title'];
            }
            $tmp_adress['zipcode'] = $url->request('addr_zipcode', TYPE_STRING, null);
            $tmp_adress['city'] = $url->request('addr_city', TYPE_STRING, null);
            $tmp_adress['address'] = $url->request('addr_address', TYPE_STRING, null);
            $tmp_adress['street'] = $url->request('addr_street', TYPE_STRING, null);
            $tmp_adress['house'] = $url->request('addr_house', TYPE_STRING, null);
            $tmp_adress['block'] = $url->request('addr_block', TYPE_STRING, null);
            $tmp_adress['apartment'] = $url->request('addr_apartment', TYPE_STRING, null);
            $tmp_adress['entrance'] = $url->request('addr_entrance', TYPE_STRING, null);
            $tmp_adress['entryphone'] = $url->request('addr_entryphone', TYPE_STRING, null);
            $tmp_adress['floor'] = $url->request('addr_floor', TYPE_STRING, null);
            $tmp_adress['subway'] = $url->request('addr_subway', TYPE_STRING, null);

            //Поищем id города и запишем
            $api = new RegionApi();
            $api->setFilter('title', $tmp_adress['city']);
            $api->setFilter('site_id', SiteManager::getSiteId());
            $api->setFilter('is_city', 1);
            $city = $api->getFirst();
            $tmp_adress['city_id'] = $city ? $city['id'] : null;

            return $tmp_adress;
        } elseif ($use_address > 0) {//Если передан через запос точный адрес, то подгрузим его
            return new Address($use_address);
        } else {
            $address = $order->getAddress(); //Получим текущий установленный адрес или пустой объект
            return $address;
        }
    }

    /**
     * Проверяет сведения о полях пользователя и сведения о адресе, и если есть ошибки добавляет их в объект заказа
     *
     * @param Order $order - объект заказа
     * @param UserFieldsManager $order_fields_manager - менеджер полей заказа
     * @param UserFieldsManager $reg_fields_manager - менеджер полей регистрации
     * @return void
     * @throws RSException
     */
    public function checkUserAndAddressFields(Order $order, $order_fields_manager, $reg_fields_manager)
    {
        $sysdata = array('step' => 'address');
        $work_fields = $order->useFields($sysdata + $_POST);
        $user_config = ConfigLoader::byModule('users');

        if ($order['only_pickup_points']) { //Если только самовывоз то исключим поля
            $work_fields = array_diff($work_fields, ['addr_country_id', 'addr_region', 'addr_region_id', 'addr_city', 'addr_zipcode', 'addr_address', 'use_addr']);
            $order->setUseAddr(0);
        }

        $order->setCheckFields($work_fields);
        $order->checkData($sysdata, null, null, $work_fields);
        $order['userfields'] = serialize($order['userfields_arr']);

        //Авторизовываемся
        //@deprecated Оставлено для совместимости со старыми шаблонами. В будущих версиях будет удалено
        //Авторизация будет работать только при стандартном типе авторизации в настройках модуля Users

        if ($order['user_type'] == 'user' && $user_config['type_auth'] == UserConfig::TYPE_AUTH_STANDARD) {
            if (!Auth::login($order['login'], $order['password'])) {
                $order->addError(t('Неверный логин или пароль'), 'login');
            } else {
                $order['user_type'] = '';
                $order['__code']->setEnable(false);
            }
        }

        $login = HttpRequest::commonInstance()->request('ologin', TYPE_BOOLEAN); //Предварительная авторизация

        if (!$login) {
            //Проверяем пароль, если пользователь решил задать его вручную. (при регистрации)
            if (in_array($order['user_type'], array('person', 'company'))) {

                if (!$order['reg_autologin']) {
                    if (strcmp($order['reg_openpass'], $order['reg_pass2'])) {
                        $order->addError(t('Пароли не совпадают'), 'reg_openpass');
                    }
                }

                //Сохраняем дополнительные сведения о пользователе
                $uf_err = $reg_fields_manager->check($order['regfields']);
                if (!$uf_err) {
                    foreach ($reg_fields_manager->getErrors() as $form => $errortext) {
                        $order->addError($errortext, $form); //Переносим ошибки в объект order
                    }
                }

                $new_user = new User();
                $new_user->addLinkToAuthInError(true);
                $new_user->enableRegistrationCheckers();
                $new_user['__phone']->setEnableVerification(false); //Проверка будет идти в поле reg_phone в объекте order
                $new_user['__data']->removeAllCheckers();
                $new_user['changepass'] = 1;

                $allow_fields = ['reg_name', 'reg_surname', 'reg_midname', 'reg_fio', 'reg_phone', 'reg_login', 'reg_e_mail', 'reg_openpass', 'reg_company', 'reg_company_inn'];

                $reg_fields = array_intersect_key($order->getValues(), array_flip($allow_fields));

                $new_user->getFromArray($reg_fields, 'reg_');
                $new_user['data'] = $order['regfields'];
                $new_user['is_company'] = (int)($order['user_type'] == 'company');

                if ($order['reg_autologin']) {
                    $new_user['openpass'] = HelperTools::generatePassword(6);
                }

                if (!$new_user->validate()) {
                    foreach ($new_user->getErrorsByForm() as $form => $errors) {
                        $order->addErrors($errors, 'reg_' . $form);
                    }
                }

                if (!$order->hasError()) {
                    if ($new_user->insert()) {
                        AppAuth::setCurrentUser($new_user);
                        if (AppAuth::onSuccessLogin($new_user, true)) {
                            $order['user_type'] = ''; //Тип регитрации - не актуален после авторизации
                            $order['__code']->setEnable(false);
                        } else {
                            throw new RSException(AppAuth::getError());
                        }
                    } else {
                        throw new RSException(t('Не удалось создать пользователя.').$new_user->getErrorsStr());
                    }
                }
            }

            //Если заказ без регистрации пользователя
            if ($order['user_type'] == 'noregister') {
                //Получим данные
                $shop_config = $this->shop_config;
                $order['user_fio'] = HttpRequest::commonInstance()->request('user_fio', TYPE_STRING);
                $order['user_email'] = HttpRequest::commonInstance()->request('user_email', TYPE_STRING);
                $order['user_phone'] = HttpRequest::commonInstance()->request('user_phone', TYPE_STRING);

                //Проверим данные
                if (empty($order['user_fio'])) {
                    $order->addError(t('Укажите, пожалуйста, Ф.И.О.'), 'user_fio');
                }
                if ($shop_config['require_email_in_noregister'] && !filter_var($order['user_email'], FILTER_VALIDATE_EMAIL)) {
                    $order->addError(t('Укажите, пожалуйста, E-mail'), 'user_email');
                }
                if ($shop_config['require_phone_in_noregister']) {
                    if (empty($order['user_phone'])) {
                        $order->addError(t('Укажите, пожалуйста, Телефон'), 'user_phone');
                    } elseif (!preg_match('/^[0-9()\-\s+,]+$/', $order['user_phone'])) {
                        $order->addError(t('Неверно указан телефон'), 'user_phone');
                    }
                }
            }

            //Сохраняем дополнительные сведения
            $uf_err = $order_fields_manager->check($order['userfields_arr']);
            if (!$uf_err) {

                //Переносим ошибки в объект order
                foreach ($order_fields_manager->getErrors() as $form => $errortext) {
                    $order->addError($errortext, $form);
                }
            }

            //Все успешно, присвоим этого пользователя заказу
            if (!$order->hasError()) {
                $order['user_id'] = Auth::getCurrentUser()['id'];
            }
        }
    }

    /**
     * Проверяет сведения о полях доставки, и если есть ошибки добавляет их в объект заказа
     *
     * @param Order $order - объект заказа
     * @param array|null $delivery_extra - дополнительные данные по доставке для добавления в заказ
     * @param integer $warehouse_id - id выбранного склада
     * @return void
     * @throws RSException
     */
    public function checkDeliveryFields(Order $order, $delivery_extra = null, $warehouse_id = 0)
    {
        $sysdata = array('step' => 'delivery');
        $work_fields = $order->useFields($sysdata + $_POST);
        $order->setCheckFields($work_fields);

        if ($order->checkData($sysdata, null, null, $work_fields)) {
            if ($delivery_extra) {
                $order->addExtraKeyPair('delivery_extra', $delivery_extra);
            }
            $order['warehouse'] = $warehouse_id;
        }
    }

    /**
     * Проверяет сведения о полях оплаты, и если есть ошибки добавляет их в объект заказа
     *
     * @param Order $order - объект заказа
     * @return void
     * @throws RSException
     */
    public function checkPaymentFields(Order $order)
    {
        $sysdata = array('step' => 'pay');
        $work_fields = $order->useFields($sysdata + $_POST);
        $order->setCheckFields($work_fields);
        $order->checkData($sysdata, null, null, $work_fields);
    }

    /**
     * Указывает использовать ли строгую фильтрацию доставок до адреса
     *
     * @param bool $value - значение
     * @return void
     */
    public function setUseStrictToAddressFilter($value)
    {
        $this->use_strict_to_address_filter = $value;
    }

    /**
     * Возвращает объект заказа
     *
     * @return Order
     */
    public function getOrder()
    {
        return $this->order;
    }
}

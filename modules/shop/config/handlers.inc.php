<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/

namespace Shop\Config;

use Catalog\Model\Orm\Dir;
use Catalog\Model\Orm\Product;
use Crm\Model\Autotask\Ruleif\{CreateOrder, CreateReservation};
use Crm\Model\Links\Type\{LinkTypeOrder, LinkTypeReservation};
use RS\Config\Loader as ConfigLoader;
use RS\Controller\Admin\Helper\CrudCollection;
use RS\Db\Exception as DbException;
use RS\Event\Exception as EventException;
use RS\Event\HandlerAbstract;
use RS\Exception as RSException;
use RS\Html\Filter;
use RS\Html\Table\Type as TableType;
use RS\Http\Request as HttpRequest;
use RS\Orm\AbstractObject;
use RS\Orm\Exception as OrmException;
use RS\Orm\Request as OrmRequest;
use RS\Orm\Type as OrmType;
use RS\Site\Manager as SiteManager;
use RS\Router\Manager as RouterManager;
use RS\Router\Route;
use Shop\Config\File as ShopConfig;
use Shop\Model\Behavior as ShopBehavior;
use Shop\Model\Cart;
use Shop\Model\DeliveryType;
use Shop\Model\OrderApi;
use Shop\Model\Orm\CartItem;
use Shop\Model\Orm\Order;
use Shop\Model\Orm\UserStatus;
use Shop\Model\PaymentType;
use Shop\Model\PrintForm;
use Shop\Model\ProductsReturnApi;
use Shop\Model\ReceiptApi;
use Shop\Model\ReservationApi;
use Users\Model\Orm\User;

class Handlers extends HandlerAbstract
{
    /**
     * Инициализация модуля
     */
    function init()
    {
        $this->bind('initialize');
        $this->bind('getroute');
        $this->bind('getmenus');
        $this->bind('user.auth');
        $this->bind('delivery.gettypes');
        $this->bind('payment.gettypes');
        $this->bind('printform.getlist');
        $this->bind('orm.init.catalog-dir');
        $this->bind('orm.init.catalog-product');
        $this->bind('orm.init.users-user');
        $this->bind('controller.exec.users-admin-ctrl.index');
        $this->bind('api.oauth.token.success');
        $this->bind('meter.recalculate');
        $this->bind('crm.interaction.getlinktypes');
        $this->bind('crm.deal.getlinktypes');
        $this->bind('crm.task.getlinktypes');
        $this->bind('crm.getifrules');
        $this->bind('cron');

        if (\Setup::$INSTALLED) {
            $this->bind('orm.afterwrite.site-site', $this, 'onSiteCreate');
        }
    }

    /**
     * Расширяем поведение объекта Пользователь
     */
    public static function initialize()
    {
        User::attachClassBehavior(new ShopBehavior\UsersUser);
    }

    /**
     * Добавляет в CRM взаимодействия возможность связи с заказом
     *
     * @param array $link_types
     * @return array
     * @throws RSException
     */
    public static function crmInteractionGetLinkTypes($link_types)
    {
        $link_types[] = LinkTypeOrder::getId();
        return $link_types;
    }

    /**
     * Добавляет в CRM сделки возможность связи с предзаказом
     *
     * @param array $link_types
     * @return array
     * @throws RSException
     */
    public static function crmDealGetLinkTypes($link_types)
    {
        $link_types[] = LinkTypeOrder::getId();
        $link_types[] = LinkTypeReservation::getId();
        return $link_types;
    }

    /**
     * Добавляет в CRM задачи возможность связи с заказом
     *
     * @param array $link_types
     * @return array
     * @throws RSException
     */
    public static function crmTaskGetLinkTypes($link_types)
    {
        $link_types[] = LinkTypeOrder::getId();
        return $link_types;
    }

    /**
     * Добавляет возможность создания автозадач при создании заказа или предзаказа
     *
     * @param array $list
     * @return array
     */
    public static function crmGetIfRules($list)
    {
        $list[] = new CreateOrder();
        $list[] = new CreateReservation();

        return $list;
    }


    /**
     * Добавляем информацию о количестве непросмотренных заказов
     * во время вызова события пересчета счетчиков
     *
     * @param array $meters - параметры метрики
     * @return mixed
     */
    public static function meterRecalculate($meters)
    {
        $order_api = new OrderApi();
        $order_meter_api = $order_api->getMeterApi();
        $meters[$order_meter_api->getMeterId()] = $order_meter_api->getUnviewedCounter();

        $reservation_api = new ReservationApi();
        $reservation_meter_api = $reservation_api->getMeterApi();
        $meters[$reservation_meter_api->getMeterId()] = $reservation_meter_api->getUnviewedCounter();

        $return_api = new ProductsReturnApi();
        $return_meter_api = $return_api->getMeterApi();
        $meters[$return_meter_api->getMeterId()] = $return_meter_api->getUnviewedCounter();

        return $meters;
    }

    /**
     * Добавляем к сведениям об авторизации, сведения о том, является ли пользователь курьером
     * @param array $params - параметры удачной авторизации
     * @return array
     */
    public static function apiOauthTokenSuccess($params)
    {
        $config = ConfigLoader::byModule(__CLASS__);
        $user_id = $params['result']['response']['user']['id'];

        $courier_user_group = $config['courier_user_group'];
        $user = new User($user_id);
        $params['result']['response']['user']['is_courier'] = in_array($courier_user_group, $user->getUserGroups());

        return $params;
    }

    /**
     * Расширяет функционал контроллера админ панели пользователей
     *
     * @param CrudCollection $crud_collection - объект контроллера
     */
    public static function controllerExecUsersAdminCtrlIndex(CrudCollection $crud_collection)
    {
        //Добавим колонку "Баланс" в таблицу с пользователями
        /** @var \RS\Html\Table\Control $table */
        $table = $crud_collection['table'];
        $table->getTable()->addColumn(new TableType\Text('balance', t('Баланс'), array('Sortable' => SORTABLE_BOTH)), -1);

        //Добавим фильтр по балансу
        /** @var \RS\Html\Filter\Control $filter */
        $filter = $crud_collection['filter'];

        $container = $filter->getContainer();
        $lines = $container->getLines();
        $lines[0]->addItem(new Filter\Type\Text('balance', t('Баланс'), array(
            'showType' => true
        )));
        $container->cleanItemsCache();

        //Добавим действия в таблицу
        $router = RouterManager::obj();
        $columns = $table->getTable()->getColumns();
        foreach ($columns as $column) {
            if ($column instanceof TableType\Actions) {
                foreach ($column->getActions() as $action) {
                    if ($action instanceof TableType\Action\DropDown) {
                        $action->addItem(array(
                            'title' => t('история транзакций'),
                            'attr' => array(
                                '@href' => $router->getAdminPattern(false, array(':f[user_id]' => '@id'), 'shop-transactionctrl'),
                            )
                        ));

                        $action->addItem(array(
                            'title' => t('исправить баланс'),
                            'attr' => array(
                                'class' => 'crud-get',
                                '@href' => $router->getAdminPattern('fixBalance', array(':id' => '@id'), 'shop-balancectrl'),
                            )
                        ));
                    }
                }
                $column->addAction(new TableType\Action\Action($router->getAdminPattern('addfunds', array(':id' => '~field~', 'writeoff' => 0), 'shop-balancectrl'), t('пополнить баланс'), array('iconClass' => 'money', 'class' => 'crud-add')), 0);
                $column->addAction(new TableType\Action\Action($router->getAdminPattern('addfunds', array(':id' => '~field~', 'writeoff' => 1), 'shop-balancectrl'), t('списать с баланса'), array('iconClass' => 'money-off', 'class' => 'crud-add')), 0);
            }
        }
    }

    /**
     * Возвращает маршруты данного модуля
     *
     * @param array $routes - ранее установленые маршруты
     * @return array
     */
    public static function getRoute(array $routes)
    {
        //Корзина
        $routes[] = new Route('shop-front-cartpage', '/cart/', null, t('Корзина'));
        //Корзина с оформлением заказа
        $routes[] = new Route('shop-front-cartcheckout', '/cart-checkout/', null, t('Корзина с оформлением заказа'));
        $routes[] = new Route('shop-block-checkout', '/block-checkout/', null, t('Блок оформления заказа'));
        //Выбор многомерной комплектации
        $routes[] = new Route('shop-front-multioffers', '/multioffers/{product_id}/', null, t('Выбор многомерной комплектации'));
        //Оформление заказа
        $routes[] = new Route('shop-front-checkout', array('/checkout/{Act}/', '/checkout/'), null, t('Оформление заказа'));
        //Документ на оплату
        $routes[] = new Route('shop-front-documents', '/paydocuments/', null, t('Документ на оплату'));
        //Лицензионное соглашение
        $routes[] = new Route('shop-front-licenseagreement', '/license-agreement/', null, t('Лицензионное соглашение'));
        //Просмотр заказа
        $routes[] = new Route('shop-front-myorderview', array('/my/orders/view-{order_id}/'), null, t('Просмотр заказа'));
        //Мои заказы
        $routes[] = new Route('shop-front-myorders', array('/my/orders/'), null, t('Мои заказы'));
        //Мои возвраты
        $routes[] = new Route('shop-front-myproductsreturn', array('/my/productsreturn/{Act:(add|edit|delete|print|view|rules)}/', '/my/productsreturn/'), null, t('Мои возвраты'));
        //Лицевой счет
        $routes[] = new Route('shop-front-mybalance', array('/my/balance/{Act}/', '/my/balance/'), null, t('Лицевой счет'));
        //Online платежи
        $routes[] = new Route('shop-front-onlinepay', array('/onlinepay/{PaymentType}/{Act:(success|fail|result|status)}/', '/onlinepay/{Act}/'), null, t('Online платежи'));
        //Список регионов
        $routes[] = new Route('shop-front-regiontools', '/regiontools/', null, t('Список регионов'), true);
        //Предварительный заказ товара
        $routes[] = new Route('shop-front-reservation', '/reservation/{product_id}/', null, t('Предварительный заказ товара'));
        //Контроллер для приёма команд от касс онлайн
        $routes[] = new Route('shop-front-cashregister', array(
            '/cashregister/{CashRegisterType}/{Act}/',
            '/cashregister/{CashRegisterType}/'
        ), null, t('Шлюз обмена данными с кассами'), true);

        return $routes;
    }

    /**
     * Привязывает корзину к пользователю после авторизации
     *
     * @param array $params - массив параметров с объектами пользователя
     */
    public static function userAuth($params)
    {
        /** @var User $user */
        $user = $params['user'];
        $guest_id = HttpRequest::commonInstance()->cookie('guest', TYPE_STRING, false);
        //Привязываем корзину к пользователю
        $cart = Cart::currentCart();
        $items = $cart->getCartItemsByType();
        $has_current_session_items = false;
        foreach ($items as $item) {
            if ($item['session_id'] == $guest_id) {
                $has_current_session_items = true;
                break;
            }
        }
        if ($has_current_session_items) {
            //Если будучи неавторизованным, пользователь собрал новую корзину, 
            //то НЕ импортируем корзину от авторизованного пользователя
            (new OrmRequest)
                ->delete()
                ->from(new CartItem())
                ->where("user_id = '#user_id' AND session_id != '#session_id'", array(
                    'session_id' => $guest_id,
                    'user_id' => $user['id']
                ))
                ->exec();
        } else {
            //Если текущая корзина пользователя пуста, а у авторизованного пользователя была собрана, 
            //то импортируем её
            (new OrmRequest)
                ->update(new CartItem())
                ->set(array(
                    'session_id' => $guest_id
                ))->where(array(
                    'user_id' => $user['id']
                ))->exec();

            $cart->cleanInfoCache();
        }

        (new OrmRequest)
            ->update(new CartItem())
            ->set(array(
                'user_id' => $user['id']
            ))->where(array(
                'session_id' => $guest_id
            ))->exec();

        Cart::destroy();
    }

    /**
     * Возвращает процессоры(типы) доставки, присутствующие в текущем модуле
     *
     * @param array $list - массив из передаваемых классов доставок
     * @return array
     */
    public static function deliveryGetTypes($list)
    {
        $list[] = new DeliveryType\FixedPay();
        $list[] = new DeliveryType\Myself();
        $list[] = new DeliveryType\Manual();
        $list[] = new DeliveryType\Spsr();
        $list[] = new DeliveryType\RussianPost();
        $list[] = new DeliveryType\Universal();
        $list[] = new DeliveryType\Cdek();
        $list[] = new DeliveryType\RussianPostCalc();
        return $list;
    }

    /**
     * Возвращает способы оплаты, присутствующие в текущем модуле
     *
     * @param array $list - массив из передаваемых классов оплат
     * @return array
     */
    public static function paymentGetTypes($list)
    {
        $list[] = new PaymentType\Cash();
        $list[] = new PaymentType\Bill();
        $list[] = new PaymentType\FormPd4();
        $list[] = new PaymentType\Robokassa();
        $list[] = new PaymentType\Assist();
        $list[] = new PaymentType\PayPal();
        $list[] = new PaymentType\YandexMoney();
        $list[] = new PaymentType\YandexKassaApi();
        $list[] = new PaymentType\PersonalAccount();
        $list[] = new PaymentType\Toucan();
        return $list;
    }

    /**
     * Обрабатывает событие - создание сайта
     *
     * @param array $params - массив параметров с объектом сайта
     */
    public static function onSiteCreate($params)
    {
        if ($params['flag'] == AbstractObject::INSERT_FLAG) {

            $site = $params['orm'];
            UserStatus::insertDefaultStatuses($site['id']); //Добавляем статусы заказов по-умолчанию

            $module = new \RS\Module\Item('shop');
            /** @var \Shop\Config\Install $installer */
            $installer = $module->getInstallInstance();
            $installer->importCsv(new \Shop\Model\CsvSchema\Region(), 'regions', $site['id']);
            $installer->importCsv(new \Shop\Model\CsvSchema\Zone(), 'zones', $site['id']);
            $installer->importCsv(new \Shop\Model\CsvSchema\SubStatus(), 'substatus', $site['id']);
        }
    }

    /**
     * Добавляем раздел "Налоги" в карточку товара
     *
     * @param Product $orm_product - объект товара
     */
    public static function ormInitCatalogProduct(Product $orm_product)
    {
        $orm_product->getPropertyIterator()->append(array(
            t('Основные'),
                'disallow_manually_add_to_cart' => new OrmType\Integer(array(
                    'description' => t('Запретить ручное добавление товара в корзину'),
                    'hint' => t('Может использоваться для подарочных товаров, которые автоматически добавляются в корзину'),
                    'maxLength' => '1',
                    'checkboxView' => array(1, 0),
                    'default' => 0,
                )),
                'payment_subject' => new OrmType\Varchar(array(
                    'description' => t('Признак предмета расчета для чека'),
                    'hint' => t('Признак предмета расчета для печати в чеке по ФЗ-54'),
                    'listFromArray' => array(array(
                        'commodity' => t('Товар'),
                        'excise' => t('Подакцизный товар'),
                        'service' => t('Услуга'),
                        'payment' => t('Платеж'),
                        'another' => t('Другое'),
                    )),
                    'default' => 'commodity'
                )),
                'payment_method' => new OrmType\Varchar(array(
                    'description' => t('Признак способа расчета для чека'),
                    'hint' => t('Если будет задан, то будет перекрывать все остальные настройки (в оплате и настройках модуля Магазин)'),
                    'list' => array(array('\Shop\Model\CashRegisterApi', 'getStaticPaymentMethods'), array(0 => t('По умолчанию'))),
                    'allowEmpty' => false,
                    'default' => 0,
                )),
            t('Налоги'),
                'tax_ids' => new OrmType\Varchar(array(
                    'description' => t('Налоги'),
                    'template' => '%shop%/productform/taxes.tpl',
                    'default' => 'category',
                    'list' => array(array('\Shop\Model\TaxApi', 'staticSelectList'))
                )),
            t('Маркировка'),
                'marked_class' => (new OrmType\Varchar())
                    ->setDescription(t('Класс маркируемых товаров'))
                    ->setList('Shop\Model\Marking\MarkingApi::MarkedClassesSelectList')
                    ->setDefault(''),
        ));
    }

    /**
     * Добавляем раздел "Налоги" в категорию товара
     *
     * @param Dir $orm_dir - объект категории
     */
    public static function ormInitCatalogDir(Dir $orm_dir)
    {
        $orm_dir->getPropertyIterator()->append(array(
            t('Налоги'),
                'tax_ids' => new OrmType\Varchar(array(
                    'description' => t('Налоги'),
                    'default' => 'all',
                    'template' => '%shop%/productform/taxes_dir.tpl',
                    'list' => array(array('\Shop\Model\TaxApi', 'staticSelectList')),
                    'rootVisible' => false
                )),
        ));
    }

    /**
     * Расширяем объект User, добавляя в него доп свойство "Менеджер пользователя"
     *
     * @param User $user
     */
    public static function ormInitUsersUser(User $user)
    {
        $user->getPropertyIterator()->append(array(
            t('Основные'),
                'manager_user_id' => new OrmType\Integer(array(
                    'index' => true,
                    'description' => t('Менеджер пользователя'),
                    'hint' => t('У всех заказов пользователя будет автоматически указываться выбранный менеджер'),
                    'list' => array(array('\Shop\Model\OrderApi', 'getUsersManagersName'), array(0 => t('- Не задан -'))),
                    'allowEmpty' => false,
                )),
        ));
    }

    /**
     * Добавляет в систему печатные формы для заказа
     *
     * @param array $list - массив установленных меню
     * @return array
     */
    public static function printFormGetList($list)
    {
        $list[] = new PrintForm\OrderForm();
        $list[] = new PrintForm\CommodityCheck();
        $list[] = new PrintForm\DeliveryNote();
        $list[] = new PrintForm\Torg12();
        $list[] = new PrintForm\Upd();
        $list[] = new PrintForm\SchetFactura();
        return $list;
    }

    /**
     * Возвращает пункты меню этого модуля в виде массива
     *
     * @param array $items - массив установленных меню
     * @return array
     */
    public static function getMenus($items)
    {
        $items[] = array(
            'title' => t('Магазин'),
            'alias' => 'orders',
            'link' => '%ADMINPATH%/shop-orderctrl/',
            'parent' => 0,
            'sortn' => 10,
            'typelink' => 'link',
        );
        $items[] = array(
            'title' => t('Заказы'),
            'alias' => 'allorders',
            'link' => '%ADMINPATH%/shop-orderctrl/',
            'sortn' => 0,
            'typelink' => 'link',
            'parent' => 'orders'
        );
        $items[] = array(
            'title' => t('Предварительные заказы'),
            'alias' => 'advorders',
            'link' => '%ADMINPATH%/shop-reservationctrl/',
            'sortn' => 1,
            'typelink' => 'link',
            'parent' => 'orders'
        );
        $items[] = array(
            'title' => t('Скидочные купоны'),
            'alias' => 'discount',
            'link' => '%ADMINPATH%/shop-discountctrl/',
            'sortn' => 3,
            'typelink' => 'link',
            'parent' => 'orders'
        );
        $items[] = array(
            'title' => t('Доставка'),
            'alias' => 'deliverygroup',
            'link' => '%ADMINPATH%/shop-regionctrl/',
            'sortn' => 4,
            'typelink' => 'link',
            'parent' => 'orders'
        );
        $items[] = array(
            'title' => t('Способы доставки'),
            'alias' => 'delivery',
            'link' => '%ADMINPATH%/shop-deliveryctrl/',
            'parent' => 'deliverygroup',
            'typelink' => 'link',
            'sortn' => 1,

        );
        $items[] = array(
            'title' => t('Регионы доставки'),
            'alias' => 'regions',
            'link' => '%ADMINPATH%/shop-regionctrl/',
            'parent' => 'deliverygroup',
            'typelink' => 'link',
            'sortn' => 2,

        );
        $items[] = array(
            'title' => t('Зоны'),
            'alias' => 'zones',
            'link' => '%ADMINPATH%/shop-zonectrl/',
            'parent' => 'deliverygroup',
            'sortn' => 3,
            'typelink' => 'link',
        );
        $items[] = array(
            'title' => t('Способы оплаты'),
            'alias' => 'payment',
            'link' => '%ADMINPATH%/shop-paymentctrl/',
            'sortn' => 5,
            'typelink' => 'link',
            'parent' => 'orders'
        );
        $items[] = array(
            'title' => t('Налоги'),
            'alias' => 'taxes',
            'link' => '%ADMINPATH%/shop-taxctrl/',
            'sortn' => 7,
            'typelink' => 'link',
            'parent' => 'orders'
        );
        $items[] = array(
            'title' => t('Транзакции'),
            'alias' => 'transactions',
            'parent' => 'userscontrol',
            'link' => '%ADMINPATH%/shop-transactionctrl/',
            'sortn' => 40,
            'typelink' => 'link',
        );
        $items[] = array(
            'title' => t('Электронные чеки'),
            'alias' => 'receipt',
            'parent' => 'userscontrol',
            'link' => '%ADMINPATH%/shop-receiptsctrl/',
            'sortn' => 42,
            'typelink' => 'link',
        );
        $items[] = array(
            'title' => t('Возвраты товаров'),
            'alias' => 'returns',
            'parent' => 'orders',
            'link' => '%ADMINPATH%/shop-returnsctrl/',
            'sortn' => 9,
            'typelink' => 'link',
        );
        $items[] = array(
            'title' => t('Отгрузки заказов'),
            'alias' => 'shipments',
            'parent' => 'orders',
            'link' => '%ADMINPATH%/shop-ordershipmentctrl/',
            'sortn' => 10,
            'typelink' => 'link',
        );
        return $items;
    }

    /**
     * Обработка событий по cron
     *
     * @param array $params - параметры cron
     * @return void
     * @throws DbException
     * @throws RSException
     */
    public static function cron($params)
    {
        //Запускаем в полночь проверку на автоматический перевод статусов заказов,
        //которые находятся в статусе L более N дней
        if (in_array(0, $params['minutes'])) {
            $sites = SiteManager::getSiteList();
            foreach ($sites as $site) {
                /** @var \Shop\Config\File $config */
                $config = ConfigLoader::byModule(__CLASS__, $site['id']);
                if ($config['auto_change_status'] && $config['auto_change_timeout_days'] && $config['auto_change_from_status']) {
                    self::autoChangeOrderStatus($config, $site['id']);
                }
            }
        }
        // Запускаем отправку уведомлений подписавшимся клиентам о поступлении товара 
        foreach ($params['minutes'] as $minute) {
            // Задание запускается в 09:00, 12:00, 16:00
            if (in_array($minute, array(540, 720, 960))) {
                $sites = SiteManager::getSiteList();
                foreach ($sites as $site) {
                    $config = ConfigLoader::byModule(__CLASS__, $site['id']);
                    if ($config['auto_send_supply_notice']) {
                        SiteManager::setCurrentSite($site);
                        ReservationApi::SendNoticeReceipt($site['id']);
                    }
                }
            }
        }

        //Проверим чеки раз в минуту, на случай если callback не отработал или него не существует впринципе.
        $sites = SiteManager::getSiteList();
        foreach ($sites as $site) {
            $config = ConfigLoader::byModule(__CLASS__, $site['id']);
            if ($config['cashregister_class'] && $config['cashregister_enable_auto_check']) { //Если только класс для касс задан и стоит флаг для проверки
                $api = new ReceiptApi();
                $api->checkWaitReceipts($site['id']);
            }
        }
    }

    /**
     * Автоматически переводит статус заказов, согласно настройкам модуля
     *
     * @param ShopConfig $config - объект конфига
     * @param int $site_id - id сайта
     */
    private static function autoChangeOrderStatus($config, $site_id)
    {
        $to_status = $config['auto_change_to_status'];
        $limit = 40;
        $offset = 0;

        $q = (new OrmRequest)
            ->from(new Order())
            ->where('dateofupdate < NOW() - INTERVAL #n DAY', array(
                'n' => $config['auto_change_timeout_days']
            ))
            ->whereIn('status', $config['auto_change_from_status'])
            ->where(array(
                'site_id' => $site_id
            ))
            ->limit($limit);

        /** @var Order[] $orders */
        while ($orders = $q->offset($offset)->objects()) {
            foreach ($orders as $order) {

                echo t('Автоматически меняем статус заказа ID:%0', array($order['id'])) . "\n";

                $order['status'] = $to_status;
                $order['is_exported'] = 0;
                $order->update();

                //Отправляем уведомление при автосмене статуса
                $notice = new \Shop\Model\Notice\AutoChangeStatus();
                $notice->init($order);
                \Alerts\Model\Manager::send($notice);
            }
            $offset += $limit;
        }
    }
}

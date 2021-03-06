<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Shop\Controller\Admin;

use RS\Controller\Admin\Crud;
use RS\Html\Category;
use RS\Html\Table\Type as TableType;
use RS\Html\Toolbar\Button as ToolbarButton;
use RS\Html\Filter;
use RS\Html\Toolbar;
use RS\Html\Table;
use RS\AccessControl\Rights;
use RS\AccessControl\DefaultModuleRights;
use Shop\Model\DeliveryApi;
use Shop\Model\DeliveryDirApi;
use Shop\Model\Orm\Delivery;

/**
 * Контроллер Управление скидочными купонами
 */
class DeliveryCtrl extends Crud
{
    protected $dir;//Категория
    /** @var \Shop\Model\DeliveryApi $api */
    protected $api;

    function __construct()
    {
        parent::__construct(new DeliveryApi());
        $this->setCategoryApi(new DeliveryDirApi(), t('группу доставок'));
    }

    /**
     * Страница доставок
     *
     * @return mixed
     */
    function actionIndex()
    {
        if ($this->dir >= 0) { //Если категория задана
            if (!$this->getCategoryApi()->getOneItem($this->dir)) {
                $this->dir = 0; //Если категории не существует, то выбираем пункт "Все"
            }
            $this->api->setFilter('parent_id', $this->dir);
        }

        return parent::actionIndex();
    }

    /**
     * Подготавливаем helper для отображения
     *
     * @return \RS\Controller\Admin\Helper\CrudCollection
     */
    function helperIndex()
    {
        $helper = parent::helperIndex();
        $helper->setTopToolbar($this->buttons(array('add'), array('add' => t('Добавить способ доставки'))));
        $helper->addCsvButton('shop-delivery');
        $helper->setTopTitle(t('Способы доставки'));
        $helper->setTopHelp($this->fetch('delivery/top_help.tpl'));
        $this->dir = $this->url->request('dir', TYPE_INTEGER, -1);

        $helper->setTable(new Table\Element(array(
            'Columns' => array(
                new TableType\Checkbox('id'),
                new TableType\Sort('sortn', t('Порядок'), array('sortField' => 'id', 'Sortable' => SORTABLE_ASC, 'CurrentSort' => SORTABLE_ASC, 'ThAttr' => array('width' => '20'))),
                new TableType\Text('title', t('Название'), array('Sortable' => SORTABLE_BOTH, 'href' => $this->router->getAdminPattern('edit', array(':id' => '@id')), 'LinkAttr' => array('class' => 'crud-edit'))),
                new TableType\Text('admin_suffix', t('Пояснение'), array('Hidden' => true)),
                new TableType\Image('picture', t('Логотип'), 30, 30, 'xy', array('Hidden' => true, 'Sortable' => SORTABLE_BOTH, 'href' => $this->router->getAdminPattern('edit', array(':id' => '@id')), 'LinkAttr' => array('class' => 'crud-edit'))),
                new TableType\Text('description', t('Описание'), array('Hidden' => true)),
                new TableType\Text('min_price', t('Мин. сумма заказа'), array('Hidden' => true)),
                new TableType\Text('max_price', t('Макс. сумма заказа'), array('Hidden' => true)),
                new TableType\Text('min_cnt', t('Мин. количество товаров в заказе'), array('Hidden' => true)),
                new TableType\Userfunc('extrachange_discount', t('Наценка/скидка на доставку'), function ($value, $field) {
                    /** @var \RS\Html\Table\Type\AbstractType $field */
                    $row = $field->getRow();
                    switch ($row['extrachange_discount_type']) {
                        case 0:
                            $extrachange_discount_type = t('ед.');
                            break;
                        case 1:
                            $extrachange_discount_type = '%';
                            break;
                        default:
                            $extrachange_discount_type = t('ед.');
                    }
                    return $value ? $value . " " . $extrachange_discount_type : t('Нет');
                }, array('Hidden' => true)),
                new TableType\Text('class', t('Тип рассчета')),
                new TableType\Text('user_type', t('Доступен для')),
                new TableType\Yesno('public', t('Видим.'), array('Sortable' => SORTABLE_BOTH, 'toggleUrl' => $this->router->getAdminPattern('ajaxTogglePublic', array(':id' => '@id'))
                )),
                new TableType\Actions('id', array(
                    new TableType\Action\Edit($this->router->getAdminPattern('edit', array(':id' => '~field~')), null, array(
                        'attr' => array(
                            '@data-id' => '@id'
                        )
                    )),
                    new TableType\Action\DropDown(array(
                        array(
                            'title' => t('Клонировать способ доставки'),
                            'attr' => array(
                                'class' => 'crud-add',
                                '@href' => $this->router->getAdminPattern('clone', array(':id' => '~field~')),
                            )
                        ),
                    )),
                ),
                    array('SettingsUrl' => $this->router->getAdminUrl('tableOptions'))
                )
            ),

            'TableAttr' => array(
                'data-sort-request' => $this->router->getAdminUrl('move')
            )
        )));

        $helper->setBottomToolbar($this->buttons(array('multiedit', 'delete')));
        $helper->viewAsTableCategory();

        $helper->setCategory(new Category\Element(array(
            'sortIdField' => 'id',
            'activeField' => 'id',
            'disabledField' => 'hidden',
            'disabledValue' => '1',
            'activeValue' => $this->dir,
            'rootItem' => array(
                'id' => -1,
                'title' => t('Все'),
                'noOtherColumns' => true,
                'noCheckbox' => true,
                'noDraggable' => true,
                'noRedMarker' => true
            ),
            'sortable' => true,
            'sortUrl' => $this->router->getAdminUrl('categoryMove'),
            'mainColumn' => new TableType\Text('title', t('Название'), array('href' => $this->router->getAdminPattern(false, array(':dir' => '@id', 'c' => $this->url->get('c', TYPE_ARRAY))))),
            'tools' => new TableType\Actions('id', array(
                new TableType\Action\Edit($this->router->getAdminPattern('categoryEdit', array(':id' => '~field~')), null, array(
                    'attr' => array(
                        '@data-id' => '@id'
                    ))),
                new TableType\Action\DropDown(array(
                    array(
                        'title' => t('Клонировать категорию'),
                        'attr' => array(
                            'class' => 'crud-add',
                            '@href' => $this->router->getAdminPattern('categoryClone', array(':id' => '~field~')),
                        )
                    ),
                )),
            )),
            'headButtons' => array(
                array(
                    'text' => t('Название группы'),
                    'tag' => 'span',
                    'attr' => array(
                        'class' => 'lefttext'
                    )
                ),
                array(
                    'attr' => array(
                        'title' => t('Создать категорию'),
                        'href' => $this->router->getAdminUrl('categoryAdd'),
                        'class' => 'add crud-add'
                    )
                ),
            ),
        )), $this->getCategoryApi());

        //Устанавливаем нижнюю полосу категорий
        $helper->setCategoryBottomToolbar(new Toolbar\Element(array(
            'Items' => array(
                new ToolbarButton\Delete(null, null, array('attr' =>
                    array('data-url' => $this->router->getAdminUrl('categoryDel'))
                )),
            )
        )));

        //Устанавливаем фильтры по категории
        $helper->setCategoryFilter(new Filter\Control(array(
            'Container' => new Filter\Container(array(
                'Lines' => array(
                    new Filter\Line(array('Items' => array(
                        new Filter\Type\Text('title', t('Название'), array('SearchType' => '%like%')),
                    )))
                ),
            )),
            'ToAllItems' => array('FieldPrefix' => $this->getCategoryApi()->defAlias()),
            'filterVar' => 'c',
            'Caption' => t('Поиск по группам')
        )));

        return $helper;
    }

    function actionAdd($primaryKey = null, $returnOnSuccess = false, $helper = null)
    {
        /** @var Delivery $element */
        if ($primaryKey === null) {
            $type_keys = array_keys($this->api->getTypes());
            if ($first = reset($type_keys)) {
                $element = $this->api->getElement();
                $element['class'] = $first;
            }
        } else {
            $element = $this->api->getElement();
            $element->fillZones();
        }

        if ($primaryKey == 0) $primaryKey = null;

        return parent::actionAdd($primaryKey, $returnOnSuccess, $helper);
    }

    /**
     * AJAX
     */
    function actionMove()
    {
        $from = $this->url->request('from', TYPE_INTEGER);
        $to = $this->url->request('to', TYPE_INTEGER);
        $direction = $this->url->request('flag', TYPE_STRING);
        return $this->result->setSuccess($this->api->moveElement($from, $to, $direction))->getOutput();
    }

    /**
     * Получает форму для типа доставки
     *
     */
    function actionGetDeliveryTypeForm()
    {
        $type = $this->url->request('type', TYPE_STRING);
        if ($type_object = $this->api->getTypeByShortName($type)) {
            $this->view->assign('type_object', $type_object);
            $this->result->setTemplate('form/delivery/type_form.tpl');
        }
        return $this->result;
    }

    /**
     * Выполняет пользовательский метод доставки, возвращая полученный ответ
     *
     */
    function actionUserAct()
    {
        $act = $this->request('userAct', TYPE_STRING, false);
        $delivery_obj = $this->request('deliveryObj', TYPE_STRING, false);
        $params = $this->request('params', TYPE_ARRAY, array());
        $module = $this->request('module', TYPE_STRING, 'Shop');

        if ($act && $delivery_obj) {
            $delivery = '\\' . $module . '\Model\DeliveryType\\' . $delivery_obj;
            $data = $delivery::$act($params);

            return $this->result->setSuccess(true)->addSection('data', $data);
        } else {
            return $this->result->setSuccess(false)->addEMessage(t('Не установлен метод или объект доставки'));
        }
    }

    /**
     * Включает/выключает флаг "публичный"
     */
    function actionAjaxTogglePublic()
    {

        if ($access_error = Rights::CheckRightError($this, DefaultModuleRights::RIGHT_UPDATE)) {
            return $this->result->setSuccess(false)->addEMessage($access_error);
        }
        $id = $this->url->get('id', TYPE_STRING);

        /** @var Delivery $delivery */
        $delivery = $this->api->getOneItem($id);
        $delivery->fillZones();
        if ($delivery) {
            $delivery['public'] = !$delivery['public'];
            $delivery->update();
        }
        return $this->result->setSuccess(true);
    }

    /**
     * Метод для клонирования
     *
     */
    function actionClone()
    {
        $this->setHelper($this->helperAdd());
        $id = $this->url->get('id', TYPE_INTEGER);

        $elem = $this->api->getElement();

        if ($elem->load($id)) {
            $clone_id = 0;
            if (!$this->url->isPost()) {
                $clone = $elem->cloneSelf();
                $this->api->setElement($clone);
                $clone_id = (int)$clone['id'];
            }
            unset($elem['id']);
            return $this->actionAdd($clone_id);
        } else {
            return $this->e404();
        }
    }
}

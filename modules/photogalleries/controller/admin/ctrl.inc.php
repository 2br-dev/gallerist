<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Photogalleries\Controller\Admin;
 
use Photogalleries\Model\AlbumApi;
use RS\Controller\Admin\Helper\CrudCollection;
use \RS\Html\Table\Type as TableType,
    \RS\Html\Filter,
    \RS\Html\Table;
use RS\Html\Toolbar\Button as ToolbarButton;
use RS\Router\Manager as RouterManager;

/**
* Контроллер Списка фотогалереи
*/
class Ctrl extends \RS\Controller\Admin\Crud
{
    /**
     * @var \Photogalleries\Model\AlbumApi $api
     */
    public $api; //Основное АПИ
    
    function __construct()
    {
        //Устанавливаем, с каким API будет работать CRUD контроллер
        parent::__construct(new AlbumApi());
    }
     
    function helperIndex()
    {
        $helper = parent::helperIndex(); //Получим helper по-умолчанию
        $helper->setTopTitle(t('Фотогалерея')); //Установим заголовок раздела
        $helper->setTopToolbar($this->buttons(array('add'), array('add' => t('добавить альбом'))));
         
        ///ПРАВАЯ КОЛОНКА 
        //Опишем колонки табличного представления данных
        $helper->setTable(new Table\Element(array(
            'Columns' => array(
                new TableType\Checkbox('id', array('showSelectAll' => true)), //Отображаем флажок "выделить элементы на всех страницах"
                new TableType\Sort('sortn', t('Порядок'), array('sortField' => 'id', 'Sortable' => SORTABLE_ASC,'CurrentSort' => SORTABLE_ASC,'ThAttr' => array('width' => '20'))),   
                new TableType\Text('title', t('Название'), array('Sortable' => SORTABLE_BOTH, 'href' => $this->router->getAdminPattern('edit', array(':id' => '@id') ), 'LinkAttr' => array('class' => 'crud-edit') )),
                new TableType\Text('alias', t('Англ. имя'), array('Sortable' => SORTABLE_BOTH, 'href' => $this->router->getAdminPattern('edit', array(':id' => '@id') ), 'LinkAttr' => array('class' => 'crud-edit') )),
                new TableType\Yesno('public', t('Публичный'), array('Sortable' => SORTABLE_BOTH, 'toggleUrl' => $this->router->getAdminPattern('ajaxTogglePublic', array(':id' => '@id')), 'LinkAttr' => array('class' => 'crud-edit') )),
                new TableType\Text('id', '№', array('TdAttr' => array('class' => 'cell-sgray'))),
                new TableType\Actions('id', array(
                        //Опишем инструменты, которые нужно отобразить в строке таблицы пользователю
                        new TableType\Action\Edit($this->router->getAdminPattern('edit', array(':id' => '~field~')), null, array(
                            'attr' => array(
                                '@data-id' => '@id'
                            ))
                        ),
                    ),
                    //Включим отображение кнопки настройки колонок в таблице
                    array('SettingsUrl' => $this->router->getAdminUrl('tableOptions'))
                ),
            ),
            'TableAttr' => array(
                'data-sort-request' => $this->router->getAdminUrl('move')
            )
        )));

        $helper['topToolbar']->addItem(new ToolbarButton\Dropdown(array(
            array(
                'title' => t('Импорт/Экспорт')
            ),
            array(
                'title' => t('Экспорт альбомов в CSV'),
                'attr' => array(
                    'data-url' => RouterManager::obj()->getAdminUrl('exportCsv', array('schema' => 'photogalleries-album', 'referer' => $this->url->selfUri()), 'main-csv'),
                    'class' => 'crud-add'
                )
            ),
            array(
                'title' => t('Импорт альбомов из CSV'),
                'attr' => array(
                    'data-url' => RouterManager::obj()->getAdminUrl('importCsv', array('schema' => 'photogalleries-album', 'referer' => $this->url->selfUri()), 'main-csv'),
                    'class' => 'crud-add'
                )
            ),
        )), 'import');


        //Опишем фильтр, который следует добавить
        $helper->setFilter(new Filter\Control(array(
            'Container' => new Filter\Container( array( //Контейнер визуального фильтра
                'Lines' =>  array(
                    new Filter\Line( array('Items' => array( //Одна линия фильтров
                            new Filter\Type\Text('id','№', array('attr' => array('class' => 'w50'))), //Фильтр по ID
                            new Filter\Type\Text('title',t('Название'), array('searchType' => '%like%')), //Фильтр по названию производителя
                        )
                    )),
                )
            )),
            'Caption' => t('Поиск')
        )));

        return $helper;
    }


    /**
     * Открытие окна добавления и редактирования сервиса и услуги
     *
     * @param integer $primaryKeyValue - первичный ключ товара(если товар уже создан)
     * @param boolean $returnOnSuccess - Если true, то будет возвращать true при успешном сохранении, иначе будет вызов стандартного _successSave метода
     * @param CrudCollection $helper - текущий хелпер
     *
     * @return bool|\RS\Controller\Result\Standard
     */
    function actionAdd($primaryKeyValue = null, $returnOnSuccess = false, $helper = null)
    {
        $obj = $this->api->getElement();    
        
        if ($primaryKeyValue == null){
            $obj['public']    = 1; 
            $obj['parent_id'] = $this->request('dir', TYPE_INTEGER, 0); //Укажем категорию, если она выбрана 
            $obj->setTemporaryId();
            $this->getHelper()->setTopTitle(t('Добавить альбом'));
        } else {
            $this->getHelper()->setTopTitle(t('Редактировать альбом').' {title}');
        }
        
        return parent::actionAdd($primaryKeyValue, $returnOnSuccess, $helper);
    }

    /**
    * Переключение флага публичности
    * 
    */
    function actionAjaxTogglePublic()
    {
        $id = $this->url->get('id', TYPE_STRING);
        
        $album = $this->api->getOneItem($id);
        if ($album) {
            $album['public'] = !$album['public'];
            $album->update();
        }
        return $this->result->setSuccess(true);
    }
}
<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/

namespace Catalog\Model\CsvSchema;

use Catalog\Model\Orm;
use Catalog\Model\WareHouseApi;
use Files\Model\FilesType\CatalogProduct;
use RS\Csv\Preset;
use RS\Db\Exception as DbException;
use RS\Event\Exception as EventException;

/**
 * Схема импорта/экспорта в CSV файл товаров
 */
class Product extends \RS\Csv\AbstractSchema
{
    protected $catalog_config;

    function __construct()
    {        
        $search_fields = (array)\RS\Config\Loader::byModule($this)->csv_id_fields;
        $this->catalog_config = \RS\Config\Loader::byModule('catalog');

        $exclude = array(
            'id', 'site_id', 'processed', 'brand_id', 'unit', 'recommended', 'maindir', 'concomitant',
        );
        $exclude_if_inventory_control_on = array(
            'num', 'reserve', 'waiting', 'writeoff',
        );

        parent::__construct(
            new Preset\Base(array(
                'ormObject' => new Orm\Product(),
                'excludeFields' => $this->catalog_config['inventory_control_enable'] ? array_merge($exclude, $exclude_if_inventory_control_on) : $exclude,
                'savedRequest' => \Catalog\Model\Api::getSavedRequest('Catalog\Controller\Admin\Ctrl_list'), //Объект запроса из сессии с параметрами текущего просмотра списка
                'multisite' => true,
                'searchFields' => $search_fields,
            )),
            array(
                new Preset\LinkedTable(array(
                    'ormObject' => new Orm\Unit(),
                    'fields' => array('stitle'),
                    'titles' => array('stitle' => t('Единица измерения')),
                    'idField' => 'id',
                    'multisite' => true,                
                    'linkForeignField' => 'unit',
                    'linkPresetId' => 0,
                    'linkDefaultValue' => 0
                )),
                new Preset\LinkedTable(array(
                    'ormObject' => new Orm\Brand(),
                    'fields' => array('title'),
                    'titles' => array('title' => t('Бренд')),
                    'idField' => 'id',
                    'multisite' => true,                
                    'linkForeignField' => 'brand_id',
                    'linkPresetId' => 0,
                    'linkDefaultValue' => 0
                )),                
                new Preset\TreeParent(array(
                    'ormObject' => new Orm\Dir(),
                    'titles' => array(
                        'name' => t('Основная категория')
                    ),
                    'idField' => 'id',
                    'parentField' => 'parent',
                    'treeField' => 'name',
                    'rootValue' => 0,
                    'multisite' => true,                
                    'linkForeignField' => 'maindir',
                    'linkPresetId' => 0
                )),                
                new \Catalog\Model\CsvPreset\Cost(array(
                    'linkPresetId' => 0,
                    'linkIdField' => 'id',
                    'arrayField' => 'excost',
                )),
                new Preset\PhotoBlock(array(
                    'typeItem' => Orm\Product::IMAGES_TYPE,
                    'linkPresetId' => 0,
                    'linkIdField' => 'id'
                )),
                new Preset\ManyTreeParent(array(
                    'ormObject' => new Orm\Dir(),
                    'idField' => 'id',
                    'manylinkOrm' => new Orm\Xdir(),
                    'title' => t('Категории'),
                    
                    'manylinkIdField' => 'dir_id',
                    'manylinkForeignIdField' => 'product_id',
                    'linkPresetId' => 0,
                    'linkIdField' => 'id',
                    
                    'rootValue' => 0,
                    'treeField' => 'name',
                    'treeParentField' => 'parent',
                    'multisite' => true,
                    
                    'arrayField' => 'xdir',
                )),
                new Preset\ProductsSerialized(array(
                    'title' => t('Рекомендуемые товары'),
                    'exportPattern' => '{products}',
                    'linkForeignField' => 'recommended',
                    'linkIdField' => 'id',
                    'linkPresetId' => 0
                )),
                new Preset\ProductsSerialized(array(
                    'title' => t('Сопутствующие товары'),
                    'exportPattern' => '{products}',
                    'linkForeignField' => 'concomitant',
                    'linkIdField' => 'id',
                    'linkPresetId' => 0
                )),                
                new \Catalog\Model\CsvPreset\Property(array(
                    'title' => t('Характеристики'),
                    'linkPresetId' => 0,
                    'linkIdField' => 'id',
                )),
                new \Catalog\Model\CsvPreset\MultiOffers(array(
                    'title' => t('Многомерные комплектации'),
                    'linkPresetId' => 0,
                    'linkIdField' => 'id',
                )),
                new \Catalog\Model\CsvPreset\ProductUrl(array(
                    'title' => t('Полный url к товару'),
                )),
                new \Catalog\Model\CsvPreset\Files(array(
                    'title' => 'Файлы',
                    'typeItem' => CatalogProduct::getShortName(),
                    'linkPresetId' => 0,
                    'linkIdField' => 'id'
                )),
            ),
            array(
                'beforeLineImport' => array(__CLASS__, 'beforeLineImport'),
                'AfterImport' => array(__CLASS__, 'afterImport'),
                
                //Ограничим область видимости для полей
                'fieldscope' => array(
                    'producturl' => self::FIELDSCOPE_EXPORT, //Только экспорт
                )
            )            
        );                                             
    }

    /**
     * Функция срабатывает перед записью одной строчки при импорте
     *
     * @param self $_this - объект текущей схемы
     * @throws DbException
     * @throws EventException
     */
    public static function beforeLineImport($_this)
    {
        static $default_warehouse_id;
        
        if ($default_warehouse_id === null) {
            $default_warehouse_id = WareHouseApi::getDefaultWareHouse()->id;
        }

        /** @var Orm\Product $row */
        $row = &$_this->getPreset(0)->row;
        
        if (isset($row['num']) && !$_this->catalog_config['inventory_control_enable']) {
            //Если задан остаток товара, то он устанавливается всегда основной 
            //комплектации для склада по умолчанию
            $row['offers'] = array(
                'main' => array(
                    'stock_num' => array(
                        $default_warehouse_id => $row['num']
                    )
                )
            );
        } else {
            //Не сохраняем комплектации, если нет колонки остаток
            $row['dont_save_offers'] = true;
        }
        
        //Подгрузим объект товара, чтобы иметь полные сведения
        /** @var Orm\Product $product */
        $product = $_this->getPreset(0)->loadObject();
        if ($product){
            $product->setFlag(Orm\Product::FLAG_DONT_UPDATE_DIR_COUNTER);
            $product->fillCost();
            if (isset($product['excost'])) {  
                $row['excost'] = $product['excost'];
            }    
        }
        
        
        //Устанавливаем временный id
        $time = -time();
        $row['id'] = $time;
        $row['_tmpid'] = $time;
    }

    /**
     * Срабатывает после обновления одной партии данных
     *
     * @param self $_this
     */
    public static function afterImport($_this)
    {
        \Catalog\Model\Dirapi::updateCounts(); //Обновляем счетчики у категорий
    }
    
    /**
    * Возвращает возможные колонки для идентификации продукта
    * 
    * @return array
    */
    public static function getPossibleIdFields()
    {
        $product = new \Catalog\Model\Orm\Product();
        $fields = array_flip(array('title', 'barcode', 'xml_id', 'alias'));
        foreach($fields as $k => $v) {
            $fields[$k] = $product['__'.$k]->getTitle();
        }
        return $fields;
    }

}

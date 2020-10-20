<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
/**
 * ReadyScript (http://readyscript.ru)
 *
 * @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
 * @license http://readyscript.ru/licenseAgreement/
 */

namespace Catalog\Model\CsvSchema;

use Catalog\Model\CsvPreset as CatalogPreset;
use Catalog\Model\DirApi;
use Catalog\Model\PropertyApi;
use RS\Csv\AbstractSchema;
use RS\Csv\Preset;

/**
 * Схема экспорта/импорта категорий товаров в CSV
 */
class Dir extends AbstractSchema
{
    function __construct()
    {
        parent::__construct(new Preset\Base(array(
            'ormObject' => new \Catalog\Model\Orm\Dir(),
            'excludeFields' => array('id', 'site_id', 'parent', 'processed', 'level', 'itemcount', 'image', 'tax_ids'),
            'multisite' => true,
            'searchFields' => array('name', 'parent'),
            'nullFields' => array('sortn'),
        )),
            array(
                new Preset\SinglePhoto(array(
                    'linkPresetId' => 0,
                    'linkForeignField' => 'image',
                    'title' => t('Изображение'),
                )),
                new Preset\TreeParent(array(
                    'ormObject' => new \Catalog\Model\Orm\Dir(),
                    'titles' => array(
                        'name' => t('Родитель'),
                    ),
                    'idField' => 'id',
                    'parentField' => 'parent',
                    'treeField' => 'name',
                    'rootValue' => 0,
                    'multisite' => true,
                    'linkForeignField' => 'parent',
                    'linkPresetId' => 0,
                )),
                new CatalogPreset\DirUrl(array(
                    'title' => t('Полный url к категории'),
                )),
                new CatalogPreset\DirProperty(array(
                    'title' => t('Характеристики'),
                    'linkPresetId' => 0,
                )),
            ),
            array(
                'afterLineImport' => array(__CLASS__, 'afterLineImport'),
            )
        );
    }

    public static function afterLineImport($_this)
    {
        $base_preset = $_this->getPreset(0);
        $row = $base_preset->row;
        if (!empty($row['prop'])) {
            $prop_api = new PropertyApi();
            $dir = $base_preset->loadObject();
            $prop_api->saveProperties($dir['id'], 'group', $row['prop']);
        }
    }
}

<?php

namespace gallerist\Config;

use RS\Orm\ConfigObject;
use RS\Orm\Type;

/**
 * Класс конфигурации модуля
 */
class File extends ConfigObject
{
    public function _init()
    {
        parent::_init()->append([
            t('Характеристики'),
                'prop_material' => new Type\Integer([
                    'description' => t('Материал'),
                    'list' => [['Catalog\Model\PropertyApi', 'staticSelectList'], [0 => t('не выбрано')]]
                ]),
                'prop_shape' => new Type\Integer([
                    'description' => t('Форма'),
                    'list' => [['Catalog\Model\PropertyApi', 'staticSelectList'], [0 => t('не выбрано')]]
                ]),
                'prop_orientation' => new Type\Integer([
                    'description' => t('Ориентация картины'),
                    'list' => [['Catalog\Model\PropertyApi', 'staticSelectList'], [0 => t('не выбрано')]]
                ]),
                'prop_style' => new Type\Integer([
                    'description' => t('Стиль работы'),
                    'list' => [['Catalog\Model\PropertyApi', 'staticSelectList'], [0 => t('не выбрано')]]
                ]),
                'prop_base' => new Type\Integer(([
                    'description' => t('Основание'),
                    'list' => [['Catalog\Model\PropertyApi', 'staticSelectList'], [0 => t('не выбрано')]]
                ])),
                'prop_theme' => new Type\Integer(([
                    'description' => t('Тема'),
                    'list' => [['Catalog\Model\PropertyApi', 'staticSelectList'], [0 => t('не выбрано')]]
                ])),
                'prop_width' => new Type\Integer(([
                    'description' => t('Ширина'),
                    'list' => [['Catalog\Model\PropertyApi', 'staticSelectList'], [0 => t('не выбрано')]]
                ])),
                'prop_height' => new Type\Integer(([
                    'description' => t('Высота'),
                    'list' => [['Catalog\Model\PropertyApi', 'staticSelectList'], [0 => t('не выбрано')]]
                ])),
                'prop_in_stock' => new Type\Integer(([
                    'description' => t('В наличии'),
                    'list' => [['Catalog\Model\PropertyApi', 'staticSelectList'], [0 => t('не выбрано')]]
                ])),
                'prop_in_baguette' => new Type\Integer(([
                    'description' => t('В багете'),
                    'list' => [['Catalog\Model\PropertyApi', 'staticSelectList'], [0 => t('не выбрано')]]
                ])),
                'prop_is_original' => new Type\Integer(([
                    'description' => t('Реплика'),
                    'list' => [['Catalog\Model\PropertyApi', 'staticSelectList'], [0 => t('не выбрано')]]
                ])),
                'prop_city' => new Type\Integer(([
                    'description' => t('Город'),
                    'list' => [['Catalog\Model\PropertyApi', 'staticSelectList'], [0 => t('не выбрано')]]
                ])),
                'prop_region' => new Type\Integer(([
                    'description' => t('Регион'),
                    'list' => [['Catalog\Model\PropertyApi', 'staticSelectList'], [0 => t('не выбрано')]]
                ]))

        ]);
    }


}

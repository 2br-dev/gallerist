<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Export\Config;
use RS\Orm\Type;
use RS\Router\Manager as RouterManager;

/**
 * Класс настроек для текущего модуля
 */
class File extends \RS\Orm\ConfigObject
{
    function _init()
    {
        parent::_init()->append(array(
            'check_product_change' => new Type\Integer(array(
                'description' => t('Обновлять во внешних сервисах только новые товары или товары с изменениями'),
                'hint' => t('Сохранение товаров может стать медленнее после включения данной функции. Опция влияет тоьлко на профили экспорта по API.'),
                'checkboxView' => array(1,0),
                'allowEmpty' => false
            ))
        ));
    }

    /**
     * Возвращает значения свойств по-умолчанию
     *
     * @return array
     * @throws \RS\Module\Exception
     */
    public static function getDefaultValues()
    {
        return parent::getDefaultValues() + array(
            'tools' => array(
                array(
                    'url' => RouterManager::obj()->getAdminUrl('AjaxDoMarkToExport', array(), 'export-ctrl'),
                    'title' => t('Обновить все товары на внешних сервисах'),
                    'description' => t('Отмечает ранее выгруженные товары, что их необходимо выгрузить повторно'),
                    'confirm' => t('Вы действительно желаете выгрузить все товары повторно?')
                ),
            )
        );
    }

}
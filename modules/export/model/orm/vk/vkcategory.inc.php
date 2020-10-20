<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Export\Model\Orm\Vk;

use RS\Orm\Type;
use RS\Orm\OrmObject;

/**
 * ORM объект, который хранит сведения о категориях ВК в рамках каждого профиля
 * --/--
 * @property integer $id Уникальный идентификатор (ID)
 * @property integer $profile_id ID профиля
 * @property string $title Название категории в ВК
 * @property integer $parent_id ID родителя
 * @property integer $vk_id ID категории ВКонтакте
 * --\--
 */
class VkCategory extends OrmObject
{
    protected static
        $table = 'export_vk_cat';

    function _init()
    {
        parent::_init()->append(array(
            'profile_id' => new Type\Integer(array(
                'description' => t('ID профиля')
            )),
            'title' => new Type\Varchar(array(
                'description' => t('Название категории в ВК')
            )),
            'parent_id' => new Type\Integer(array(
                'description' => t('ID родителя')
            )),
            'vk_id' => new Type\Integer(array(
                'description' => t('ID категории ВКонтакте')
            )),
        ));

        $this->addIndex(array('profile_id', 'vk_id'), self::INDEX_UNIQUE);
    }
}
<?php
namespace OrmEditor\Config;
use OrmEditor\Model\Orm\CustomField;
use RS\Orm\AbstractObject;
use RS\Orm\Request;

/**
 * Обработчик событий ReadyScript
 */
class Handlers extends \RS\Event\HandlerAbstract
{
    protected static $append_orm_fields = array();
    protected static $hide_orm_fields = array();
    protected static $bind_orm;

    function init()
    {
        $this->bind('getmenus'); //событие сбора пунктов меню для административной панели
        $this->dynamicBind();
    }

    /**
     * Возвращает сокращенное наименование orm объекта.
     * Данное имя используется в названиях событий
     *
     * @return string
     */
    private static function getShortOrmAlias($class_name)
    {
        $name = str_replace('\\', '-', strtolower($class_name));
        return trim(str_replace('model-orm-', '', $name), '-');
    }

    /**
     * Инициализирует справочники кастомных полей, которые добавлены через административную панель
     *
     * @throws \RS\Orm\Exception
     */
    private static function initCustomOrmData()
    {
        if (!isset(self::$bind_orm)) {

            $custom_fields_data = Request::make()
                ->from(new CustomField())
                ->orderby('id')
                ->objects(null, 'orm_class', true);

            self::$append_orm_fields = array();
            self::$hide_orm_fields = array();
            self::$bind_orm = array();

            foreach ($custom_fields_data as $class_name => $data) {
                $shot_orm_name = self::getShortOrmAlias($class_name);
                self::$bind_orm[$shot_orm_name] = $shot_orm_name;
                foreach ($data as $field_data) {
                    if (!$field_data['is_base']) {
                        self::$append_orm_fields[$shot_orm_name][$field_data['tab']][$field_data['field']] = $field_data->getOrmType();
                    }

                    if ($field_data['hide']) {
                        if (!isset($hide[$shot_orm_name])) {
                            $hide[$shot_orm_name] = array();
                        }

                        self::$hide_orm_fields[$shot_orm_name][$field_data['field']] = $field_data['field'];
                    }
                }
            }

        }
    }

    /**
     * Динамически подписывает обработчики на события orm.init
     *
     * @throws \RS\Orm\Exception
     */
    public function dynamicBind()
    {
        self::initCustomOrmData();
        foreach(self::$bind_orm as $shot_orm_name) {
            $this->bind('orm.init.'.$shot_orm_name, null, 'dynamicBindOrmInitHandler', -1);
        }
    }

    /**
     * Единый обработчик событий orm.init.....
     * Добавляет новые свойства, скрывает существующие, при необходимости
     *
     * @param AbstractObject $orm
     * @throws \RS\Orm\Exception
     */
    public static function dynamicBindOrmInitHandler(AbstractObject $orm)
    {
        self::initCustomOrmData();

        $short_alias = $orm->getShortAlias();
        if (isset(self::$append_orm_fields[$short_alias])) {
            $property = $orm->getPropertyIterator();

            foreach(self::$append_orm_fields[$short_alias] as $tab_name => $fields) {
                foreach($fields as $field => $orm_type) {
                    $property->group($tab_name);
                    $property->append(array(
                        $field => $orm_type
                    ));
                }
            }
        }

        if (isset(self::$hide_orm_fields[$short_alias])) {
            foreach(self::$hide_orm_fields[$short_alias] as $field) {
                $orm['__'.$field]->setVisible(false);
            }
        }
    }

    /**
     * Добавляет пункты меню в административной панели
     *
     * @param array $items
     * @return array
     */
    public static function getMenus($items)
    {
        $items[] = array(
            'title' => t('Редактор ORM-объектов'),
            'alias' => 'ormeditor',
            'link' => '%ADMINPATH%/ormeditor-editorctrl/',
            'parent' => 'modules',
            'typelink' => 'link'
        );

        return $items;
    }
    
}
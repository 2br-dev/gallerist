<?php
namespace OrmEditor\Model;

use OrmEditor\Model\Orm\CustomField;
use RS\Cache\Cleaner;
use RS\Db\Adapter;
use RS\Exception;
use RS\Html\Filter\Control as FilterControl;
use RS\Html\Table\Control as TableControl;
use RS\Module\AbstractModel\BaseModel;
use RS\Module\Item;
use RS\Module\Manager;
use RS\Orm\AbstractObject;
use RS\Orm\ConfigObject;
use RS\Orm\Request;

/**
 * Класс предоставляет возможность выбирать,
 * редактировать правила для кастомных полей ORM Объектов
 */
class OrmEditorApi extends BaseModel
{
    protected $module;
    protected $sort_direction_asc = true;
    protected $filters = array();

    /**
     * Подключает фильтрацию
     *
     * @param FilterControl $filter_control
     */
    function addFilterControl(FilterControl $filter_control)
    {
        $this->filters = $filter_control->getKeyVal();
    }

    /**
     * Подключает сортировку, устанавливаемую в таблице
     *
     * @param TableControl $table_control
     */
    function addTableControl(TableControl $table_control)
    {
        if ($sort_column = $table_control->getTable()->getSortColumn()) {
            $this->sort_direction_asc = $sort_column->property['CurrentSort'] == SORTABLE_ASC;
        }
    }

    /**
     * Устанавливает фильтр по модулю для метода getList
     *
     * @param string $module
     */
    function setMouduleFilter($module)
    {
        $this->module = $module;
    }

    /**
     * Возвращает список ORM объектов модуля $module
     *
     * @return array
     */
    function getList()
    {
        if (!$this->module) { //Все модули
            $result = array();
            $module_manager = new Manager();
            $modules = $module_manager->getList();
            foreach($modules as $module) {
                $result = array_merge($result, $this->getModuleOrm($module));
            }
        } else {
            $result = $this->getModuleOrm($this->module);
        }

        //Фильтруем
        if (isset($this->filters['id'])) {
            foreach($result as $key => $item) {
                if (mb_stripos($item['title'], $this->filters['id']) === false) {
                    unset($result[$key]);
                }
            }
        }

        //Сортируем
        $sort_asc = $this->sort_direction_asc;
        usort($result, function($a, $b) use($sort_asc) {
            if ($sort_asc) {
                return strcasecmp($a['title'], $b['title']);
            } else {
                return strcasecmp($b['title'], $a['title']);
            }
        });

        return $result;
    }

    /**
     *
     *
     * @param $module
     * @return array
     */
    protected function getModuleOrm($module)
    {
        if (!($module instanceof Item)) {
            $module = new Item($module);
        }

        $orm_objects = $module->getOrmObjects();
        $class = get_class($module->getConfig());
        $result = array(array(
            'id' => $class,
            'title' => $class
        ));
        foreach($orm_objects as $orm) {
            $class = get_class($orm);
            $result[] = array(
                'id' => $class,
                'title' => $class
            );
        }
        return $result;
    }

    /**
     * @return array
     */
    protected function getAllConfigOrm()
    {
        $result = array();
        $module_manager = new Manager();
        $modules = $module_manager->getList();
        foreach($modules as $module) {
            $class = get_class($module->getConfig());
            $result[] = array(
                'id' => $class,
                'title' => $class
            );
        }

        return $result;
    }


    /**
     * Возвращает кастомные поля, добавленные с помощью модуля ormEditor
     *
     * @param AbstractObject $orm
     * @return array
     * @throws \RS\Orm\Exception
     */
    function getCustomFields(AbstractObject $orm)
    {
        $data = Request::make()
            ->from(new CustomField())
            ->where(array(
                'orm_class' => get_class($orm)
            ))
            ->objects(null, 'field');

        return $data;
    }

    /**
     * Возвращает поля ORM объекта, сгруппированные по вкладкам
     *
     * @param AbstractObject $orm
     * @return array
     * @throws \RS\Orm\Exception
     */
    function getFieldData(AbstractObject $orm)
    {
        $iterator = $orm->getPropertyIterator();
        $groups = $iterator->getGroups();

        $custom = $this->getCustomFields($orm);

        $result_fields = array();
        foreach($groups as $group) {
            $result_fields[$group['group']] = $group['items'];
            foreach($group['items'] as $key => $item) {
                if (empty($item->custom_field) && isset($custom[$key])) {
                    $item->custom_field = $custom[$key];
                    $item->is_custom_field = false;
                }
            }
        }

        return $result_fields;
    }

    /**
     * Трансформирует полученные из POST данные.
     * Формирует ассоциативный массив, где имя свойства находится в ключе
     *
     * @param array $field_data
     * @return array
     */
    public function transformFieldData($field_data)
    {
        $result = array();
        foreach($field_data as $data) {
            $result[$data['field']] = $data;
        }

        return $result;
    }

    /**
     * Сохраняет новые сведения по кастомным полям
     *
     * @param AbstractObject $orm
     * @param array $field_data
     * @return bool
     * @throws \RS\Db\Exception
     * @throws \RS\Event\Exception
     */
    public function save(AbstractObject $orm, $field_data)
    {
        $field_data_normalized = $this->transformFieldData($field_data);
        $native_fields = array();
        $drop_custom_fields = array();
        $field_already_exists = false;

        //Определяем, какие кастомные поля были удалены
        $property_iterator = $orm->getPropertyIterator();
        foreach($property_iterator as $key => $property) {
            if (!empty($property->is_custom_field)) {
                if (!isset($field_data_normalized[$key])) {
                    $drop_custom_fields[] = $key;
                    unset($property_iterator[$key]);
                }
            } else {
                $native_fields[$key] = $key;
                if (isset($field_data_normalized[$key]['type'])) {
                    $this->addError(t('Поле с идентификатором %0 уже существует', array($key)));
                    $field_already_exists = true;
                }
            }
        }

        if ($field_already_exists) {
            return false;
        }

        $custom_fields = $this->addCustomFields($orm, $field_data_normalized, $native_fields);

        //Добавляем новые поля в PropertyIterator
        foreach($custom_fields as $group => $fields) {
            foreach($fields as $field) {
                $property_iterator->group($group);
                $property_iterator->append(array(
                    $field['field'] => $field->getOrmType()
                ));
            }
        }

        //Очищаем кэш
        Cleaner::obj()->clean(Cleaner::CACHE_TYPE_COMMON);

        //Синхронизируем БД
        if (!$this->syncDb($orm)) {
            return false;
        }

        //Удаляем поля из БД
        if (!$this->dropCustomColumns($orm, $drop_custom_fields)) {
            return false;
        }

        return true;
    }

    /**
     * Добавляет произвольные поля в БД
     *
     * @param AbstractObject $orm ORM объект, к которому добавляются поля
     * @param array $field_data_normalized Данные, которые получены из формы в административной панели
     * @return array
     * @throws \RS\Db\Exception
     * @throws \RS\Event\Exception
     */
    private function addCustomFields(AbstractObject $orm, $field_data_normalized, $native_fields)
    {
        $custom_fields = array();

        Request::make()
            ->delete()
            ->from(new CustomField())
            ->where(array(
                'orm_class' => get_class($orm)
            ))->exec();

        //Добавляем новые поля в PropertyIterator
        foreach($field_data_normalized as $key => $data) {
            $custom_field = new CustomField();
            $custom_field['orm_class'] = get_class($orm);
            $custom_field['field'] = $data['field'];
            $custom_field['hide'] = (int)!empty($data['hide']);

            if (isset($native_fields[$key])) {
                $custom_field['is_base'] = 1;
                if ($custom_field['hide']) {
                    $custom_field->insert();
                }
            } else {
                $custom_field['is_base'] = 0;
                $custom_field['tab'] = $data['tab'];
                $custom_field['type'] = $data['type'];
                $custom_field['description'] = $data['description'];
                $custom_field['default'] = $data['default'];
                $custom_field['allow_empty'] = $data['allow_empty'];
                $custom_fields[$data['tab']][] = $custom_field;
                $custom_field->insert();
            }

        }

        return $custom_fields;
    }

    /**
     * Приводит БД в соответствие с описанием ORM Объекта
     *
     * @param AbstractObject $orm
     * @return bool
     */
    private function syncDb(AbstractObject $orm)
    {
        try {
            $orm->dbUpdate();
            return true;
        } catch(Exception $exception) {
            return $this->addError(t('Не удалось обновить БД: %0', array($exception->getMessage())));
        }
    }

    /**
     * Удаляет кастомные поля из БД
     *
     * @param AbstractObject $orm
     * @param array $drop_custom_fields список удаляемых колонок
     * @return bool
     */
    private function dropCustomColumns(AbstractObject $orm, $drop_custom_fields)
    {
        if ($orm instanceof ConfigObject) {
            return true; //Не удаляем колонку, если это конфигурационный объект (там нет реальных колонок)
        }

        try {
            foreach ($drop_custom_fields as $drop_field) {
                $sql = "ALTER TABLE " . $orm->_getTable() . " DROP COLUMN `" . $drop_field . "`";
                Adapter::sqlExec($sql);
            }

            return true;
        } catch(Exception $exception) {
            if ($exception->getCode() == 1091) { //Can't DROP; check that column/key exist
                return true; //Возвращает успех, если колонка была уже удалена ранее
            }

            return $this->addError(t('Не удалось удалить колонку: %0', array($exception->getMessage())));
        }
    }

}
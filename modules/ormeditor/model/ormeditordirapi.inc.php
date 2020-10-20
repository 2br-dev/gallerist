<?php
namespace OrmEditor\Model;

use ModControl\Model\ModuleApi;
use RS\Html\Filter\Control as FilterControl;
use RS\Module\Manager;

class OrmEditorDirApi
{
    const MODULE_NAME_ALL = '';

    protected $filters = array();

    /**
     *
     */
    public function addFilterControl(FilterControl $filter_control)
    {
        $this->filters = $filter_control->getKeyVal();
    }


    /**
     * Возвращает полный список модулей, установленных в системе
     *
     * @return array
     */
    public function getCategoryList()
    {
        $module_manager = new Manager();
        $modules = $module_manager->getList();

        $result = array();

        foreach($modules as $module) {
            $config = $module->getConfig();
            $result[$module->getName()] = array(
                'id' => $module->getName(),
                'title' => $config->name." (<b>{$module->getName()}</b>)",
            );
        }

        //Фильтруем
        if (isset($this->filters['module'])) {
            foreach($result as $key => $item) {
                if (mb_stripos($item['title'], $this->filters['module']) === false) {
                    unset($result[$key]);
                }
            }
        }

        //Сортируем
        usort($result, function($a, $b) {
            return strcmp($a['title'], $b['title']);
        });

        $result = array(
            self::MODULE_NAME_ALL => array(
                'id' => self::MODULE_NAME_ALL,
                'title' => t('Все')
            )
        ) + $result;

        return $result;
    }
}
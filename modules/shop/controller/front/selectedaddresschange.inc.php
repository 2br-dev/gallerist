<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/

namespace Shop\Controller\Front;

use RS\Application\Application;
use RS\Config\Loader as ConfigLoader;
use RS\Controller\Front;
use Shop\Model\Orm\Region;
use Shop\Model\RegionApi;
use Shop\Model\SelectedAddress;

/**
 * Смена выбранного города
 */
class SelectedAddressChange extends Front
{
    /** @var Region[] */
    protected $marked;
    /** @var Region[] */
    protected $marked_countries;
    /** @var Region[] */
    protected $marked_regions;
    /** @var Region[] */
    protected $marked_cities;

    public $new_region_id;
    public $new_region_title;
    public $referrer;
    /** @var RegionApi */
    public $region_api;

    /**
     * Функция, вызывающяся сразу после конструктора
     * в случае успешной инициализации ничего не должна возвращать (null),
     * в случае ошибки должна вернуть текст ошибки, который будет возвращен при вызове _exec();
     */
    function init()
    {
        $this->new_region_id = $this->url->request('region_id', TYPE_INTEGER);
        $this->new_region_title = $this->url->request('region_title', TYPE_STRING);
        $this->referrer = $this->url->request('referrer', TYPE_STRING, $this->url->server('HTTP_REFERER'));
        /** @var RegionApi */
        $this->region_api = new RegionApi();
    }

    public function actionIndex()
    {
        $selected_address = SelectedAddress::getInstance();

        if ($this->new_region_id || $this->new_region_title) {
            $filter = [];
            if ($this->new_region_id) {
                $filter['|id'] = $this->new_region_id;
            }
            if ($this->new_region_title) {
                $filter['|title:%like%'] = $this->new_region_title;
            }

            /** @var Region $region */
            $region = $this->region_api->resetQueryObject()
                ->setFilter([$filter])
                ->setOrder('id = #0 desc', [$this->new_region_id])
                ->queryObj()->object();

            if (!empty($region['id'])) {
                $selected_address->setAddressFromRegion($region);
                if ($this->url->isPost()) {
                    return $this->result->setSuccess(true)->setAjaxRedirect($this->referrer);
                } else {
                    Application::getInstance()->redirect($this->referrer);
                }
            }
        }

        $this->view->assign([
            'selected_address' => $selected_address,
        ]);
        return $this->result->setTemplate('selected_address_change.tpl');
    }

    /**
     * Поиско города для автокомлита
     *
     * @return false|string
     */
    public function actionAjaxSearchCity()
    {
        $this->wrapOutput(false);
        $query = $this->url->request('term', TYPE_STRING);

        $region_api = new RegionApi();
        $region_api->setFilter([
            'title:%like%' => $query,
            'is_city' => 1,
        ]);

        /** @var Region[] $region_list */
        $region_list = $region_api->getList(1, 5);
        $result = [];
        foreach ($region_list as $region) {
            $result[] = [
                'id' => $region['id'],
                'label' => $region['title'] . ', ' . $region->getParent()['title'],
            ];
        }

        return json_encode($result, JSON_UNESCAPED_UNICODE);
    }

    /**
     * Возвращает структурированное дерево городов
     *
     *  @return array
     */
    public function getMarkedCitiesTree(): array
    {
        $marked_cities_tree = [];
        $marked_regions = $this->getMarkedRegions();
        $marked_countries = $this->getMarkedCountries();
        foreach ($this->getMarkedCities() as $city) {
            $region = $marked_regions[$city['parent_id']];
            $country = $marked_countries[$region['parent_id']];
            $marked_cities_tree[$country['id']][$region['id']][$city['id']] = $city;
        }
        return $marked_cities_tree;
    }

    /**
     * Возвращает выделенные города
     *
     * @return Region[]
     */
    public function getMarkedCities()
    {
        if ($this->marked_cities === null) {
            $this->sortMarked();
        }
        return $this->marked_cities;
    }

    /**
     * Возвращает выделенные регионы
     *
     * @return Region[]
     */
    public function getMarkedRegions()
    {
        if ($this->marked_regions === null) {
            $this->sortMarked();
        }
        return $this->marked_regions;
    }

    /**
     * Возвращает выделенные страны
     *
     * @return Region[]
     */
    public function getMarkedCountries()
    {
        if ($this->marked_countries === null) {
            $this->sortMarked();
        }
        return $this->marked_countries;
    }

    /**
     * Сортирует выделенные регионы
     *
     * @return void
     */
    protected function sortMarked(): void
    {
        $this->marked_countries = [];
        $this->marked_regions = [];
        $this->marked_cities = [];
        foreach ($this->getMarked() as $region) {
            if ($region['is_city']) {
                $this->marked_cities[$region['id']] = $region;
            } elseif ($region['parent_id'] == 0) {
                $this->marked_countries[$region['id']] = $region;
            } else {
                $this->marked_regions[$region['id']] = $region;
            }
        }
    }

    /**
     * Возвращает список всех выделенный регионов
     *
     * @return Region[]
     */
    public function getMarked()
    {
        if ($this->marked === null) {
            $this->marked = [];
            $config = ConfigLoader::byModule($this);
            $region_api = new RegionApi();
            if ($config['regions_marked_when_change_selected_address']) {
                $marked_regions_ids = $region_api->getParentIds($config['regions_marked_when_change_selected_address']);
                $region_api->setFilter(['id:in' => implode(',', $marked_regions_ids)]);
                /** @var Region[] $marked */
                $this->marked = $region_api->getList();
            }
        }
        return $this->marked;
    }
}

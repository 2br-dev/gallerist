<?php

namespace gallerist\Controller\Front;

use RS\Controller\Front;

/**
 * Фронт контроллер
 */
class Regions extends Front
{
    function actionIndex()
    {
        $region_api = new \Shop\Model\RegionApi();
        $regions = $region_api->getTreeList(1);
        $this->view->assign([
            'regions' => $regions
        ]);
        return $this->result->setTemplate('regions.tpl');
    }

    public function actionGetRegions()
    {
        $region_api = new \Shop\Model\RegionApi();
        $regions = $region_api->setFilter('parent_id', 1)->getListAsArray();
        $regions_output = [];
        foreach ($regions as $key=>$value){
            $regions_output[$value['title']] = null;
        }
//        echo '<pre>';
//        var_dump($regions);
//        if($regions){
            $this->result->setSuccess(true);
            $this->result->addSection('regions', $regions_output);
//        }
        return $this->result;
    }

    public function actionGetCities()
    {
        $region_title = $this->request('region', TYPE_STRING, '');
        $region_api = new \Shop\Model\RegionApi();
        $cities_output = [];
        if($_POST){
            $region = \RS\Orm\Request::make()
                ->from(new \Shop\Model\Orm\Region())
                ->where([
                    'title' => $region_title
                ])->object();
            if($region){
                $cities = $region_api->setFilter('parent_id', $region['id'])->getListAsArray();
                foreach ($cities as $key=>$value){
                    $cities_output[$value['title']] = null;
                }
                if(!empty($cities_output)){
                    $this->result->setSuccess('true');
                }else{
                    $this->result->setSuccess('false');
                }
                $this->result->addSection('cities', $cities_output);
            }
        }
        return $this->result;
    }
}

<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Designer\Config;

use Catalog\Model\Dirapi;
use Catalog\Model\Orm\Dir;
use Main\Model\Widgets as WidgetsApi;
use RS\Config\Loader as ConfigLoader;
use RS\Module\AbstractInstall;
use RS\Orm\AbstractObject;
use RS\Site\Manager as SiteManager;
use Templates\Model\PageApi;
use Users\Model\Orm\User;
use Users\Model\Orm\UserGroup;

/**
* Класс отвечает за установку и обновление модуля
*/
class Install extends AbstractInstall
{

    /**
     * Импортирует баннеры
     *
     * @return array
     */
    function importCSVBanners()
    {
        return $this->importCsvFiles(array(
            array('\Banners\Model\CsvSchema\Zone', 'banners-zone'),
            array('\Banners\Model\CsvSchema\Banner', 'banners-banner'),
        ), 'utf-8', array());
    }

    /**
     * Добавляет демонстрационные данные
     *
     * @param array $params - произвольные параметры.
     * @return boolean|array
     * @throws \RS\Exception
     */
    function insertDemoData($params = array())
    {
        $imports = [];
        if (\RS\Module\Manager::staticModuleExists('banners') && \RS\Module\Manager::staticModuleEnabled('banners')){
            $imports[] = array('\Banners\Model\CsvSchema\Zone', 'banners-zone');
            $imports[] = array('\Banners\Model\CsvSchema\Banner', 'banners-banner');
        }

        return $this->importCsvFiles(array(
            $imports,
        ), 'utf-8', $params);
    }
}

<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Main\Controller\Block;

use RS\Controller\StandartBlock;
use RS\Orm\Type;
use RS\Orm\Type\VariableList\TextAreaVariableListField;
use RS\Orm\Type\VariableList\TextVariableListField;

/**
* Блок - Яндекс карта
*/
class YandexMap extends StandartBlock
{
    protected static $controller_title = 'Яндекс Карта';
    protected static $controller_description = 'Отображает яндекс карту с точками на ней';

    protected $default_params = array(
        'indexTemplate' => 'blocks/yandexmap/yandexmap.tpl',
        'width' => '400',
        'height' => '300',
        'zoom' => '11',
        'block_mouse_zoom' => '1',
        'mapType' => 'yandex#map',
        'mapId' => 'map',
        'auto_init' => '1',
    );
    
    /**
     * Возвращает ORM объект, содержащий настриваемые параметры или false в случае, 
     * если контроллер не поддерживает настраиваемые параметры
     * @return \RS\Orm\ControllerParamObject | false
     */
    public function getParamObject()
    {
        return parent::getParamObject()->appendProperty(array(
            'width' => new Type\Integer(array(
                'description' => t('Ширина карты, px'),
                'hint' => t('Если пустое поле, то будет на всю ширину'),
            )),
            'height' => new Type\Integer(array(
                'description' => t('Высота карты, px'),
            )),
            'points' => new Type\VariableList(array(
                'description' => t('Координаты точек'),
                'tableFields' => array(array(
                    new TextVariableListField('lat', t('Широта')),
                    new TextVariableListField('lon', t('Долгота')),
                    new TextAreaVariableListField('balloonContent', t('Текст точки')),
                )),
            )),
            'zoom' => new Type\Integer(array(
                'description' => t('Масштаб карты'),
                'hint' => t('Если несколько точек на карте, то зум будет определять автоматически'),
            )),
            'block_mouse_zoom' => new Type\Integer(array(
                'description' => t('Блокировать изменение масштаба колесом мышки?'),
                'checkboxview' => array(1, 0)
            )),
            'mapType' => new Type\Varchar(array(
                'description' => t('Тип карты'),
                'listFromArray' => array(array(
                    'yandex#map' => 'Схема',
                    'yandex#satellite' => 'Спутник',
                    'yandex#hybrid' => 'Гибрид',
                ))
            )),
            'mapId' => new Type\Varchar(array(
                'description' => t('id карты'),

            )),
            'auto_init' => new Type\Integer(array(
                'description' => t('Автоматически инициализировать карту при загрузке страницы'),
                'checkboxView' => array(1,0),
            )),
        ));
    }

    public function actionIndex()
    {
        $this->view->assign(array(
            'width' => $this->getParam('width'),
            'height' => $this->getParam('height', $this->default_params['height'], true),
            'coors' => $this->getParam('coors'),
            'zoom' => $this->getParam('zoom'),
            'block_mouse_zoom' => $this->getParam('block_mouse_zoom'),
            'mapType' => $this->getParam('mapType'),
            'mapId' => $this->getParam('mapId'),
            'auto_init' => $this->getParam('auto_init'),
        ));
        return $this->result->setTemplate( $this->getParam('indexTemplate') );
    }
    
    /**
     * Возвращает JSON массив точек
     * 
     * @return string
     */
    public function getPointsJSON()
    {
        return json_encode($this->getParam('points', TYPE_ARRAY), JSON_UNESCAPED_UNICODE);
    }
}

<?php
namespace Gallerist\Controller\Block;

use Catalog\Model\Api;
use RS\Controller\StandartBlock;
use RS\Debug\Action as DebugAction;
use RS\Debug\Tool as DebugTool;
use RS\Orm\Type;

/**
 * Класс выводящи все бренды
 */
class Arts extends StandartBlock
{
    protected static $controller_title = 'Картины';  //Краткое название контроллера
    protected static $controller_description = 'Выводит список картин';  //Описание контроллера

    protected $default_params = [
        'indexTemplate' => 'blocks/arts/arts_main.tpl',
        'cache_html_lifetime' => 300,
        'count' => 12
    ];

    /** @var \Catalog\Model\Api */
    public $api;

    function init()
    {
        $this->api = new Api();
    }

    /**
     * Возвращает ORM объект, содержащий настриваемые параметры или false в случае,
     * если контроллер не поддерживает настраиваемые параметры
     * @return \RS\Orm\ControllerParamObject | false
     */
    function getParamObject()
    {
        return parent::getParamObject()->appendProperty([
            'pageSize' => new Type\Integer([
                'description' => t('Количество элементов для отображения. 0 - все'),
                'default' => 0,
            ]),
            'cache_html_lifetime' => new Type\Integer([
                'description' => t('Время кэширования HTML блока, секунд?'),
                'hint' => t('0 - кэширование выключено. Значение больше нуля ускоряет работу сайта, но допускает неактуальность данных на срок кэширования. Работает только если в настройках системы включено кэширование данных.'),
            ]),
            'count' => new Type\Integer([
                'description' => t('Количество выводимых картин')
            ])
        ]);
    }

    function actionIndex()
    {
        $template = $this->getParam('indexTemplate');
        $count = $this->getParam('count');
        $arts = $this->api->setFilter('public', 1)->getList(1, $count, 'RAND()');
        $this->view->assign('arts', $arts);
        return $this->result->setTemplate($template);
    }
}

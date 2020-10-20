<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Crm\Model\CsvSchema;

use Crm\Model\CsvPreset\LinksReverse;
use Crm\Model\Links\Type\LinkTypeCall;
use Crm\Model\Orm\Interaction;
use Crm\Model\Orm\Task;
use \RS\Csv\Preset;

/**
 * Схема экспорта звонков в CSV
 */
class CallHistory extends \RS\Csv\AbstractSchema
{
    function __construct()
    {
        parent::__construct(new Preset\Base(array(
            'ormObject' => new \Crm\Model\Orm\Telephony\CallHistory(),
            'excludeFields' => array(
                'id', 'custom_data', '_custom_data'
            ),
            'savedRequest' => \Crm\Model\DealApi::getSavedRequest('Crm\Controller\Admin\CallHistoryCtrl_list'), //Объект запроса из сессии с параметрами текущего просмотра списка
            'searchFields' => array('deal_num')
        )), array(
            new LinksReverse(array(
                'ColumnTitle' => t('Взаимодействия'),
                'LinkType' => LinkTypeCall::getId(),
                'sourceType' => Interaction::getLinkSourceType(),
                'linkIdField' => 'id',
                'exportObject' => new Interaction(),
                'exportFormatCallback' => function($export_object) {
                    return $export_object['date_of_create'].' - '.$export_object['title'].'('.$export_object->getCreatorUser()->getFio().')';
                },
            )),
            new LinksReverse(array(
                'ColumnTitle' => t('Задачи'),
                'LinkType' => LinkTypeCall::getId(),
                'sourceType' => Task::getLinkSourceType(),
                'linkIdField' => 'id',
                'exportObject' => new Task(),
                'exportFormatCallback' => function($export_object) {
                    return $export_object['task_num'].' - '.$export_object['title'].'('.$export_object->getCreatorUser()->getFio().')';
                },
            )),
        ), array(
            'FieldScope' => array(
                'linksreverse-title' => 'export',
                'links-title' => 'export'
            )
        ));
    }
}
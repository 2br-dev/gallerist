<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Crm\Controller\Admin;
use Crm\Model\CallHistoryApi;
use Crm\Model\DealApi;
use Crm\Model\Orm\Telephony\CallHistory;
use Users\Model\Api as UserApi;

/**
 * Контроллер, поддерживающий выпадающие списки. Обеспечивает поиск объектов по строке
 */
class AjaxList extends \RS\Controller\Admin\Front
{
    /**
     * Ищет Сделки по входящей строке данных
     *
     * @return string
     */
    function actionAjaxSearchDeal()
    {
        $api = new DealApi();

        $term = $this->url->request('term', TYPE_STRING);
        $list = $api->search($term, array('id', 'deal_num', 'title', 'client_name', 'user'), 8);

        $json = array();
        foreach ($list as $deal) {

            $user = $deal->getClientUser();
            $json[] = array(
                'label' => t('Сделка №%num от %date', array(
                    'num' => $deal['deal_num'],
                    'date' => date('d.m.Y', strtotime($deal['date_of_create']))
                )),
                'id' => $deal['id'],
                'desc' => $deal['title'].'<br>'.t('Клиент').':'.$user->getFio().
                    ($user['id'] ? "({$user['id']})" : '').
                    ($user['company'] ? t(" ; {$user['company']}(ИНН:{$user['company_inn']})") : '')
            );
        }

        return json_encode($json);
    }

    /**
     * Ищет звонки по номеру телефона или ID звонка
     */
    function actionAjaxSearchCall()
    {
        $api = new CallHistoryApi();
        $term = $this->url->request('term', TYPE_STRING);
        $json = array();

        if ($term !== '') {
            $api->setFilter(array(
                'id' => $term,
                '|' => array(
                    '' => array(
                        'call_flow' => CallHistory::CALL_FLOW_IN,
                        'caller_number:%like%' => UserApi::normalizePhoneNumber($term)
                    ),
                    '|' => array(
                        'call_flow' => CallHistory::CALL_FLOW_OUT,
                        'called_number:%like%' => UserApi::normalizePhoneNumber($term)
                    )
                )
            ));

            foreach ($api->getList(1, 20) as $call) {
                $duration = $call->getDurationString();
                $json[] = array(
                    'label' => ($call['call_flow'] == CallHistory::CALL_FLOW_IN ?
                            t('Входящий звонок №')
                            : t('Исходящий звонок №')) . $call['id'],
                    'id' => $call['id'],
                    'desc' => t('%number, %date %duration', array(
                        'number' => $call->getCalledUser()->phone,
                        'date' => date('d.m.Y H:i', strtotime($call->event_time)),
                        'duration' => $duration ? "({$duration})" : ""
                    ))
                );
            }
        }

        return json_encode($json);
    }
}
<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/

namespace Users\Controller\Admin;

/**
 * Контроллер отдает список пользователей для компонента JQuery AutoComplete
 * @ingroup Users
 */
class AjaxList extends \RS\Controller\Admin\Front
{
    /** @var \Users\Model\Api */
    public $api;

    function init()
    {
        $this->api = new \Users\Model\Api();
    }

    function actionAjaxEmail()
    {
        $term = $this->url->request('term', TYPE_STRING);
        $list = $this->api->getLike($term, array('login', 'e_mail', 'surname', 'name', 'company', 'company_inn', 'phone'));
        $list = array_slice($list, 0, 5);
        $json = array();
        foreach ($list as $user) {
            $json[] = array(
                'label' => $user['surname'] . ' ' . $user['name'] . ' ' . $user['midname'],
                'id' => $user['id'],
                'email' => $user['e_mail'],
                'desc' => t('E-mail') . ':' . $user['e_mail'] . ($user['company'] ? t(" ; {$user['company']}(ИНН:{$user['company_inn']})") : '')
            );

        }

        return json_encode($json);
    }
}

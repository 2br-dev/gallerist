<?php

namespace gallerist\Controller\Front;

use Alerts\Model\Manager as AlertsManager;
use RS\Controller\Front;

/**
 * Фронт контроллер
 */
class Complaint extends Front
{
    function actionIndex()
    {
        $author_id = $this->url->get('author_id', TYPE_INTEGER);
        $author = new \Users\Model\Orm\User($author_id);
        $user = \RS\Application\Auth::getCurrentUser();
        $this->view->assign('author', $author);
        $this->view->assign('user', $user);
        return $this->result->setTemplate('complaint-form.tpl');
    }

    function actionSendComplaint()
    {
        $from = $this->request('from', TYPE_INTEGER);
        $to = $this->request('to', TYPE_INTEGER);
        $user_to = new \Users\Model\Orm\User($to);
        $user_from = new \Users\Model\Orm\User($from);
        $message = $this->request('message', TYPE_STRING);
        $success = false;
        $error = '';
        if($message == ''){
            $error = 'message';
        }
        if($error == ''){
            $item = new \Gallerist\Model\Orm\Complaint();
            $item['to'] = $to;
            $item['from'] = $from;
            $item['message'] = $message;
            $item['date'] = date('Y-m-d');
            $success = $item->insert();
        }
//        if($success){
//            // Оптарвить сообщение автору - что кто-то отправил ему личное сообщение.
//            $notice = new \Gallerist\Model\Notice\PersonalMessageToAuthor();
//            $notice->init($user_from, $user_to, $message);
//            AlertsManager::send($notice);
//        }
        $this->result->addSection('success', $success);
        $this->result->addSection('error', $error);
        return $this->result;
    }
}

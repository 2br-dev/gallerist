<?php

namespace gallerist\Controller\Front;

use Alerts\Model\Manager as AlertsManager;
use RS\Controller\Front;

/**
 * Фронт контроллер
 */
class Request extends Front
{
    function actionIndex()
    {
        return $this->result->setTemplate('test.tpl');
    }

    function actionSendRequest()
    {
        $art = intval($this->request('product', TYPE_INTEGER, 0));
        $is_auth = $this->request('is_auth', TYPE_BOOLEAN, false);
        $user_to = $this->request('user_to', TYPE_INTEGER, 0);
        $comment = $this->request('comment', TYPE_MIXED, '');
        $success = true;
        $error = [];
        $request = new \Gallerist\Model\Orm\Request();
        if($is_auth){
            $user_from = $this->request('user_from', TYPE_INTEGER, 0);
            $sender = new \Users\Model\Orm\User($user_from);
            $email = $sender['e_mail'];
            $phone = $sender['phone'];
        }else {
            $user_from = -100;
            $email = $this->request('from_email', TYPE_INTEGER, '');
            $phone = $this->request('from_phone', TYPE_INTEGER, '');
        }
        if($email == ''){
            $error['email'] = true;
        }
        if($phone == ''){
            $error['phone'] = true;
        }
        if($email == '' && $phone == ''){
            $success = false;
        }
        $request['user_from'] = $user_from;
        $request['user_to'] = $user_to;
        $request['from_email'] = $email;
        $request['from_phone'] = $phone;
        $request['comment'] = $comment;
        $request['date'] = date('Y-m-d H:i:s');
        $request['art'] = $art;
        if($success){
            $send_success = $request->insert();
            if($send_success){
                $notice = new \Gallerist\Model\Notice\PurchaseRequestToOwner();
                $notice->init(new \Catalog\Model\Orm\Product($art), $email, $phone, $user_from);
                AlertsManager::send($notice);
            }
        }
        $this->result->setSuccess($success);
        $this->result->addSection('error', $error);
        return $this->result;
    }
}

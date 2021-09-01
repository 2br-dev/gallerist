<?php
namespace Gallerist\Model\Notice;

/**
* Уведомление - Заявка на покупку картины для Автора
*/
class PersonalMessageToAuthor extends \Alerts\Model\Types\AbstractNotice
    implements \Alerts\Model\Types\InterfaceEmail
{
    public
        /**
        * @var \Users\Model\Orm\User $user
        */
        $user;
    public $user_from;
    public $message;
        
    /**
    * Возвращает название уведомления
    *     
    */
    public function getDescription()
    {
        return t('Личное сообщение (автору)');
    } 

    /**
    * Инициализация уведомления
    * 
    * @param \Catalog\Model\Orm\Product $picture - объект товара
    */
    function init($user_from, $user_to, $message)
    {
        /**
         * @var \Catalog\Model\Orm\Product $picture
         */
        $this->user = $user_to;
        $this->user_from = $user_from;
        $this->message = $message;
    }
    
    /**
    * Получаение информации о письме
    * 
    * @return \Alerts\Model\Types\NoticeDataEmail|false
    */
    function getNoticeDataEmail()
    {
        $email_to_user = new \Alerts\Model\Types\NoticeDataEmail();
        
        if (filter_var($this->user['e_mail'], FILTER_VALIDATE_EMAIL)){ //Если задан пользовательский E-mail
            $email_to_user->email = $this->user['e_mail']; 
        }else{ //Если пользовательского E-mail нет
            return false;
        }

        $email_to_user->subject  = t('Личное сообщение на сайте %0', [\RS\Http\Request::commonInstance()->getDomainStr()]);
        $email_to_user->template = '%gallerist%/notice/toauthor_personalmessage.tpl';
        $email_to_user->vars     = $this;                                          
        
        return $email_to_user;
        
    }

    /**
    * Возвращает шаблон письма
    * 
    * @return string
    */
    public function getTemplateEmail()
    {
        return '%gallerist%/notice/toauthor_personalmessage.tpl';
    }
}

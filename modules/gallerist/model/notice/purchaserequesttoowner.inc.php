<?php
namespace Gallerist\Model\Notice;

/**
* Уведомление - Заявка на покупку картины для Автора
*/
class PurchaseRequestToOwner extends \Alerts\Model\Types\AbstractNotice
    implements \Alerts\Model\Types\InterfaceEmail
{
    public
        /**
        * @var \Catalog\Model\Orm\Product $picture
        */
        $picture,
        /**
        * @var \Users\Model\Orm\User $user
        */
        $user;
    public $email;
    public $phone;
    public $user_from;
        
    /**
    * Возвращает название уведомления
    *     
    */
    public function getDescription()
    {
        return t('Заявка на покупку (автору)');
    } 

    /**
    * Инициализация уведомления
    * 
    * @param \Catalog\Model\Orm\Product $picture - объект товара
    */
    function init(\Catalog\Model\Orm\Product $picture, $email, $phone, $user_from)
    {
        /**
         * @var \Catalog\Model\Orm\Product $picture
         */
        $this->picture = $picture;
        $this->user  = $picture->getAuthor();
        $this->email = $email;
        $this->phone = $phone;
        if($user_from > 0){
            $this->user_from = new \Users\Model\Orm\User($user_from);
        }else{
            $this->user_from = $user_from;
        }

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

        $email_to_user->subject  = t('Заявка на покупку картины N%0 на сайте %1', [$this->picture['title'], \RS\Http\Request::commonInstance()->getDomainStr()]);
        $email_to_user->template = '%gallerist%/notice/toauthor_request.tpl';
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
        return '%gallerist%/notice/toauthor_request.tpl';
    }
}

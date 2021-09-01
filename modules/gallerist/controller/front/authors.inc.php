<?php
namespace Gallerist\Controller\Front;

use RS\Application\Auth as AppAuth;
use RS\Controller\Front;
use RS\Helper\Tools as HelperTools;
use RS\Orm\Type;
use RS\Site\Manager as SiteManager;
use Users\Model\Orm\User;

class Authors extends Front
{
    function actionIndex()
    {
        $user_api = new \Users\Model\Api();
        $authors = $user_api->setFilter('is_author', 1)->getList();
        $this->view->assign(array(
            'authors' => $authors
        ));
        return $this->result->setTemplate('%gallerist%/authors.tpl');
    }
}

<?php
namespace Gallerist\Controller\Front;

use RS\Application\Auth as AppAuth;
use RS\Controller\Front;
use RS\Helper\Tools as HelperTools;
use RS\Orm\Type;
use RS\Site\Manager as SiteManager;
use Users\Model\Orm\User;

class Author extends Front
{
    protected $author_name;

    function init()
    {
        $this->author_name = $this->url->get('name', TYPE_STRING);
    }

    function actionIndex()
    {
        $exploded_name = explode('_', $this->author_name);
        $author_name = $exploded_name[0];
        $author_surname = $exploded_name[1];
        $current_user = \RS\Application\Auth::getCurrentUser();
        $author = \RS\Orm\Request::make()
            ->from(new \Users\Model\Orm\User())
            ->where([
                'name_transliteration' => $author_name,
                'surname_transliteration' => $author_surname
            ])->object();
        $this->view->assign(array(
            'author' => $author,
            'current_user' => $current_user
        ));
        return $this->result->setTemplate('%gallerist%/author.tpl');
    }
}

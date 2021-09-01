<?php

namespace gallerist\Model\Orm;

use RS\Orm\OrmObject;
use RS\Orm\Type;

/**
 * ORM объект
 */
class Request extends OrmObject
{
    protected static $table = 'gallerist_request';

    function _init()
    {
        parent::_init()->append([
            'user_from' => new Type\Integer([
                'description' => t('От кого (id авторизованного)')
            ]),
            'user_to' => new Type\Integer([
                'description' => t('Кому (id)')
            ]),
            'from_email' => new Type\Varchar([
                'description' => t('E-mail')
            ]),
            'from_phone' => new Type\Varchar([
                'description' => t('Телефон')
            ]),
            'comment' => new Type\Richtext([
                'description' => t('Комментарий')
            ]),
            'date' => new Type\Datetime([
                'description' => t('Дата')
            ]),
            'art' => new Type\Integer([
                'description' => t('Картина (id)')
            ])
        ]);
    }
}

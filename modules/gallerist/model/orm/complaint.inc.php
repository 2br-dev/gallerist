<?php

namespace gallerist\Model\Orm;

use RS\Orm\OrmObject;
use RS\Orm\Type;

/**
 * ORM объект
 */
class Complaint extends OrmObject
{
    protected static $table = 'complaint';

    function _init()
    {
        parent::_init()->append([
            'from' => new Type\Integer([
                'description' => t('От кого'),
            ]),
            'to' => new Type\Integer([
                'description' => t('Кому'),
            ]),
            'date' => new Type\Date([
                'description' => t('Дата'),
            ]),
            'message' => new Type\Richtext([
                'description' => t('Сообщение'),
            ]),
        ]);
    }
}

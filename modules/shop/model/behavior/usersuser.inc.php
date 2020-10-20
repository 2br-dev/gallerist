<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/

namespace Shop\Model\Behavior;

use RS\Behavior\BehaviorAbstract;
use Users\Model\Orm\User;

class UsersUser extends BehaviorAbstract
{
    /**
     * Возвращает менедрера пользователя
     *
     * @return User|null
     */
    public function getManager(): ?User
    {
        if ($this->owner['manager_user_id']) {
            return new User($this->owner['manager_user_id']);
        }
        return null;
    }
}

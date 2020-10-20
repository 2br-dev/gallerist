<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/

namespace Shop\Model;

use RS\Event\Manager as EventManager;
use Shop\Model\Orm\Address;
use Shop\Model\Orm\Order;
use Users\Model\Orm\User;

class AddressApi extends \RS\Module\AbstractModel\EntityList
{
    function __construct()
    {
        parent::__construct(new \Shop\Model\Orm\Address, [
            'multisite' => true,
        ]);
    }

    /**
     *  Возвращает список доступых адресов, доступных при оформлении заказа для данного пользователя
     *
     * @param Order $order - заказ
     * @param User $user - пользователь
     * @return Address[]
     */
    public function getCheckoutUserAddresses(Order $order, User $user)
    {
        $this->clearFilter();
        $this->setFilter([
            'user_id' => $user['id'],
            'deleted' => 0,
        ]);
        /** @var Address[] $addr_list */
        $addr_list = $this->getList();

        // TODO описать событие 'checkout.useraddress.list' в документации
        $event_result = EventManager::fire('checkout.useraddress.list', array(
            'addr_list' => $addr_list,
            'order' => $order,
            'user' => $user,
        ));
        list($addr_list) = $event_result->extract();

        return $addr_list;
    }

    /**
     * Возвращает адрес по id города
     *
     * @param integer $city_id
     * @return Orm\Address
     */
    static function getAddressByCityid($city_id)
    {
        $city = new Orm\Region($city_id);
        if (!$city['is_city']) {
            return false;
        }
        $region = $city->getParent();
        $country = $region->getParent();

        $address = new Orm\Address();
        $address['zipcode']    = $city['zipcode'];
        $address['city']       = $city['title'];
        $address['city_id']    = $city['id'];
        $address['region']     = $region['title'];
        $address['region_id']  = $region['id'];
        $address['country']    = $country['title'];
        $address['country_id'] = $country['id'];

        return $address;
    }
}

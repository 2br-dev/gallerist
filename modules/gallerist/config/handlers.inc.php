<?php

namespace Gallerist\Config;

use RS\Event\HandlerAbstract;
use RS\Router\Route as RouterRoute;

/**
 * Класс содержит обработчики событий, на которые подписан модуль
 */
class Handlers extends HandlerAbstract
{
    /**
     * Добавляет подписку на события
     *
     * @return void
     */
    function init()
    {
        $this
            ->bind('orm.init.users-user')
            ->bind('getroute')  //событие сбора маршрутов модулей
            ->bind('getmenus')
            ->bind('orm.init.catalog-product')
            ->bind('product.getsearchtext');
    }

    public static function productGetSearchText($param){
        /**
         * @var \Catalog\Model\Orm\Product $product
         */
        $product = $param['product'];
        $text = $param['text_parts'];

        ///

        return [
            $text
        ];
    }

    public static function ormInitCatalogProduct(\Catalog\Model\Orm\Product $product){
        $product->getPropertyIterator()->append(array(
            'owner' => new \RS\Orm\Type\Integer(array(
                'description' => t('Владелец'),
                'maxLength' => 3,
                'visible' => false
            ))
        ));
    }

    /**
     * Добавляем новый атрибут пользователю - Покупатель(0) или Художник(1)
     * @param \Users\Model\Orm\User $user
     */
    public static function ormInitUsersUser(\Users\Model\Orm\User $user){
        $for_artist = array('is_artist' => 1);
        $src_folder = '/storage/users/original';
        $user->getPropertyIterator()->append(array(
            'is_artist' => new \RS\Orm\Type\Integer(array(
                'maxLength' => '1',
                'description' => t('Художник или покупатель')
            )),
            'city' => new \RS\Orm\Type\Varchar(array(
                'description' => t('Город'),
                'maxLength' => '255',
                'condition' => $for_artist,
//                'Checker' => array($chk_depend, t('Не указано название организации'), 'chkEmpty', $for_company),
            )),
            'photo' => new \RS\Orm\Type\File(array(
                'description' => t('Фото'),
                'storage' => array(\Setup::$ROOT, \Setup::$FOLDER . $src_folder),
                'template' => '%banners%/form/banner/file.tpl'
            )),

        ));
    }

    /**
     * Изменяем стандартный роутер регистарции пользователя - чтоб добавить выбор: Покупатель или Художник
     * @param array $routes
     * @return array
     */
    public static function getRoute(array $routes)
    {
        $routes[] = new \RS\Router\Route('users-front-register', '/register/', array(
            'controller' => 'gallerist-front-register'
        ), t('Регистрация пользователя'));

        return $routes;
    }

    /**
     * Добавление пункта меню в админ панел - Мои картины
     * @param $items
     * @return array
     */
    public static function getMenus($items)
    {
        $items[] = array(
            'title' => t('Мои картины'),
            'alias' => 'mypictures',
            'link'  => '%ADMINPATH%/catalog-ctrl/',
            'sortn' => 100,
            'parent' => '0',
            'typelink' => 'link'
        );

        $items[] = array(
            'title' => t('Профиль'),
            'alias' => 'profile',
            'link'  => '%ADMINPATH%/users-ctrl/',
            'sortn' => 101,
            'parent' => '0',
            'typelink' => 'link'
        );

        return $items;
    }

}

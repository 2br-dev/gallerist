<?php

namespace gallerist\Config;

use RS\Event\HandlerAbstract;
use RS\Orm\Type\ArrayList;
use RS\Orm\Type\Double;
use RS\Orm\Type\Integer;
use RS\Orm\Type\Richtext;
use RS\Orm\Type\Varchar;

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
            ->bind('orm.afterwrite.users-user')
            ->bind('orm.beforewrite.users-user')
            ->bind('orm.init.gallerist-picture')
            ->bind('orm.init.users-user')
            ->bind('orm.delete.users-user')
//            ->bind('start')
            ->bind('initialize')
            ->bind('getroute', null, null, 0)  //событие сбора маршрутов модулей
            ->bind('getmenus');
    }

    public static function ormDeleteUsersUser($params): void
    {
        $orm = $params['orm'];
        $arts = \RS\Orm\Request::make()
            ->from(new \Catalog\Model\Orm\Product())
            ->where([
                'owner' => $orm['id']
            ])->objects();
        if($arts){
            foreach ($arts as $art){
                $art->delete();
            }
        }
    }

    public static function initialize()
    {
        \Users\Model\Orm\User::attachClassBehavior(new \Gallerist\Model\Behavior\UsersUser());
        \Catalog\Model\Orm\Product::attachClassBehavior(new \Gallerist\Model\Behavior\CatalogProduct());
    }

    public static function start()
    {
        $user = \RS\Application\Auth::getCurrentUser();
        $request_uri = strtok($_SERVER['REQUEST_URI'], '?');

        //Если пользователь не является супервизором - то не может войти в админку
        if(!$user->inGroup('supervisor') && ($request_uri == '/admin/' || $request_uri == '/admin')){
            \RS\Application\Application::getInstance()->redirect('/');
        }
    }

    public static function ormBeforeWriteUsersUser($params){
        /**
         * @var \Users\Model\Orm\User $user
         */
        $user = $params['orm'];
        if($user->isModified('name')){
            $user['name_transliteration'] = \RS\Helper\Transliteration::rus2translit($user['name']);

        }
        if($user->isModified('surname')){
            $user['surname_transliteration'] = \RS\Helper\Transliteration::rus2translit($user['surname']);
        }
        if($user->checkTheSameNameAndSurname()){
            $user['surname_transliteration'] = $user['surname_transliteration'].$user->checkTheSameNameAndSurname();
        }
        $user['login'] = $user['e_mail'];
    }

    public static function ormAfterWriteUsersUser($params){
        /**
         * @var \Users\Model\Orm\User $user
         */
        $user = $params['orm'];
        $flag = $params['flag'];
        if($flag == $user::INSERT_FLAG){
            if($user['is_author']){
                $user->linkGroup(['artist']);
            }
        }
    }

    public static function ormInitGalleristPicture(\Gallerist\Model\Orm\Picture $orm)
    {
        $orm->getPropertyIterator()->append([
            t('Автор'),
                'owner' => new Integer([
                    'description' => t('Автор работы'),
                    'visible' => false
                ]),
                'has_image' => new Varchar([
                    'description' => t('Изображение'),
                    'checker' => [['\Gallerist\Model\Orm\Picture', 'checkSelectedImage'], t('Загрузите фото картины')],
                    'visible' => false
                ]),
            t('Характеристики'),
                'height' => new Double([
                    'description' => t('Высота картины (см)'),
                ]),
                'width' => new Double([
                    'description' => t('Ширина картины (см)')
                ]),
                'shape' => new ArrayList([
                    'description' => t('Форма'),
                    'list' => [['Gallerist\Model\PictureApi', 'getShapesList'], [0 => t('не выбрано')]]
                ]),
                '_shape' => new Varchar([
                    'description' => t('Форма (serialize)'),
                    'visible' => false
                ]),
                'orientation' => new ArrayList([
                    'description' => t('Ориентация'),
                    'list' => [['Gallerist\Model\PictureApi', 'getOrientationsList'], [0 => t('не выбрано')]]
                ]),
                '_orientation' => new Varchar([
                    'description' => t('Ориентация (serialize)'),
                    'visible' => false
                ]),
                'style' => new ArrayList([
                    'description' => t('Стиль(техника) работы'),
                    'list' => [['Gallerist\Model\PictureApi', 'getStylesList'], [0 => t('не выбрано')]]
                ]),
                '_style' => new Varchar([
                    'description' => t('Стиль (serialize)'),
                    'visible' => false
                ]),
                'material' => new ArrayList([
                    'description' => t('Материал'),
                    'list' => [['Gallerist\Model\PictureApi', 'getMaterialsList'], [0 => 'Не выбрано']]
                ]),
                '_material' => new Varchar([
                    'description' => t('Материал (serialize)'),
                    'visible' => false
                ]),
                'base' => new ArrayList([
                    'description' => t('Основа'),
                    'list' => [['Gallerist\Model\PictureApi', 'getBasesList'], [0 => 'не выбрано']]
                ]),
                '_base' => new Varchar([
                    'description' => t('Основа (serialize)'),
                    'visible' => false
                ]),
                'theme' => new ArrayList([
                    'description' => t('Тематика работы'),
                    'list' => [['Gallerist\Model\PictureApi', 'getThemesList'], [0 => t('не выбрано')]]
                ]),
                '_theme' => new Varchar([
                    'description' => t('Тематика (serialize)'),
                    'visible' => false
                ]),
                'city' => new Varchar([
                    'description' => t('Город'),
                    'visible' => false
                ]),
                'region' => new Varchar([
                    'description' => t('Регион'),
                    'visible' => false
                ]),
                'is_original' => new Integer([
                    'description' => t('Реплика'),
                    'checkBoxView' => [1,0],
                    'default' => 0
                ]),
                'in_baguette' => new Integer([
                    'description' => t('В багете'),
                    'checkBoxView' => [1,0],
                    'default' => 0
                ]),
                'in_stock' => new Integer([
                    'description' => t('В наличии'),
                    'checkBoxView' => [1,0],
                    'default' => 1
                ])
        ]);
    }

    public static function ormInitUsersUser(\Users\Model\Orm\User $orm)
    {
        $orm->getPropertyIterator()->append([
            'style' => new Varchar([
                'description' => t('Стиль работ')
            ]),
            'is_author' => new Integer([
                'description' => t('Является автором'),
                'maxLength' => 2
            ]),
            'name_transliteration' => new Varchar([
                'description' => t('Имя (транслит)'),
                'visible' => false
            ]),
            'surname_transliteration' => new Varchar([
                'description' => t('Фамилия (транслит)'),
                'visible' => false
            ]),
            t('Основные'),
                'city' => new Varchar([
                    'description' => t('Город'),
                    'checker' => ['chkEmpty', t('Укажите из какого вы города')]
                ]),
                'region' => new Varchar([
                    'description' => t('Регион'),
                    'checker' => ['chkEmpty', t('Укажите регион')]
                ]),
            t('Фото'),
                'photo' => new \RS\Orm\Type\Image(array(
                    'description' => t('Фото'),
                    'max_file_size'    => 10000000, //Максимальный размер - 10 Мб
                    'allow_file_types' => array('image/jpg', 'image/jpeg', 'image/png', 'image/gif'),//Допустимы форматы jpg, png, gif
                )),
            t('О себе'),
                'about' => new Richtext([
                    'description' => t('О себе')
                ])
        ]);
    }

    /**
     * Возвращает маршруты данного модуля. Откликается на событие getRoute.
     * @param array $routes - массив с объектами маршрутов
     * @return array of \RS\Router\Route
     */
    public static function getRoute(array $routes)
    {
        $routes[] = new \RS\Router\Route('users-front-register', '/register/', array(
            'controller' => 'gallerist-front-register'
        ), t('Регистрация пользователя'));
        $routes[] = new \RS\Router\Route('gallerist-front-authors', '/authors/', array(
            'controller' => 'gallerist-front-authors'
        ), t('Список авторов'));
        $routes[] = new \RS\Router\Route('users-front-profile', '/my/', array(
            'controller' => 'gallerist-front-profile'
        ), t('Личный кабинет'));
        $routes[] = new \RS\Router\Route('gallerist-front-editimage', '/editimage/{id}/', array(
            'controller' => 'gallerist-front-editimage'
        ), t('Редакитрование главного изображения'));
        $routes[] = new \RS\Router\Route('gallerist-front-author', '/author/{name}/', array(
            'controller' => 'gallerist-front-author'
        ), t('Профиль автора'));
        return $routes;
    }

    /**
     * Возвращает пункты меню этого модуля в виде массива
     * @param array $items - массив с пунктами меню
     * @return array
     */
    public static function getMenus($items)
    {
        $items[] = [
            'title' => 'Пункт модуля gallerist',
            'alias' => 'gallerist-control',
            'link' => '%ADMINPATH%/gallerist-control/',
            'parent' => 'modules',
            'sortn' => 40,
            'typelink' => 'link',
        ];
        return $items;
    }
}

<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Main\Config;

use Main\Model\NoticeSystem\InternalAlerts;
use Main\Model\RsNewsApi;
use Main\Model\WallPostApi;
use RS\Application\Application;
use RS\Config\Loader;
use RS\Db\Exception as DbException;
use RS\Event\HandlerAbstract;
use RS\Img\Core as ImgCore;
use RS\Orm\Exception as OrmException;
use RS\Router;

class Handlers extends HandlerAbstract
{
    function init()
    {
        $this
            ->bind('getmenus')
            ->bind('geoip.getservices')
            ->bind('meter.recalculate')
            ->bind('getroute')
            ->bind('getpages')
            ->bind('internalalerts.get')
            ->bind('start');
    }

    public static function getRoute(array $routes)
    {
        $routes[] = new Router\Route('main.image', '/storage/system/resized/{type}/{picid}\.{ext}$', array(
            'controller' => 'main-front-photohandler'
        ), t('Изображение для ORM-объектов'), true);

        $routes[] = new Router\Route('main.index', "/", array(
            'controller' => 'main-front-stub'
        ),
            t('Главная страница'), false, '^{pattern}$'
        );

        $routes[] = new Router\Route('main.rsgate', '/--rsgate-{Act}/', array(
            'controller' => 'main-front-rsrequestgate'
        ), t('Внешнее API для взаимодействия с сервисами ReadyScript'), true);

        $routes[] = new Router\Route('main-front-cmssign', '/cms-sign/', null, t('Отпечаток CMS'), true);
        $routes[] = new Router\Route('kaptcha', '/nobot/', array('controller' => 'main-front-captcha'), t('Капча'), true);
        $routes[] = new Router\Route('main-front-qrcode', '/qrcode/', null, t('QR Код'), true);

        return $routes;
    }


    /**
     * Возвращает пункты меню этого модуля в виде массива
     *
     */
    public static function getMenus($items)
    {
        $items[] = array(
            'title' => t('Настройка системы'),
            'alias' => 'systemoptions',
            'link' => '%ADMINPATH%/main-options/',
            'parent' => 'control',
            'sortn' => 0,
            'typelink' => 'link',
        );
        if (!defined('CANT_MANAGE_LICENSE')) {
            $items[] = array(
                'title' => t('Лицензии'),
                'alias' => 'license',
                'link' => '%ADMINPATH%/main-license/',
                'parent' => 'control',
                'sortn' => 1,
                'typelink' => 'link',
            );
        }
        return $items;
    }


    /**
     * Возвращает список сервисов для определения Геопозиции по IP
     *
     * @param \Main\Model\GeoIp\IpGeoBase[] $list
     * @return \Main\Model\GeoIp\IpGeoBase[]
     */
    public static function GeoIpGetservices($list)
    {
        $list[] = new \Main\Model\GeoIp\IpGeoBase();
        $list[] = new \Main\Model\GeoIp\Dadata();
        return $list;
    }

    /**
     * Добавим информацию о счетчиках
     */
    public static function meterRecalculate($meters)
    {
        //Обновляем счетчик непрочитанных новостей ReadyScript
        $rs_news_api = new RsNewsApi();
        $meters[RsNewsApi::METER_KEY] = $rs_news_api->checkNews();

        return $meters;
    }

    /**
     * Возвращает url адреса для Sitemap
     *
     * @param array $urls - массив ранее созданных адресов
     * @return array
     * @throws DbException
     * @throws OrmException
     */
    public static function getPages($urls)
    {
        $urls[] = array(
            'loc' => \RS\Site\Manager::getSite()->getRootUrl(),
            'priority' => '1'
        );
        return $urls;
    }

    /**
     * Обработчик, вызываемый на старте каждой страницы
     */
    static function start()
    {
        /** @var File $config */
        $config = Loader::byModule(__CLASS__);

        // Инициализируем капчу
        \RS\Captcha\Manager::currentCaptcha()->onStart();

        // Подключаем проверку поддержки webp
        $router = Router\Manager::obj();
        if (function_exists('imagewebp') && !$router->isAdminZone() && $config['webp_generate_only']) {
            Application::getInstance()->addJs('/webpjs/rs.webpcheck.js', null, BP_COMMON);
        }

        if ($config['webp_generate_only'] && $config['webp_disable_on_apple'] && $config->isAppleUser()) {
            ImgCore::switchFormat(ImgCore::FORMAT_WEBP, false);
        }
    }


    /**
     * Добавляет системные уведомления о возможности получить бонус за репост
     *
     * @param array $params
     */
    static function internalAlertsGet($params)
    {
        $internal_alerts = $params['internal_alerts'];
        $wall_post_api = new WallPostApi();

        if (defined('CLOUD_UNIQ')) {
            $message = t('5 дней в облаке');
        } else {
            $message = t('5 дней подписки на обновления');
        }

        if ($wall_post_api->canShowNotice(WallPostApi::SOCIAL_VK)) {

            $internal_alerts->addMessage(
                t('+ %0 за пост в ВК', array($message)),
                $wall_post_api->getPostUrl(WallPostApi::SOCIAL_VK),
                '_blank',
                InternalAlerts::STATUS_WARNING,
                t('Нажмите сюда, чтобы опубликовать пост на вашей стене Вконтакте о ReadyScript и автоматически получить бонус в виде дополнительных %0.', array($message)),
                array(
                    'url' => $wall_post_api->getCloseAlertUrl(WallPostApi::SOCIAL_VK)
                )
            );
        }

        if ($wall_post_api->canShowNotice(WallPostApi::SOCIAL_FB)) {

            $internal_alerts->addMessage(
                t('+ %0 за пост в FaceBook', array($message)),
                $wall_post_api->getPostUrl(WallPostApi::SOCIAL_FB),
                '_blank',
                InternalAlerts::STATUS_WARNING,
                t('Нажмите сюда, чтобы опубликовать пост на вашей стене Facebook о ReadyScript и автоматически получить бонус в виде дополнительных %0.', array($message)),
                array(
                    'url' => $wall_post_api->getCloseAlertUrl(WallPostApi::SOCIAL_FB)
                ));
        }
    }
}

<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/

namespace Main\Config;

use RS\AccessControl\DefaultModuleRights;
use RS\AccessControl\Right;

class ModuleRights extends DefaultModuleRights
{
    const RIGHT_WIDGET_CONTROL = 'widget_control';
    const RIGHT_DEBUG_MODE = 'debug_mode';

    protected function getSelfModuleRights()
    {
        return array(
            new Right(self::RIGHT_READ, t('Чтение')),
            new Right(self::RIGHT_CREATE, t('Создание')),
            new Right(self::RIGHT_UPDATE, t('Изменение')),
            new Right(self::RIGHT_DELETE, t('Удаление')),
            new Right(self::RIGHT_WIDGET_CONTROL, t('Управление виджетами')),
            new Right(self::RIGHT_DEBUG_MODE, t('Возможность включить режим отладки')),
        );
    }
}

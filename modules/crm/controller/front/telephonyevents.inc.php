<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Crm\Controller\Front;

use Crm\Model\Telephony\Manager;
use RS\Controller\ExceptionPageNotFound;
use RS\Controller\Front;
use RS\Helper\Log;

/**
 * Контроллер обрабатывает входящие сообщения от телефонии
 */
class TelephonyEvents extends Front
{
    /**
     * @var Log
     */
    private $log;
    private $enable_log;

    function init()
    {
        $this->enable_log = $this->getModuleConfig()->tel_enable_log;
        $this->log = Log::file(Manager::getLogFilepath(), true);
        $this->log->setEnable($this->enable_log);
    }

    /**
     * Обрабатывает входящий запрос с событием от телефонии
     *
     */
    function actionIndex()
    {
        $this->wrapOutput(false);
        $this->writeLogHeader();

        try {
            $provider_id = $this->url->get('provider', TYPE_STRING);
            $secret = $this->url->get('secret', TYPE_STRING);
            $provider = Manager::getProviderById($provider_id);

            if ($secret !== $provider->getUrlSecret()) {
                $this->e404(t('Некорректный ключ'));
            }

            $call_event = $provider->onEvent($this->url);
            if ($call_event) {
                $result = Manager::registerCallEvent($call_event);
                if ($result === true) {
                    $this->log->append('Событие успешно зарегистрировано');
                } else {
                    $this->log->append(t('Событие не зарегистрировано. Ошибка: %error', array('error' => $result)));
                }
            }
        } catch (\Throwable $e) {

            $this->log->append('Ошибка: '.$e->getMessage());
            if (!($e instanceof ExceptionPageNotFound)) {
                $this->log->append('Код ошибки: ' . $e->getCode());
                $this->log->append('Файл: ' . $e->getFile());
                $this->log->append('Строка: ' . $e->getLine());
                $this->log->append('Стек вызова: ' . $e->getTraceAsString());
            }
            throw $e;

        }

        $this->log->append(t('Запрос успешно принят, ответ: %response', array(
            'response' => $call_event->getReturnData()
        )));
        $this->log->append('-----');

        return $call_event->getReturnData();
    }

    /**
     * Записывает сведения о начале запроса в лог файл
     * @throws \RS\Exception
     */
    private function writeLogHeader()
    {
        if ($this->enable_log) {
            $this->log->append(' ');
            $this->log->append('-- '.date('Y-m-d H:i:s').' --');
            $this->log->append(t('Входящий запрос на URL: %url', array('url' => $this->url->getSelfUrl())));

            $this->log->append(t('Данные из GET:'));
            foreach ($this->url->getSource(GET) as $key => $value) {
                $this->log->append($key . '=' . var_export($value, true));
            }

            $this->log->append(t('Данные из POST:'));
            foreach ($this->url->getSource(POST) as $key => $value) {
                $this->log->append($key . '=' . var_export($value, true));
            }
        }
    }
}
<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Crm\Model\Telephony;

use RS\Config\Loader;
use RS\Helper\Log;

/**
 * Класс, необходимый для выполнения запросов к провайдеру телефонии.
 *
 * В случае если AccessToken протух, умеет обновлять токен и повторять запрос автоматически
 * Позволяет логировать запросы.
 */
class Requester
{
    public $retry_status_code_min = 400;
    public $retry_status_code_max = 499;

    private $provider;
    private $headers = array();
    private $method = 'GET';
    private $data = array();
    private $authorize_callback;

    private $enable_log;
    private $log;

    function __construct($provider)
    {
        $this->provider = $provider;

        $this->enable_log = Loader::byModule($this)->tel_enable_log;
        $this->log = Log::file(Manager::getLogFilepath(), true);
        $this->log->setEnable($this->enable_log);
    }

    /**
     * Возвращае объект т провайдера телефонии, запросы к которому будут логироваться
     *
     * @return Provider
     */
    public function getProvider()
    {
        return $this->provider;
    }

    /**
     * Сбрасывает установленные ранее заголовки, данные и метод запроса
     *
     * @return self
     */
    public function clean()
    {
        $this->data = array();
        $this->headers = array();
        $this->method = 'GET';

        return $this;
    }


    /**
     * Добавляет заголовок
     *
     * @param $key
     * @param $value
     */
    public function addHeader($key, $value)
    {
        if (is_array($key)) {
            $this->headers = array_merge($this->headers, $key);
        } else {
            $this->headers[$key] = $value;
        }
    }

    /**
     * Возвращает заголови
     *
     * @param $key
     * @return array|mixed
     */
    public function getHeader($key = null)
    {
        $headers = $this->headers;

        if ($this->getMethod() != 'GET'
            && !isset($this->headers['Content-Type'])
            && is_array($this->getData())) {

            $headers['Content-Type'] = 'application/x-www-form-urlencoded';
        }

        return $key !== null ? $headers[$key] : $headers;
    }

    /**
     * Удаляет заголовок с ключем $key
     *
     * @param $key
     */
    public function removeHeader($key)
    {
        unset($this->headers[$key]);
    }

    /**
     * Устанавливает метод запроса GET, POST, PUT, DELETE ...
     *
     * @param $method
     */
    public function setMethod($method)
    {
        $this->method = strtoupper($method);

        return $this;
    }

    /**
     * Возвращает метод запроса
     *
     * @param $method
     * @return string
     */
    public function getMethod()
    {
        return $this->method;
    }

    /**
     * Устанавливает массив с данными для запроса
     *
     * @param $data
     * @return self
     */
    public function setData($data)
    {
        $this->data = $data;

        return $this;
    }

    /**
     * Возвращает массив с данными для запроса
     *
     * @return array
     */
    public function getData()
    {
        return $this->data;
    }

    /**
     * Возвращает заголовки, которые необходимо добавить в запрос
     *
     * @return string
     */
    function getHeadersInline()
    {
        $result = array();
        $headers = $this->getHeader();
        foreach($headers as $key => $value) {
            $result[] = $key.':'.$value;
        }

        return implode("\r\n", $result);
    }

    /**
     * Устанавливает callback, который будет получать accessToken и
     * устанавливать его в параметры запроса текущего объекта
     *
     * @param $callback
     */
    public function setAuthorizeCallback($callback)
    {
        $this->authorize_callback = $callback;
    }

    /**
     * Выполняет авторизацию
     *
     * @param bool $force
     */
    public function authorize($force = false)
    {
        if ($this->authorize_callback) {
            return call_user_func($this->authorize_callback, $this, $force);
        }
    }

    /**
     * Выполянет запрос на удаленный сервер
     *
     * @param string $url URL запроса
     * @param bool $auto_auth Если true, то предварительно будет вызываться метод установки авторизации
     * @param bool $retry Если true, то при получении статуса ответа в диапазоне $retry_status_code_min и $retry_status_code_max,
     * будет повторно вызван метод установки авторизации с флагом force
     * @param bool $no_log_response_content Если true, то в лог не будет сохраняться тело ответа. (нужно, если возвращаются бинарные данные)
     * @return RequesterResult
     */
    public function request($url, $auto_auth = true, $retry = true, $no_log_response_content = false)
    {
        if ($auto_auth) {
            $this->authorize();
        }

        $context = array(
            'http'=>array(
                'method' => $this->getMethod(),
                'header' => $this->getHeadersInline(),
                'ignore_errors' => true
            )
        );

        if ($this->getMethod() != 'GET') {
            $data = $this->getData();
            $context['http']['content'] = is_array($data) ? http_build_query($data) : $data;
        }

        $stream = stream_context_create($context);

        $this->logRequestHeader($url, $context);

        $response = @file_get_contents($url,null, $stream);

        $result = new RequesterResult();
        $result->setHeaders($http_response_header);
        $result->setRawData($response);

        if ($response) {
            $this->log->append(t('Получен ответ %response. Статус: %status', array(
                'response' => $no_log_response_content ? t('-- невозможно отобразить --') : $response,
                'status' => $result->getStatusCode()
            )));
        }

        if ($retry
            && $result->getStatusCode() >= $this->retry_status_code_min
            && $result->getStatusCode() <= $this->retry_status_code_max) {

            $this->log->append('Обновляем авторизационный токен и повторяем попытку');

            $this->authorize(true);
            return $this->request($url, false, false, $no_log_response_content);
        }

        return $result;
    }

    /**
     * Записывает в лог-файл заголовок происходящего звонка
     *
     * @param $url
     * @param $context
     */
    public function logRequestHeader($url, $context)
    {
        $this->log->append("");
        $this->log->append('-- '.date('Y-m-d H:i:s').' --');
        $this->log->append(t('Исходящий %method запрос на URL: %url', array(
            'method' => $this->getMethod(),
            'url' => $url
        )));
        $this->log->append(t('Заголовки:'));

        if (isset($context['http']['header'])) {
            $this->log->append($context['http']['header']);
        }

        $this->log->append(t('Данные:'));

        if (is_array($this->getData())) {
            foreach($this->getData() as $key => $value) {
                $this->log->append($key.'='.var_export($value, true));
            }
        } else {
            $this->log->append(var_export($this->getData(), true));
        }
    }
}
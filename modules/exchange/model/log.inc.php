<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Exchange\Model;

/**
 * Класс содержит функции логгирования
 */
class Log
{
    const DEFAULT_LOG = 'exchange/exchange.log';// Лог-файл по умолчанию

    static private $enable = true;              // Если true, то логирование включено
    static private $indent = 0;                 // Текущий отступ в лог-файле (количество символов \t перед строкой)

    /**
     * Включает/выключает логирование
     *
     * @param bool $bool - значение
     * @return void
     */
    static public function setEnable($bool)
    {
        self::$enable = $bool;
    }

    /**
     * Запись строки в log-файл
     *
     * @param string $text - Строка для записи
     * @return void
     */
    static public function w($text)
    {
        if (!self::$enable) return;
        $indent = str_repeat("\t", self::$indent);
        $file = self::getFile();
        $file->append($indent . $text);
    }

    public static function getFile()
    {
        static $file;
        if ($file === null) {
            $file = \RS\Helper\Log::file(\Setup::$ROOT . \Setup::$STORAGE_DIR . DS . self::DEFAULT_LOG);
            $file->enableDate();
            $file->setMaxLength(1048576);
        }
        return $file;
    }

    /**
     * Очистить лог-файл
     *
     * @param string|bool $log_file Имя лог-файла (необязательно)
     * @return void
     */
    static public function clear($log_file = false)
    {
        if (!$log_file) $log_file = self::DEFAULT_LOG;
        @unlink(\Setup::$ROOT . \Setup::$STORAGE_DIR . DS . $log_file);
    }

    /**
     * Увеличить отступ в лог файле для последующих записей
     *
     * @return void
     */
    static public function indentInc()
    {
        self::$indent++;
    }

    /**
     * Уменьшить отступ в лог файле для последующих записей
     *
     * @return void
     */
    static public function indentDec()
    {
        if (self::$indent <= 0) return;
        self::$indent--;
    }

    /**
     * Представить массив в виде [key=val, key2=val2]
     *
     * @param array $arr
     * @return string
     */
    static public function arr2str($arr)
    {
        $lines = array();
        foreach ($arr as $key => $val) {
            $lines[] = "{$key}={$val}";
        }
        return '[' . join(', ', $lines) . ']';
    }
}

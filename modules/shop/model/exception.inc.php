<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Shop\Model;

/**
 * Исключения, связанные с модулем магазин
 */
class Exception extends \RS\Exception
{
    //Обработка транзакций
    const ERR_ORDER_NOT_FOUND = 1;
    const ERR_ORDER_ALREADY_PAYED = 2;
    const ERR_TRANSACTION_CREATION = 3;
    const ERR_BAD_PAYMENT_TYPE = 4;
    const ERR_BAD_PAYMENT_PARENT = 5;
    const ERR_NOT_ONLINE_PAYMENT = 6;
    const ERR_NO_TRANSACTION_ID = 7;
    const ERR_TRANSACTION_NOT_FOUND = 8;
    const ERR_ORDER_BAD_STATUS = 9;
}
{*
    В этом шаблоне доступна переменная $transaction
    Объект заказа можно получить так: $transaction->getOrder()
    $need_check_receipt - Флаг, если нужно проверить статус чека после оплаты 
*}
<div class="paymentResult">
    <div class="success">
    {if $need_check_receipt}
        <img id="rs-waitReceiptLoading" src="{$THEME_IMG}/loading.gif" alt=""/>
    {/if}
    <span class="text">{t}Оплата успешно проведена{/t}{if $need_check_receipt}<span id="rs-waitReceiptStatus">, {t}ожидается получение чека.{/t}</span>{/if}</span></div><br>
    {if $transaction->getOrder()->id}
        <a href="{$router->getUrl('shop-front-myorderview', ['order_id' => $transaction->getOrder()->order_num])}" class="colorButton">{t}перейти к заказу{/t}</a>
    {else}
        <a href="{$router->getUrl('shop-front-mybalance')}" class="colorButton">{t}перейти к лицевому счету{/t}</a>
    {/if}
</div>

{if $need_check_receipt} {* Если нужно проверить статус чека после оплаты *}
   {addjs file="%shop%/order/success_receipt.js"}
{/if}
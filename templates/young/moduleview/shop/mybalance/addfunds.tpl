{addjs file='%shop%/mybalance.js'}

<div class="addMoneyBlock">
    <h2>{t}Выберите способ оплаты{/t}</h2>
    {if $api->hasError()}
        <div class="pageError pbottom">
            {foreach $api->getErrors() as $item}
            <p>{$item}</p>
            {/foreach}
        </div>
    {/if}    
    <form method="POST" class="formStyle addMoney">
        <input type="hidden" name="payment" value="0">
        <table class="formStyle">
            {foreach $pay_list as $item}
            <tr>
                <td class="radio">
                    <input type="radio" id="dlv_{$item.id}" value="{$item.id}" name="payment" {if $smarty.post.payment==$item.id}checked{/if}>
                </td>
                <td class="info">
                    <label for="dlv_{$item.id}">{$item.title}</label>
                    <div class="help">{$item.description}</div>
                </td>
            </tr>
            {/foreach}
        </table>
        
        <div class="addMoneyForm">
            <span class="text">{t}Укажите сумму пополнения{/t} ({$base_currency.stitle})</span>
            <span class="summa "><input class="cost_field" type="text" name="cost" value="{$smarty.post.cost}" placeholder="0.00"></span>
            {if $current_currency.stitle != $base_currency.stitle}
            <label class="label_curr"></label>
            {/if}
            <input class="hidden_curr" data-ratio="{$current_currency.ratio}" data-liter="{$current_currency.stitle}" type="hidden" value="">
            <br>
            <input type="submit" value="{t}Пополнить{/t}">
        </div>
    </form>
</div>
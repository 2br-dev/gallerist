{$app->autoloadScripsAjaxBefore()}
{addcss file="{$mod_css}productamountincart.css" basepath="root"}
{addjs file="{$mod_js}productamountincart.js" basepath="root"}

{$url = $router->getUrl('shop-block-productamountincart', [cart_amount_action=>'changeAmount', _block_id=>$_block_id])}
<div class="cartAmount {if $style_class}style-{$style_class}{/if} rs-cartAmount {if $amount}rs-inCart{/if}" data-cart-amount-options='{$cart_amount_options}' data-url="{$url}"">
    <a data-url="{$router->getUrl('shop-front-cartpage', ["add" => $product.id, "amount" => $amount_add_to_cart])}" class="cartAmount_addButton rs-to-cart">{t}В корзину{/t}</a>
    <input type="number" name="{$input_name}" value="{$amount}" class="cartAmount_input rs-cartAmount_input rs-field-amount">
    {if !$forbid_change_amount}
        <div class="cartAmount_increaseButton rs-cartAmount_inc">+</div>
        <div class="cartAmount_decreaseButton rs-cartAmount_dec">-</div>
    {/if}
</div>
{$app->autoloadScripsAjaxAfter()}
{* Список товаров, который может быть в 2х видов *}
{foreach $list as $product}
    {include file="%catalog%/product_in_list_block.tpl" product=$product}
{/foreach}

<form method="GET" class="query on" action="{$router->getUrl('catalog-front-listproducts', [])}" id="queryBox">
    <input type="text" class="input query{if !$param.hideAutoComplete} autocomplete{/if}" name="query" value="{$query}" autocomplete="off" data-source-url="{$router->getUrl('catalog-block-searchline', ['sldo' => 'ajaxSearchItems', _block_id => $_block_id])}" placeholder="{t}Поиск по каталогу{/t}">
    <input type="submit" class="submit" value="" title="{t}Найти в каталоге{/t}">
</form>
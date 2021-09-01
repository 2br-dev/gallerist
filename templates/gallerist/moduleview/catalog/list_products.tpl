{* Просмотр списка товаров в категории, просмотр результатов поиска *}

{$shop_config=ConfigLoader::byModule('shop')}
{$check_quantity=$shop_config.check_quantity}
{$list = $this_controller->api->addProductsDirs($list)}

{if $THEME_SETTINGS.enable_favorite}
    {$list = $this_controller->api->addProductsFavorite($list)}
    {addjs file='rs.favorite.js'}
{/if}

{if $no_query_error}
    <div class="empty-list">
        {t}Не задан поисковый запрос{/t}
    </div>      
{else}
    <div id="products" class="catalog {if $shop_config}shopVersion{/if}">
        <div class="row">
                {if count($list)}

                    {include file="list_products_items.tpl"}

                    <div class="pull-right">
                        {include file="%THEME%/paginator.tpl"}
                    </div>

                {else}
                    <div class="empty-list col l4 m6 s12 gallery-entry @@colors">
                        {if !empty($query)}
                            {t}Извините, ничего не найдено{/t}
                        {else}
                            {t}В данной категории нет ни одного товара{/t}
                        {/if}
                    </div>
                {/if}

        </div>
    </div>
{/if}

<div class="affiliatesColumns">
    <ul class="tree">
        {foreach $regions as $item}
            <li>
                {if $item.fields.clickable}
                    <a class="city {if $item.fields.is_highlight}hl{/if}" data-is-default="{$item.fields.is_default}" data-href="{$router->getUrl('affiliate-front-change', ['affiliate' => {$item.fields.alias|default:$item.fields.id}, 'referer' => $referer])}">{$item.fields.title}</a>
                {else}
                    <span class="city {if $item.fields.is_highlight}hl{/if}">{$item.fields.title}</span>
                {/if}

                {* Второй уровень *}
                {if $item.child}
                    <ul>
                        {foreach $item.child as $subitem}
                            <li>&sdot;&sdot;&sdot;
                                {if $subitem.fields.clickable}
                                    <a class="city {if $subitem.fields.is_highlight}hl{/if}" data-is-default="{$item.fields.is_default}" data-href="{$router->getUrl('affiliate-front-change', ['affiliate' => {$subitem.fields.alias|default:$subitem.fields.id}, 'referer' => $referer])}">{$subitem.fields.title}</a>
                                {else}
                                    <span class="city {if $subitem.fields.is_highlight}hl{/if}">{$subitem.fields.title}</span>
                                {/if}
                            </li>
                        {/foreach}
                    </ul>
                {/if}
                {* Конец второго уровня *}
            </li>
        {/foreach}
    </ul>
</div>

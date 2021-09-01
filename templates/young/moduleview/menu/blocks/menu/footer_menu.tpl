{if $items}
    <div class="footerMenu mobileHidden">
        {if $root.title}
            <p class="caption">{$root.title}</p>
        {/if}
        <ul>
            {foreach $items as $item}
                <li {$item.fields->getDebugAttributes()}>
                    <a href="{$item.fields->getHref()}" {if $item.fields.target_blank}target="_blank"{/if}>{$item.fields.title}</a>
                </li>
            {/foreach}
        </ul>
    </div>
{else}
    {include file="%THEME%/block_stub.tpl"  class="noBack blockSmall blockLeft blockLogo" do=[
        {$this_controller->getSettingUrl()|escape}    => t("Настройте блок")
    ]}
{/if}
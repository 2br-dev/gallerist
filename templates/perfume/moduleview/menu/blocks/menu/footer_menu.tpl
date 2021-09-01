{if $items}
    {if $root.title}<p class="footHead">{$root.title}</p>{/if}
    <ul class="footMenu">
        {foreach $items as $item}
        <li {$item.fields->getDebugAttributes()}>
            <a href="{$item.fields->getHref()}" {if $item.fields.target_blank}target="_blank"{/if}>{$item.fields.title}</a>
        </li>
        {/foreach}
    </ul>
{else}
    {include file="%THEME%/block_stub.tpl"  class="noBack blockSmall blockLeft blockLogo" do=[
        {$this_controller->getSettingUrl()}    => t("Настройте блок")
    ]}
{/if}
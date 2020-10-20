<div id="tab-orm-editor-{$index}" class="tab-pane {if $active}active{/if}" data-group-name="{$group}">
    <div class="table-mobile-wrapper">
        <table class="rs-table">
            <thead>
            <tr>
                <th>{t}Скрыт{/t}</th>
                <th>{t}ID свойства{/t}</th>
                <th>{t}Название свойства{/t}</th>
                <th>{t}Тип{/t}</th>
                <th>{t}Значение по умолчанию{/t}</th>
                <th>{t}Разрешен NULL{/t}</th>
                <th></th>
            </tr>
            </thead>
            <tbody class="rs-orm-item-list">
                {foreach $items as $n => $item}
                    {if $item->is_custom_field}
                        {include file="%ormeditor%/custom_property.tpl" item=$item uniq=$n group=$group}
                    {else}
                        {include file="%ormeditor%/native_property.tpl" item=$item uniq=$n group=$group}
                    {/if}
                {/foreach}
            </tbody>
        </table>
        <div class="m-t-10 m-b-10">
            <a data-href="{adminUrl do="getCustomFieldLine" group=$group}" class="btn btn-primary btn-alt rs-orm-add-field">{t}Добавить свойство{/t}</a>
        </div>
    </div>
</div>
{addjs file="%ormeditor%/jquery.ormeditor.js"}

<div class="rs-orm-editor">
    <div class="m-t-10">
        <a data-href="{adminUrl do="getCustomTab"}" class="btn btn-primary btn-alt rs-orm-add-tab">{t}Добавить вкладку{/t}</a>
    </div>
    <div class="tabs">
        <ul class="tab-nav">
            {foreach $field_data as $group => $items}
                {$remove=true}
                {foreach $items as $n => $item}
                    {if !$item->is_custom_field}
                        {$remove=false}
                    {/if}
                {/foreach}

                {include file="%ormeditor%/field_tab.tpl" active=$items@first group=$group index=$items@iteration remove=$remove}
            {/foreach}
        </ul>
        <form class="tab-content crud-form" method="POST" action="{urlmake}" enctype="multipart/form-data">
            {foreach $field_data as $group => $items}
                {include file="%ormeditor%/field_list.tpl" items=$items active=$items@first group=$group index=$items@iteration}
            {/foreach}
        </form>
    </div>
</div>
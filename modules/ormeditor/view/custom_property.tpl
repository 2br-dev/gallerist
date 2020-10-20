<tr>
    <td>
        <input type="hidden" name="field[{$uniq}][tab]" value="{$group}">
        <input type="checkbox" name="field[{$uniq}][hide]" value="1" {if $item->custom_field->hide}checked{/if}></td>
    <td><input type="text" name="field[{$uniq}][field]" value="{$item->getName()}" placeholder="{t}Англ. идентификатор{/t}"></td>
    <td><input type="text" name="field[{$uniq}][description]" value="{$item->getDescription()}" placeholder="{t}Название поля{/t}"></td>
    <td><select name="field[{$uniq}][type]">
            {foreach $item->custom_field->getTypeTitles() as $key => $value}
                <option value="{$key}" {if $key == $item->custom_field->type}selected{/if}>{$value}</option>
            {/foreach}
        </select>
    </td>
    <td>
        <input type="text" name="field[{$uniq}][default]" value="{$item->getDefault()}">
    </td>
    <td>
        <select name="field[{$uniq}][allow_empty]">
            <option value="1" {if $item->isAllowEmpty()}selected{/if}>{t}Да{/t}</option>
            <option value="0" {if !$item->isAllowEmpty()}selected{/if}>{t}Нет{/t}</option>
        </select>
    </td>
    <td>
        <a class="c-red rs-remove-field"><i class="zmdi zmdi-delete f-18" title="{t}удалить{/t}"></i></a>
    </td>
</tr>
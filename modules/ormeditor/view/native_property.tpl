<tr>
    <td><input type="checkbox" name="field[{$uniq}][hide]" value="1" {if $item->custom_field->hide}checked{/if}>
        <input type="hidden" name="field[{$uniq}][field]" value="{$item->getName()}">
    </td>
    <td>{$item->getName()}</td>
    <td>{$item->getDescription()}</td>
    <td>{$item->getSQLNotation()}</td>
    <td>{$item->getDefault()}</td>
    <td>{if $item->isAllowEmpty()}{t}Да{/t}{else}{t}Нет{/t}{/if}</td>
    <td></td>
</tr>
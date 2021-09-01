{* Фильтры по характеристикам товаров *}

{addcss file="libs/nouislider.css"}
{addjs file="libs/nouislider.min.js"}
{addjs file="libs/wnumb.js"}
{addjs file="rs.filter.js"}
{$catalog_config=ConfigLoader::byModule('catalog')}

<div class="col s12 sidebar sec-filter rs-filter-section{if $smarty.cookies.filter} expand{/if}" data-query-value="{$url->get('query', $smarty.const.TYPE_STRING)}">
    <form method="GET" class="filters rs-filters" action="{urlmake filters=null pf=null bfilter=null p=null}" autocomplete="off">
        {if $param.show_cost_filter}
            <div class="filters-block minmax filter filter-interval rs-type-interval">
                <div class="current">
                    <div class="key">Цена</div>
                    <div class="value">
                        <i class="mdi mdi-information gold-text hidden"></i>
                    </div>
                    <div class="reset-wrapper">
                        <a class="reset-filter">
                            <i class="mdi mdi-close-circle"></i>
                        </a>
                    </div>
                </div>
                <div class="values detail">
                    <div class="minmax-block filter-fromto">
                        <label>Сумма в ₽</label>
                        <div class="min input-wrapper">
                            <input type="number" placeholder="мин." min="{$moneyArray.interval_from}" max="{$moneyArray.interval_to}" class="rs-filter-from" name="bfilter[cost][from]" value="{if !$catalog_config.price_like_slider}{$basefilters.cost.from}{else}{$basefilters.cost.from|default:$moneyArray.interval_from}{/if}" data-start-value="{if $catalog_config.price_like_slider}{$moneyArray.interval_from|floatval}{/if}">
                        </div>
                        <div class="max">
                            <input type="number" placeholder="макс." min="{$moneyArray.interval_from}" max="{$moneyArray.interval_to}" class="rs-filter-to" name="bfilter[cost][to]" value="{if !$catalog_config.price_like_slider}{$basefilters.cost.to}{else}{$basefilters.cost.to|default:$moneyArray.interval_to}{/if}" data-start-value="{if $catalog_config.price_like_slider}{$moneyArray.interval_to|floatval}{/if}">
                        </div>
                        <div class="accept">
                            <a class="accept">
                                <i class="mdi mdi-check"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        {/if}

        <div class="filters-block minmax filter filter-interval rs-type-interval">
            <div class="current">
                <div class="key">Размер</div>
                <div class="value"><i class="mdi mdi-information gold-text hidden"></i></div>
                <div class="reset-wrapper"><a class="reset-filter"><i class="mdi mdi-close-circle"></i></a></div>
            </div>
            <div class="values filter-fromto">
                {foreach $prop_list as $item}
                    {foreach $item.properties as $prop}
                        {if $prop['title'] == 'Ширина'}
                            <div class="minmax-block">
                                <label>Ширина (см)</label>
                                <div class="min">
                                    <input type="number" placeholder="мин." class="rs-filter-from" name="pf[{$prop.id}][from]" value="{$filters[$prop.id].from|default:$prop.interval_from}" data-start-value="{$prop.interval_from}">
                                </div>
                                <div class="max">
                                    <input type="number" placeholder="макс." class="rs-filter-to" name="pf[{$prop.id}][to]" value="{$filters[$prop.id].to|default:$prop.interval_to}" data-start-value="{$prop.interval_to}">
                                </div>
                                <div class="accept"><a class="accept"><i class="mdi mdi-check"></i></a></div>
                            </div>
                        {/if}
                        {if $prop['title'] == 'Высота'}
                            <div class="minmax-block">
                                <label>Высота (см)</label>
                                <div class="min"><input type="number" placeholder="мин."></div>
                                <div class="max"><input type="number" placeholder="макс."></div>
                                <div class="accept"><a class="accept"><i class="mdi mdi-check"></i></a></div>
                            </div>
                        {/if}
                    {/foreach}
                {/foreach}
            </div>
        </div>
        {foreach $prop_list as $item}
            {foreach $item.properties as $prop}
                {if $prop['title'] == 'В багете'}
                    <div class="filters-block check filter">
                        <div class="current">
                            <div class="key">
                                <input type="hidden" value="" name="pf[{$prop.id}]">
                                <input
                                    type="checkbox"
                                    id="baget"
                                    class="pseudo-checkbox yesno checkbox"
                                    data-select="select_baget"
                                    name="pf[{$prop.id}]"
                                    value="1"
                                    {if $filters[$prop.id] == '1'}checked{/if}
                                >
                                <label for="baget">Багет</label>
                            </div>
                        </div>
                    </div>
                {/if}
                {if $prop['title'] == 'В наличии'}
                    <div class="filters-block check filter">
                        <div class="current">
                            <div class="key">
                                <input type="hidden" value="" name="pf[{$prop.id}]">
                                <input
                                    type="checkbox"
                                    id="exists"
                                    class="pseudo-checkbox yesno checkbox"
                                    data-select="select_exist"
                                    name="pf[{$prop.id}]"
                                    value="1"
                                    {if $filters[$prop.id] == '1'}checked{/if}
                                >
                                <label for="exists">В наличии</label>
                            </div>
                        </div>
                    </div>
                {/if}
                {if $prop['title'] == 'Стиль'}
                    <div class="filters-block multiselect filter filter-checkbox rs-type-multiselect">
                        <div class="current">
                            <div class="key">Стиль</div>
                            <div class="value">0</div>
                            <div class="reset-wrapper"><a class="reset-filter"><i class="mdi mdi-close-circle"></i></a></div>
                        </div>
                        <ul class="values filter-checkbox_content rs-content">
                            {$i = 1}
                            {foreach $prop->getAllowedValues() as $key => $value}
                                <li style="order: {$i++};" class="input-field-check {if isset($filters_allowed_sorted[$prop.id][$key]) && ($filters_allowed_sorted[$prop.id][$key] == false)}disabled-property{/if}">
                                    <input type="checkbox" {if is_array($filters[$prop.id]) && in_array($key, $filters[$prop.id])}checked{/if} name="pf[{$prop.id}][]" value="{$key}" class="cb" id="cb_{$prop.id}_{$value@iteration}">
                                    <label for="cb_{$prop.id}_{$value@iteration}">{$value}</label>
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                {/if}
                {if $prop['title'] == 'Материал'}
                    <div class="filters-block multiselect filter filter-checkbox rs-type-multiselect">
                        <div class="current">
                            <div class="key">Материал</div>
                            <div class="value">0</div>
                            <div class="reset-wrapper"><a class="reset-filter"><i class="mdi mdi-close-circle"></i></a></div>
                        </div>
                        <ul class="values filter-checkbox_content rs-content">
                            {$i = 1}
                            {foreach $prop->getAllowedValues() as $key => $value}
                                <li style="order: {$i++};" class="input-field-check {if isset($filters_allowed_sorted[$prop.id][$key]) && ($filters_allowed_sorted[$prop.id][$key] == false)}disabled-property{/if}">
                                    <input type="checkbox" {if is_array($filters[$prop.id]) && in_array($key, $filters[$prop.id])}checked{/if} name="pf[{$prop.id}][]" value="{$key}" class="cb" id="cb_{$prop.id}_{$value@iteration}">
                                    <label for="cb_{$prop.id}_{$value@iteration}">{$value}</label>
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                {/if}
                {if $prop['title'] == 'Тема'}
                    <div class="filters-block multiselect filter filter-checkbox rs-type-multiselect">
                        <div class="current">
                            <div class="key">Тема</div>
                            <div class="value">0</div>
                            <div class="reset-wrapper"><a class="reset-filter"><i class="mdi mdi-close-circle"></i></a></div>
                        </div>
                        <ul class="values filter-checkbox_content rs-content">
                            {$i = 1}
                            {foreach $prop->getAllowedValues() as $key => $value}
                                <li style="order: {$i++};" class="input-field-check {if isset($filters_allowed_sorted[$prop.id][$key]) && ($filters_allowed_sorted[$prop.id][$key] == false)}disabled-property{/if}">
                                    <input type="checkbox" {if is_array($filters[$prop.id]) && in_array($key, $filters[$prop.id])}checked{/if} name="pf[{$prop.id}][]" value="{$key}" class="cb" id="cb_{$prop.id}_{$value@iteration}">
                                    <label for="cb_{$prop.id}_{$value@iteration}">{$value}</label>
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                {/if}
                {if $prop['title'] == 'Город'}
                    <div class="filters-block multiselect filter filter-checkbox rs-type-multiselect">
                        <div class="current">
                            <div class="key">Город</div>
                            <div class="value">0</div>
                            <div class="reset-wrapper"><a class="reset-filter"><i class="mdi mdi-close-circle"></i></a></div>
                        </div>
                        <ul class="values filter-checkbox_content rs-content">
                            {$i = 1}
                            {foreach $prop->getAllowedValues() as $key => $value}
                                <li style="order: {$i++};" class="input-field-check {if isset($filters_allowed_sorted[$prop.id][$key]) && ($filters_allowed_sorted[$prop.id][$key] == false)}disabled-property{/if}">
                                    <input type="checkbox" {if is_array($filters[$prop.id]) && in_array($key, $filters[$prop.id])}checked{/if} name="pf[{$prop.id}][]" value="{$key}" class="cb" id="cb_{$prop.id}_{$value@iteration}">
                                    <label for="cb_{$prop.id}_{$value@iteration}">{$value}</label>
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                {/if}
                {if $prop['title'] == 'Основание'}
                    <div class="filters-block multiselect filter filter-checkbox rs-type-multiselect">
                        <div class="current">
                            <div class="key">Основа</div>
                            <div class="value">0</div>
                            <div class="reset-wrapper"><a class="reset-filter"><i class="mdi mdi-close-circle"></i></a></div>
                        </div>
                        <ul class="values filter-checkbox_content rs-content">
                            {$i = 1}
                            {foreach $prop->getAllowedValues() as $key => $value}
                                <li style="order: {$i++};" class="input-field-check {if isset($filters_allowed_sorted[$prop.id][$key]) && ($filters_allowed_sorted[$prop.id][$key] == false)}disabled-property{/if}">
                                    <input type="checkbox" {if is_array($filters[$prop.id]) && in_array($key, $filters[$prop.id])}checked{/if} name="pf[{$prop.id}][]" value="{$key}" class="cb" id="cb_{$prop.id}_{$value@iteration}">
                                    <label for="cb_{$prop.id}_{$value@iteration}">{$value}</label>
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                {/if}
                {if $prop['title'] == 'Форма'}
                    <div class="filters-block multiselect filter filter-checkbox rs-type-multiselect">
                        <div class="current">
                            <div class="key">Форма</div>
                            <div class="value">0</div>
                            <div class="reset-wrapper"><a class="reset-filter"><i class="mdi mdi-close-circle"></i></a></div>
                        </div>
                        <ul class="values filter-checkbox_content rs-content">
                            {$i = 1}
                            {foreach $prop->getAllowedValues() as $key => $value}
                                <li style="order: {$i++};" class="input-field-check {if isset($filters_allowed_sorted[$prop.id][$key]) && ($filters_allowed_sorted[$prop.id][$key] == false)}disabled-property{/if}">
                                    <input type="checkbox" {if is_array($filters[$prop.id]) && in_array($key, $filters[$prop.id])}checked{/if} name="pf[{$prop.id}][]" value="{$key}" class="cb" id="cb_{$prop.id}_{$value@iteration}">
                                    <label for="cb_{$prop.id}_{$value@iteration}">{$value}</label>
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                {/if}
                {if $prop['title'] == 'Ориентация'}
                    <div class="filters-block multiselect filter filter-checkbox rs-type-multiselect">
                        <div class="current">
                            <div class="key">Ориентация</div>
                            <div class="value">0</div>
                            <div class="reset-wrapper"><a class="reset-filter"><i class="mdi mdi-close-circle"></i></a></div>
                        </div>
                        <ul class="values filter-checkbox_content rs-content">
                            {$i = 1}
                            {foreach $prop->getAllowedValues() as $key => $value}
                                <li style="order: {$i++};" class="input-field-check {if isset($filters_allowed_sorted[$prop.id][$key]) && ($filters_allowed_sorted[$prop.id][$key] == false)}disabled-property{/if}">
                                    <input type="checkbox" {if is_array($filters[$prop.id]) && in_array($key, $filters[$prop.id])}checked{/if} name="pf[{$prop.id}][]" value="{$key}" class="cb" id="cb_{$prop.id}_{$value@iteration}">
                                    <label for="cb_{$prop.id}_{$value@iteration}">{$value}</label>
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                {/if}
                {if $prop['title'] == 'Реплика'}
                    <div class="filters-block check filter">
                        <div class="current">
                            <div class="key">
                                <input type="hidden" value="" name="pf[{$prop.id}]">
                                <input
                                        type="checkbox"
                                        id="original"
                                        class="pseudo-checkbox yesno checkbox"
                                        data-select="select_original"
                                        name="pf[{$prop.id}]"
                                        value="1"
                                        {if $filters[$prop.id] == '1'}checked{/if}
                                >
                                <label for="original">Реплика</label>
                            </div>
                        </div>
                    </div>
                {/if}
            {/foreach}
        {/foreach}

        <div class="sidebar_menu">

{*            {if $param.show_cost_filter}*}
{*                <div class="filter filter-interval rs-type-interval {if $basefilters.cost || (is_array($param.expanded) && in_array('cost', $param.expanded))}open{/if}">*}
{*                    <a class="expand">*}
{*                        <span class="right-arrow"><i class="pe-2x pe-7s-angle-down-circle"></i></span>*}
{*                        <span>{t}Цена{/t}</span>*}
{*                    </a>*}
{*                    <div class="detail">*}
{*                        {if $catalog_config.price_like_slider && ($moneyArray.interval_to>$moneyArray.interval_from)}*}
{*                            <input type="hidden" data-slider='{ "from":{$moneyArray.interval_from}, "to":{$moneyArray.interval_to}, "step": "{$moneyArray.step}", "round": {$moneyArray.round}, "dimension": " {$moneyArray.unit}", "heterogeneity": [{$moneyArray.heterogeneity}]  }' value="{$basefilters.cost.from|default:$moneyArray.interval_from};{$basefilters.cost.to|default:$moneyArray.interval_to}" class="rs-plugin-input"/>*}
{*                        {/if}*}

{*                        <div class="filter-fromto">*}
{*                            <div class="input-wrapper">*}
{*                                <label>{t}от{/t}</label>*}
{*                                <input type="number" min="{$moneyArray.interval_from}" max="{$moneyArray.interval_to}" class="rs-filter-from" name="bfilter[cost][from]" value="{if !$catalog_config.price_like_slider}{$basefilters.cost.from}{else}{$basefilters.cost.from|default:$moneyArray.interval_from}{/if}" data-start-value="{if $catalog_config.price_like_slider}{$moneyArray.interval_from|floatval}{/if}">*}
{*                            </div>*}
{*                            <div class="input-wrapper">*}
{*                                <label>{t}до{/t}</label>*}
{*                                <input type="number" min="{$moneyArray.interval_from}" max="{$moneyArray.interval_to}" class="rs-filter-to" name="bfilter[cost][to]" value="{if !$catalog_config.price_like_slider}{$basefilters.cost.to}{else}{$basefilters.cost.to|default:$moneyArray.interval_to}{/if}" data-start-value="{if $catalog_config.price_like_slider}{$moneyArray.interval_to|floatval}{/if}">*}
{*                            </div>*}
{*                        </div>*}
{*                    </div>*}
{*                </div>*}
{*            {/if}*}

{*            {foreach $prop_list as $item}*}
{*                {foreach $item.properties as $prop}*}
{*                    {include file="%catalog%/blocks/sidefilters/type/{$prop.type}.tpl"}*}
{*                {/foreach}*}
{*            {/foreach}*}
        </div>

        <div class="sidebar_menu_buttons filters-block reset-wrapper">
            <button type="submit" class="theme-btn_search rs-apply-filter">{t}Применить{/t}</button>
            <a href="{urlmake pf=null p=null bfilter=null filters=null escape=true}" class="btn theme-btn_reset rs-clean-filter{if empty($filters) && empty($basefilters)} hidden{/if}">{t}Сбросить{/t}</a>
        </div>
    </form>
</div>

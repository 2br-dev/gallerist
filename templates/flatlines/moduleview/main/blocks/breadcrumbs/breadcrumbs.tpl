{* Хлебные крошки *}
{$bc = $app->breadcrumbs->getBreadCrumbs()}
{if !empty($bc)}
    <nav itemscope itemtype="http://schema.org/BreadcrumbList">
        <ol class="breadcrumb">
            {foreach $bc as $key => $item}
                <li itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem">
                    {if !$item.href}
                        <span itemprop="name">{$item.title}</span>
                    {else}
                        <a itemprop="item" href="{$item.href}">
                            <span itemprop="name">{$item.title}</span>
                        </a>
                    {/if}
                    <meta itemprop="position" content="{$key}">
                </li>
            {/foreach}
        </ol>
    </nav>
{/if}
{if $paginator->total_pages>1}
    {$pagestr = t('Страница %page', ['page' => $paginator->page])}
    {if $paginator->page > 1 && !substr_count($app->title->get(), $pagestr)}
        {$app->title->addSection($pagestr, 0, 'after')|devnull}
        {$caonical = implode('', ['<link rel="canonical" href="', $SITE->getRootUrl(true), substr($paginator->getPageHref(1),1), '"/>'])}
        {$app->setAnyHeadData($caonical)|devnull}
    {/if}
    <div class="paginator">
        <div class="top">
                {if $paginator->page>1}
                    <a href="{$paginator->getPageHref($paginator->page-1)}" class="prev" title="{t}предыдущая страница{/t}">&laquo;<span class="text"> {t}назад{/t}</span></a>
                {/if}
                {if $paginator->page < $paginator->total_pages}
                    <a href="{$paginator->getPageHref($paginator->page+1)}" class="next" title="{t}следующая страница{/t}"><span class="text">{t}вперед{/t}</span> &raquo;</a>
                {/if}
        </div>
        <div class="pages">
            {foreach $paginator->getPageList() as $page}
                <a href="{$page.href}" data-page="{$page.n}" {if $page.act}class="active"{/if}>{$page.n}</a>
            {/foreach}

            {if $paginator->page < $paginator->total_pages}
                <a href="{$paginator->getPageHref($paginator->page+1)}" data-page="{$paginator->page+1}" title="{t}следующая страница{/t}" class="next">
                    <i class="pe-7s-angle-right"></i>
                </a>
            {/if}
        </div>
    </div>
{/if}
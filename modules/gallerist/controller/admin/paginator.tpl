{addjs file="rs.ajaxpagination.js"}
{if $paginator->total_pages>1}
    {$pagestr = t('Страница %page', ['page' => $paginator->page])}
    {if $paginator->page > 1 && !substr_count($app->title->get(), $pagestr)}
        {$app->title->addSection($pagestr, 0, 'after')|devnull}
        {$caonical = implode('', ['<link rel="canonical" href="', $SITE->getRootUrl(true), substr($paginator->getPageHref(1),1), '"/>'])}
        {$app->setAnyHeadData($caonical)|devnull}
    {/if}

    {if !$paginator_len}
        {$paginator_len = 5}
    {/if}
    {$paginator->setPaginatorLen($paginator_len)|devnull}
    <div class="paginator" data-url="{$paginator->getPageHref($paginator->page+1)}">
        <a href="{$paginator->getPageHref($paginator->page-1)}" data-page="{$paginator->page-1}" title="{t}Предыдущая страница{/t}" class="prev {if $paginator->page == 1}invisible{/if}">
            <span class="icon icon-arrow-left"><!----></span>
            <span class="text">{t}Предыдущая{/t}</span>
        </a>

        <div>
            {if $paginator->showFirst()}
                <a href="{$paginator->getPageHref(1)}" data-page="1" title="{t}Первая страница{/t}" class="first">1</a>
            {/if}

            {foreach $paginator->getPageList() as $page}
                <a href="{$page.href}" data-page="{$page.n}" {if $page.act}class="active"{/if}>{$page.n}</a>
            {/foreach}

            {if $paginator->showLast()}
                <a href="{$paginator->getPageHref($paginator->total_pages)}" data-page="{$paginator->total_pages}"
                   title="{t}Последняя страница{/t}" class="last">{$paginator->total_pages}</a>
            {/if}
        </div>

        <a href="{$paginator->getPageHref($paginator->page+1)}" data-page="{$paginator->page+1}" title="{t}Следующая страница{/t}" class="next {if $paginator->page == $paginator->total_pages}invisible{/if}">
            <span class="text">{t}Следующая{/t}</span>
            <span class="icon icon-arrow-right"><!----></span>
        </a>

        {if $paginator->page < $paginator->total_pages}
            <div class="paginator_showMoreRow" data-url="{$paginator->getPageHref($paginator->page+1)}"><span class="btn-theme">{t}Показать ещё{/t}</span></div>
        {/if}

        {if $paginator->page < $paginator->total_pages}
            <script>
                $(document).ready(function () {
                    $('.paginator_showMoreRow').ajaxPagination({
                        appendElement: '.catalog-items-wrapper',
                        findElement: '.catalog-items-wrapper',
//                        clickOnScroll: true,
                        loaderElement: '.paginator_showMoreRow',
                        loaderBlock: '.paginator',
                        replaceBrowserUrl: true
                    });
                });
            </script>
        {/if}
    </div>
{/if}

{if $article.id}
<div class="deliveryBlock">
    <div class="image"></div>
    <div class="text">
        <p class="caption">{t}Доставка{/t}</p>
        <div class="descr">{$article.content}</div>
    </div>
</div>
{else}
    {include file="%THEME%/block_stub.tpl"  class="blockArticleDelivery" do=[
        [
            'title' => t("Добавьте статью о доставке"),
            'href' => {adminUrl do=false mod_controller="article-ctrl"}
        ],
        [
            'title' => t("Настройте блок"),
            'href' => {$this_controller->getSettingUrl()},
            'class' => 'crud-add'
        ]
    ]}
{/if}
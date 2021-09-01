{nocache}
{addjs file="{$mod_js}productasbanner.js" basepath="commmon"}
{/nocache}
{if $dirs}
    <div class="advBlock bannerProduct bmBig" data-block-url="{$router->getUrl('catalog-block-bannerview',['bndo' => 'getSlide', '_block_id' => $_block_id])}">
        <ul class="banners wrapperContainer">
            {$element_html}                
        </ul>
    </div>
    {nocache}
    <script type="text/javascript">
        $(function() {
            $('.advBlock').productsAsBanner({
                mainImage: '.imageBlock img'
            });
        });
    </script>
    {/nocache}
{else}
    {include file="%THEME%/block_stub.tpl"  class="blockBannerView" do=[
        [
            'title' => t("Добавьте спецкатегорию с товарами"),
            'href' => {adminUrl do=false mod_controller="catalog-ctrl"}
        ],
        [
            'title' => t("Настройте блок"),
            'href' => {$this_controller->getSettingUrl()},
            'class' => 'crud-add'
        ]
    ]}
{/if}
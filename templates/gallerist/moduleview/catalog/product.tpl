{* Шаблон карточки товара *}

{$shop_config = ConfigLoader::byModule('shop')}
{$check_quantity = $shop_config.check_quantity}
{$catalog_config = $this_controller->getModuleConfig()}

{addcss file="libs/owl.carousel.min.css"}
{addcss file="common/lightgallery/css/lightgallery.min.css" basepath="common"}

{addjs file="libs/owl.carousel.min.js"}
{addjs file="lightgallery/lightgallery-all.min.js" basepath="common"}
{addjs file="rs.product.js"}

{if $product->isVirtualMultiOffersUse()} {* Если используются виртуальные многомерные комплектации *}
    {addjs file="rs.virtualmultioffers.js"}
{/if}
{$product->fillOffersStockStars()} {* Загружаем сведения по остаткам на складах *}

<div id="updateProduct" itemscope itemtype="http://schema.org/Product" class="product row flex
                                                                              {if !$product->isAvailable()} rs-not-avaliable{/if}
                                                                              {if $product->canBeReserved()} rs-can-be-reserved{/if}
                                                                              {if $product.reservation == 'forced'} rs-forced-reserve{/if}" data-id="{$product.id}">
    <div class="col s12">
        <h1 class="page-header">{$product['title']}</h1>
    </div>
    <div class="col l5 m6 s12">
        <img class="lazy responsive-img" data-src="{$product->getMainImage()->getOriginalUrl()}" title="{$product['title']}"/>
    </div>
    <div class="col l7 m6 s12">
        <div class="data-wrapper">
            <div class="flex-separator"></div>
            {if !empty($product['description'])}
                <div class="product-description">
                    {$product['description']}
                </div>
            {/if}

{*            <div class="tags-wrapper">*}
{*                <span class="tag">графика</span>*}
{*                <span class="tag">живопись</span>*}
{*                <span class="tag">коллаж</span>*}
{*                <span class="tag">андерграунд</span>*}
{*                <span class="tag">импрессионизм</span>*}
{*            </div>*}
            <div class="flex-separator"></div>
            <div class="chars">
                {if $product->getSize()}
                    <div class="char">
                        <div class="key">
                            <i class="mdi mdi-image-size-select-large"></i>
                            <span>Размер</span>
                        </div>
                        <div class="value">{$product->getSize()}</div>
                    </div>
                {/if}
                {if $product->getPropValue('style')}
                    <div class="char">
                        <div class="key">
                            <i class="mdi mdi-palette"></i>
                            <span>Стиль</span>
                        </div>
                        <div class="value">{$product->getPropValue('style')}</div>
                    </div>
                {/if}
                {if $product->getPropValue('material')}
                    <div class="char">
                        <div class="key">
                            <i class="mdi mdi-wrench"></i>
                            <span>Материал</span>
                        </div>
                        <div class="value">{$product->getPropValue('material')}</div>
                    </div>
                {/if}
                {if $product->getPropValue('theme')}
                    <div class="char">
                        <div class="key">
                            <i class="mdi mdi-wrench"></i>
                            <span>Тема</span>
                        </div>
                        <div class="value">{$product->getPropValue('theme')}</div>
                    </div>
                {/if}
                <div class="char">
                    <div class="key">
                        <i class="mdi mdi-map-marker"></i>
                        <span>Территориально</span>
                    </div>
                    <div class="value">{$product->getRegion()}, {$product->getCity()}</div>
                </div>
            </div>
            {$author = $product->getAuthor()}
            <div class="author-data">
                <div class="author-avatar-wrapper">
                    <a href="/author.html">
                        <div class="avatar lazy" data-src="{$author['__photo']->getLink()}"></div>
                    </a>
                </div>
                <div class="author-data-wrapper">
                    <div class="data-block">
                        <div class="key">Автор</div>
                        <div class="value">{$product->getAuthorName()}</div>
                    </div>
                    <div class="data-block">
                        <div class="key">Количество работ</div>
                        <div class="value">{$author->getCountArt()}</div>
                    </div>
                </div>
            </div>
            <div class="flex-separator"></div>
            <div class="more-info">
                <div class="share-wrapper">
                    <a href=""><i class="mdi mdi-vk"></i></a>
                    <a href=""><i class="mdi mdi-facebook"></i></a>
                    <a href=""><i class="mdi mdi-whatsapp"></i></a>
                    <a href=""><i class="mdi mdi-telegram"></i></a>
                    <a href=""><i class="mdi mdi-odnoklassniki"></i></a>
                </div>
                <div class="price">
                    {if $product->getCost()}
                        {$product->getCost()} ₽
                    {else}
                        Цена не указана
                    {/if}
                </div>
                <div class="price-wrapper">
                    <a href="#request" class="btn btn-large modal-trigger">
                        <span class="white-color">Хочу</span>
                        <span class="gold-text"> купить</span>
                    </a>
                </div>
            </div>
            <div class="flex-separator"></div>
        </div>
    </div>
</div>


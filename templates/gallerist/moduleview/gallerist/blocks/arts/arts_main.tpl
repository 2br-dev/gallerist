<div class="masonry-grid">
    {foreach $arts as $product}
        <div class="gallery-entry @@colors">
            <div class="image lazy">
                <div class="info-trigger"><i class="mdi mdi-information-outline"></i></div>
                <div class="info">
                    {if $product->getSize()}
                        <div class="info-block">
                            <div class="mdi mdi-image-size-select-large"></div>
                            <span>{$product->getSize()}</span>
                        </div>
                    {/if}
                    {if $product->getPropValue('style')}
                        <div class="info-block">
                            <div class="mdi mdi-palette"></div>
                            <span>{$product->getPropValue('style')}</span>
                        </div>
                    {/if}
                    {*            <div class="info-block">*}
                    {*                <div class="mdi mdi-invert-colors"></div>*}
                    {*                <span>{$product->getTechnique()}</span>*}
                    {*            </div>*}
                    {if $product->getPropValue('material')}
                        <div class="info-block">
                            <div class="mdi mdi-wrench"></div>
                            <span>{$product->getPropValue('material')}</span>
                        </div>
                    {/if}
                    {if $product->getPropValue('orientation')}
                        <div class="info-block">
                            <div class="mdi mdi-crop-rotate"></div>
                            <span>{$product->getPropValue('orientation')}</span>
                        </div>
                    {/if}
                    {*            {if $product->getCity()}*}
                    <div class="info-block">
                        <div class="mdi mdi-map-marker"></div>
                        <span>{$product->getCity()}</span>
                    </div>
                    {*            {/if}*}
                    <div class="separator"></div>
                    <div class="info-actions">
                        <a href="{$product->getMainImage()->getOriginalUrl()}" target="_blank">
                            <i class="mdi mdi-monitor-screenshot"></i>
                        </a>
                        <a href="">
                            <i class="mdi mdi-share-variant"></i>
                        </a>
                        <a
                                class="ticket-favorite rs-favorite favorite-card {if $product->inFavorite()}rs-in-favorite{/if}"
                                data-title="В избранное" data-already-title="В избранном" title="В избранное"
                        >
                            <i class="mdi favorite-ico"></i>
                        </a>
                    </div>
                </div>
                <a href="{$product->getUrl()}">
                    <img class="lazy materialboxed" data-src="{$product->getMainImage()->getOriginalUrl()}"/>
                </a>
            </div>
            <div class="info-small">
                <div class="name">
                    <a href="{$product->getUrl()}">{$product['title']}</a>
                </div>
                <div class="author">
                    {*            <a href="/author.html">{$product->getAuthor()}</a>*}
                    {if $product->getCost()}
                        <a>{$product->getCost()} {$product->getCurrency()}</a>
                    {else}
                        <a>цена не указана</a>
                    {/if}
                </div>
            </div>
        </div>
    {/foreach}
</div>
<div class="center-align">
    <a href="/gallery.html" class="btn">
        <span class="white-text">Смотреть</span>
        <span class="gold-text"> все</span>
    </a>
</div>

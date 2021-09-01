<div class="container">
    <div class="row flex">
        <div class="col s12">
            <h1>{$author['name']} {if !empty($author['midname'])}{$author['midname']} {/if}{$author['surname']}</h1>
        </div>
        <div class="col m6 s12">
            <div class="author-data">
                <div class="avatar-wrapper">
                    {if $author['photo']}
                        <div class="avatar lazy" data-src="{$author['__photo']->getLink()}"></div>
                    {else}
                        <div class="avatar lazy" data-src="{$author['__photo']->getStub()->getUrl(150, 150, 'xy')}"></div>
                    {/if}
                </div>
                <div class="info-wrapper">
                    <div class="kv-pair">
                        <div class="key">
                            <i class="mdi mdi-map-marker"></i>
                            <span>Территориально</span>
                        </div>
                        <div class="value">{$author['region']}, {$author['city']}</div>
                    </div>
                    <div class="kv-pair">
                        <div class="key">
                            <i class="mdi mdi-image-multiple"></i>
                            <span>Количество работ</span>
                        </div>
                        <div class="value">
                            {if $author->getCountArt()}
                                {$author->getCountArt()}
                            {else}
                                нет работ
                            {/if}
                        </div>
                    </div>
                    {if $author->getMinCost()}
                        <div class="kv-pair">
                            <div class="key">
                                <i class="mdi mdi-cash-minus"></i>
                                <span>Минимальный ценник</span>
                            </div>
                            <div class="value">{$author->getMinCost()} ₽</div>
                        </div>
                    {/if}
                    <div class="kv-pair">
                        <div class="key">
                            <i class="mdi mdi-calendar-check"></i>
                            <span>Дата регистрации</span>
                        </div>
                        <div class="value">{$author.dateofreg|date_format:"d.m.Y"}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col m6 s12">
            <div class="text-wrapper">
                <p>{$author['about']}</p>
            </div>
        </div>
        <div class="col s12">
{*            {if $current_user['id'] != $author['id']}*}
                <a href="{$router->getUrl('gallerist-front-personalmessage', ['author_id' => {$author['id']}])}" class="btn btn-flat rs-in-dialog">Написать автору</a>
                <a href="" class="btn btn-flat">Добавить в избранное</a>
                <a href="{$router->getUrl('gallerist-front-complaint')}" class="btn btn-flat rs-in-dialog">Пожаловаться</a>
{*            {/if}*}
        </div>
        <div class="col s12">
            <h2>Галерея</h2>
        </div>
        {$arts = $author->getArts()}
        {foreach $arts['arts'] as $product}
            <div class="col l4 m6 s12 gallery-entry">
                <div class="image lazy">
                    <a href="{$product->getUrl()}">
                        <div class="lazy" data-src="{$product->getMainImage()->getOriginalUrl()}"></div>
                    </a>
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
    <div class="row">
        <div class="col s12">
            <div class="pagination-wrapper">
{*                <div class="pagination-container">*}
{*                    <ul class="pagination">*}
{*                        <li><a href="" class="btn btn-flat"><div class="gold-text">1</div></a></li>*}
{*                        <li><a class="btn btn-flat">…</a></li>*}
{*                        <li><a href="" class="btn btn-flat"><div class="gold-text">12</div></a></li>*}
{*                        <li><a href="" class="btn btn-flat"><div class="gold-text">13</div></a></li>*}
{*                        <li><a href="" class="btn"><div class="gold-text">14</div></a></li>*}
{*                        <li><a class="btn btn-flat">…</a></li>*}
{*                        <li><a href="" class="btn btn-flat"><div class="gold-text">134</div></a></li>*}
{*                    </ul>*}
{*                </div>*}
{*                <div class="action right-align">*}
{*                    <a href="/events.html" class="btn">Мероприятия <span class="gold-text">автора</span></a>*}
{*                </div>*}
            </div>
        </div>
    </div>
</div>

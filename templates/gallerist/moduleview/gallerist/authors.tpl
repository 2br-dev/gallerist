<div class="container">
    <div class="row">
        <div class="col s12">
            <h1>Авторы</h1>
            {if count($authors)}
                {foreach $authors as $author}
                    {if $author->getCountArt()}
                        <div class="author-entry">
                            <div class="avatar-wrapper">
                                <a href="/author/{$author['name_transliteration']}_{$author['surname_transliteration']}/">
                                    {if $author['photo']}
                                        <div class="avatar lazy" data-src="{$author['__photo']->getLink()}"></div>
                                    {else}
                                        <div class="avatar lazy" data-src="{$author['__photo']->getStub()->getUrl(150, 150, 'xy')}"></div>
                                    {/if}
                                </a>
                            </div>
                            <div class="info-wrapper">
                                <div class="name">
                                    <a href="/author/{$author['name_transliteration']}_{$author['surname_transliteration']}/">{$author['name']} {$author['surname']}</a>
                                </div>
                                <div class="kv-pair" title="Территориально">
                                    <div class="key">
                                        <i class="mdi mdi-map-marker"></i>
                                        <span>Территориально</span>
                                    </div>
                                    <div class="value">{$author['region']}, {$author['city']}</div>
                                </div>
                                <div class="kv-pair" title="Количество работ">
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
                                    <div class="kv-pair" title="Минимальный ценник">
                                        <div class="key">
                                            <i class="mdi mdi-cash-minus"></i>
                                            <span>Минимальный ценник</span>
                                        </div>
                                        <div class="value">{$author->getMinCost()} ₽</div>
                                    </div>
                                {/if}
                                <div class="kv-pair" title="Дата регистрации">
                                    <div class="key">
                                        <i class="mdi mdi-calendar-check"></i>
                                        <span>Дата регистрации</span>
                                    </div>
                                    <div class="value">{$author.dateofreg|date_format:"d.m.Y"}</div>
                                </div>
                            </div>
                            <div class="tags-wrapper">
                                {$tags = $author->getTags(10)}
                                {foreach $tags as $tag}
                                    <a href="/gallery.html" class="tag">{$tag}</a>
                                {/foreach}
                            </div>
                            <div class="gallery">
                                {$arts = $author->getArts(9)}
                                {if count($arts['arts'])}
                                    {foreach $arts['arts'] as $art}
                                        <a title="{$art['title']}" href="{$art->getUrl()}" class="author-gallery-image lazy" data-src="{$art->getMainImage()->getOriginalUrl()}"></a>
                                    {/foreach}
                                {/if}
                                {if $arts['lost'] > 0}
                                    <a class="author-gallery-image more-button" href="/author.html">
                                        <span class="count">{$arts['lost']}</span>
                                    </a>
                                {/if}
                            </div>
                        </div>
                    {/if}
                {/foreach}
            {/if}
        </div>
    </div>
</div>

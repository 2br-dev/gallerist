<div class="col s12">
    {foreach $authors as $author}
        <div class="col xl4 l6 m12 s12">
            <div class="author">
                <div class="avatar-wrapper">
                    <a href="/authors/{$author['id']}">
                        {if $author['photo']}
                            <div class="avatar lazy" data-src="{$author['__photo']->getLink()}"></div>
                        {else}
                            <div class="avatar lazy" data-src="{$author['__photo']->getStub()->getUrl(150, 150, 'xy')}"></div>
                        {/if}
                    </a>
                </div>
                <div class="info-wrapper">
                    <div class="name">{$author['name']} {$author['surname']}</div>
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
                        <div class="value">{if $author->getCountArt()}
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
                    <div class="kv-pair">
                        <div class="key">
                            <i class="mdi mdi-calendar-check"></i>
                            <span>Дата регистрации</span>
                        </div>
                        <div class="value">{$author.dateofreg|date_format:"d.m.Y"}</div>
                    </div>
                </div>
                <div class="actions-wrapper">
                    <a class="actions-trigger"><i class="mdi mdi-dots-vertical"></i></a>
                    <ul class="actions">
                        <li><a href="/author/{$author['name_transliteration']}_{$author['surname_transliteration']}">Профиль</a></li>
                        <li>
                            <hr>
                        </li>
{*                        <li><a href="">Связаться</a></li>*}
{*                        <li><a href="">Отслеживать</a></li>*}
                    </ul>
                </div>
            </div>
        </div>
    {/foreach}
</div>
<div class="col s12">
    <div class="center-align">
        <a href="/authors.html" class="btn">
            <span class="white-text">Смотреть</span>
            <span class="gold-text"> все</span>
        </a>
    </div>
</div>

{if $smarty.server.REQUEST_URI == '/register/'}
    <div id="city-selector" class="modal">
        <div class="modal-content">
            <div class="modal-header">Выбор города</div>
            <div class="input-field">
                <input type="text" id="regions" data-url="{$router->getUrl('gallerist-front-regions', ['Act' => 'getRegions'])}" placeholder="Например, Краснодарский край" class="autocomplete styled" autocomplete="ffdfd">
                <label for="">Укажите регион</label>
            </div>
            <div class="input-field">
                <input type="text" data-url="{$router->getUrl('gallerist-front-regions', ['Act' => 'getCities'])}" id="cities" placeholder="Например, Краснодар" class="autocomplete styled">
                <label for="">Укажите город</label>
            </div>
            <div class="modal-actions">
                <a class="btn btn-flat modal-close">Закрыть</a>
                <a href="" class="btn btn right" id="setCity">Принять</a>
            </div>
        </div>
    </div>
{/if}

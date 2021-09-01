{extends file="%THEME%/wrapper.tpl"}
{block name="content"}
    <div class="global-wrapper" id="product">
        <section id="main-data">
            <div class="container">
                {$app->blocks->getMainContent()}
            </div>
        </section>
    </div>
    {$user = \RS\Application\Auth::getCurrentUser()}
    <div class="modal" id="request">
        <form class="modal-content">
            <div class="row">
                <div class="col s12">
                    <div class="modal-header">Заявка на покупку картины</div>
                </div>
                <input type="hidden" name="is_auth" value="{$is_auth}">
                <input type="hidden" name="product" value="{$product['id']}">
                <input type="hidden" name="user_to" value="{$product['owner']}">
                {if $is_auth}
                    <input type="hidden" name="user_from" value="{$user['id']}">
                {else}
                    <div class="col s12">
                        <div class="input-field">
                            <input type="text" name="from_phone" class="styled">
                            <label>Телефон*</label>
                        </div>
                    </div>
                    <div class="col s12">
                        <div class="input-field">
                            <input type="text" name="from_email" class="styled">
                            <label>E-mail*</label>
                        </div>
                    </div>
                {/if}
                <div class="col s12">
                    <div class="input-field">
                        <textarea class="styled" rows="1" placeholder="Сообщение продавцу"></textarea>
                        <label>Сообщение для продавца</label>
                    </div>
                </div>
            </div>
            <div class="modal-actions">
                <a class="btn btn-flat modal-close">Закрыть</a>
                <a id="send-purchase-request" data-url="{$router->getUrl('gallerist-front-request', ['Act' => 'sendRequest'])}" class="btn right">Отправить</a>
            </div>
        </form>
    </div>
{/block}

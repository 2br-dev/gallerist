{if $is_auth}
    <div class="rs-modal modal open" id="personal-message">
        <form class="modal-content" method="POST" data-url="{$router->getUrl('gallerist-front-personalmessage', ['Act' => 'sendMessage'])}" id="personal-message-form">
            {$this_controller->myBlockIdInput()}
            <input type="hidden" name="from" value="{$user['id']}">
            <input type="hidden" name="to" value="{$author['id']}">
            <div class="modal-header">
                Отправить сообщение
            </div>
            <div class="input-field">
                <textarea class="styled" name="message" rows="3" placeholder="Сообщение автору"></textarea>
                <label>Сообщение автору</label>
            </div>
            <div class="modal-actions align-right">
                <a id="personal-message-button" class="btn">Отправить</a>
            </div>
        </form>
    </div>
{else}
    <div class="rs-modal modal open" id="personal-message">
        <div class="modal-content">
            <div class="modal-header">Внимание</div>
            <div class="">
                Чтоб оправить сообщение автору, необходимо авторизоваться
            </div>
        </div>
    </div>
{/if}

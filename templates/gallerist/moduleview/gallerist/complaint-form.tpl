<div class="rs-modal modal open" id="complaint">
    <form class="modal-content" method="POST" data-url="{$router->getUrl('gallerist-front-complaint', ['Act' => 'sendComplaint'])}" id="complaint-form">
        {$this_controller->myBlockIdInput()}
        <input type="hidden" name="from" value="{$user['id']}">
        <input type="hidden" name="to" value="{$author['id']}">
        <div class="modal-header">
            Отправить жалобу
        </div>
        <div class="input-field">
            <textarea class="styled" name="message" rows="3" placeholder="Содержание жалобы"></textarea>
            <label>Содержание жалобы</label>
        </div>
        <div class="modal-actions align-right">
            <a id="complaint-button" class="btn">Отправить</a>
        </div>
    </form>
</div>

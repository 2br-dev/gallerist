{extends file="%gallerist%/notice_template.tpl"}
{block name="content"}
    {$user_from=$data->user_from}
    {$message = $data->message}
    <p style="margin-bottom: 20px;">Пользователь {$user_from['name']} {$user_from['surname']} отправил вам личное сообщение</p>
    <div>
        {$message}
    </div>
{/block}

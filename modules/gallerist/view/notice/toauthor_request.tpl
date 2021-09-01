{extends file="%gallerist%/notice_template.tpl"}
{block name="content"}
    {$user_from=$data->user_from}
    {$picture=$data->picture}
    {$email=$data->email}
    {$phone=$data->phone}
    <p>Заявка на покупку картины: {$picture['title']}</p>
    {if $user_from == -100}
        <p>Не авторизованный на сайте пользователь интересовался вашей картиной</p>
    {else}
        <p>Пользователь: {$user_from['name']} {$user_from['midname']} {$user_from['surname']} - инересовался вашей картиной</p>
    {/if}
    {if $email != ''}
        <p>E-mail: {$email}</p>
    {/if}
    {if $phone != ''}
        <p>Телефон: {$phone}</p>
    {/if}
{/block}

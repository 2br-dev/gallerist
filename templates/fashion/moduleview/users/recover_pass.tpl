<form method="POST" action="{$router->getUrl('users-front-auth', ["Act" => "recover"])}" class="authorization recoverPassword">
    {$this_controller->myBlockIdInput()}
    <h1 data-dialog-options='{ "width": "450" }'>{t}Восстановление пароля{/t}</h1>
    <div class="forms formStyle">
        <div class="center">
            {if !empty($error)}<div class="error">{$error}</div>{/if}
            <div class="formLine">
                <label class="fieldName">{$login_placeholder}</label>
                <input type="text" name="login" value="{$data.login}" class="inp" value="{$data.login}" {if $send_success}readonly{/if}>
            </div>

            {if $send_success}
                <div class="recoverText success">
                    <i></i>
                    {t}Письмо успешно отправлено. Следуйте инструкциям в письме{/t}
                </div>
            {else}
                <div class="recoverText">
                    <i></i>
                    {t}На указанный контакт будет отправлено письмо с дальнейшими инструкциями по восстановлению пароля{/t}
                </div>
                <div class="floatWrap oh">
                    <input type="submit" value="Отправить">
                </div>
            {/if}
        </div>
        <div class="underLine links">
            <a href="{$router->getUrl('users-front-register')}" class="linkreg inDialog">{t}Зарегистрируйтесь{/t}</a>
            <a href="{$router->getUrl('users-front-auth')}" class="linkauth inDialog">{t}Авторизуйтесь{/t}</a>
        </div>
    </div>
</form>
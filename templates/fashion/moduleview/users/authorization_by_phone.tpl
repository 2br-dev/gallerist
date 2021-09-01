{* Диалог авторизации пользователя *}
<form method="POST" action="{$router->getUrl('users-front-auth', ['Act' => 'byphone'])}" class="authorization formStyle">
    <h1 data-dialog-options='{ "width": "460" }'>{t}Авторизация{/t}</h1>
    {$this_controller->myBlockIdInput()}

    {hook name="users-authorization-by-phone:form" title="{t}Авторизация по телефону:форма{/t}"}
        <div class="forms">
            <input type="hidden" name="referer" value="{$data.referer}">
            {if !empty($status_message)}<div class="pageError">{$status_message}</div>{/if}
            {if !empty($error)}<div class="error">{$error}</div>{/if}
            <div class="center">
                <div class="formLine">
                    <input type="text" placeholder="{t}Номер телефона{/t}" name="phone" value="{$data.phone}" class="login {if !empty($error)}has-error{/if}" autocomplete="off">
                </div>
                <div class="formLine rem">
                    <input type="checkbox" id="rememberMe" name="remember" value="1" {if $data.remember}checked{/if}> <label for="rememberMe">{t}Запомнить меня{/t}</label>
                </div>
                <div class="oh">
                    <div class="fleft">
                        <input type="submit" value="{t}Войти{/t}">
                    </div>
                    <div class="fright line25">
                        <a href="{$router->getUrl('users-front-auth', ["Act" => "recover"])}" class="recover inDialog">{t}Забыли пароль?{/t}</a><br>
                        <a href="{$router->getUrl('users-front-auth')}" class="standard inDialog">{t}Войти с помощью пароля{/t}</a>
                    </div>
                </div>
            </div>
            <div class="underLine">
                <p>{t alias="Преимущества регистрации"}Зарегистрировавшись у нас, Вы сможете хранить всю информацию о Ваших покупках, адресах доставок на нашем сайте,
                        а также видеть ход исполнения заказов. Регистрация займет не более 2-х минут.{/t}</p>
                <a href="{$router->getUrl('users-front-register')}" class="button color reg inDialog">{t}Зарегистрироваться{/t}</a>
            </div>
        </div>
    {/hook}
</form>
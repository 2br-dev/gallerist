{* Диалог авторизации пользователя *}
<form method="POST" class="authorization formStyle" action="{$router->getUrl('users-front-auth', ['Act' => 'byphone'])}">
    <h2 data-dialog-options='{ "width": "450" }'>{t}Войти{/t}</h2>
    {$this_controller->myBlockIdInput()}
    {hook name="users-authorization-by-phone:form" title="{t}Авторизация по телефону:форма{/t}"}
        <div class="forms">
            <input type="hidden" name="referer" value="{$data.referer}">
            {if !empty($status_message)}<div class="pageError pbottom">{$status_message}</div>{/if}
            {if !empty($error)}<div class="error">{$error}</div>{/if}
            <div class="center">
                <div class="formLine">
                    <label class="fielName">{t}Номер телефона{/t}</label><br>
                    <input type="text" size="30" name="phone" value="{$data.phone}" class="inp">
                </div>
                <div class="oh">
                    <div class="fleft rem">
                        <input type="checkbox" id="rememberMe" name="remember" value="1" {if $data.remember}checked{/if}> <label for="rememberMe">{t}Запомнить меня{/t}</label>
                    </div>
                    <div class="fright">
                        <input type="submit" value="{t}Войти{/t}">
                    </div>
                </div>
            </div>
            <div class="underLine">
                <a href="{$router->getUrl('users-front-auth', ["Act" => "recover"])}" class="recover inDialog">{t}Забыли пароль?{/t}</a>
                <div>
                    <a href="{$router->getUrl('users-front-register')}" class="reg inDialog">{t}Зарегистрироваться{/t}</a><br>
                    <a href="{$router->getUrl('users-front-auth')}" class="standard inDialog">{t}Войти с помощью пароля{/t}</a>
                </div>
            </div>
        </div>
    {/hook}
</form>

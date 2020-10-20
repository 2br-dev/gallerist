{* Диалог авторизации пользователя *}
<form method="POST" action="{$router->getUrl('users-front-auth',
['Act' => 'verify',
'token' => $token])}" class="authorization formStyle">
    <h2 data-dialog-options='{ "width": "450" }'>{t}Подтверждение{/t}</h2>
    {$this_controller->myBlockIdInput()}
    {hook name="users-authorization-two-step:form" title="{t}Авторизация-подтверждение:форма{/t}"}
        <div class="forms">
            <div class="center">

                {$verification_engine->getVerificationFormView()}

                <div class="buttonLine">
                    <input type="submit" value="Войти">
                </div>
            </div>
        </div>
    {/hook}
</form>

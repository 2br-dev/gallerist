{* Диалог авторизации пользователя *}

<form method="POST" action="{$router->getUrl('users-front-auth',
['Act' => 'verify',
'token' => $token])}" class="authorization formStyle">
    <h1 data-dialog-options='{ "width": "460" }'>{t}Подтверждение{/t}</h1>
    {$this_controller->myBlockIdInput()}
    {hook name="users-authorization-two-step:form" title="{t}Авторизация-подтверждение:форма{/t}"}
        <div class="forms">
            <div class="center">

                {$verification_engine->getVerificationFormView()}

                <div class="oh">
                    <div class="fleft">
                        <input type="submit" value="{t}Войти{/t}">
                    </div>
                </div>
            </div>
        </div>
    {/hook}
</form>
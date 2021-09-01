{* Диалог авторизации пользователя *}
{$is_dialog_wrap=$url->request('dialogWrap', $smarty.const.TYPE_INTEGER)}
<div class="rs-modal modal open" id="login">
    <form method="POST" action="{$router->getUrl('users-front-auth')}" class="modal-content">
        {$this_controller->myBlockIdInput()}
        <input type="hidden" name="referer" value="{$data.referer}">
        <input type="hidden" name="remember" value="1" checked>
        <div class="row">
            <div class="col s12">
                <div class="modal-header">Авторизация</div>
            </div>
            {if !empty($status_message)}<div class="page-error col s12">{$status_message}</div>{/if}
            <div class="col s12">
                <div class="input-field">
                    <input type="text" placeholder="Имя пользователя" name="login" value="{$data.login|default:$Setup.DEFAULT_DEMO_LOGIN}" class="styled {if !empty($error)}has-error{/if}"/>
                    <label for="">Логин</label>
                    {if $error}<span class="formFieldError error">{$error}</span>{/if}
                </div>
            </div>
            <div class="col s12">
                <div class="input-field">
                    <input type="password" placeholder="Пароль, указанный при регистрации" name="pass" value="{$Setup.DEFAULT_DEMO_PASS}" class="styled {if !empty($error)}has-error{/if}" autocomplete="off">
                    <label for="Пароль">Пароль</label>
                </div>
            </div>
            <div class="col s12">
                <ul>
{*                    <li>*}
{*                        <a href=""><span class="gold-text">Уже есть аккаунт</span></a>*}
{*                    </li>*}
                    <li>
                        <a href=""><span class="gold-text">Забыли пароль?</span></a>
                    </li>
                </ul>
            </div>
            <div class="col s12">
                <div class="input-field-check">
                    <input type="checkbox" id="remember" class="styled">
                    <label for="remember">Запомнить меня</label>
                </div>
            </div>
        </div>
        <div class="modal-actions">
            <a href="{$router->getUrl('users-front-register')}" class="btn btn-flat">Регистрация</a>
            <button type="submit" class="btn right">Войти</button>
        </div>
    </form>
</div>



{*<div class="form-style modal-body mobile-width-small">*}
{*    {if $is_dialog_wrap}*}
{*        <h2 class="h2">{t}Авторизация{/t}</h2>*}
{*    {/if}*}

{*    {if !empty($status_message)}<div class="page-error">{$status_message}</div>{/if}*}

{*    <form method="POST" action="{$router->getUrl('users-front-auth')}">*}
{*        {hook name="users-authorization:form" title="{t}Авторизация:форма{/t}"}*}
{*        {$this_controller->myBlockIdInput()}*}
{*        <input type="hidden" name="referer" value="{$data.referer}">*}
{*        <input type="hidden" name="remember" value="1" checked>*}

{*        <input type="text" placeholder="{$login_placeholder}" name="login" value="{$data.login|default:$Setup.DEFAULT_DEMO_LOGIN}" {if !empty($error)}class="has-error"{/if} autocomplete="off">*}
{*        {if $error}<span class="formFieldError">{$error}</span>{/if}*}

{*        <input type="password" placeholder="{t}Введите пароль{/t}" name="pass" value="{$Setup.DEFAULT_DEMO_PASS}" {if !empty($error)}class="has-error"{/if} autocomplete="off">*}

{*        <div class="form__menu_buttons mobile-flex">*}
{*            <button type="submit" class="link link-more">{t}Войти{/t}</button>*}

{*            <div class="other-buttons">*}
{*                {if $is_dialog_wrap}*}
{*                    <a href="{$router->getUrl('users-front-register')}" class="rs-in-dialog">{t}Зарегистрироваться{/t}</a><br>*}
{*                {/if}*}

{*                <a href="{$router->getUrl('users-front-auth', ["Act" => "recover"])}" {if $is_dialog_wrap}class="rs-in-dialog"{/if}>{t}Забыли пароль?{/t}</a>*}
{*            </div>*}
{*        </div>*}
{*        {/hook}*}
{*    </form>*}
{*</div>*}

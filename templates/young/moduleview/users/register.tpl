{$user_config=$this_controller->getModuleConfig()}
<form method="POST" action="{$router->getUrl('users-front-register')}" class="authorization register formStyle">
    <input type="hidden" name="referer" value="{$referer}">
    {$this_controller->myBlockIdInput()}
    <h2 data-dialog-options='{ "width": "755" }'>{t}Регистрация пользователя{/t}</h2>
        {if count($user->getNonFormErrors())>0}
            <div class="pageError">
                {foreach $user->getNonFormErrors() as $item}
                <p>{$item}</p>
                {/foreach}
            </div>
        {/if}
    
    {hook name="users-registers:form" title="{t}Регистрация:форма{/t}"}    
        <div class="userType">
            <input type="radio" id="ut_user" name="is_company" value="0" {if !$user.is_company}checked{/if}><label for="ut_user">{t}Частное лицо{/t}</label>
            <input type="radio" id="ut_company" name="is_company" value="1" {if $user.is_company}checked{/if}><label for="ut_company">{t}Компания{/t}</label>
        </div>
        <div class="forms">        
            <div class="oh {if $user.is_company} thiscompany{/if}" id="fieldsBlock">
                {hook name="users-registers:form-fields" title="{t}Регистрация:поля формы{/t}"}

                <div class="columns2">
                        <div class="companyFields">
                            <div class="formLine">
                                <label class="fielName">{t}Название организации{/t}</label>
                                {$user->getPropertyView('company')}
                            </div>
                            <div class="formLine">
                                <label class="fielName">{t}ИНН{/t}</label>
                                {$user->getPropertyView('company_inn')}
                            </div>
                        </div>
                        {if $user_config.user_one_fio_field}
                            <div class="formLine">
                                <label class="fielName">{t}Ф.И.О.{/t}</label>
                                {$user->getPropertyView('fio')}
                            </div>
                        {else}
                            {if $user_config->canShowField('name')}
                                <div class="formLine">
                                    <label class="fielName">{t}Имя{/t}</label>
                                    {$user->getPropertyView('name')}
                                </div>
                            {/if}
                            {if $user_config->canShowField('surname')}
                                <div class="formLine">
                                    <label class="fielName">{t}Фамилия{/t}</label>
                                    {$user->getPropertyView('surname')}
                                </div>
                            {/if}
                            {if $user_config->canShowField('midname')}
                                <div class="formLine">
                                    <label class="fielName">{t}Отчество{/t}</label>
                                    {$user->getPropertyView('midname')}
                                </div>
                            {/if}
                        {/if}
                        {if $user_config->canShowField('phone')}
                            <div class="formLine">
                                <label class="fielName">{t}Телефон{/t}</label>
                                {$user->getPropertyView('phone')}
                            </div>
                        {/if}
                        {if $user->__captcha->isEnabled()}
                            <div class="formLine captcha">
                                <label class="fielName">&nbsp;</label>
                                <div class="alignLeft">
                                    {$user->getPropertyView('captcha')}
                                    <br><span class="fielName">{$user->__captcha->getTypeObject()->getFieldTitle()}</span>
                                </div>
                            </div>
                        {/if}
                        {if $user_config->canShowField('login')}
                            <div class="formLine">
                                <label class="fielName">{t}Логин{/t}</label>
                                {$user->getPropertyView('login')}
                            </div>
                        {/if}
                        {if $user_config->canShowField('e_mail')}
                            <div class="formLine">
                                <label class="fielName">E-mail</label>
                                {$user->getPropertyView('e_mail')}
                            </div>
                        {/if}
                        <div class="formLine">
                            <label class="fielName">{t}Пароль{/t}</label>
                            <input type="password" name="openpass" {if count($user->getErrorsByForm('openpass'))}class="has-error"{/if}>
                            <div class="formFieldError">{$user->getErrorsByForm('openpass', ',')}</div>
                        </div>
                        <div class="formLine">
                            <label class="fielName">{t}Повтор пароля{/t}</label>
                            <input type="password" name="openpass_confirm">
                        </div>
                        {if $conf_userfields->notEmpty()}
                            {foreach $conf_userfields->getStructure() as $fld}
                                <div class="formLine">
                                    <label class="fielName">{$fld.title}</label>
                                    {$conf_userfields->getForm($fld.alias)}
                                    {$errname=$conf_userfields->getErrorForm($fld.alias)}
                                    {$error=$user->getErrorsByForm($errname, ', ')}
                                    {if !empty($error)}
                                        <span class="formFieldError">{$error}</span>
                                    {/if}
                                </div>
                            {/foreach}
                        {/if}
                </div>
                {/hook}
            </div>
            <div class="buttons cboth">
                {if $CONFIG.enable_agreement_personal_data}
                    {include file="%site%/policy/agreement_phrase.tpl" button_title="{t}Зарегистрироваться{/t}"}
                {/if}

                <input type="submit" value="Зарегистрироваться">
                <br><br>
            </div> 
        </div>   
    {/hook}
    
    <script type="text/javascript">
        $(function() {
            $('.userType input').click(function() {
                $('#fieldsBlock').toggleClass('thiscompany', $(this).val() == 1);
                if ($(this).closest('#colorbox')) $.colorbox.resize();
            });
        });        
    </script>    
</form>

<form method="POST" class="formStyle profile">
    {csrf}
    {$this_controller->myBlockIdInput()}
    <div class="userType">
        <input type="radio" id="ut_user" name="is_company" value="0" {if !$user.is_company}checked{/if}><label for="ut_user" class="userLabel f14">{t}Частное лицо{/t}</label>
        <input type="radio" id="ut_company" name="is_company" value="1" {if $user.is_company}checked{/if}><label for="ut_company" class="f14">{t}Компания{/t}</label>
    </div>
    
    <div class="tabs gray topMarg"> 
        <ul class="tabList">
            <li class="act"><a href="#">{t}Персональные данные{/t}</a></li>
        </ul>
        
        <div class="tab act">
            {if count($user->getNonFormErrors())>0}
                <div class="pageError">
                    {foreach $user->getNonFormErrors() as $item}
                    <p>{$item}</p>
                    {/foreach}
                </div>
            {/if}

            <a href="{$router->getAdminUrl('add', ['dir' => 1, 'referer' => $router->getUrl('users-front-profile')], 'gallerist-ctrl')}"
               class="crud-add">Добавить картину</a>

            {if $result}
                <div class="formResult success">{$result}</div>
            {/if}           
            <div class="oh">
                <div class="half fleft{if $user.is_company} thiscompany{/if}" id="fieldsBlock">
                   <div class="companyFields">
                        <div class="formLine">
                            <label class="fieldName">{t}Название организации{/t}</label>
                            {$user->getPropertyView('company')}
                        </div>                            
                        <div class="formLine">
                            <label class="fieldName">{t}ИНН{/t}</label>
                            {$user->getPropertyView('company_inn')}
                        </div>                                
                    </div>
                    <div class="formLine">
                        <label class="fieldName">{t}Фамилия{/t}</label>
                        {$user->getPropertyView('surname')}
                    </div>                    
                    <div class="formLine">
                        <label class="fieldName">{t}Имя{/t}</label>
                        {$user->getPropertyView('name')}
                    </div>
                    <div class="formLine">
                        <label class="fieldName">{t}Отчество{/t}</label>
                        {$user->getPropertyView('midname')}
                    </div>
                    <div class="formLine">
                        <label class="fieldName">{t}Телефон{/t}</label>
                        {$user->getPropertyView('phone')}
                    </div>
                    <div class="formLine">
                        <label class="fieldName">E-mail</label>
                        {$user->getPropertyView('e_mail')}
                    </div>
                    {if $conf_userfields->notEmpty()}
                        {foreach $conf_userfields->getStructure() as $fld}
                        <div class="formLine">
                        <label class="fieldName">{$fld.title}</label>
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
                <div class="half fright">
                    <div class="formLine mt30">
                        <div class="alignRight mb20">
                            <input type="checkbox" id="changePass" name="changepass" value="1" {if $user.changepass}checked{/if}><label for="changePass" class="ft14">{t}Сменить пароль{/t}</label>
                        </div>
                        <div class="changePass {if !$user.changepass}hidden{/if}">
                            <div class="formLine">
                                <label class="fieldName">{t}Текущий пароль{/t}</label>
                                <input type="password" name="current_pass" {if count($user->getErrorsByForm('current_pass'))}class="has-error"{/if}>
                                <span class="formFieldError">{$user->getErrorsByForm('current_pass', ',')}</span>
                            </div>
                            <div class="formLine">
                                <label class="fieldName">{t}Новый пароль{/t}</label>
                                <input type="password" name="openpass" {if count($user->getErrorsByForm('openpass'))}class="has-error"{/if}>
                                <span class="formFieldError">{$user->getErrorsByForm('openpass', ',')}</span>
                            </div>                        
                            <div class="formLine">
                                <label class="fieldName">{t}Повторить пароль{/t}</label>
                                <input type="password" name="openpass_confirm" {if count($user->getErrorsByForm('openpass'))}class="has-error"{/if}>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="buttons cboth">
                <input type="submit" value="{t}Сохранить{/t}">
            </div>
        </div>            
    </div>    
</form>    
<script type="text/javascript">
    $(function() {
        $('#changePass').change(function() {
            $('.changePass').toggleClass('hidden', !this.checked);
        });            
        
        $('.profile .userType input').click(function() {
            $('#fieldsBlock').toggleClass('thiscompany', $(this).val() == 1);
        });
    });        
</script>    

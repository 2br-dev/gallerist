{* Регистрация пользователя *}
{$user_config=$this_controller->getModuleConfig()}
{$is_dialog_wrap=$url->request('dialogWrap', $smarty.const.TYPE_INTEGER)}
<div class="global-wrapper" id="register">
    <section id="page-header">
        <div class="container">
            <div class="row">
                <div class="col s12">
                    <h1>Регистрация пользователя</h1>
                </div>
            </div>
        </div>
    </section>
    <section id="form-data">
        <div class="container">
            <div class="row">
                <div class="col l4 m6 s12">
                    <form method="POST" action="{$router->getUrl('users-front-register')}" enctype="multipart/form-data">
                        <input type="hidden" name="is_company" value="0"/>
                        {csrf}
                        {$this_controller->myBlockIdInput()}
                        <input type="hidden" name="referer" value="{$referer}">
                        <div class="avatar-holder">
                            <input type="file" name="photo" id="avatar-file-selector"/>
                            <label for="avatar-file-selector" id="avatar-img" class="avatar lazy" data-src="{$THEME_IMG}/no-photo.png">
                                <div class="overlay">
                                    <i class="mdi mdi-camera"></i>
                                </div>
                            </label>
                            <label class="filename-wrapper">
                                <span id="filename"></span>
                            </label>
                        </div>
                        <div class="input-field-check">
                            <input class="styled" checked type="radio" name="is_author" value="1" id="artist">
                            <label for="artist">Художник</label>
                        </div>
                        <div class="input-field-check">
                            <input class="styled" type="radio" name="is_author" value="0" id="customer">
                            <label for="customer">Покупатель</label>
                        </div>
                        <div class="select-city-block">
                            <input type="hidden" name="city" value="" id="selected-city-input"/>
                            <input type="hidden" name="region" value="" id="selected-region-input"/>
                            <a href="#city-selector" class="btn btn-flat modal-trigger" id="city-selector-trigger">
                                <span id="prompt">Выбрать город</span>
                                <span id="selected-city" class="hidden">
                                    <i id="region">Краснодарский край</i>,
                                    <i id="city">Краснодар</i>
                                </span>
                            </a>
                            {if count($user->getErrorsByForm('city'))}
                                <div class="formFieldError">{$user->getErrorsByForm('city', ',')}</div>
                            {/if}
                        </div>
                        <div class="input-field">
                            {$user->getPropertyView('surname', ['class' => 'styled', 'placeholder' => 'Фамилия'], [form => true, errors => false])}
                            <label for="" class="active">Фамилия</label>
                            {if count($user->getErrorsByForm('surname'))}
                                <div class="formFieldError">{$user->getErrorsByForm('surname', ',')}</div>
                            {/if}
                        </div>
                        <div class="input-field">
                            {$user->getPropertyView('name', ['class' => 'styled', 'placeholder' => 'Имя'], [form => true, errors => false])}
                            <label for="">Имя</label>
                            {if count($user->getErrorsByForm('name'))}
                                <div class="formFieldError">{$user->getErrorsByForm('name', ',')}</div>
                            {/if}
                        </div>
                        <div class="input-field">
                            {$user->getPropertyView('midname', ['class' => 'styled', 'placeholder' => 'Отчество'], [form => true, errors => false])}
                            <label for="">Отчество</label>
                            {if count($user->getErrorsByForm('midname'))}
                                <div class="formFieldError">{$user->getErrorsByForm('midname', ',')}</div>
                            {/if}
                        </div>
                        <div class="input-field">
                            {$user->getPropertyView('phone', ['class' => 'styled phone-mask', 'placeholder' => 'Телефон'], [form => true, errors => false])}
                            <label for="">Телефон</label>
                            {if count($user->getErrorsByForm('phone'))}
                                <div class="formFieldError">{$user->getErrorsByForm('phone', ',')}</div>
                            {/if}
                        </div>
                        <div class="input-field">
                            {$user->getPropertyView('e_mail', ['class' => 'styled email-mask', 'placeholder' => 'E-mail'], [form => true, errors => false])}
                            <label for="">E-mail</label>
                            {if count($user->getErrorsByForm('e_mail'))}
                                <div class="formFieldError">{$user->getErrorsByForm('e_mail', ',')}</div>
                            {/if}
                        </div>
                        <div class="input-field">
                            {$user->getPropertyView('openpass', ['class' => 'styled', 'placeholder' => 'Пароль'], [form => true, errors => false])}
                            <label class="label-sup">{t}Пароль{/t}</label>
                            {if count($user->getErrorsByForm('openpass'))}
                                <div class="formFieldError">{$user->getErrorsByForm('openpass', ',')}</div>
                            {/if}
                        </div>
                        <div class="input-field">
                            {$user->getPropertyView('openpass_confirm', ['class' => 'styled', 'placeholder' => 'Повтор пароль'], [form => true, errors => false])}
                            <label class="label-sup">{t}Повтор пароля{/t}</label>
                            {if count($user->getErrorsByForm('openpass_confirm'))}
                                <div class="formFieldError">{$user->getErrorsByForm('openpass_confirm', ',')}</div>
                            {/if}
                        </div>
                        <div class="register-action">
                            <input type="reset" class="btn btn-flat" value="Сброс" />
                            <button type="submit" class="btn right">Зарегистрироваться</button>
                        </div>
                    </form>
                </div>
                <div class="col l6 offset-l2 m6 s12">
                    <h3>Для чего нужна регистрация?</h3>
                    <p>
                        Регистрируясь на сайте, пользователь получает уникальную возможность как общаться напрямую с авторами картин, представленных
                        на сайте, так и самому зарегистрировавшись в качестве автора, выкладывать свои работы, общаться с авторами других картин,
                        отслеживать их процесс, появление новых работ и многое другое.
                    </p>
                    <p>
                        Зарегистрировавшись в качестве покупателя, пользователь имеет возможность связаться с автором по вопросу приобретения
                        понравившейся картины, либо попросить автора нарисовать картину на заказ, получив таким образом абсолютный эксклюзив,
                        как для себя, так и в качестве подарка своим близким и родным людям.
                    </p>
                    <p>
                        Человек, зарегистрировавшийся на сайте получает множество прав, но вместе с ними и множество обязанностей, в частности,
                        он должен принять <a href="">Политику обработки персональных данных</a>, <a href="">Пользовательское соглашение</a>,
                        и <a href="">Правила пользования сайтом</a>, соблюдать нормы приличия, не оскорблять других пользователей сайта,
                        не заниматься рассылкой СПАМ'а и не флудить.
                    </p>
                    <p>
                        Замеченные в подобного рода деятельности будут лишены доступа к сайту, и заблокированы после несоблюдения первого предупреждения со стороны Администрации
                        сайта, и потеряют доступ к личному кабинету, а как следствие ко всей истории переписок, своим работам, и прочими удобствами,
                        предоставляемыми личным кабинетом в срок, определяемой Администрацией.
                    </p>
                    <p>
                        Для восстановления доступа к сайту, пользователю будет необходимо связаться с Администрацией сайта, и восстановить доступ
                        после того, как будут устранены как сами неприемлимые действия, так и их последствия. В дальнейшем Администрация оставляет за собой
                        право перманентного удаления личных данных пользователей, злостно нарушающих правила пользования сайтом.
                    </p>
                </div>
            </div>
        </div>
    </section>
</div>
{include file="%gallerist%/modals.tpl"}

{*<a data-url="{$router->getUrl('gallerist-front-regions')}" class="rs-in-dialog">Город</a>*}





{*<div class="form-style modal-body mobile-width-wide">*}

{*    {if $is_dialog_wrap}*}
{*        <h2 class="h2">{t}Регистрация{/t}</h2>*}
{*    {/if}*}

{*    {if count($user->getNonFormErrors())>0}*}
{*        <div class="page-error">*}
{*            {foreach $user->getNonFormErrors() as $item}*}
{*                <div class="item">{$item}</div>*}
{*            {/foreach}*}
{*        </div>*}
{*    {/if}*}

{*    {if $result}*}
{*        <div class="page-success-result">{$result}</div>*}
{*    {/if}*}

{*    <form method="POST" action="{$router->getUrl('users-front-register')}">*}
{*        {csrf}*}
{*        {$this_controller->myBlockIdInput()}*}
{*        <input type="hidden" name="referer" value="{$referer}">*}

{*            {hook name="users-registers:form" title="{t}Регистрация:форма{/t}"}*}
{*                <div class="form-group">*}
{*                    <input type="radio" name="is_company" value="0" id="is_company_no" {if !$user.is_company}checked{/if}>&nbsp;<label for="is_company_no">{t}Частное лицо{/t}</label><br>*}
{*                    <input type="radio" name="is_company" value="1" id="is_company_yes" {if $user.is_company}checked{/if}>&nbsp;<label for="is_company_yes">{t}Юридическое лицо или ИП{/t}</label>*}
{*                </div>*}

{*            <div class="mobile-2-column">*}
{*                {hook name="users-registers:form-fields" title="{t}Регистрация:поля формы{/t}"}*}
{*                <div class="form-fields_company{if !$user.is_company} hidden{/if}">*}
{*                    <div class="form-group">*}
{*                        <label class="label-sup">{t}Наименование компании{/t}</label>*}
{*                        {$user->getPropertyView('company', ['placeholder' => "{t}Например, ООО Ромашка{/t}"])}*}
{*                    </div>*}
{*                    <div class="form-group">*}
{*                        <label class="label-sup">{t}ИНН{/t}</label>*}
{*                        {$user->getPropertyView('company_inn', ['placeholder' => "{t}10 или 12 цифр{/t}"])}*}
{*                    </div>*}
{*                </div>*}

{*                {if $user_config.user_one_fio_field}*}
{*                    <div class="form-group">*}
{*                        <label class="label-sup">{t}Ф.И.О.{/t}</label>*}
{*                        {$user->getPropertyView('fio', ['placeholder' => "{t}Например, Иванов Иван Иванович{/t}"])}*}
{*                    </div>*}
{*                {else}*}
{*                    {if $user_config->canShowField('name')}*}
{*                        <div class="form-group">*}
{*                            <label class="label-sup">{t}Имя{/t}</label>*}
{*                            {$user->getPropertyView('name', ['placeholder' => "{t}Например, Иван{/t}"])}*}
{*                        </div>*}
{*                    {/if}*}

{*                    {if $user_config->canShowField('surname')}*}
{*                    <div class="form-group">*}
{*                        <label class="label-sup">{t}Фамилия{/t}</label>*}
{*                        {$user->getPropertyView('surname', ['placeholder' => "{t}Например, Иванов{/t}"])}*}
{*                    </div>*}
{*                    {/if}*}

{*                    {if $user_config->canShowField('midname')}*}
{*                    <div class="form-group">*}
{*                        <label class="label-sup">{t}Отчество{/t}</label>*}
{*                        {$user->getPropertyView('midname', ['placeholder' => "{t}Например, Иванович{/t}"])}*}
{*                    </div>*}
{*                    {/if}*}
{*                {/if}*}

{*                {if $user_config->canShowField('phone')}*}
{*                    <div class="form-group">*}
{*                        <label class="label-sup">{t}Телефон{/t}</label>*}
{*                        {$user->getPropertyView('phone', ['placeholder' => "{t}Например, +7(XXX)-XXX-XX-XX{/t}"])}*}
{*                    </div>*}
{*                {/if}*}

{*                {if $user_config->canShowField('login')}*}
{*                    <div class="form-group">*}
{*                        <label class="label-sup">{t}Логин{/t}</label>*}
{*                        {$user->getPropertyView('login', ['placeholder' => "{t}Придумайте логин для входа{/t}"])}*}
{*                    </div>*}
{*                {/if}*}

{*                {if $user_config->canShowField('e_mail')}*}
{*                    <div class="form-group">*}
{*                        <label class="label-sup">{t}E-mail{/t}</label>*}
{*                        {$user->getPropertyView('e_mail', ['placeholder' => "{t}Например, demo@example.com{/t}"])}*}
{*                    </div>*}
{*                {/if}*}

{*                {if $conf_userfields->notEmpty()}*}
{*                    {foreach $conf_userfields->getStructure() as $fld}*}
{*                        <div class="form-group">*}
{*                            <label class="label-sup">{$fld.title}</label>*}
{*                            {$conf_userfields->getForm($fld.alias)}*}

{*                            {$errname = $conf_userfields->getErrorForm($fld.alias)}*}
{*                            {$error = $user->getErrorsByForm($errname, ', ')}*}
{*                            {if !empty($error)}*}
{*                                <span class="formFieldError">{$error}</span>*}
{*                            {/if}*}
{*                        </div>*}

{*                    {/foreach}*}
{*                {/if}*}

{*                {if $user->__captcha->isEnabled()}*}
{*                    <div class="form-group">*}
{*                        <label class="label-sup">{$user->__captcha->getTypeObject()->getFieldTitle()}</label>*}
{*                        {$user->getPropertyView('captcha')}*}
{*                    </div>*}
{*                {/if}*}

{*                <div class="form-group">*}
{*                    <label class="label-sup">{t}Пароль{/t}</label>*}
{*                    {$user->getPropertyView('openpass')}*}
{*                </div>*}
{*                <div class="form-group">*}
{*                    <label class="label-sup">{t}Повтор пароля{/t}</label>*}
{*                    {$user->getPropertyView('openpass_confirm')}*}
{*                </div>*}
{*                {/hook}*}
{*            </div>*}
{*            {/hook}*}

{*        {if $CONFIG.enable_agreement_personal_data}*}
{*            {include file="%site%/policy/agreement_phrase.tpl" button_title="{t}Зарегистрироваться{/t}"}*}
{*        {/if}*}

{*        <div class="form__menu_buttons mobile-center">*}


{*            <button type="submit" class="link link-more">{t}Зарегистрироваться{/t}</button>*}
{*        </div>*}
{*    </form>*}
{*</div>*}

{* Профиль пользователя *}

{addjs file="rs.profile.js"}

<section id="profile-data">
    <div class="container">
        <form  class="row flex" method="POST" id="profile-form" data-url="{$router->getUrl('users-front-profile')}" enctype="multipart/form-data">
            {csrf}
            {$this_controller->myBlockIdInput()}
            <input type="hidden" name="referer" value="{$referer}">
            <input type="hidden" name="is_author" value="{$user['is_author']}"/>
            <div class="col s12">
                <h1>Личный кабинет</h1>
            </div>
            <div class="col m2 s4">
                <div class="avatar-wrapper hidden-input">
                    <input type="file" name="photo" id="avatar-file-selector">
                    {if $user['photo']}
                        <div id="avatar-img" class="avatar lazy" data-src="{$user['__photo']->getLink()}"></div>
                    {else}
                        <div id="avatar-img" class="avatar lazy" data-src="{$user['__photo']->getStub()->getUrl(150, 150, 'xy')}"></div>
                    {/if}

                    <label for="avatar-file-selector">
                        <i class="mdi mdi-camera"></i>
                    </label>
                </div>
                {if $user->getErrorsByForm('photo', ',')}
                    <span class="formFieldError">{$user->getErrorsByForm('photo', ',')}</span>
                {/if}
            </div>
            <div class="col m4 s8">
                <div class="kv-wrapper">
                    <div class="kv-pair">
                        <div class="key">
                            <div class="fogged">Регион</div>
                            {if $user->getErrorsByForm('region', ',')}
                                <div class="error-text">Укажите регион</div>
                            {/if}
                        </div>
                        <div class="value input-field">
                            <input
                                type="text"
                                id="regions"
                                class="hidden-input autocomplete styled"
                                value="{$user['region']}"
                                data-url="{$router->getUrl('gallerist-front-regions', ['Act' => 'getRegions'])}"
                                autocomplete="ffdfd"
                                data-region="{$user['region']}"
                            />
                        </div>
                    </div>
                    <div class="kv-pair">
                        <div class="key">
                            <div class="fogged">Город</div>
                            {if $user->getErrorsByForm('city', ',')}
                                <div class="error-text">Укажите город</div>
                            {/if}
                        </div>
                        <div class="value input-field">
                            <input
                                type="text"
                                name="city"
                                id="cities"
                                class="hidden-input autocomplete styled"
                                value="{$user['city']}"
                                data-url="{$router->getUrl('gallerist-front-regions', ['Act' => 'getCities'])}"
                                autocomplete="ffdfd"
                            >
                        </div>
                    </div>
                    <div class="kv-pair">
                        <div class="key">
                            <div class="fogged">Фамилия</div>
                        </div>
                        <div class="value">
                            <input type="text" name="surname" class="hidden-input" value="{$user['surname']}">
                        </div>
                    </div>
                    <div id="error-surname" class="error-text hidden-block">Укажите фамилию</div>
                    <div class="kv-pair">
                        <div class="key">
                            <div class="fogged">Имя</div>
                        </div>
                        <div class="value"><input type="text" name="name" class="hidden-input" value="{$user['name']}"></div>
                    </div>
                    <div id="error-name" class="error-text hidden-block">Укажите Имя</div>
                    <div class="kv-pair">
                        <div class="key">
                            <div class="fogged">Отчество</div>
                        </div>
                        <div class="value"><input type="text" name="midname" class="hidden-input" value="{$user['midname']}"></div>
                    </div>
                    <div class="kv-pair">
                        <div class="key">
                            <div class="fogged">
                                {if $user->getErrorsByForm('e_mail', ',')}
                                    <span class="formFieldError">{$user->getErrorsByForm('e_mail', ',')}</span>
                                {else}
                                    E-mail
                                {/if}
                            </div>
                        </div>
                        <div class="value"><input type="text" name="e_mail" class="hidden-input" value="{$user['e_mail']}"></div>
                    </div>
                    <div class="kv-pair">
                        <div class="key">
                            <div class="fogged">
                                {if $user->getErrorsByForm('phone', ',')}
                                    <span class="formFieldError">{$user->getErrorsByForm('phone', ',')}</span>
                                {else}
                                    Телефон
                                {/if}
                            </div>
                        </div>
                        <div class="value"><input type="text" name="phone" class="hidden-input" value="{$user['phone']}"></div>
                    </div>
                </div>
            </div>
            <div class="col m6 s12">
                <textarea name="about" class="hidden-input" placeholder="Коротко о себе">{$user['about']}</textarea>
            </div>
            {if $result}
                <div class="page-success-result">{$result}</div>
            {/if}

{*            <div class="form_label__block form-group hidden-block">*}
{*                <input type="checkbox" name="changepass" id="pass-accept" value="1" {if $user.changepass}checked{/if}>*}
{*                <label for="pass-accept">{t}Сменить пароль{/t}</label>*}
{*            </div>*}

            <div class="form-fields_change-pass{if !$user.changepass} hidden{/if}">
                <div class="form-group">
                    <label class="label-sup">{t}Старый пароль{/t}</label>
                    {$user->getPropertyView('current_pass')}
                </div>
                <div class="form-group">
                    <label class="label-sup">{t}Пароль{/t}</label>
                    {$user->getPropertyView('openpass')}
                </div>
                <div class="form-group">
                    <label class="label-sup">{t}Повтор пароля{/t}</label>
                    {$user->getPropertyView('openpass_confirm')}
                </div>
            </div>


            <div class="col s12 profile-form-actions">
                <a href="" class="btn btn-flat">Изменить <span class="gold-text">пароль</span></a>
                <a href="" class="btn" id="saver">Редактировать <span class="gold-text">профиль</span></a>
{*                <button type="submit" class="btn hidden-block" id="saver-submit">Сохранить <span class="gold-text">изменения</span></button>*}
            </div>
        </form>
    </div>
</section>
<section id="tools">
    <div class="container">
        <div class="row">
            <div class="col s12">
                <ul class="tabs">
                    <li class="tab"><a class="active" href="#images">Управление работами</a></li>
                    <li class="tab disabled"><a href="#events">Мероприятия</a></li>
                    <li class="tab disabled"><a href="#notifications">Уведомления</a></li>
                    <li class="tab"><a href="#communications">Общение</a></li>
                    <li class="tab disabled"><a href="#recycle">Корзина</a></li>
                </ul>
                <div id="images">
                    <div class="row">
                        <div class="col s12">
                            <div class="profile-gallery-wrapper sortable-wrapper">
                                {$arts = $user->getArts()}
                                {foreach $arts['arts'] as $art}
                                    <div class="profile-gallery-entry @@extraClass">
                                        <div class="drag-handler"><i class="mdi mdi-drag-vertical"></i></div>
                                        <div class="thumbnail">
                                            <div class="lazy" data-src="{$art->getMainImage()->getOriginalUrl()}"></div>
                                        </div>
                                        <div class="name">{$art['title']}</div>
                                        <div class="date">{$art['dateof']|date_format:'%d.%m.%Y'}</div>
                                        <div class="size">{$art->getSize()}</div>
                                        <div class="price">{$art->getCost()}₽</div>
                                        <div class="actions">
                                            <a href="{$router->getAdminUrl('edit', ['referer' => '/my/', 'id' => $art['id'], 'dir' => $art->getMainDir()->id], 'gallerist-picturectrl')}" class="edit crud-edit"><i class="mdi mdi-pen"></i></a>
                                            <a href="" class="publish-indicator inactive"><i></i></a>
                                            <a href="{$router->getAdminUrl('delProd', ['referer' => '/my/', 'id' => $art['id']], 'gallerist-picturectrl')}" class="remove delete crud-get crud-close-dialog"><i class="mdi mdi-delete"></i></a>
                                            <a href="/editimage/{$art['id']}" target="_blank"><i class="mdi mdi-image-edit"></i></a>
                                        </div>
                                    </div>
                                {/foreach}
                            </div>
                        </div>

                    </div>
                </div>
                <div id="events">2</div>
                <div id="notifications">3</div>
                <div id="communications">
                    <div class="row">
                        <div class="col l8 m12 s12">
                            <div class="messaging-wrapper">
                                <div class="communications-header">
                                    <div class="header">Переписка</div>
                                    <div class="actions">
                                        <a><i class="mdi mdi-magnify"></i></a>
                                        <a><i class="mdi mdi-dots-vertical"></i></a>
                                        <a class="sidenav-trigger" href="#chat-sidenav"><i class="mdi mdi-menu"></i></a>
                                    </div>
                                </div>
                                <div class="messages-wrapper">
                                    @@loop("./parts/message.html", "./data/messages.json")
                                </div>
                                <ul class="sidenav" id="chat-sidenav">
                                    <div class="messages-authors-wrapper">
                                        @@loop("./parts/message-author-sidenav.html", "./data/authors.json")
                                    </div>
                                </ul>
                                <div class="communications-footer">
                                    <div class="input-field">
                                        <input type="text" placeholder="Текст сообщения">
                                        <label for="">Текст сообщения</label>
                                        <a href=""><span class="mdi mdi-send"></span></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col m4">
                            <div class="contacts">
                                <div class="messages-authors-header">
                                    <div class="header">Контакты</div>
                                </div>
                                <div class="input-field">
                                    <input type="text" placeholder="Поиск">
                                    <label for="">Поиск</label>
                                </div>
                                <div class="messages-authors-wrapper">
                                    @@loop("./parts/message-author.html", "./data/authors.json")
                                </div>
                            </div>
                            <div class="contacts-footer">
                                <a href="" class="btn">Добавить <span class="gold-text">контакт</span></a>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="recycle"></div>
            </div>
        </div>
    </div>
</section>


{*<div class="form-style">*}
{*    <div class="tab-content">*}
{*        <div id="menu1" class="tab-pane fade active in">*}
{*            <div class="col-xs-12">*}
{*                <h3 class="h3">{t}Личные данные{/t}</h3>*}

{*                {if $errors=$user->getNonFormErrors()}*}
{*                    <div class="page-error">*}
{*                        {foreach $errors as $item}*}
{*                            <div class="item">{$item}</div>*}
{*                        {/foreach}*}
{*                    </div>*}
{*                {/if}*}

{*                {if $result}*}
{*                    <div class="page-success-result">{$result}</div>*}
{*                {/if}*}

{*                <form method="POST">*}
{*                    {csrf}*}
{*                    {$this_controller->myBlockIdInput()}*}
{*                    <input type="hidden" name="referer" value="{$referer}">*}

{*                    <div class="form-group">*}
{*                        <input type="radio" name="is_company" value="0" id="is_company_no" {if !$user.is_company}checked{/if}><label for="is_company_no">{t}Частное лицо{/t}</label><br>*}
{*                        <input type="radio" name="is_company" value="1" id="is_company_yes" {if $user.is_company}checked{/if}><label for="is_company_yes">{t}Юридическое лицо или ИП{/t}</label>*}
{*                    </div>*}

{*                    <div class="form-fields_company{if !$user.is_company} hidden{/if}">*}
{*                        <div class="form-group">*}
{*                            <label class="label-sup">{t}Наименование компании{/t}</label>*}
{*                            {$user->getPropertyView('company', ['placeholder' => "{t}Например, ООО Ромашка{/t}"])}*}
{*                        </div>*}
{*                        <div class="form-group">*}
{*                            <label class="label-sup">{t}ИНН{/t}</label>*}
{*                            {$user->getPropertyView('company_inn', ['placeholder' => "{t}10 или 12 цифр{/t}"])}*}
{*                        </div>*}
{*                    </div>*}

{*                    <div class="form-group">*}
{*                        <label class="label-sup">{t}Имя{/t}</label>*}
{*                        {$user->getPropertyView('name', ['placeholder' => "{t}Например, Иван{/t}"])}*}
{*                    </div>*}

{*                    <div class="form-group">*}
{*                        <label class="label-sup">{t}Фамилия{/t}</label>*}
{*                        {$user->getPropertyView('surname', ['placeholder' => "{t}Например, Иванов{/t}"])}*}
{*                    </div>*}

{*                    <div class="form-group">*}
{*                        <label class="label-sup">{t}Отчество{/t}</label>*}
{*                        {$user->getPropertyView('midname', ['placeholder' => "{t}Например, Иванович{/t}"])}*}
{*                    </div>*}

{*                    <div class="form-group">*}
{*                        <label class="label-sup">{t}Телефон{/t}</label>*}
{*                        {$user->getPropertyView('phone', ['placeholder' => "{t}Например, +7(XXX)-XXX-XX-XX{/t}"])}*}
{*                    </div>*}

{*                    <div class="form-group">*}
{*                        <label class="label-sup">{t}E-mail{/t}</label>*}
{*                        {$user->getPropertyView('e_mail', ['placeholder' => "{t}Например, demo@example.com{/t}"])}*}
{*                    </div>*}

{*                    {if $conf_userfields->notEmpty()}*}
{*                        {foreach $conf_userfields->getStructure() as $fld}*}
{*                            <div class="form-group">*}
{*                                <label class="label-sup">{$fld.title}</label>*}
{*                                {$conf_userfields->getForm($fld.alias)}*}

{*                                {$errname = $conf_userfields->getErrorForm($fld.alias)}*}
{*                                {$error = $user->getErrorsByForm($errname, ', ')}*}
{*                                {if !empty($error)}*}
{*                                    <span class="formFieldError">{$error}</span>*}
{*                                {/if}*}
{*                            </div>*}

{*                        {/foreach}*}
{*                    {/if}*}

{*                    <div class="form_label__block form-group">*}
{*                        <input type="checkbox" name="changepass" id="pass-accept" value="1" {if $user.changepass}checked{/if}>*}
{*                        <label for="pass-accept">{t}Сменить пароль{/t}</label>*}
{*                    </div>*}

{*                    <div class="form-fields_change-pass{if !$user.changepass} hidden{/if}">*}
{*                        <div class="form-group">*}
{*                            <label class="label-sup">{t}Старый пароль{/t}</label>*}
{*                            {$user->getPropertyView('current_pass')}*}
{*                        </div>*}
{*                        <div class="form-group">*}
{*                            <label class="label-sup">{t}Пароль{/t}</label>*}
{*                            {$user->getPropertyView('openpass')}*}
{*                        </div>*}
{*                        <div class="form-group">*}
{*                            <label class="label-sup">{t}Повтор пароля{/t}</label>*}
{*                            {$user->getPropertyView('openpass_confirm')}*}
{*                        </div>*}
{*                    </div>*}

{*                    <div class="form__menu_buttons">*}
{*                        <button type="submit" class="link link-more">{t}Сохранить{/t}</button>*}
{*                    </div>*}
{*                </form>*}
{*            </div>*}
{*        </div>*}
{*    </div>*}
{*</div>*}

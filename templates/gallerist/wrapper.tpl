{$user = \RS\Application\Auth::getCurrentUser()}
<header>
    <nav>
        <a href="/" class="logo"></a>
        <ul class="nav-menu">
            <li><a href="/">Главная</a></li>
            <li><a href="/catalog/pictures/">Галерея</a></li>
            <li><a href="/authors/">Авторы</a></li>
            <li>
                <a href="" class="events">Мероприятия</a>
                <ul>
                    <li><a href="">Выставки</a></li>
                    <li><a href="">Аукционы</a></li>
                    <li><a href="">Мастерклассы</a></li>
                </ul>
            </li>
        </ul>
        {moduleinsert name="Users\Controller\Block\Authblock"}
        <div class="burger-wrapper">
            <a href="#mobile-navi" class="sidenav-trigger">
                <i class="mdi mdi-menu"></i>
            </a>
        </div>
    </nav>
</header>
<ul class="sidenav" id="mobile-navi">
    <li class="user-view">

    </li>
    <li><a href="/">Главная</a></li>
    <li><a href="/gallery.html">Галерея</a></li>
    <li><a href="/authors.html">Авторы</a></li>
    <li class="folder">
        <a>Мероприятия</a>
        <ul>
            <li><a href="">Выставки</a></li>
            <li><a href="">Аукционы</a></li>
            <li><a href="">Мастерклассы</a></li>
        </ul>
    </li>
</ul>
<main>
    {block name="content"}{/block}
</main>
{if $is_auth && $user->isAuthor()}
    <a class="floating-action-button crud-add" href="{$router->getAdminUrl('add', ['referer' => $referer, 'dir' => 1], 'gallerist-picturectrl')}">
        <i class="mdi mdi-cloud-upload"></i>
    </a>
{/if}
<footer>
    <div class="container">
        <div class="logo-wrapper">
            <div class="logo"></div>
        </div>
        <div class="footer-main">
            <div class="row">
                <div class="col m4">
                    <ul>
                        <li><a href="">Главная</a></li>
                        <li><a href="">Галерея</a></li>
                        <li><a href="">Авторы</a></li>
                        <li><a href="">Мероприятия</a></li>
                        <li><a href="">Контакты</a></li>
                        <li><a href="">Политика конфиденциальности</a></li>
                        <li><a href="">Пользовательское соглашение</a></li>
                    </ul>
                </div>
                <div class="col m8 s12">
                    <div class="row">
                        <div class="col s12">
                            <div class="form-header">Обратная связь</div>
                        </div>
                        <div class="col m6 s12">
                            <div class="input-field">
                                <input type="text" placeholder="Имя, Фамилия">
                                <div class="error">Недопустимые символы в имени</div>
                                <label for="">Пожалуйста представьтесь</label>
                            </div>
                        </div>
                        <div class="col m6 s12">
                            <div class="input-field">
                                <input type="text" placeholder="+7 123 456-7890">
                                <div class="error">Неверный формат</div>
                                <label for="">Телефон</label>
                            </div>
                        </div>
                        <div class="col s12">
                            <div class="input-field">
                                <textarea name="" id="" cols="30" rows="0" placeholder="Что Вас интересует?"></textarea>
                                <div class="error">Поле не должно быть пустым</div>
                                <label for="">Сообщение</label>
                            </div>
                            <div class="buttons-wrapper">
                                <a href="" class="btn"><span class="white-text">Отправить</span><span class="gold-text"> сообщение</span></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>

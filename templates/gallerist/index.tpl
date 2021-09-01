{extends file="%THEME%/wrapper.tpl"}
{block name="content"}
    <div class="global-wrapper" id="main">
        <section id="hero">
            <div class="row">
                <div class="col l8 offset-l2 s12 center-align">
                    <h1>Gallerist</h1>
                </div>
                <div class="col m6 offset-m3 s8 offset-s2 center-align">
                    <p class="subheader">
                        Виртуальная выставка-продажа картин&nbsp;независимых художников&nbsp;мира
                    </p>
                    {if !$is_auth}
                        <a href="{$router->getUrl('users-front-register')}" class="btn btn-flat">
                            <span class="black-text">Присоединиться</span>
                            <span class="gold-text"> к сообществу</span>
                        </a>
                    {/if}
                </div>
                <div class="col xl3 offset-xl3 l3 offset-l3 m4 offset-m2 s6 xs12 right-align intro">
                    Виртуальная площадка Gallerist предоставляет возможность независимым художникам показать свои картины,
                    а при желании и продать их, кроме того, площадка позволяет обмениваться опытом с коллегами по всей России
                    и за ее пределами. Кроме того, художники могут участвовать и выступать организаторами в таких мероприятиях,
                    как мастер-классы, аукционы и выставки.
                </div>
                <div class="col xl3 l3 m4 s6 xs12 intro">
                    Посетителям же предоставляется возможность увидеть картины малоизвестных авторов, и увидеть эксклюзивы,
                    доступные очень ограниченному кругу ценителей, а также, связавшись с автором напрямую приобрести понравившиеся
                    картины или их репродукции напрямую у автора, минуя длинную цепь посредников.
                </div>
            </div>
        </section>
        <section id="gallery">
            <div class="container">
                <div class="row">
                    <div class="col s12">
                        <h2>Галерея</h2>
                        {moduleinsert name="\Gallerist\Controller\Block\Arts"}
                    </div>
                </div>
            </div>
        </section>
        <section id="authors">
            <div class="container">
                <h2>Авторы</h2>
                <div class="row">
                    {moduleinsert name="\Gallerist\Controller\Block\Authors"}
                </div>
            </div>
        </section>
    </div>
{/block}

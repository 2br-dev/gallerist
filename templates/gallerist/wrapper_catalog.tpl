{extends file="%THEME%/wrapper.tpl"}
{block name="content"}
    <div class="global-wrapper" id="gallery">
        <section id="main-data">
            <div class="container">
                <div class="row">
                    <div class="col s12">
                        <h1>Галерея</h1>
                    </div>
                </div>
                <div class="row">
                    {moduleinsert name="Catalog\Controller\Block\Sidefilters"}
                </div>
                {$app->blocks->getMainContent()}
            </div>
        </section>
    </div>
{/block}

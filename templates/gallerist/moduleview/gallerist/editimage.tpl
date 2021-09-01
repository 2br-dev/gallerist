{addjs file="libs/cropper/cropper.js"}
{addcss file="libs/cropper/cropper.css"}
{*{addjs file="libs/cropper/jquery-cropper.js"}*}
{if $success}
    <div class="edit-image-block container">
        <div class="row">
            <div class="col s12">
                <h1>
                    <span>{$art['title']}</span>
                    <span class="subheader">режим редактирования изображения</span>
                </h1>
            </div>
            <div class="col m8">
                <div class="edit-image-img">
                    <img id="image" src="{$art->getMainImage()->getOriginalUrl()}">
                </div>
            </div>
            <div class="col m4">
                <div>
                    <i class="mdi mdi-rotate-right"></i>
                    <input type="range" min="-180" max="180" step="10" id="image-degree">
                </div>
                <div class="manual-rotate center-align">
                    <a id="rotate-left" class="btn btn-flat"><i class="mdi mdi-rotate-left gold-text"></i></a>
                    <a id="rotate-right" class="btn btn-flat"><i class="mdi mdi-rotate-right gold-text"></i></a>
                </div>
                <div>
                    <i class="mdi mdi-magnify-plus-outline"></i>
                    <input type="range" min="0" max="2" step=".01" id="image-scale">
                </div>
                <div class="edit-image-actions">
                    <a id="reset-edited" class="btn">
                        <span>Сброс</span>
                        <i class="mdi mdi-refresh gold-text"></i>
                    </a>
                    <a id="save-edited" data-url="{$router->getUrl('gallerist-front-editimage', ['Act' => 'saveEditedImage'])}" class="btn">
                        <span>Сохранить</span>
                        <i class="mdi mdi-check gold-text"></i>
                    </a>
                </div>
            </div>
{*            <div class="edit-image-actions">*}
{*                <div class="image-editor">*}
{*                    <a id="rotate-left"><i class="mdi mdi-rotate-left"></i></a>*}
{*                    <a id="rotate-right"><i class="mdi mdi-rotate-right"></i></a>*}
{*                </div>*}
{*                <a id="save-edited" data-url="{$router->getUrl('gallerist-front-editimage', ['Act' => 'saveEditedImage'])}"><span>Сохранить</span><i class="mdi mdi-check-bold"></i></a>*}
{*            </div>*}
        </div>
    </div>
{else}
    <p>не достаточно прав не просмотр содержимого этой страницы</p>
{/if}


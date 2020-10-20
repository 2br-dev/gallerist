{addjs file="jcarousel/jquery.jcarousel.min.js"}
{addjs file="jquery.changeoffer.js?v=2"}
{addjs file="jquery.zoom.min.js"}
{addjs file="product.js"}
{assign var=shop_config value=ConfigLoader::byModule('shop')}
{assign var=check_quantity value=$shop_config.check_quantity}
{assign var=catalog_config value=$this_controller->getModuleConfig()} 
{if $product->isVirtualMultiOffersUse()} {* Если используются виртуальные многомерные комплектации *}
    {addjs file="jquery.virtualmultioffers.js"}
{/if} 
{$product->fillOffersStockStars()} {* Загружаем сведения по остаткам на складах *}

<div id="updateProduct" itemscope itemtype="http://schema.org/Product" class="product{if !$product->isAvailable()} notAvaliable{/if}{if $product->canBeReserved()} canBeReserved{/if}{if $product.reservation == 'forced'} forcedReserve{/if}" data-id="{$product.id}">
    <div class="productInfo">
        {hook name="catalog-product:rating" title="{t}Карточка товара:рейтинг{/t}"}
        <div class="ratingZone">
            <div class="social">
                <a class="handler"></a>
                <div class="socialLinks">
                    <i class="corner"></i>
                    <p class="caption">{t}Поделиться с друзьями:{/t}</p>
                    <script type="text/javascript" src="//yastatic.net/es5-shims/0.0.2/es5-shims.min.js" charset="utf-8"></script>
                    <script type="text/javascript" src="//yastatic.net/share2/share.js" charset="utf-8"></script>
                    <div class="ya-share2" data-services="vkontakte,facebook,odnoklassniki,moimir,twitter"></div>
                </div>                        
            </div>
                                    
            <div class="rating">
                <span class="stars" title="{t}Средняя оценка{/t}: {$product->getRatingBall()}"><i style="width:{$product->getRatingPercent()}%"></i></span>
                <a href="#comments" class="commentsCount">{t comments=$product->getCommentsNum()}%comments [plural:%comments:отзыв|отзыва|отзывов]{/t}</a>
            </div>
        </div>
        {/hook}
        
        <h1 itemprop="name">{$product.title}</h1>                    
        
        {hook name="catalog-product:information" title="{t}Карточка товара:краткая информация{/t}"}
            {if $product.barcode}
            <p class="attribute">{t}Артикул:{/t} <span class="offerBarcode">{$product.barcode}</span></p>
            {/if}
            {if $product.brand_id}
            <p class="attribute">{t}Бренд:{/t} <a class="brandTitle" href="{$product->getBrand()->getUrl()}">{$product->getBrand()->title}</a></p>
            {/if}                
        {/hook}
        
        {hook name="catalog-product:offers" title="{t}Карточка товара:комплектации{/t}"}
            {include "%catalog%/product_offers.tpl"}
        {/hook}
        
        {if $shop_config}
            {* Блок с сопутствующими товарами *}
            {moduleinsert name="\Shop\Controller\Block\Concomitant"}
        {/if}
        
        {hook name="catalog-product:price" title="{t}Карточка товара:цены{/t}"}
            {assign var=last_price value=$product->getOldCost()}
            <div itemprop="offers" itemscope itemtype="http://schema.org/Offer" class="price">
                    {if $last_price>0}<p class="lastPrice">{$last_price}</p>{/if}
                    <strong itemprop="price" class="myCost" content="{$product->getCost(null, null, false)}">{$product->getCost()}</strong><span class="myCurrency">{$product->getCurrency()}</span>
                    <span itemprop="priceCurrency" class="hidden">{$product->getCurrencyCode()}</span>
                    {* Если включена опция единицы измерения в комплектациях *}
                    {if $catalog_config.use_offer_unit && $product->isOffersUse()}
                        <span class="unitBlock">/ <span class="unit">{$product->getMainOffer()->getUnit()->stitle}</span></span>
                    {/if}
            </div>
        {/hook}
        
        {hook name="catalog-product:action-buttons" title="{t}Карточка товара:кнопки{/t}"}
            <div class="buttons">
                {if $shop_config && !$product.disallow_manually_add_to_cart}
                    <a data-href="{$router->getUrl('shop-front-reservation', ["product_id" => $product.id])}" class="button reserve inDialog">{t}Заказать{/t}</a>
                    <span class="unobtainable">{t}Нет в наличии{/t}</span>
                    <a data-href="{$router->getUrl('shop-front-cartpage', ["add" => $product.id])}" class="button addToCart" data-add-text="Добавлено">{t}В корзину{/t}</a>
                {/if}
                
                {if !$shop_config || (!$product->shouldReserve() && (!$check_quantity || $product.num>0))}
                    {if $catalog_config.buyinoneclick }
                        <a data-href="{$router->getUrl('catalog-front-oneclick',["product_id"=>$product.id])}" title="Купить в 1 клик" class="button buyOneClick inDialog">{t}Купить в 1 клик{/t}</a>
                    {/if}                        
                {/if}
                {if $THEME_SETTINGS.enable_compare || $THEME_SETTINGS.enable_favorite}
                <br/>
                <div class="dotBlock">   
                    {if $THEME_SETTINGS.enable_compare}
                    <a class="compare{if $product->inCompareList()} inCompare{/if}">
                        <span>{t}К сравнению{/t}</span>
                        <span class="already">{t}В сравнении{/t}</span>
                    </a>
                    {/if}
                    {if $THEME_SETTINGS.enable_favorite}
                    <a class="favorite{if $product->inFavorite()} inFavorite{/if}">
                        <span>{t}В избранное{/t}</span>
                        <span class="already">{t}В избранном{/t}</span>
                    </a>                    
                    {/if}
                </div>
                {/if}
            </div>
        {/hook}
        
        {if !$product->shouldReserve()}
            {hook name="catalog-product:stock" title="{t}Карточка товара:остатки{/t}"}
                {* Вывод наличия на складах *}
                {assign var=stick_info value=$product->getWarehouseStickInfo()}
                {if !empty($stick_info.warehouses)}
                    <div class="warehouseDiv">
                        <div class="titleDiv">{t}Наличие{/t}:</div>
                        {foreach $stick_info.warehouses as $warehouse}
                            <div class="warehouseRow" data-warehouse-id="{$warehouse.id}">
                                <div class="stickWrap">
                                    {$first_offer = $product->getMainOffer()}
                                    {$sticks = $first_offer.sticks[$warehouse.id]}
                                    {foreach $stick_info.stick_ranges as $stick_range}
                                         <span class="stick {if $sticks >= $stick_range}filled{/if}"></span>
                                    {/foreach}
                                </div>
                                <a class="title" href="{$warehouse->getUrl()}"><span>{$warehouse.title}</span></a>
                            </div>
                        {/foreach}
                    </div>
                {/if}
            {/hook}
        {/if}
        
        {if $product.short_description}
        <div itemprop="description" class="shortDescription">{$product.short_description|nl2br}</div>
        {/if}
        
        {$tabs=[]}
        {if $product.properties || $product->isOffersUse()} {$tabs["property"] = t('Характеристики')} {/if}
        {if $product.description} {$tabs["description"] = t('Описание')} {/if}
        {if $files=$product->getFiles()} {$tabs["files"] = t('Файлы')} {/if}
        {$tabs["comments"] = t('Отзывы')}
        
        <div class="tabs gray productTabs">
            <ul class="tabList">
                {foreach $tabs as $key=>$tab}
                {if $tab@first}{$act_tab=$key}{/if}
                <li {if $tab@first}class="act"{/if} data-href=".tab-{$key}"><a>{$tab}</a></li>
                {/foreach}
            </ul>
            
            {if $tabs.property}
            <div class="tab tab-property {if $act_tab == 'property'}act{/if}">
                {hook name="catalog-product:properties" title="{t}Карточка товара:характеристики{/t}"}
                    {foreach $product.offers.items as $key=>$offer}
                    {if $offer.propsdata_arr}
                    <div class="offerProperty propertyGroup{if $key>0} hidden{/if}" data-offer="{$key}">
                        <p class="groupName">{t}Характеристики комплектации{/t}</p>
                        <table class="properties">
                            {foreach $offer.propsdata_arr as $pkey=>$pval}
                            <tr>
                                <td class="key"><span>{$pkey}</span></td>
                                <td class="value"><span>{$pval}</span></td>
                            </tr>
                            {/foreach}
                        </table>
                    </div>
                    {/if}
                    {/foreach}
                
                    {foreach $product.properties as $data}
                        <div class="propertyGroup">
                            <p class="groupName">{$data.group.title|default:t("Характеристики")}</p>
                            <table class="properties">
                                {foreach $data.properties as $property}
                                    {$prop_value = $property->textView()}
                                    <tr>
                                        <td class="key"><span>{$property.title}</span>
                                            {if $property.description}
                                                <a class="popover-button"
                                                   data-toggle="popover"
                                                   tabindex="0"
                                                   data-trigger="manual"
                                                   data-content="{$property.description}"> ? </a>
                                            {/if}
                                        </td>
                                        <td class="value"><span>{$prop_value} {$property.unit}</span></td>
                                    </tr>
                                {/foreach}
                            </table>
                        </div>
                    {/foreach}
                {/hook}
            </div>
            {/if}
            
            {if $tabs.description}
            <div class="tab tab-description textStyle {if $act_tab == 'description'}act{/if}">
                {hook name="catalog-product:description" title="{t}Карточка товара:описание{/t}"}
                    <article>{$product.description}</article>
                {/hook}
            </div>
            {/if}
            
            {if $tabs.files}
                <div class="tab tab-files {if $act_tab == 'files'}act{/if}">
                    {hook name="catalog-product:files" title="{t}Карточка товара:файлы{/t}"}
                    <ul class="filesList">
                        {foreach $files as $file}
                        <li>
                            <a href="{$file->getUrl()}">{$file.name} ({$file.size|format_filesize})</a>
                            {if $file.description}<div class="fileDescription">{$file.description}</div>{/if}
                        </li>
                        {/foreach}
                    </ul>
                    {/hook}
                </div>
            {/if}            
            
            {if $tabs.comments}
            <div class="tab tab-comments {if $act_tab == 'comments'}act{/if}">
                {hook name="catalog-product:comments" title="{t}Карточка товара:комментарии{/t}"}
                    <script type="text/javascript">
                        $(function() {
                            function openComments()
                            {
                                $('.product .tabs .tab').removeClass('act');
                                $('.product .tabs .tabList [data-href=".tab-comments"]').click();
                                
                            }
                            if (location.hash=='#comments') {
                                openComments();
                            }
                            $('.commentsCount').click(openComments);
                        });
                    </script>
                    {moduleinsert name="\Comments\Controller\Block\Comments" type="\Catalog\Model\CommentType\Product"}    
                {/hook}        
            </div>
            {/if}
        </div>
    </div>    
    <div class="productImages">
        {hook name="catalog-product:images" title="{t}Карточка товара:изображения{/t}"}
            <div class="main">
                {$images=$product->getImages()}
                {if !$product->hasImage()} 
                    {$main_image=$product->getMainImage()}       
                    <span class="item"><img src="{$main_image->getUrl(350,486,'xy')}" alt="{$main_image.title|default:"{$product.title}"}"/></span>
                {else}               
                    {* Главное фото *} 
                    {if $product->isOffersUse()}
                       {* Назначенные фото у первой комлектации *}
                        {$first_offer = $product->getMainOffer()}
                        {$offer_images = $first_offer.photos_arr}
                    {/if}
                    {foreach $images as $key => $image}
                       <a href="{$image->getUrl(800,600,'xy')}" data-id="{$image.id}" class="item mainPicture {if ($offer_images && ($image.id!=$offer_images.0)) || (!$offer_images && !$image@first)} hidden{/if} zoom" {if ($offer_images && in_array($image.id, $offer_images)) || (!$offer_images)}rel="bigphotos"{/if} data-n="{$key}" target="_blank" data-zoom-src="{$image->getUrl(947, 1300)}"><img class="winImage" src="{$image->getUrl(350,486,'xy')}" alt="{$image.title|default:"{$product.title} фото {$key+1}"}"></a>
                    {/foreach}
                {/if}
            </div>
            {* Нижняя линейка фото *}
            {if count($images)>1}
            <div class="gallery">
                <div class="wrap">
                    <ul>
                        {$first = 0}
                        {foreach $images as $key => $image}
                        <li data-id="{$image.id}" class="{if $offer_images && !in_array($image.id, $offer_images)}hidden{elseif !$first++} first{/if}">
                            <a href="{$image->getUrl(800,600,'xy')}" class="preview" data-n="{$key}" target="_blank"><img src="{$image->getUrl(70, 92)}">
                            </a></li>
                        {/foreach}
                    </ul>
                </div>
                <a class="control prev"></a>
                <a class="control next"></a>
            </div>
            {/if}
        {/hook}
        
        <ul class="articles">
            <li class="payment first">
                <span class="title" onclick="$(this).parent().toggleClass('open'); return false;">{t}Условия оплаты{/t} <i class="flag"></i></span>
                <article class="text">
                    {moduleinsert name="\Main\Controller\Block\UserHtml" html="{t}<p>&nbsp;Мы принимаем пластиковые карты Visa, Mastercard. А также любые электронные платежи Яндекс.Деньги, WebMoney, RBC Money, и.т.д</p>
<p>Вы можете расплатиться также со счета Вашего мобильного телефона. Прием платежей осуществляется с помощью сервисов Robokassa, Assist, PayPal, Яндекс.Деньги</p>{/t}"}
                </article>
            </li>
            <li class="delivery">
                <span class="title" onclick="$(this).parent().toggleClass('open'); return false;">Доставка <i class="flag"></i></span>
                <article class="text">
                    {moduleinsert name="\Main\Controller\Block\UserHtml" html="{t}<p>Доставка товаров по территории России осуществляется бесплатно. Забрать товар самостоятельно можно из пункта самовывоза по адресу: ул. Краснодар, ул. Тестовая, 180. тел. 8 (918) 000-00-00</p>
<p>Стоимость доставки курьерскими службами за пределы России осуществляется в менеджером после оформления заказа. Менеджер свяжется с вами для уточнения стоимости доставки.</p>{/t}"}
                </article>
            </li>
        </ul>
    </div>    
         
    <div class="clearBoth"></div>    
</div>


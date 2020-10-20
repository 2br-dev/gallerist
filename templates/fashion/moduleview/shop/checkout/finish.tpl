<div class="formStyle checkoutBox">
        <h3>{t}Спасибо! Ваш заказ успешно оформлен{/t}</h3>
        {if $user.id}
            <p class="thanks">{t alias="Следить за изменениями статуса.." url={$router->getUrl('shop-front-myorders')}}Следить за изменениями статуса заказа можно в разделе <a href="%url" target="_blank">история заказов</a>.{/t}</p>
        {/if}
        <p>{t}Все уведомления об изменениях в данном заказе также будут отправлены на электронную почту покупателя.{/t}</p>
        <div class="coInfo">
            {$user=$order->getUser()}
            <div class="grayblock">            
                <h2>{t}Сведения о заказе{/t}</h2>
                <table>
                    <tr>
                        <td class="key">{t}Заказчик{/t}</td>
                        <td>{$user.surname} {$user.name} {$user.midname}</td>
                    </tr>
                    <tr>
                        <td class="key">{t}Телефон{/t}</td>
                        <td>{$user.phone}</td>
                    </tr>
                    <tr class="preSep">
                        <td class="key">e-mail</td>
                        <td>{$user.e_mail}</td>
                    </tr>
                    {$fmanager=$order->getFieldsManager()}
                    {if $fmanager->notEmpty()}
                        {foreach $fmanager->getStructure() as $field}
                            <tr class="{if $field@first}postSep{/if} {if $field@last}preSep{/if}">
                                <td class="key">{$field.title}</td>
                                <td>{$fmanager->textView($field.alias)}</td>
                            </tr>
                        {/foreach}
                    {/if}
                    {$delivery=$order->getDelivery()}
                    {$address=$order->getAddress()}
                    {$pay=$order->getPayment()}
                    {if $order.delivery}
                        <tr class="postSep">
                            <td class="key">{t}Доставка{/t}</td>
                            <td>{$delivery.title}</td>
                        </tr>
                    {/if}
                    {if $order.only_pickup_points && $order.warehouse} {* Если только самовывоз *}
                        <tr>
                            <td class="key">{t}Пункт самовывоза{/t}</td>
                            <td>{$order->getWarehouse()->adress}</td>
                        </tr>
                    {elseif $order.use_addr}
                        <tr>
                            <td class="key">{t}Адрес{/t}</td>
                            <td>{$address->getLineView()}</td>
                        </tr>
                    {/if}
                    {if $order.payment}
                        <tr>
                            <td class="key">{t}Оплата{/t}</td>
                            <td>{$pay.title}</td>
                        </tr>
                    {/if}
                    {$url=$order->getTrackUrl()}
                    {if !empty($url)}
                        <tr>
                            <td class="key">{t}Данные заказа{/t}</td>
                            <td><a href="{$url}" target="_blank">{t}Отследить заказ{/t}</a></td>
                        </tr>
                    {/if}
                </table>
            </div>

            {if $order->getPayment()->hasDocs()}
            <div class="docs grayblock">
                <h2>{t}Документы на оплату{/t}</h2>
                <div class="border">
                    <p>{t}Воспользуйтесь следующими документами для оплаты заказа. Эти документы всегда доступны в разделе история заказов.{/t}</p>
                    <br>
                    <div class="textCenter">
                    {$type_object=$order->getPayment()->getTypeObject()}
                    {foreach $type_object->getDocsName() as $key => $doc}
                    <a href="{$type_object->getDocUrl($key)}" target="_blank" class="button white">{$doc.title}</a>
                    {/foreach}
                    </div>
                </div>
            </div>            
            {/if}
            
        </div>            
        
        {assign var=orderdata value=$cart->getOrderData()}
        <div class="coItems">
            <p class="orderId">{t}Заказ N{/t} {$order.order_num}</p>
            <p class="orderDate">{t}от{/t} {$order.dateof|date_format:"d.m.Y"}</p>
            <table class="themeTable">
                <thead>
                    <tr>
                        <td>{t}Товар{/t}</td>
                        <td>{t}Количество{/t}</td>
                        <td class="price">{t}Цена{/t}</td>
                    </tr>
                </thead>
                <tbody>
                {hook name="shop-checkout-finish:products" title="{t}Завершение заказа:товары{/t}"}
                    {foreach $orderdata.items as $n=>$item}
                    {$orderitem=$item.cartitem}
                    {$barcode=$orderitem.barcode}
                    {$offer_title=$orderitem.model}
                    {$multioffer_titles=$orderitem->getMultiOfferTitles()}
                    <tr>
                        <td>{$orderitem.title}
                            <div class="codeLine">
                                {if $barcode != ''}{t}Артикул:{/t}<span class="value">{$barcode}</span><br>{/if}
                                {if $multioffer_titles || $offer_title}
                                    <div class="multioffersWrap">
                                        {foreach $multioffer_titles as $multioffer}
                                            <p class="value">{$multioffer.title} - <strong>{$multioffer.value}</strong></p>
                                        {/foreach}
                                        {if !$multioffer_titles}
                                            <p class="value"><strong>{$offer_title}</strong></p>
                                        {/if}
                                    </div>
                                {/if}
                            </div>
                        </td>
                        <td>
                            {$orderitem.amount} {$orderitem.data.unit}
                        </td>
                        <td class="price">
                            {$item.total}
                            <div class="discount">
                                {if $item.discount>0}
                                    {t}скидка{/t} {$item.discount}
                                {/if}
                            </div>
                        </td>
                    </tr>
                    {/foreach}
                {/hook}
                </tbody>
            </table>
            <br>
            <table class="themeTable">
                <tbody>
                    {foreach $orderdata.other as $item}
                    <tr>
                        <td>{$item.cartitem.title}</td>
                        <td>{if $item.total != 0}{$item.total}{/if}</td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
            <div class="summary">
                <span class="text">{t}Итого:{/t} </span>
                <span class="price">{$orderdata.total_cost}</span>
            </div>
        </div>
        <div class="clearBoth"></div>
        <div class="buttons">
            {if $order->canOnlinePay()}
                <a href="{$order->getOnlinePayUrl()}" class="button color">{t}Перейти к оплате{/t}</a>
            {else}
                <a href="{$router->getRootUrl()}" class="button color">{t}Завершить заказ{/t}</a>
            {/if}
        </div>
</div>
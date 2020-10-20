<h3>{t}Настройка аккаунта Яндекс.Касса{/t}</h3>

<p>
    {t href="https://kassa.yandex.ru/joinups?source=readyscript"}Если у вас еще нет аккаунта в Яндекс.Кассе, создайте его <a href="%href" target="_blank">здесь</a>.{/t}<br>
    <small>{t}Для работы с Яндекс.Кассой необходимо наличие сертификата (как минимум самоподписного) у сайта для установления SSL соединения.{/t}</small>
</p>

<b>{t}Способ подключения к Яндекс.Кассе{/t}:</b><br>
{t}протокол API{/t}

<br><br>

<b>{t}URL для уведомлений{/t}:</b><br>
https://{$Setup.DOMAIN}{$router->getUrl('shop-front-onlinepay', [Act=>result, PaymentType=>$payment_type->getShortName()])}



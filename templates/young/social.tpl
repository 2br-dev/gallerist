{if $CONFIG.facebook_group || $CONFIG.vkontakte_group || $CONFIG.twitter_group}
<div class="social">
    {if $CONFIG.facebook_group}
        <a href="{$CONFIG.facebook_group}" class="fb"></a>
    {/if}
    {if $CONFIG.vkontakte_group}
        <a href="{$CONFIG.vkontakte_group}" class="vk"></a>
    {/if}
    {if $CONFIG.twitter_group}
        <a href="{$CONFIG.twitter_group}" class="tw"></a>
    {/if}
    {if $CONFIG.instagram_group}
        <a href="{$CONFIG.instagram_group}" class="instagram"></a>
    {/if}
    {if $CONFIG.youtube_group}
        <a href="{$CONFIG.youtube_group}" class="youtube"></a>
    {/if}
    {if $CONFIG.viber_group}
        <a href="{$CONFIG.viber_group}" class="viber"></a>
    {/if}
    {if $CONFIG.telegram_group}
        <a href="{$CONFIG.telegram_group}" class="telegram"></a>
    {/if}
    {if $CONFIG.whatsapp_group}
        <a href="{$CONFIG.whatsapp_group}" class="whatsapp"></a>
    {/if}
</div>
<p class="footerImage"><img src="{$THEME_IMG}/footer_image.png" alt=""/></p>
{/if}
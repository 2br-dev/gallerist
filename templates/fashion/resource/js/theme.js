/**
 * Скрипт инициализирует стандартные функции для работы темы
 */
$.detectMedia = function( checkMedia ) {
    var init = function() {
        var detectMedia = function() {
            var
                currentMedia = $('body').data('currentMedia'),
                newMedia = '';

            if ($(document).width() < 760) {
                newMedia = 'mobile';
            }
            if ($(document).width() >= 760 && $(document).width() <= 980) {
                newMedia = 'portrait';
            }

            if (currentMedia != newMedia) {
                $('body').data('currentMedia', newMedia);
            }
        }
        $(window).on('resize.detectMedia', detectMedia);
        detectMedia();
    }

    var check = function(media) {
        return $('body').data('currentMedia') == media;
    }

    if (checkMedia) {
        return check(checkMedia);
    } else {
        init();
    }
};
//Инициализируем работу data-href у ссылок
$.initDataHref = function() {
    $('a[data-href]:not(.addToCart):not(.applyCoupon):not(.ajaxPaginator)').on('click', function() {
        if ($.detectMedia('mobile') || !$(this).hasClass('inDialog')) {
            location.href = $(this).data('href');
        }
    });
};

//Инициализируем работу блока, скрывающего длинный текст
$.initCut = function() {
    $('.rs-cut').each(function(){
        $(this).css('max-height', ($(this).data('cut-height')) ? $(this).data('cut-height') : '200px');
        $(this).append('<div class="cut-switcher"></div>');
        $(this).children().last().click(function(){
            if ($(this).parent().hasClass('open')) {
                $(this).parent().css('max-height', ($(this).parent().data('cut-height')) ? $(this).parent().data('cut-height') : '200px');
            } else {
                $(this).parent().css('max-height', '10000px');
            }
            $(this).parent().toggleClass('open');
        });
    });
};

$(function() {
    $('[data-toggle="popover"]').popover({placement : 'auto', trigger: 'click'});
    $(document).on('click', function (e) {
        $('[data-toggle="popover"],[data-original-title]').each(function () {
            if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
                (($(this).popover('hide').data('bs.popover')||{}).inState||{}).click = false  // fix for BS 3.3.6
            }

        });
    });

   $('#up').click(function () { 
        $('body, html').animate({ scrollTop: 0 });  
        return false; 
    });
    
    //Инициализируем корзину
    $.cart({
        saveScroll: '.scrollBox',
        cartItemRemove: '.cartTable .iconRemove',
        cartTotalPrice: '.floatCartPrice',
        cartTotalItems: '.floatCartAmount'
    }); 
    
    $('.inDialog').openInDialog();
    $('.tabs').activeTabs();

    //Инициализируем быстрый поиск по товарам
    $(window).resize(function() {
        $( ".query.autocomplete" ).autocomplete( "close" );
    });

    $.initDataHref();
    $.initCut();

    /**
    * Автозаполнение в строке поиска 
    */
    $( ".query.autocomplete" ).each(function() {
        $(this).autocomplete({
            source: $(this).data('sourceUrl'),
            appendTo: '#queryBox',
            minLength: 3,
            select: function( event, ui ) {
                location.href=ui.item.url;
                return false;
            },
            messages: {
                noResults: '',
                results: function() {}
            }
        }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
            ul.addClass('searchItems');
            var li = $( "<li />" );
            var link_class = "";
            if (item.image){
                var img = $('<img />').attr('src', item.image).css('visibility', 'hidden').load(function() {
                    $(this).css('visibility', 'visible');
                });    
                li.append($('<div class="image" />').append(img));
            }else{
                link_class = "class='noimage'";
            }

            if (item.type == 'search'){
                li.addClass('allSearchResults');
            }
            
            var item_html = '<a '+link_class+'><span class="label">' + item.label + '</span>';
            if (item.barcode){ //Если артикул есть
               item_html += '<span class="barcode">' + item.barcode + '</span>';
            }else if (item.type == 'brand'){
                item_html += '<span class="barcode">' + lang.t('Проиводитель') + '</span>';
            }else if (item.type == 'category'){
                item_html += '<span class="barcode">' + lang.t('Категория') + '</span>';
            }
            if (item.price){ //Если цена есть
               item_html += '<span class="price">' + item.price + '</span>';
            }
            console.log(item);
            if (item.preview){ //Если цена превью (для статей)
               item_html += '<span class="preview">' + item.preview + '</span>';
            }
            item_html += '</a>';        
            
            return li
                .append( item_html )         
                .appendTo( ul );
        };
    });    
    
    //Инициализируем открытие картинок во всплывающем окне
    $('a[rel="lightbox"], .lightimage').colorbox({
       rel:'lightbox',
       className: 'titleMargin',
       opacity:0.2
    });     
    
    //Исправляем ситуацию, когда корзина выскакиет за пределы экрана при зуммировании
    $(window).resize(function() {
        $('.fixedCart').css('transform', "scale(" + window.innerWidth/document.documentElement.clientWidth + ")");
    });
  

}); 

$(window).load(function() {
    $('.products .photoView').on('mouseover', function() {
        if (!$(this).data('gallery')) {
    
            $('.gallery [data-change-preview]', this).mouseenter(function() {
                $(this).addClass('act').siblings().removeClass('act');
                $(this).closest('.photoView').find('.middlePreview').attr('src', $(this).data('changePreview') );
                return false;
            });            

            $('.products .photoView').mouseleave(function() {
                $('.gallery [data-change-preview]:first', this).trigger('mouseenter');
            });            
            
            $('.scrollable .scrollBox', this).jcarousel({
                vertical: true
            });
            $(window).unbind('resize.jcarousel');            
            
            $('.scrollable .control', this).on({
                'inactive.jcarouselcontrol': function() {
                    $(this).addClass('disabled');
                },
                'active.jcarouselcontrol': function() {
                    $(this).removeClass('disabled');
                }
            });            

            $('.scrollable .control.up', this).jcarouselControl({
                target: '-=3'
            });
            $('.scrollable .control.down', this).jcarouselControl({
                target: '+=3'
            });
            $(this).data('gallery', true);
        }
    });
});


//Инициализируем обновляемые зоны
$(window).bind('new-content', function(e) {
    $('.inDialog', e.target).openInDialog();
    $.initDataHref();
    $.initCut();
});
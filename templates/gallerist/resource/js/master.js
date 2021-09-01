const PATH = "/templates/gallerist/resource/js";
var 
    sameAuthor, 
    sameStyle, 
    otherAuthors, 
    tabs, 
    datepicker, 
    sortable,
    naviSidenav,
    editorSidenav,
    chatSidenav,
    regions,
    cities;
var editMode = "view";

$(() => {

    //= Инициализация событий ================================================
    $('body').on('mouseenter', '.info-trigger', showInfoPane);
    $('body').on('mouseleave', '.info, .image', hideInfoPane);
    $('body').on('click', '.search-trigger', openSearcher);
    $('body').on('click', '.close-search', closeSearcher);
    $('body').on('click', '.searcher', closeSearcherOutside);
    $('body').on('click', '.folder', toggleSidenavFolder);
    $('body').on('click', '#saver', toggleEdit);
    $('body').on('click', '.datePicker', openPicker);
    $('body').on('click', '.profile-gallery-entry', selectGalleryItem);
    $('body').on('change', '#avatar-file-selector', updateAvatar);
    $(window).on('resize', updateFooterHeight);

    // Отработка эвентов по фильтрам
    $('body').on('change', '.minmax input', setCurrentMinMax);
	$('body').on('change', '.filters-block .values input[type=checkbox]', updateFiltersMultiSelect);
    $('body').on('click', '.filters-block.select .values a', updateFiltersSelect);
    $('body').on('reset', '.filters', resetFilters);
    $('body').on('click', '.reset-filter', resetFilter);
    $('body').on('click', '.accept', acceptMinMax);
    init();
})

//= Обработчики событий =======================================================
function updateAvatar(){
    var file = this.files[0].name;
    var curFile = this.files[0];
    if(file){
        $(this).next().addClass('file-selected');
        $(this).parent().find('#filename').text(file);
        // $('#avatar-img').data('src', window.URL.createObjectURL(curFile));
        // $('#avatar-img').lazy();
        $('#avatar-img').removeAttr('style').attr('style', 'display: block; background-image: url("'+ window.URL.createObjectURL(curFile)+'");');
    }
}
function acceptMinMax(e){
    e.preventDefault();
    e.stopImmediatePropagation();
    setCurrentMinMax(e, this);
}
function setCurrentMinMax(e, el){

    var element = el ? el : this;
    
    var minmax = $(element).parents('.minmax');
    var values = minmax.find('.minmax-block');
    var tooltipHtml = "";

    $(values).each((index, el) => {

        var min = $(el).find('.min input').val();
        var max = $(el).find('.max input').val();
        if (min!='' || max!=''){
            tooltipHtml += "1"
        }
    });
    
    if(tooltipHtml != ''){
        minmax.find('.current i.mdi-information').removeClass('hidden');
    }else{
        minmax.find('.current i.mdi-information').addClass('hidden');
    }

}
function resetFilter(e){
  var filter = $(this).parents('.filters-block');
  var multiselect = filter.hasClass('multiselect');
  var select = filter.hasClass('select')

  if(multiselect){
    filter.find(':checked').prop('checked', false);
    filter.find('.current .value').text('0');
  }else{
    if(select){
        filter.find('.current input[type="hidden"]').val('');
        filter.find('.current .value').text('Все');
        filter.find('.values a').removeClass('active');
        filter.find('.values li:first-of-type a').addClass('active');
    }else{
        filter.find('input').val('');
        setCurrentMinMax(e, this);
    }
  }
}
function resetFilters(){
  $('.filters-block.select .current .value').text('Все');
  $('.filters-block input[type="hidden"]').val('');
  $('.filters-block.multiselect .current .value').text('0');
  $('.filters-block .values li a').removeClass('active');
  $('.filters-block .values li:first-of-type a').addClass('active');
}
function updateFiltersMultiSelect(){
  var checkedCount = $(this).parents('.values').find(':checked').length;
  $(this).parents('.filters-block').find('.current .value').text(checkedCount);
}
function updateFiltersSelect(){
  $(this).parents('.filters-block').find('.current .value').text($(this).text());
  $(this).parents('.filters-block .values').find('a').removeClass('active');
  $(this).addClass('active');
  if($(this).text() == 'Все'){
    $('.filters-block input[type="hidden"]').val('');
  }else{
    $('.filters-block input[type="hidden"]').val($(this).text());
  }
}
function selectGalleryItem(){
    $('.profile-gallery-entry').removeClass("selected");
    $(this).addClass("selected");

    if($(window).outerWidth() < 1400){
        editorSidenav.open();
    }
    console.log("Ajax-заполнение деталей картины в редакторе");
}
function dragCompleteCallback(e){
    console.log({
        "Старый индекс элемента:":e.oldIndex,
        "Новый индекс элемента:":e.newIndex
    })
}
function openPicker(e){
    e.preventDefault();
    var instance = M.Datepicker.getInstance(this);
    instance.open();
}
function toggleSidenavFolder(e){
    if(e){e.preventDefault();}
    $(this).toggleClass('expanded');
}
function closeSearcherOutside(e){
    var path = e.originalEvent.path;
    var filtered = path.filter(el => {
        return $(el).hasClass('form-wrapper');
    });

    if(!filtered.length){
        closeSearcher();
    }
}
function closeSearcher(e){
    if(e){e.preventDefault();}
    $('.searcher').removeClass('active');
}
function openSearcher(e){
    if(e){e.preventDefault();}
    $('.searcher').addClass('active');
}
function hideInfoPane(){
    if($(this).hasClass("info")){
        $(this).removeClass('active');
    }else{
        $(this).find(".info").removeClass("active");
    }
}
function showInfoPane(){
    $(this).parents(".image").find(".info").addClass("active");
}

function getCityByRegionsTitle(region){
    let url = $('#cities').data('url');
    $.ajax({
        url: url,
        dataType: 'JSON',
        type: 'POST',
        data: {
            region: region
        },
        success: function(data) {
            cities = M.Autocomplete.init(document.querySelector('#cities'), {
                data: data.cities,
                onBlur: (nearestSubstitute, clickedItem) => {
                    if (!clickedItem) {
                        document.querySelector('#cities').value = nearestSubstitute;
                    }
                }
            })
        }
    });
}

//= Общая инициализация =======================================================
function init(){
    if($('.lazy').length){
        loadScript(PATH + "/jquery.lazy.min.js", () => {
            $('.lazy').lazy();
        })
    }

    datepicker = M.Datepicker.init(document.querySelectorAll('.datepicker'), {
        firstDay: 1,
        i18n: {
            "done": "Принять",
            "cancel": "Отмена",
            months: [
                'Январь',
                'Февраль',
                'Март',
                'Апрель',
                'Май',
                'Июнь',
                'Июль',
                'Август',
                'Сентябрь',
                'Октябрь',
                'Ноябрь',
                'Декабрь'
            ],
            monthsShort: [
                "Янв",
                "Фев",
                "Мрт",
                "Апр",
                "Май",
                "Июн",
                "Июл",
                "Авг",
                "Сен",
                "Окт",
                "Ноя",
                "Дек"
            ],
            "weekdays": [
                "Воскресенье",
                "Понедельник",
                "Вторник",
                "Среда",
                "Четверг",
                "Пятница",
                "Суббота"
            ],
            "weekdaysShort": [
                "Вс",
                "Пн",
                "Вт",
                "Ср",
                "Чт",
                "Пт",
                "Сб"
            ],
            "weekdaysAbbrev": ["В","П","В","С","Ч","П","С"]
        }
    });

    tabs = M.Tabs.init(document.querySelectorAll('.tabs'));

    if($('.swiper-container').length){
        loadScript(PATH + "/swiper-bundle.js", () => {

            if($('#same-author').length){
                sameAuthor = new Swiper('#same-author', swiperOptions('#same-author-navi'))
                sameAuthor.on("slideChangeTransitionEnd", () => {
                    $('.lazy').lazy();
                })
            }

            if($('#same-style').length){
                sameStyle = new Swiper('#same-style', swiperOptions('#same-style-navi'))
                sameStyle.on("slideChangeTransitionEnd", () => {
                    $('.lazy').lazy();
                })
            }

            if($('#other-authors-swiper').length){
                otherAuthors = new Swiper('#other-authors-swiper', swiperOptions('#other-authors-navi', {
                    320: {
                        slidesPerView: 1
                    },
                    1100: {
                        slidesPerView: 2
                    },
                    1600: {
                        slidesPerView: 3
                    }
                }))
                otherAuthors.on("slideChangeTransitionEnd", () => {
                    $('.lazy').lazy();
                })
            }
        })
    }

    if($('.sortable-wrapper').length){
        loadScript("/js/Sortable.min.js", () => {
            sortable = new Sortable(document.querySelector('.sortable-wrapper'), {
                animation: 150,
                onEnd: dragCompleteCallback,
                handle: '.drag-handler'
            })
        });
    }

    $('.modal').modal({
        opacity: .9
    });

    naviSidenav = M.Sidenav.init(document.querySelector('#mobile-navi'));

    if($('#gallery-editor').length){
        editorSidenav = M.Sidenav.init(document.querySelector('#gallery-editor'), {
            edge: "right"
        });
    }

    if($('#chat-sidenav').length){
        chatSidenav = M.Sidenav.init(document.querySelector('#chat-sidenav'), {
            edge: "right"
        });
    }

    $('.chips').chips();

    updateFooterHeight();

    // Заполнение регионов
    if($('#regions').length) {
        $.ajax({
            url: $('#regions').data('url'),
            dataType: "JSON",
            success: function (data) {
                var justSelected = $('#regions').data('region');
                if(justSelected != ''){
                    getCityByRegionsTitle(justSelected);
                }
                regions = M.Autocomplete.init(document.querySelector('#regions'), {
                    data: data.regions,
                    onBlur: (nearestSubstitute, clickedItem) => {
                        if (!clickedItem) {
                            document.querySelector('#regions').value = nearestSubstitute;
                            getCityByRegionsTitle(nearestSubstitute);
                            // console.log("Выбран элемент:" + nearestSubstitute);
                        }
                    },
                    onItemSelect: (liElement) => {
                        getCityByRegionsTitle(liElement.innerText);
                        // console.log("Выбран элемент:" + liElement.innerText);
                    }
                })
            }
        })
    }
}

function toggleEdit(e){
    e.preventDefault();

    var editHtml = "Редактировать <span class='gold-text'>профиль</span>";
    var saveHtml = "Сохранить <span class='gold-text'>изменения</span>";

    editMode = editMode == "edit" ? "view" : "edit";

    if(editMode == "edit"){
        $(".hidden-input").addClass("obvious");
        $(".datepicker").removeClass("hidden");
        $(this).html(saveHtml);
    }else{
        let form = $('#profile-form');
        let fd = new FormData(form[0]);
        $.ajax({
            url: form.data('url'),
            type: 'POST',
            data: fd,
            processData: false,
            contentType: false,
            dataType: 'JSON',
            success: (res)=>{
                if(res.success){
                    $('.error-text').addClass('hidden-block');
                    M.toast({html: "Изменения успешно внесены!"});
                    $(this).html(editHtml);
                    $(".hidden-input").removeClass("obvious");
                    $(".datepicker").addClass("hidden");
                    editMode = 'view';
                }else{
                    for(let error in res.errors){
                        editMode = 'edit';
                        $('#error-'+error).removeClass('hidden-block');
                    }
                }
            },
            error: (err)=>{
                M.toast({html: "Произошла ошибка. Обновите страницу и попробуйте ещё раз."});
                console.error(err);
            }
        });
    }
}

function swiperOptions(naviElement, breakpoints){

    if(!breakpoints){
        breakpoints = {
            320: {
                slidesPerView: 1
            },
            800: {
                slidesPerView: 2
            },
            1200: {
                slidesPerView: 3
            },
            1800: {
                slidesPerView: 4
            }
        }
    }

    return {
        breakpoints: breakpoints,
        spaceBetween: 20,
        loop: true,
        pagination: {
            el: naviElement,
            type: 'bullets',
            clickable: true
        }
    }
}

//= Загрузка внешних скриптов по необходимости ================================
loadScript = (url, callback) => {

    var script = document.createElement("script")
    script.type = "text/javascript";
  
    if (script.readyState){  //IE
        script.onreadystatechange = function(){
            if (script.readyState == "loaded" ||
                    script.readyState == "complete"){
                script.onreadystatechange = null;
                callback();
            }
        };
    } else {  //Others
        script.onload = function(){
            callback();
        };
    }
  
    script.src = url;
    document.getElementsByTagName("head")[0].appendChild(script);
}

function updateFooterHeight(){
    var footerHeight = $('footer').outerHeight();
    $('.global-wrapper').css({
        marginBottom: footerHeight + "px"
    })
}

//   class Swipe{
//       constructor(element){
//           this.xDown = null;
//           this.yDown = null;
//           this.element = typeof(element) === 'string' ? document.querySelector(element) : element;


//       }
//   }

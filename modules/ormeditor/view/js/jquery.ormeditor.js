/**
 * Плагин инициализирует в административной панели работу редактора ORM Объектов
 *
 * @author ReadyScript lab.
 */
(function( $ ){

    $.fn.ormEditor = function( method ) {
        var defaults = {
                addTab: '.rs-orm-add-tab',
                addField: '.rs-orm-add-field',
                removeField: '.rs-remove-field',
                removeTab: '.rs-remove-tab',
                tabNav: '.tab-nav',
                tabContent: '.tab-content'
            },
            args = arguments;

        return this.each(function() {
            var $this = $(this),
                data = $this.data('ormEditor');

            var methods = {
                init: function(initoptions) {
                    if (data) return;
                    data = {}; $this.data('ormEditor', data);
                    data.opt = $.extend({}, defaults, initoptions);

                    $this
                        .on('click', data.opt.addTab, addTab)
                        .on('click', data.opt.addField, addField)
                        .on('click', data.opt.removeField, removeField)
                        .on('click', data.opt.removeTab, removeTab);

                }
            };

            var
                addTab = function() {
                    var tab_name = prompt(lang.t('Название вкладки'), lang.t('Новая вкладка'));

                    var already_exists = false;
                    $(data.opt.tabNav + ' li .title', $this).each(function() {
                        if ($(this).text() === tab_name) {
                            already_exists = true;
                        }
                    });

                    if (already_exists) {
                        $.messenger(lang.t('Вкладка с таким именем уже существует'), {theme:'error'});
                        return false;
                    }

                    if (tab_name) {
                        $.ajaxQuery({
                            url: $(this).data('href'),
                            data: {
                                group: tab_name
                            },
                            success: function(response) {
                                if (response.success) {
                                    $(data.opt.tabNav, $this).append(response.tab);
                                    $(data.opt.tabContent, $this).append(response.tabPane);
                                }
                            }
                        });
                    }
                },

                addField = function() {
                    var container = $(this).closest('.tab-pane').find('.rs-orm-item-list');

                    $.ajaxQuery({
                        url: $(this).data('href'),
                        dataType: 'json',
                        success: function(response) {

                            if (response.success) {
                                container.append(response.html);
                            }
                        }
                    });
                },

                removeField = function() {
                    $(this).closest('tr').remove();
                },

                removeTab = function() {
                    var target = $(this).closest('a').data('target');
                    $(target).remove();
                    var tab = $(this).closest('li');

                    if (tab.prev().length) {
                        tab.prev().find('a').click();
                    }
                    tab.remove();
                };

            if ( methods[method] ) {
                methods[ method ].apply( this, Array.prototype.slice.call( args, 1 ));
            } else if ( typeof method === 'object' || ! method ) {
                return methods.init.apply( this, args );
            }
        });
    };

    $.contentReady(function() {
        $('.rs-orm-editor').ormEditor();
    });

})( jQuery );
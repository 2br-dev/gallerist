class YandexMap {

    constructor(element) {
        this.selector = {
            // form: '.order-shipment-form',
        };
        this.class = {
            button: 'button',
        };
        this.options = {
            center: [55.76, 37.64], // центр карты
            zoom: 10, // масштаб карты
            checkZoomRange: true, // автоматическая корректировка масштаба
            callbackOnInit: false,
        };

        this.owner = element;

        if (this.owner.dataset.yandexMapOptions) {
            this.options = Object.assign(this.options, JSON.parse(this.owner.dataset.yandexMapOptions));
        }

        this.map = new ymaps.Map(this.owner, {
            center: this.options.center,
            zoom: this.options.zoom
        });

        this.owner.addEventListener('click', (event) => {
            let terget = event.target;
            if (terget.closest(this.class.button)) {
                let value = (JSON.parse(terget.closest(this.class.button).dataset.value));
                let event = new CustomEvent('yandexMap-buttonClick', {
                    detail: value,
                    bubbles: true,
                    cancelable: true,
                });
                this.owner.dispatchEvent(event);
            }
        });

        this.callback('OnInit');
    }



    /**
     * Размещает на карте точку
     *
     * @param {number} latitude - широта
     * @param {number} longitude - долгота
     * @param {object} properties - данные метки
     */
    addPoint(latitude, longitude, properties = {}) {
        var newObject = new ymaps.Placemark([latitude, longitude], properties, {});

        this.map.geoObjects.add(newObject);
    }

    setBounds(top, bottom, left, right) {
        this.map.setBounds([[bottom, left], [top, right]], {
            checkZoomRange: this.options.checkZoomRange,
        });
    }

    /**
     * Устанавливает масштаб карты
     *
     * @param {number} zoom - масштаб
     */
    setZoom(zoom) {
        this.map.setZoom(zoom, {
            checkZoomRange: this.options.checkZoomRange,
        });
    }

    /**
     * Устанавливает центр карты
     *
     * @param {number} latitude - широта
     * @param {number} longitude - долгота
     * @param {number} zoom - масштаб
     */
    setCenter(latitude, longitude, zoom = null) {
        if (zoom === null) {
            zoom = this.map.getZoom();
        }
        this.map.setCenter([latitude, longitude], zoom, {
            checkZoomRange: this.options.checkZoomRange,
        });
    }

    htmlButton(value, title, css_class = '') {
        return "<button data-value='" + JSON.stringify(value) + "' class='" + this.class.button + " " + css_class + "'>" + title + "</button>";
    }

    /**
     * Вызывает пользовательский callback
     *
     * @param {string} name - имя функции
     */
    callback(name) {
        let option_name = 'callback' + name;
        if (this.options[option_name]) {
            window[this.options[option_name]](this);
        }
    }

    static init(selector)
    {
        if (!document.querySelector('script[src="https://api-maps.yandex.ru/2.1/?lang=ru_RU"]')) {
            let script = document.createElement('script');
            script.src = 'https://api-maps.yandex.ru/2.1/?lang=ru_RU';
            document.body.appendChild(script);
        }

        let waiting = setInterval(() => {
            if (typeof ymaps != "undefined") {
                clearInterval(waiting);
                ymaps.ready(() => {
                    document.querySelectorAll(selector).forEach((element) => {
                        if (!element.yandexMap) {
                            element.yandexMap = new YandexMap(element);
                        }
                    });
                });
            }
        }, 10);
    }
}

YandexMap.init('.rs-yandexMap');
document.addEventListener('DOMContentLoaded', () => {
    YandexMap.init('.rs-yandexMap');
});

// todo кусочек jQuery в нативном классе
$('body').on('new-content', () => {
    YandexMap.init('.rs-yandexMap');
});
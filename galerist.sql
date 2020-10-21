-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Окт 21 2020 г., 10:51
-- Версия сервера: 5.6.38-log
-- Версия PHP: 7.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `galerist`
--

-- --------------------------------------------------------

--
-- Структура таблицы `gr_access_menu`
--

CREATE TABLE `gr_access_menu` (
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `menu_id` varchar(50) DEFAULT NULL COMMENT 'ID пункта меню',
  `menu_type` enum('user','admin') NOT NULL DEFAULT 'user' COMMENT 'Тип меню',
  `user_id` int(11) DEFAULT NULL COMMENT 'ID пользователя',
  `group_alias` varchar(50) DEFAULT NULL COMMENT 'ID группы'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_access_menu`
--

INSERT INTO `gr_access_menu` (`site_id`, `menu_id`, `menu_type`, `user_id`, `group_alias`) VALUES
(1, '-1', 'user', NULL, 'admins'),
(1, '-2', 'admin', NULL, 'admins'),
(1, '-1', 'user', NULL, 'clients'),
(1, '-1', 'user', NULL, 'guest'),
(1, 'mypictures', 'admin', NULL, 'artist');

-- --------------------------------------------------------

--
-- Структура таблицы `gr_access_module`
--

CREATE TABLE `gr_access_module` (
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `module` varchar(150) DEFAULT NULL COMMENT 'Идентификатор модуля',
  `user_id` int(11) DEFAULT NULL COMMENT 'ID пользователя',
  `group_alias` varchar(50) DEFAULT NULL COMMENT 'ID группы',
  `access` int(11) DEFAULT NULL COMMENT 'Уровень доступа'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_access_module_right`
--

CREATE TABLE `gr_access_module_right` (
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `group_alias` varchar(50) DEFAULT NULL COMMENT 'ID группы',
  `module` varchar(50) DEFAULT NULL COMMENT 'Идентификатор модуля',
  `right` varchar(150) DEFAULT NULL COMMENT 'Идентификатор права',
  `access` enum('allow','disallow') NOT NULL DEFAULT 'allow' COMMENT 'Уровень доступа'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_access_module_right`
--

INSERT INTO `gr_access_module_right` (`site_id`, `group_alias`, `module`, `right`, `access`) VALUES
(1, 'artist', 'catalog', 'create', 'allow'),
(1, 'artist', 'catalog', 'read', 'allow'),
(1, 'artist', 'catalog', 'update', 'allow'),
(1, 'artist', 'catalog', 'delete', 'allow');

-- --------------------------------------------------------

--
-- Структура таблицы `gr_access_site`
--

CREATE TABLE `gr_access_site` (
  `group_alias` varchar(50) DEFAULT NULL COMMENT 'ID группы',
  `user_id` int(11) DEFAULT NULL COMMENT 'ID пользователя',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта, к которому разрешен доступ'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_access_site`
--

INSERT INTO `gr_access_site` (`group_alias`, `user_id`, `site_id`) VALUES
('admins', NULL, 1),
('artist', NULL, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_affiliate`
--

CREATE TABLE `gr_affiliate` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Наименование(регион или город)',
  `alias` varchar(255) DEFAULT NULL COMMENT 'URL имя',
  `parent_id` int(11) DEFAULT NULL COMMENT 'Родитель',
  `clickable` int(11) DEFAULT '1' COMMENT 'Разрешить выбор данного филиала',
  `cost_id` int(11) DEFAULT NULL COMMENT 'Тип цен',
  `short_contacts` mediumtext COMMENT 'Краткая контактная информация',
  `contacts` mediumtext COMMENT 'Контактная информация',
  `coord_lng` decimal(10,6) DEFAULT NULL COMMENT 'Долгота',
  `coord_lat` decimal(10,6) DEFAULT NULL COMMENT 'Широта',
  `skip_geolocation` int(1) NOT NULL DEFAULT '0' COMMENT 'Не выбирать данный филиал с помощью геолокации',
  `sortn` int(11) DEFAULT NULL COMMENT 'Порядк. №',
  `is_default` int(1) NOT NULL COMMENT 'Филиал по умолчанию',
  `is_highlight` int(1) DEFAULT NULL COMMENT 'Выделить филиал визуально',
  `public` int(11) DEFAULT '1' COMMENT 'Публичный',
  `linked_region_id` int(11) DEFAULT NULL COMMENT 'Связанный регион',
  `meta_title` varchar(1000) DEFAULT NULL COMMENT 'Заголовок',
  `meta_keywords` varchar(1000) DEFAULT NULL COMMENT 'Ключевые слова',
  `meta_description` varchar(1000) DEFAULT NULL COMMENT 'Описание'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_antivirus_events`
--

CREATE TABLE `gr_antivirus_events` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата события',
  `component` varchar(255) DEFAULT NULL COMMENT 'Компонент',
  `type` varchar(255) DEFAULT NULL COMMENT 'Тип события',
  `file` varchar(2048) DEFAULT NULL COMMENT 'Путь к файлу',
  `details` mediumblob COMMENT 'Детали проблемы/уязвимости',
  `viewed` int(1) NOT NULL COMMENT 'Флаг просмотра события администратором'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_antivirus_excluded_files`
--

CREATE TABLE `gr_antivirus_excluded_files` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата добавления',
  `component` varchar(255) DEFAULT NULL COMMENT 'Компонент',
  `file` varchar(2048) DEFAULT NULL COMMENT 'Путь к файлу'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_antivirus_request_count`
--

CREATE TABLE `gr_antivirus_request_count` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `ip` varchar(100) DEFAULT NULL COMMENT 'IP адрес',
  `last_time` bigint(11) DEFAULT NULL COMMENT 'Дата последнего запроса в милисекундах',
  `count` int(11) NOT NULL COMMENT 'Количество запросов',
  `malicious_count` int(11) NOT NULL COMMENT 'Количество вредоносных запросов'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_antivirus_request_count`
--

INSERT INTO `gr_antivirus_request_count` (`id`, `ip`, `last_time`, `count`, `malicious_count`) VALUES
(1, '127.0.0.1', 1603266696392, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_article`
--

CREATE TABLE `gr_article` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(150) DEFAULT NULL COMMENT 'Название',
  `alias` varchar(150) DEFAULT NULL COMMENT 'Псевдоним(Ан.яз)',
  `content` mediumtext COMMENT 'Содержимое',
  `parent` int(11) DEFAULT NULL COMMENT 'Рубрика',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата и время',
  `image` varchar(255) DEFAULT NULL COMMENT 'Картинка',
  `user_id` bigint(11) DEFAULT NULL COMMENT 'Автор',
  `rating` decimal(3,1) DEFAULT '0.0' COMMENT 'Средний балл(рейтинг)',
  `comments` int(11) DEFAULT '0' COMMENT 'Кол-во комментариев к статье',
  `public` int(1) NOT NULL DEFAULT '1' COMMENT 'Публичный',
  `attached_products` varchar(10000) DEFAULT NULL COMMENT 'Прикреплённые товары',
  `short_content` mediumtext COMMENT 'Краткий текст',
  `meta_title` varchar(1000) DEFAULT NULL COMMENT 'Заголовок',
  `meta_keywords` varchar(1000) DEFAULT NULL COMMENT 'Ключевые слова',
  `meta_description` varchar(1000) DEFAULT NULL COMMENT 'Описание',
  `affiliate_id` int(11) DEFAULT NULL COMMENT 'Фильтр по городам'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_article_category`
--

CREATE TABLE `gr_article_category` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(150) DEFAULT NULL COMMENT 'Название',
  `alias` varchar(150) DEFAULT NULL COMMENT 'Псевдоним(Ан.яз)',
  `parent` int(11) DEFAULT NULL COMMENT 'Родительская категория',
  `public` int(1) DEFAULT '1' COMMENT 'Показывать на сайте?',
  `sortn` int(11) DEFAULT NULL COMMENT 'Сортировочный индекс',
  `use_in_sitemap` int(11) DEFAULT NULL COMMENT 'Добавлять в sitemap',
  `meta_title` varchar(1000) DEFAULT NULL COMMENT 'Заголовок',
  `meta_keywords` varchar(1000) DEFAULT NULL COMMENT 'Ключевые слова',
  `meta_description` varchar(1000) DEFAULT NULL COMMENT 'Описание',
  `mobile_public` int(1) DEFAULT '0' COMMENT 'Показывать в мобильном приложении',
  `mobile_image` varchar(50) DEFAULT NULL COMMENT 'Идентификатор картинки Ionic 2'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_banner`
--

CREATE TABLE `gr_banner` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название баннера',
  `file` varchar(255) DEFAULT NULL COMMENT 'Баннер',
  `use_original_file` int(11) DEFAULT NULL COMMENT 'Использовать оригинал файла для вставки',
  `link` varchar(255) DEFAULT NULL COMMENT 'Ссылка',
  `targetblank` int(11) DEFAULT NULL COMMENT 'Открывать ссылку в новом окне',
  `info` mediumtext COMMENT 'Дополнительная информация',
  `public` int(1) DEFAULT NULL COMMENT 'Публичный',
  `weight` int(11) DEFAULT '100' COMMENT 'Вес от 1 до 100',
  `use_schedule` varchar(255) DEFAULT '0' COMMENT 'Использовать показ по расписанию?',
  `date_start` datetime DEFAULT NULL COMMENT 'Дата начала показа',
  `date_end` datetime DEFAULT NULL COMMENT 'Дата окончания показа',
  `mobile_banner_type` varchar(255) DEFAULT '0' COMMENT 'Тип баннера',
  `mobile_link` varchar(255) DEFAULT '' COMMENT 'Страницы для показа пользователю',
  `mobile_menu_id` int(11) DEFAULT '0' COMMENT 'Страницы для показа пользователю',
  `mobile_product_id` int(11) DEFAULT '0' COMMENT 'Товар для показа пользователю',
  `mobile_category_id` int(11) DEFAULT '0' COMMENT 'Категория для показа пользователю'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_banner_x_zone`
--

CREATE TABLE `gr_banner_x_zone` (
  `zone_id` int(11) DEFAULT NULL COMMENT 'ID зоны',
  `banner_id` int(11) DEFAULT NULL COMMENT 'ID баннера'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_banner_zone`
--

CREATE TABLE `gr_banner_zone` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `alias` varchar(255) DEFAULT NULL COMMENT 'Симв. идентификатор',
  `width` int(11) DEFAULT NULL COMMENT 'Ширина области, px',
  `height` int(11) DEFAULT NULL COMMENT 'Высота области, px'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_blocked_ip`
--

CREATE TABLE `gr_blocked_ip` (
  `ip` varchar(100) NOT NULL COMMENT 'IP-адрес',
  `expire` datetime DEFAULT NULL COMMENT 'Дата разблокировки',
  `comment` varchar(255) DEFAULT NULL COMMENT 'Комментарий'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_brand`
--

CREATE TABLE `gr_brand` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(250) DEFAULT NULL COMMENT 'Название бренда',
  `alias` varchar(255) DEFAULT NULL COMMENT 'URL имя',
  `public` int(1) DEFAULT '1' COMMENT 'Публичный',
  `image` varchar(255) DEFAULT NULL COMMENT 'Картинка',
  `description` mediumtext COMMENT 'Описание',
  `xml_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор в системе 1C',
  `sortn` int(11) DEFAULT NULL COMMENT 'Сортировочный номер',
  `meta_title` varchar(1000) DEFAULT NULL COMMENT 'Заголовок',
  `meta_keywords` varchar(1000) DEFAULT NULL COMMENT 'Ключевые слова',
  `meta_description` varchar(1000) DEFAULT NULL COMMENT 'Описание'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_cart`
--

CREATE TABLE `gr_cart` (
  `uniq` varchar(10) NOT NULL COMMENT 'ID в рамках одной корзины',
  `type` enum('product','service','coupon') DEFAULT NULL COMMENT 'Тип записи товар, услуга, скидочный купон',
  `entity_id` varchar(50) DEFAULT NULL COMMENT 'ID объекта type',
  `offer` int(11) DEFAULT NULL COMMENT 'Комплектация',
  `multioffers` mediumtext COMMENT 'Многомерные комплектации',
  `amount` decimal(11,3) DEFAULT '1.000' COMMENT 'Количество',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `extra` mediumtext COMMENT 'Дополнительные сведения (сериализованные)',
  `site_id` int(11) NOT NULL COMMENT 'ID сайта',
  `session_id` varchar(32) NOT NULL COMMENT 'ID сессии',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата добавления',
  `user_id` bigint(11) DEFAULT NULL COMMENT 'Пользователь'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_comments`
--

CREATE TABLE `gr_comments` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `type` varchar(150) DEFAULT NULL COMMENT 'Класс комментария',
  `aid` int(12) DEFAULT NULL COMMENT 'Идентификатор объект',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата',
  `user_id` int(11) DEFAULT NULL COMMENT 'Пользователь',
  `user_name` varchar(100) DEFAULT NULL COMMENT 'Имя пользователя',
  `message` mediumtext COMMENT 'Сообщение',
  `moderated` int(1) DEFAULT NULL COMMENT 'Проверено',
  `rate` int(5) DEFAULT NULL COMMENT 'Оценка (от 1 до 5)',
  `help_yes` int(11) NOT NULL COMMENT 'Ответ помог',
  `help_no` int(11) NOT NULL COMMENT 'Ответ не помог',
  `ip` varchar(15) DEFAULT NULL COMMENT 'IP адрес',
  `useful` int(11) NOT NULL COMMENT 'Полезность'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_comments_votes`
--

CREATE TABLE `gr_comments_votes` (
  `ip` varchar(255) DEFAULT NULL COMMENT 'IP пользователя, который оставил комментарий',
  `comment_id` int(11) DEFAULT NULL COMMENT 'ID комментария',
  `help` int(11) DEFAULT NULL COMMENT 'Оценка полезности комментария'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_connect_form`
--

CREATE TABLE `gr_connect_form` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(150) DEFAULT NULL COMMENT 'Название',
  `sortn` int(11) DEFAULT NULL COMMENT 'Сортировочный индекс',
  `email` varchar(250) DEFAULT NULL COMMENT 'Email получения писем',
  `subject` varchar(255) DEFAULT 'Получение письма из формы' COMMENT 'Заголовок письма',
  `template` varchar(255) DEFAULT '%feedback%/mail/default.tpl' COMMENT 'Путь к шаблону письма',
  `successMessage` varchar(255) DEFAULT NULL COMMENT 'Сообщение об успешной отправке формы',
  `use_captcha` int(1) DEFAULT NULL COMMENT 'Использовать каптчу',
  `use_csrf_protection` int(11) DEFAULT NULL COMMENT 'Использовать CSRF защиту'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_connect_form`
--

INSERT INTO `gr_connect_form` (`id`, `site_id`, `title`, `sortn`, `email`, `subject`, `template`, `successMessage`, `use_captcha`, `use_csrf_protection`) VALUES
(1, 1, 'Обратная связь', NULL, NULL, 'Получение письма из формы', '%feedback%/mail/default.tpl', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_connect_form_field`
--

CREATE TABLE `gr_connect_form_field` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(150) DEFAULT NULL COMMENT 'Название',
  `alias` varchar(150) DEFAULT NULL COMMENT 'Псевдоним(Ан.яз)',
  `hint` varchar(150) DEFAULT NULL COMMENT 'Подпись поля',
  `form_id` int(11) DEFAULT NULL COMMENT 'Форма',
  `required` int(11) DEFAULT NULL COMMENT 'Обязательное поле',
  `length` int(11) DEFAULT NULL COMMENT 'Длина поля',
  `show_type` varchar(10) DEFAULT NULL COMMENT 'Тип',
  `anwer_list` mediumtext COMMENT 'Значения списка',
  `show_list_as` varchar(255) DEFAULT NULL COMMENT 'Отображать список как',
  `file_size` int(11) DEFAULT '8192' COMMENT 'Макс. размер файлов (Кб)',
  `file_ext` varchar(150) DEFAULT NULL COMMENT 'Допустимые форматы файлов',
  `use_mask` varchar(20) DEFAULT NULL COMMENT 'Маска проверки',
  `mask` varchar(255) DEFAULT NULL COMMENT 'Произвольная маска проверки',
  `attributes` mediumtext COMMENT 'Список дополнительных атрибутов поля в сериализованном виде',
  `error_text` varchar(255) DEFAULT NULL COMMENT 'Текст ошибки',
  `sortn` int(11) DEFAULT NULL COMMENT 'Сортировочный индекс'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_connect_form_field`
--

INSERT INTO `gr_connect_form_field` (`id`, `site_id`, `title`, `alias`, `hint`, `form_id`, `required`, `length`, `show_type`, `anwer_list`, `show_list_as`, `file_size`, `file_ext`, `use_mask`, `mask`, `attributes`, `error_text`, `sortn`) VALUES
(1, 1, 'Имя', 'name', 'Представьтесь, пожалуйста', 1, 1, NULL, 'string', '', NULL, 8192, '', '', '', NULL, '', 1),
(2, 1, 'E-mail', 'email', 'Электронный ящик, на который будет направлен ответ', 1, 1, NULL, 'email', '', NULL, 8192, '', '', '', NULL, '', 2),
(3, 1, 'Сообщение', 'message', '', 1, 1, NULL, 'text', '', NULL, 8192, '', '', '', NULL, '', 3);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_connect_form_result`
--

CREATE TABLE `gr_connect_form_result` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `form_id` int(11) DEFAULT NULL COMMENT 'Форма',
  `title` varchar(150) DEFAULT NULL COMMENT 'Название',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата отправки',
  `status` enum('new','viewed') NOT NULL DEFAULT 'new' COMMENT 'Статус',
  `ip` varchar(150) DEFAULT NULL COMMENT 'IP Пользователя',
  `sending_url` varchar(255) DEFAULT NULL COMMENT 'URL с которого отравлена форма',
  `stext` mediumtext COMMENT 'Содержимое результата формы',
  `answer` mediumtext COMMENT 'Ответ'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_crm_autotaskrule`
--

CREATE TABLE `gr_crm_autotaskrule` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `enable` int(11) DEFAULT NULL COMMENT 'Включено',
  `rule_if_class` varchar(255) DEFAULT 'crm-createorder' COMMENT 'Когда создавать задачи?',
  `rule_if_data` mediumtext COMMENT 'Дополнительные параметры',
  `rule_then_data` mediumtext COMMENT 'Данные, которые описывают создание связанных задач'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_crm_custom_data`
--

CREATE TABLE `gr_crm_custom_data` (
  `object_type_alias` varchar(50) NOT NULL COMMENT 'Тип объекта, к которому привязан статус',
  `object_id` int(11) NOT NULL COMMENT 'ID объекта',
  `field` varchar(255) NOT NULL COMMENT 'Идентификатор поля',
  `value_float` float DEFAULT NULL COMMENT 'Числовое значение для поиска',
  `value_string` varchar(100) DEFAULT NULL COMMENT 'Строковое значение для поиска',
  `value` mediumtext COMMENT 'Текстовое значение'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_crm_deal`
--

CREATE TABLE `gr_crm_deal` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `deal_num` varchar(20) DEFAULT NULL COMMENT 'Уникальный номер сделки',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название сделки',
  `status_id` int(11) DEFAULT NULL COMMENT 'Статус',
  `manager_id` bigint(11) DEFAULT NULL COMMENT 'Менеджер, создавший сделку',
  `client_type` enum('guest','user') DEFAULT 'guest' COMMENT 'Тип клиента',
  `client_name` varchar(255) DEFAULT NULL COMMENT 'Имя клиента',
  `client_id` bigint(11) DEFAULT NULL COMMENT 'Клиент, для которого создается сделка',
  `date_of_create` datetime DEFAULT NULL COMMENT 'Дата создания',
  `message` mediumtext COMMENT 'Комментарий',
  `cost` decimal(20,2) DEFAULT NULL COMMENT 'Сумма сделки',
  `board_sortn` int(11) DEFAULT NULL COMMENT 'Сортировочный индекс на доске',
  `is_archived` int(11) NOT NULL COMMENT 'Сделка архивная?'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_crm_interaction`
--

CREATE TABLE `gr_crm_interaction` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `title` varchar(255) DEFAULT NULL COMMENT 'Короткое описание',
  `date_of_create` datetime DEFAULT NULL COMMENT 'Дата создания',
  `duration` varchar(255) DEFAULT NULL COMMENT 'Продолжительность',
  `creator_user_id` bigint(11) DEFAULT NULL COMMENT 'Создатель взаимодействия',
  `message` mediumtext COMMENT 'Комментарий'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_crm_link`
--

CREATE TABLE `gr_crm_link` (
  `source_type` varchar(50) DEFAULT NULL COMMENT 'Тип объекта источника',
  `source_id` int(11) DEFAULT NULL COMMENT 'ID объекта источника',
  `link_type` varchar(50) DEFAULT NULL COMMENT 'Тип связываемого объекта ',
  `link_id` int(11) DEFAULT NULL COMMENT 'ID связываемого объекта'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_crm_statuses`
--

CREATE TABLE `gr_crm_statuses` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `object_type_alias` varchar(50) DEFAULT NULL COMMENT 'Тип объекта, к которому привязан статус',
  `title` varchar(255) DEFAULT NULL COMMENT 'Наименование статуса',
  `alias` varchar(50) NOT NULL COMMENT 'Англ. идентификатор',
  `color` varchar(7) DEFAULT NULL COMMENT 'Цвет',
  `sortn` int(11) DEFAULT NULL COMMENT 'Порядок'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_crm_statuses`
--

INSERT INTO `gr_crm_statuses` (`id`, `object_type_alias`, `title`, `alias`, `color`, `sortn`) VALUES
(1, 'crm-task', 'Новая', 'new', '#cc4b83', 1),
(2, 'crm-task', 'Сделать', 'todo', '#edaf3b', 2),
(3, 'crm-task', 'В работе', 'in-work', '#d1cd5a', 3),
(4, 'crm-task', 'На проверке', 'review', '#6fb3f2', 4),
(5, 'crm-task', 'Выполнена', 'complete', '#28c950', 5),
(6, 'crm-deal', 'Новая', 'new', '#c6d460', 1),
(7, 'crm-deal', 'В работе', 'in-work', '#4c4cf5', 2),
(8, 'crm-deal', 'Успешно завершена', 'success', '#3bc753', 3),
(9, 'crm-deal', 'Отменена', 'fail', '#f21d1d', 4);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_crm_task`
--

CREATE TABLE `gr_crm_task` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `task_num` varchar(20) DEFAULT NULL COMMENT 'Уникальный номер задачи',
  `title` varchar(255) DEFAULT NULL COMMENT 'Суть задачи',
  `status_id` int(11) DEFAULT NULL COMMENT 'Статус',
  `description` mediumtext COMMENT 'Описание',
  `date_of_create` datetime DEFAULT NULL COMMENT 'Дата создания',
  `date_of_planned_end` datetime DEFAULT NULL COMMENT 'Планируемая дата завершения задачи',
  `date_of_end` datetime DEFAULT NULL COMMENT 'Фактическая дата завершения задачи',
  `expiration_notice_time` int(11) DEFAULT '300' COMMENT 'Уведомить исполнителя о скором истечении срока выполнении задачи за...',
  `expiration_notice_is_send` int(11) DEFAULT NULL COMMENT 'Было ли отправлено уведомление об истечении срока выполнения задачи?',
  `creator_user_id` bigint(11) DEFAULT NULL COMMENT 'Создатель задачи',
  `implementer_user_id` bigint(11) DEFAULT NULL COMMENT 'Исполнитель задачи',
  `board_sortn` int(11) DEFAULT NULL COMMENT 'Сортировочный индекс на доске',
  `is_archived` int(11) NOT NULL COMMENT 'Задача архивная?',
  `autotask_index` int(11) DEFAULT NULL COMMENT 'Порядковый номер автозадачи',
  `autotask_group` int(11) DEFAULT NULL COMMENT 'Идентификатор группы связанных заказов',
  `is_autochange_status` int(11) DEFAULT NULL COMMENT 'Включить автосмену статуса',
  `autochange_status_rule` mediumtext COMMENT 'Условия для смены статуса'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_crm_task_filter`
--

CREATE TABLE `gr_crm_task_filter` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `user_id` bigint(11) DEFAULT NULL COMMENT 'Пользователь, для которого настраивается фильтр',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название выборки',
  `filters` mediumtext COMMENT 'Значения фильтров',
  `sortn` int(11) DEFAULT NULL COMMENT 'Порядок'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_crm_tel_call_history`
--

CREATE TABLE `gr_crm_tel_call_history` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `provider` varchar(255) DEFAULT NULL COMMENT 'Провайдер тефонных услуг',
  `call_id` varchar(255) DEFAULT NULL COMMENT 'Внутренний ID вызова',
  `call_api_id` varchar(255) DEFAULT NULL COMMENT 'Внешний ID вызова',
  `caller_number` varchar(255) DEFAULT NULL COMMENT 'Номер вызывающего абонента',
  `caller_id` varchar(255) DEFAULT NULL COMMENT 'ID вызывающего абонента',
  `called_number` varchar(255) DEFAULT NULL COMMENT 'Номер вызываемого абонента',
  `called_id` varchar(255) DEFAULT NULL COMMENT 'ID вызываемого абонента',
  `called_public_number` varchar(255) DEFAULT NULL COMMENT 'Публичный номер на который звонит абонент',
  `event_time` datetime DEFAULT NULL COMMENT 'Дата и время звонка',
  `duration` bigint(11) DEFAULT NULL COMMENT 'Время разговора, в микросекундах',
  `record_id` varchar(255) NOT NULL COMMENT 'ID файла записи разговора',
  `call_status` varchar(255) DEFAULT NULL COMMENT 'Статус звонка',
  `call_sub_status` varchar(255) DEFAULT NULL COMMENT 'Результат звонка',
  `call_flow` enum('in','out') DEFAULT NULL COMMENT 'Направление вызова',
  `_custom_data` mediumtext COMMENT 'Произвольные данные',
  `is_closed` int(11) NOT NULL COMMENT 'Звонок принудительно закрыт пользователем'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_csv_map`
--

CREATE TABLE `gr_csv_map` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `schema` varchar(255) DEFAULT NULL COMMENT 'Схема импорта-экспорта',
  `type` enum('export','import') DEFAULT NULL COMMENT 'Тип операции',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название предустановки',
  `_columns` varchar(5000) DEFAULT NULL COMMENT 'Информация о колонках'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_currency`
--

CREATE TABLE `gr_currency` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(3) DEFAULT NULL COMMENT 'Трехсимвольный идентификатор валюты (Ан. яз)',
  `stitle` varchar(10) DEFAULT NULL COMMENT 'Символ валюты',
  `is_base` int(11) DEFAULT NULL COMMENT 'Это базовая валюта?',
  `ratio` float DEFAULT NULL COMMENT 'Коэффициент относительно базовой валюты',
  `public` int(11) DEFAULT NULL COMMENT 'Видимость',
  `default` int(11) DEFAULT NULL COMMENT 'Выбирать по-умолчанию',
  `percent` float DEFAULT '0' COMMENT 'Увеличивать/уменьшать курс на %'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_currency`
--

INSERT INTO `gr_currency` (`id`, `site_id`, `title`, `stitle`, `is_base`, `ratio`, `public`, `default`, `percent`) VALUES
(1, 1, 'RUB', 'р.', 1, 1, 1, 1, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_document_inventorization`
--

CREATE TABLE `gr_document_inventorization` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `applied` int(11) DEFAULT '1' COMMENT 'Проведен',
  `comment` mediumtext COMMENT 'Комментарий',
  `warehouse` int(250) DEFAULT NULL COMMENT 'Склад',
  `fact_amount` int(11) DEFAULT NULL COMMENT 'Фактическое кол-во',
  `calc_amount` int(11) DEFAULT NULL COMMENT 'Расчетное кол-во',
  `dif_amount` int(11) DEFAULT NULL COMMENT 'Разница',
  `date` datetime DEFAULT NULL COMMENT 'Дата',
  `type` varchar(255) DEFAULT NULL COMMENT 'Тип документа'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_document_inventory`
--

CREATE TABLE `gr_document_inventory` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `applied` int(11) DEFAULT '1' COMMENT 'Проведен',
  `comment` mediumtext COMMENT 'Комментарий',
  `archived` int(11) DEFAULT '0' COMMENT 'Заархивирован?',
  `warehouse` int(250) DEFAULT NULL COMMENT 'Склад',
  `date` datetime DEFAULT NULL COMMENT 'Дата',
  `provider` int(11) DEFAULT NULL COMMENT 'Поставщик',
  `type` enum('arrival','waiting','reserve','write_off') DEFAULT NULL COMMENT 'Тип документа',
  `items_count` int(11) DEFAULT NULL COMMENT 'Количество товаров'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_document_inventory_products`
--

CREATE TABLE `gr_document_inventory_products` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `title` varchar(250) DEFAULT NULL COMMENT 'Название',
  `fact_amount` int(11) DEFAULT NULL COMMENT 'Фактическое кол-во',
  `calc_amount` int(11) DEFAULT NULL COMMENT 'Расчетное кол-во',
  `dif_amount` int(11) DEFAULT NULL COMMENT 'Разница',
  `uniq` varchar(250) DEFAULT NULL COMMENT 'uniq',
  `product_id` int(250) DEFAULT NULL COMMENT 'id товара',
  `offer_id` int(250) DEFAULT NULL COMMENT 'id комплектации',
  `document_id` int(250) DEFAULT NULL COMMENT 'id документа'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_document_links`
--

CREATE TABLE `gr_document_links` (
  `source_id` int(11) DEFAULT NULL COMMENT 'id источника',
  `source_type` varchar(255) DEFAULT NULL COMMENT 'тип источника',
  `document_id` varchar(255) DEFAULT NULL COMMENT 'id документа',
  `document_type` varchar(255) DEFAULT NULL COMMENT 'тип документа',
  `order_num` varchar(255) DEFAULT NULL COMMENT 'Номер заказа'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_document_movement`
--

CREATE TABLE `gr_document_movement` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `applied` int(11) DEFAULT '1' COMMENT 'Проведен',
  `comment` mediumtext COMMENT 'Комментарий',
  `warehouse_from` int(250) DEFAULT NULL COMMENT 'Со склада',
  `warehouse_to` int(250) DEFAULT NULL COMMENT 'На склад',
  `date` datetime DEFAULT NULL COMMENT 'Дата',
  `type` varchar(255) DEFAULT NULL COMMENT 'Тип документа'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_document_movement_products`
--

CREATE TABLE `gr_document_movement_products` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `title` varchar(250) DEFAULT NULL COMMENT 'Название',
  `amount` int(11) DEFAULT NULL COMMENT 'Количество',
  `uniq` varchar(250) DEFAULT NULL COMMENT 'uniq',
  `product_id` int(250) DEFAULT NULL COMMENT 'id товара',
  `offer_id` int(250) DEFAULT NULL COMMENT 'id комплектации',
  `document_id` int(250) DEFAULT NULL COMMENT 'id документа'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_document_products`
--

CREATE TABLE `gr_document_products` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `title` varchar(250) DEFAULT NULL COMMENT 'Название',
  `amount` varchar(250) DEFAULT NULL COMMENT 'Количество',
  `uniq` varchar(250) DEFAULT NULL COMMENT 'Уникальный Идентификатор',
  `product_id` int(250) DEFAULT NULL COMMENT 'Id товара',
  `offer_id` int(250) DEFAULT NULL COMMENT 'Id комплектации',
  `warehouse` int(250) DEFAULT NULL COMMENT 'Id склада',
  `document_id` int(250) DEFAULT NULL COMMENT 'Id документа'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_document_products_archive`
--

CREATE TABLE `gr_document_products_archive` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `title` varchar(250) DEFAULT NULL COMMENT 'Название',
  `amount` varchar(250) DEFAULT NULL COMMENT 'Количество',
  `uniq` varchar(250) DEFAULT NULL COMMENT 'Уникальный Идентификатор',
  `product_id` int(250) DEFAULT NULL COMMENT 'Id товара',
  `offer_id` int(250) DEFAULT NULL COMMENT 'Id комплектации',
  `warehouse` int(250) DEFAULT NULL COMMENT 'Id склада',
  `document_id` int(250) DEFAULT NULL COMMENT 'Id документа'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_document_products_start_num`
--

CREATE TABLE `gr_document_products_start_num` (
  `product_id` int(11) DEFAULT NULL COMMENT 'ID товара',
  `offer_id` int(11) DEFAULT NULL COMMENT 'ID комплектации',
  `warehouse_id` int(11) DEFAULT NULL COMMENT 'ID склада',
  `stock` decimal(11,3) DEFAULT '0.000' COMMENT 'Доступно',
  `reserve` decimal(11,3) DEFAULT '0.000' COMMENT 'Резерв',
  `waiting` decimal(11,3) DEFAULT '0.000' COMMENT 'Ожидание',
  `remains` decimal(11,3) DEFAULT '0.000' COMMENT 'Остаток'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_exchange_history`
--

CREATE TABLE `gr_exchange_history` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата обмена',
  `method` varchar(10) DEFAULT NULL COMMENT 'Метод',
  `type` varchar(20) DEFAULT NULL COMMENT 'Тип',
  `mode` varchar(20) DEFAULT NULL COMMENT 'Режим',
  `query` varchar(1024) DEFAULT NULL COMMENT 'Запрос',
  `postsize` int(10) DEFAULT NULL COMMENT 'Размер post',
  `response` mediumtext COMMENT 'Ответ сервера',
  `duration` decimal(10,3) DEFAULT NULL COMMENT 'Время обработки запроса сек.',
  `memory_peak` int(10) DEFAULT NULL COMMENT 'Памяти израсходовано',
  `readed_nodes` int(10) DEFAULT NULL COMMENT 'Позиция, на которой остановился импорт'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_export_external_link`
--

CREATE TABLE `gr_export_external_link` (
  `profile_id` int(11) DEFAULT NULL COMMENT 'id профиля экспорта',
  `product_id` int(11) DEFAULT NULL COMMENT 'id товара на сайте',
  `offer_id` int(11) DEFAULT NULL COMMENT 'id комплектации',
  `ext_id` int(11) DEFAULT NULL COMMENT 'id товара во внешней системе',
  `ext_data` varchar(4000) DEFAULT NULL COMMENT 'произвольные json данные связи',
  `has_changed` int(11) DEFAULT NULL COMMENT 'флаг изменения товара',
  `hash` varchar(50) DEFAULT NULL COMMENT 'Хэш от последних выгруженных данных'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_export_profile`
--

CREATE TABLE `gr_export_profile` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `alias` varchar(150) DEFAULT NULL COMMENT 'URL имя',
  `class` varchar(255) DEFAULT NULL COMMENT 'Класс экспорта',
  `life_time` int(11) DEFAULT NULL COMMENT 'Период экспорта',
  `url_params` varchar(255) DEFAULT NULL COMMENT 'Дополнительные параметры<br/> для ссылки на товар',
  `_serialized` mediumtext,
  `is_exporting` int(11) DEFAULT NULL COMMENT 'Флаг незавершенного экспорта',
  `is_enabled` int(1) DEFAULT '1' COMMENT 'Включен'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_export_vk_cat`
--

CREATE TABLE `gr_export_vk_cat` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `profile_id` int(11) DEFAULT NULL COMMENT 'ID профиля',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название категории в ВК',
  `parent_id` int(11) DEFAULT NULL COMMENT 'ID родителя',
  `vk_id` int(11) DEFAULT NULL COMMENT 'ID категории ВКонтакте'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_export_vk_cat_link`
--

CREATE TABLE `gr_export_vk_cat_link` (
  `dir_id` int(11) NOT NULL COMMENT 'ID категории RS',
  `profile_id` int(11) NOT NULL COMMENT 'ID профиля',
  `vk_cat_id` int(11) NOT NULL COMMENT 'ID категории ВКонтакте'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_external_api_log`
--

CREATE TABLE `gr_external_api_log` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата совершения запроса',
  `request_uri` mediumtext COMMENT 'URL запроса к API',
  `request_params` blob COMMENT 'Параметры запроса',
  `response` mediumblob COMMENT 'Ответ на запрос',
  `ip` varchar(255) DEFAULT NULL COMMENT 'IP-адрес',
  `user_id` int(11) DEFAULT NULL COMMENT 'Пользователь',
  `token` varchar(255) DEFAULT NULL COMMENT 'Авторизационный токен',
  `client_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор клиента',
  `method` varchar(255) DEFAULT NULL COMMENT 'Метод API',
  `error_code` varchar(255) DEFAULT NULL COMMENT 'Код ошибки'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_external_api_token`
--

CREATE TABLE `gr_external_api_token` (
  `token` varchar(255) DEFAULT NULL COMMENT 'Авторизационный токен',
  `user_id` int(11) DEFAULT NULL COMMENT 'ID Пользователя',
  `app_type` varchar(255) DEFAULT NULL COMMENT 'Класс приложения',
  `ip` varchar(255) DEFAULT NULL COMMENT 'IP-адрес',
  `dateofcreate` datetime DEFAULT NULL COMMENT 'Дата создания',
  `expire` int(11) DEFAULT NULL COMMENT 'Срок истечения авторизационного токена'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_external_api_user_allow_methods`
--

CREATE TABLE `gr_external_api_user_allow_methods` (
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `user_id` bigint(11) DEFAULT NULL COMMENT 'Пользователь',
  `api_method` varchar(255) DEFAULT NULL COMMENT 'Имя метода API'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_external_request_cache`
--

CREATE TABLE `gr_external_request_cache` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `date` datetime DEFAULT NULL COMMENT 'Время запроса',
  `source_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор инициатора запроса',
  `request_url` varchar(255) DEFAULT NULL COMMENT 'URL запроса',
  `request_headers` blob COMMENT 'Заголовки запроса',
  `request_params` blob COMMENT 'Параметры запроса',
  `request_hash` varchar(255) DEFAULT NULL COMMENT 'Хэш параметров запроса',
  `idempotence_key` varchar(255) DEFAULT NULL COMMENT 'Ключ идемпотентности',
  `response_status` int(11) DEFAULT NULL COMMENT 'Статус ответа',
  `response_headers` blob COMMENT 'Заголовки ответа',
  `response_body` mediumblob COMMENT 'Тело ответа'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_fast_link`
--

CREATE TABLE `gr_fast_link` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название ссылки',
  `link` varchar(255) DEFAULT NULL COMMENT 'Ссылка',
  `target` enum('window','blank') DEFAULT NULL COMMENT 'Открывать',
  `icon` varchar(255) DEFAULT 'zmdi-open-in-new' COMMENT 'Иконка',
  `bgcolor` varchar(7) DEFAULT '#eeeeee' COMMENT 'Цвет фона иконки',
  `sortn` int(11) DEFAULT NULL COMMENT 'Порядок'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_files`
--

CREATE TABLE `gr_files` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `servername` varchar(50) DEFAULT NULL COMMENT 'Имя файла на сервере',
  `name` varchar(255) DEFAULT NULL COMMENT 'Название файла',
  `description` mediumtext COMMENT 'Описание',
  `size` varchar(255) DEFAULT NULL COMMENT 'Размер файла',
  `mime` varchar(255) DEFAULT NULL COMMENT 'Mime тип файла',
  `access` varchar(255) DEFAULT NULL COMMENT 'Уровень доступа',
  `sortn` int(11) DEFAULT NULL COMMENT 'Порядковый номер',
  `link_type_class` varchar(100) DEFAULT NULL COMMENT 'Класс типа связываемых объектов',
  `link_id` int(11) DEFAULT NULL COMMENT 'ID связанного объекта',
  `xml_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор в сторонней системе',
  `uniq` varchar(32) DEFAULT NULL COMMENT 'Уникальный идентификатор',
  `uniq_name` varchar(255) DEFAULT NULL COMMENT 'Уникальное название файла (url-имя)'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_hash_store`
--

CREATE TABLE `gr_hash_store` (
  `hash` bigint(12) NOT NULL COMMENT 'Хэш ключа',
  `value` varchar(4000) DEFAULT NULL COMMENT 'Значение для ключа'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_hash_store`
--

INSERT INTO `gr_hash_store` (`hash`, `value`) VALUES
(3227350232, 'b:1;'),
(3203139685, 'b:1;'),
(1318362129, 'b:1;'),
(792215500, 'b:1;'),
(876603600, 'b:1;'),
(1263585396, 'b:1;'),
(2721279297, 'b:1;'),
(2774444376, 'b:1;'),
(3410143375, 'b:1;'),
(1380710709, 'b:1;'),
(330477605, 'b:1;'),
(1689616563, 'b:1;'),
(3671498173, 'b:1;'),
(4030504467, 'b:1;'),
(330825122, 'b:1;'),
(3938926908, 'b:1;'),
(2392926377, 'b:1;'),
(2045954494, 'b:1;'),
(2467047061, 'b:1;'),
(2051278907, 'b:1;'),
(2830556431, 'b:1;'),
(880788988, 'b:1;'),
(3492685472, 'b:1;'),
(1658998507, 'b:1;'),
(3540042858, 'b:1;'),
(2270996553, 'b:1;'),
(3796323324, 'b:1;'),
(3681538968, 'b:1;'),
(2363953823, 'b:1;'),
(617101625, 'b:1;'),
(1453263790, 'b:1;'),
(2420634801, 'b:1;'),
(3196438845, 'b:1;'),
(1599035878, 'b:1;'),
(1763814139, 'b:1;'),
(626166410, 'b:1;'),
(3614776887, 'b:1;'),
(1233211065, 'b:1;'),
(2840897447, 'b:1;'),
(2296611849, 'b:1;'),
(4160181905, 'b:1;'),
(3945304734, 'b:1;'),
(2638322274, 'b:1;'),
(2773365246, 'b:1;'),
(2887763448, 'b:1;'),
(2253723831, 'b:1;'),
(1865858434, 'b:1;'),
(4131384376, 'b:1;'),
(105347148, 'b:1;'),
(1982696643, 'b:1;'),
(2552491503, 'b:1;'),
(1757201611, 'b:1;'),
(1906832778, 'b:1;'),
(2839650087, 'b:1;'),
(2618964412, 'b:1;'),
(4170269845, 'b:1;'),
(1770614713, 'b:1;'),
(3848435729, 'b:1;'),
(841392839, 'b:1;'),
(725455750, 'b:1;'),
(3000203793, 'b:1;'),
(1294996616, 'b:1;'),
(22065818, 'b:1;'),
(2448404235, 'b:1;'),
(2454582507, 'b:1;'),
(803055673, 'b:1;'),
(1793915437, 'b:1;'),
(166591280, 'b:1;'),
(3302029545, 's:24:\"2853887939-4584824562448\";'),
(1778353382, 's:445:\"a:44:{i:0;i:1604;i:1;i:36;i:2;i:42;i:3;i:56;i:4;i:40;i:5;i:11;i:6;i:35;i:7;i:1091;i:8;i:9;i:9;i:24;i:10;i:197;i:11;i:1289;i:12;i:21;i:13;i:35;i:14;i:63;i:15;i:10;i:16;i:48;i:17;i:29;i:18;i:26;i:19;i:37;i:20;i:14;i:21;i:170;i:22;i:26;i:23;i:48;i:24;i:12;i:25;i:88;i:26;i:25;i:27;i:10;i:28;i:10;i:29;i:23;i:30;i:23;i:31;i:17;i:32;i:35;i:33;i:13;i:34;i:487;i:35;i:36;i:36;i:7;i:37;i:21;i:38;i:76;i:39;i:30;i:40;i:15;i:41;i:91;i:42;i:109;i:43;i:33;}\";'),
(1236226021, 'i:7624;'),
(3606101029, 's:3:\"153\";'),
(2287582876, 's:3:\"237\";'),
(3236832156, 'b:1;'),
(3420776109, 's:3:\"237\";'),
(290516774, 's:3:\"237\";');

-- --------------------------------------------------------

--
-- Структура таблицы `gr_images`
--

CREATE TABLE `gr_images` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `servername` varchar(25) DEFAULT NULL COMMENT 'Имя файла на сервере',
  `filename` varchar(255) DEFAULT NULL COMMENT 'Оригинальное имя файла',
  `view_count` int(11) DEFAULT NULL COMMENT 'Количество просмотров',
  `size` int(11) DEFAULT NULL COMMENT 'Размер файла',
  `mime` varchar(20) DEFAULT NULL COMMENT 'Mime тип изображения',
  `sortn` int(11) NOT NULL COMMENT 'Порядковый номер',
  `title` mediumtext COMMENT 'Подпись изображения',
  `type` varchar(20) DEFAULT NULL COMMENT 'Название объекта, которому принадлежат изображения',
  `linkid` int(11) DEFAULT NULL COMMENT 'Идентификатор объекта, которому принадлежит изображение',
  `extra` varchar(255) DEFAULT NULL COMMENT 'Дополнительный символьный идентификатор изображения',
  `hash` varchar(50) DEFAULT NULL COMMENT 'Хэш содержимого файла'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_images`
--

INSERT INTO `gr_images` (`id`, `site_id`, `servername`, `filename`, `view_count`, `size`, `mime`, `sortn`, `title`, `type`, `linkid`, `extra`, `hash`) VALUES
(6, 1, 'i/0zpcjdbkw8ak4a4.jpg', '1.jpg', NULL, 130333, 'image/jpeg', 0, '', 'catalog', -1603196086, NULL, '6263a6073eca4a0e8da3658b3941c854'),
(2, 1, 'f/pvms3otjpj3x3cv.jpg', '1.jpg', NULL, 130333, 'image/jpeg', 0, '', 'catalog', -1603193915, NULL, '6263a6073eca4a0e8da3658b3941c854'),
(3, 1, 'g/qymlv4j0oj3b000.jpg', '1.jpg', NULL, 130333, 'image/jpeg', 0, '', 'catalog', -1603194175, NULL, '6263a6073eca4a0e8da3658b3941c854'),
(4, 1, 'a/sgz2a0r03mjpycd.jpg', '1.jpg', NULL, 130333, 'image/jpeg', 0, '', 'catalog', -1603195395, NULL, '6263a6073eca4a0e8da3658b3941c854'),
(5, 1, 'i/andbo4p1kcu8hmc.jpg', '1.jpg', NULL, 130333, 'image/jpeg', 0, '', 'catalog', -1603195841, NULL, '6263a6073eca4a0e8da3658b3941c854'),
(7, 1, 'f/ontejqpwluzoja2.jpg', '1.jpg', NULL, 130333, 'image/jpeg', 0, '', 'catalog', -1603196153, NULL, '6263a6073eca4a0e8da3658b3941c854'),
(8, 1, 'i/6cfp9i3o1p0csw0.jpg', '1.jpg', NULL, 130333, 'image/jpeg', 1, '', 'catalog', -1603196153, NULL, '6263a6073eca4a0e8da3658b3941c854'),
(9, 1, 'g/sw50yfcy7ubwzab.jpg', '1.jpg', NULL, 130333, 'image/jpeg', 0, '', 'catalog', -1603196422, NULL, '6263a6073eca4a0e8da3658b3941c854'),
(10, 1, 'g/x7eparwe4q5n1r0.jpg', '1.jpg', NULL, 130333, 'image/jpeg', 0, '', 'catalog', 8, NULL, '6263a6073eca4a0e8da3658b3941c854');

-- --------------------------------------------------------

--
-- Структура таблицы `gr_license`
--

CREATE TABLE `gr_license` (
  `license` varchar(24) NOT NULL COMMENT 'Лицензионный номер',
  `data` blob,
  `crypt_type` varchar(255) DEFAULT 'mcrypt',
  `type` varchar(50) DEFAULT NULL COMMENT 'Тип лицензии'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_long_polling_event`
--

CREATE TABLE `gr_long_polling_event` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `user_id` bigint(11) DEFAULT NULL COMMENT 'Пользователь-адресат',
  `date_create` datetime DEFAULT NULL COMMENT 'Дата создания события',
  `event_name` varchar(255) DEFAULT NULL COMMENT 'Имя события',
  `json_data` mediumtext COMMENT 'JSON данные, которые следует передать с событием',
  `expire` datetime DEFAULT NULL COMMENT 'Время потери актуальности'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_menu`
--

CREATE TABLE `gr_menu` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `menutype` varchar(70) DEFAULT NULL COMMENT 'Тип меню',
  `title` varchar(150) DEFAULT NULL COMMENT 'Название',
  `hide_from_url` int(1) DEFAULT NULL COMMENT 'Не использовать для построения URL',
  `alias` varchar(150) DEFAULT NULL COMMENT 'Симв. идентификатор',
  `parent` int(11) DEFAULT '0' COMMENT 'Родитель',
  `public` int(1) DEFAULT '1' COMMENT 'Публичный',
  `typelink` varchar(20) DEFAULT 'article' COMMENT 'Тип элемента',
  `sortn` int(11) DEFAULT NULL COMMENT 'Порядк. №',
  `content` mediumtext COMMENT 'Статья',
  `link` varchar(255) DEFAULT NULL COMMENT 'Ссылка',
  `target_blank` int(1) DEFAULT '0' COMMENT 'Открывать ссылку в новом окне',
  `link_template` varchar(255) DEFAULT NULL COMMENT 'Шаблон',
  `affiliate_id` int(11) NOT NULL DEFAULT '0' COMMENT 'Филиал',
  `mobile_public` int(1) DEFAULT '0' COMMENT 'Показывать в мобильном приложении',
  `mobile_image` varchar(50) DEFAULT NULL COMMENT 'Идентификатор картинки Ionic 2',
  `partner_id` int(11) NOT NULL DEFAULT '0' COMMENT 'Партнёрский сайт'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_menu`
--

INSERT INTO `gr_menu` (`id`, `site_id`, `menutype`, `title`, `hide_from_url`, `alias`, `parent`, `public`, `typelink`, `sortn`, `content`, `link`, `target_blank`, `link_template`, `affiliate_id`, `mobile_public`, `mobile_image`, `partner_id`) VALUES
(1, 1, NULL, 'контакты', NULL, 'kontakty', 0, 1, 'affiliate', NULL, NULL, NULL, 0, NULL, 0, 0, NULL, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_module_config`
--

CREATE TABLE `gr_module_config` (
  `site_id` int(11) NOT NULL COMMENT 'ID сайта',
  `module` varchar(150) NOT NULL COMMENT 'Имя модуля',
  `data` mediumtext COMMENT 'Данные модуля'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_module_config`
--

INSERT INTO `gr_module_config` (`site_id`, `module`, `data`) VALUES
(1, 'menu', 'a:4:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856330;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;}'),
(1, 'site', 'a:4:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856331;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;}'),
(1, 'main', 'a:27:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856332;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:13:\"image_quality\";s:2:\"95\";s:9:\"watermark\";N;s:15:\"wmark_min_width\";s:3:\"300\";s:16:\"wmark_min_height\";s:3:\"300\";s:11:\"wmark_pos_x\";s:6:\"center\";s:11:\"wmark_pos_y\";s:6:\"middle\";s:13:\"wmark_opacity\";s:3:\"100\";s:18:\"webp_generate_only\";N;s:21:\"webp_disable_on_apple\";N;s:11:\"csv_charset\";s:12:\"windows-1251\";s:13:\"csv_delimiter\";s:1:\";\";s:17:\"csv_check_timeout\";s:1:\"1\";s:11:\"csv_timeout\";s:2:\"26\";s:14:\"geo_ip_service\";s:9:\"ipgeobase\";s:12:\"dadata_token\";N;s:23:\"long_polling_can_enable\";s:1:\"1\";s:24:\"long_polling_timeout_sec\";s:2:\"20\";s:38:\"long_polling_event_listen_interval_sec\";s:1:\"1\";s:22:\"yandex_js_api_geocoder\";N;s:14:\"dadata_api_key\";N;s:17:\"dadata_secret_key\";N;s:17:\"dadata_enable_log\";i:0;s:21:\"enable_remote_support\";s:1:\"1\";}'),
(1, 'users', 'a:32:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856334;s:7:\"enabled\";i:1;s:11:\"deactivated\";N;s:24:\"generate_password_length\";i:8;s:26:\"replace_country_phone_code\";i:8;s:20:\"country_phone_length\";i:11;s:26:\"default_country_phone_code\";i:7;s:25:\"generate_password_symbols\";s:64:\"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#?\";s:10:\"userfields\";a:0:{}s:19:\"clear_for_last_time\";i:2160;s:12:\"clear_random\";i:5;s:9:\"type_auth\";i:0;s:18:\"type_code_provider\";s:3:\"sms\";s:15:\"two_factor_auth\";i:2;s:19:\"two_factor_register\";i:1;s:18:\"two_factor_recover\";i:0;s:31:\"lifetime_resolved_session_hours\";i:2;s:17:\"register_by_phone\";i:0;s:16:\"send_count_limit\";i:5;s:20:\"resend_delay_seconds\";i:60;s:19:\"block_delay_minutes\";i:20;s:22:\"lifetime_session_hours\";i:2;s:15:\"try_count_limit\";i:10;s:21:\"lifetime_code_minutes\";i:10;s:22:\"ip_limit_session_count\";i:30;s:11:\"code_length\";i:4;s:20:\"two_factor_demo_mode\";i:0;s:14:\"visible_fields\";a:1:{i:0;s:7:\"midname\";}s:14:\"require_fields\";a:3:{i:0;s:6:\"e_mail\";i:1;s:4:\"name\";i:2;s:7:\"surname\";}s:12:\"login_fields\";a:2:{i:0;s:5:\"login\";i:1;s:6:\"e_mail\";}s:18:\"user_one_fio_field\";i:1;}'),
(1, 'modcontrol', 'a:4:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856335;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;}'),
(1, 'alerts', 'a:10:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856337;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:16:\"sms_sender_class\";s:9:\"smsuslugi\";s:16:\"sms_sender_login\";N;s:15:\"sms_sender_pass\";N;s:14:\"sms_sender_log\";i:0;s:25:\"notice_items_delete_hours\";s:3:\"120\";s:17:\"allow_user_groups\";a:2:{i:0;s:10:\"supervisor\";i:1;s:6:\"admins\";}}'),
(0, 'antivirus', 'a:19:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856338;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:20:\"signverify_step_size\";s:2:\"50\";s:30:\"signverify_step_size_intensive\";s:3:\"500\";s:23:\"signverify_auto_recover\";s:1:\"0\";s:19:\"antivirus_step_size\";s:2:\"10\";s:29:\"antivirus_step_size_intensive\";s:3:\"100\";s:26:\"antivirus_max_file_size_kb\";s:3:\"512\";s:22:\"antivirus_auto_recover\";s:1:\"0\";s:26:\"proactive_allowed_interval\";s:4:\"1000\";s:24:\"proactive_block_duration\";s:4:\"3600\";s:20:\"proactive_auto_block\";s:1:\"0\";s:31:\"proactive_trigger_request_count\";s:2:\"30\";s:41:\"proactive_trigger_malicious_request_count\";s:1:\"5\";s:21:\"proactive_trusted_ips\";N;s:29:\"proactive_trusted_user_agents\";N;s:21:\"proactive_trusted_url\";N;}'),
(1, 'article', 'a:6:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856339;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:21:\"preview_list_pagesize\";s:2:\"10\";s:13:\"search_fields\";a:4:{i:0;s:5:\"title\";i:1;s:13:\"short_content\";i:2;s:7:\"content\";i:3;s:13:\"meta_keywords\";}}'),
(1, 'atolonline', 'a:13:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856339;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:11:\"service_url\";N;s:14:\"_load_settings\";N;s:5:\"login\";N;s:4:\"pass\";N;s:10:\"group_code\";N;s:3:\"inn\";N;s:3:\"sno\";N;s:6:\"domain\";N;s:11:\"api_version\";s:1:\"3\";}'),
(1, 'banners', 'a:4:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856343;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;}'),
(1, 'cdn', 'a:6:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856343;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:6:\"domain\";N;s:12:\"cdn_elements\";a:2:{i:0;s:2:\"js\";i:1;s:3:\"img\";}}'),
(1, 'comments', 'a:8:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856345;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:13:\"need_moderate\";s:1:\"N\";s:19:\"allow_more_comments\";s:1:\"0\";s:14:\"need_authorize\";s:1:\"N\";s:23:\"widget_newlist_pagesize\";s:1:\"8\";}'),
(0, 'crm', 'a:19:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856348;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:20:\"widget_task_pagesize\";s:2:\"15\";s:31:\"expiration_task_notice_statuses\";a:1:{i:0;s:1:\"0\";}s:35:\"expiration_task_default_notice_time\";a:1:{i:0;s:3:\"300\";}s:15:\"deal_userfields\";N;s:22:\"interaction_userfields\";N;s:15:\"task_userfields\";N;s:14:\"tel_secret_key\";N;s:19:\"tel_active_provider\";N;s:14:\"tel_enable_log\";N;s:28:\"tel_enable_call_notification\";s:1:\"1\";s:20:\"tel_bottom_offset_px\";s:1:\"0\";s:14:\"telphin_app_id\";N;s:18:\"telphin_app_secret\";N;s:16:\"telphin_user_map\";N;s:23:\"telphin_download_record\";N;}'),
(1, 'designer', 'a:6:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856349;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:14:\"ya_map_api_key\";N;s:17:\"designer_settings\";N;}'),
(1, 'emailsubscribe', 'a:6:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856350;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:17:\"dialog_open_delay\";s:1:\"0\";s:18:\"send_confirm_email\";s:1:\"1\";}'),
(1, 'exchange', 'a:55:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856352;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:13:\"import_scheme\";N;s:28:\"import_offers_in_one_product\";N;s:10:\"file_limit\";s:6:\"204800\";s:7:\"use_zip\";i:1;s:7:\"use_log\";s:1:\"0\";s:13:\"history_depth\";s:1:\"0\";s:20:\"dont_check_sale_init\";i:0;s:20:\"lock_expire_interval\";s:3:\"300\";s:14:\"cat_for_import\";s:1:\"0\";s:24:\"cat_for_catless_porducts\";N;s:23:\"catalog_import_interval\";s:2:\"30\";s:22:\"catalog_element_action\";s:7:\"nothing\";s:20:\"catalog_offer_action\";N;s:22:\"catalog_section_action\";s:7:\"nothing\";s:18:\"product_uniq_field\";s:6:\"xml_id\";s:15:\"is_unic_dirname\";N;s:17:\"hide_new_products\";i:0;s:13:\"hide_new_dirs\";i:0;s:24:\"full_name_to_description\";i:0;s:22:\"catalog_keep_spec_dirs\";s:1:\"1\";s:21:\"catalog_update_parent\";s:1:\"1\";s:18:\"product_update_dir\";s:1:\"1\";s:16:\"dont_delete_prop\";i:1;s:17:\"dont_delete_costs\";N;s:18:\"dont_delete_stocks\";N;s:18:\"dont_update_fields\";N;s:24:\"dont_update_offer_fields\";N;s:24:\"dont_update_group_fields\";N;s:23:\"dont_update_prop_fields\";N;s:31:\"remove_offer_from_product_title\";N;s:23:\"catalog_translit_on_add\";N;s:26:\"catalog_translit_on_update\";N;s:14:\"brand_property\";N;s:12:\"import_brand\";i:0;s:15:\"weight_property\";N;s:22:\"multi_separator_fields\";s:0:\"\";s:24:\"allow_insert_multioffers\";s:1:\"1\";s:20:\"unique_offer_barcode\";i:0;s:20:\"sort_offers_by_title\";i:0;s:22:\"sale_export_only_payed\";N;s:20:\"sale_export_statuses\";a:0:{}s:29:\"sale_final_status_on_delivery\";s:1:\"0\";s:24:\"sale_final_status_on_pay\";N;s:29:\"sale_final_status_on_shipment\";N;s:28:\"sale_final_status_on_success\";N;s:27:\"sale_final_status_on_cancel\";N;s:32:\"order_flag_cancel_requisite_name\";s:14:\"Отменен\";s:21:\"sale_replace_currency\";s:7:\"руб.\";s:19:\"order_update_status\";i:0;s:15:\"export_timezone\";s:7:\"default\";s:16:\"uniq_delivery_id\";N;}'),
(1, 'export', 'a:5:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856353;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:20:\"check_product_change\";N;}'),
(1, 'extcsv', 'a:7:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856354;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:13:\"csv_id_fields\";a:1:{i:0;s:7:\"barcode\";}s:24:\"csv_recommended_id_field\";s:5:\"title\";s:24:\"csv_concomitant_id_field\";s:5:\"title\";}'),
(1, 'externalapi', 'a:13:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856355;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:12:\"allow_domain\";N;s:7:\"api_key\";s:8:\"asfr1lb5\";s:15:\"enable_api_help\";s:1:\"0\";s:27:\"show_internal_error_details\";s:1:\"0\";s:14:\"token_lifetime\";s:8:\"31536000\";s:19:\"default_api_version\";s:1:\"1\";s:18:\"enable_request_log\";N;s:18:\"disable_image_webp\";s:1:\"1\";s:17:\"allow_api_methods\";a:1:{i:0;s:3:\"all\";}}'),
(1, 'feedback', 'a:4:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856356;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;}'),
(1, 'files', 'a:4:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856359;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;}'),
(1, 'install', 'a:4:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856359;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;}'),
(1, 'kaptcha', 'a:12:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856360;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:26:\"rs_captcha_allowed_symbols\";s:29:\"123456789abcdefghikmnpqrstuvw\";s:17:\"rs_captcha_length\";s:1:\"6\";s:16:\"rs_captcha_width\";s:3:\"100\";s:17:\"rs_captcha_height\";s:2:\"42\";s:21:\"recaptcha_v3_site_key\";N;s:23:\"recaptcha_v3_secret_key\";N;s:26:\"recaptcha_v3_success_score\";s:3:\"0.5\";s:25:\"recaptcha_v3_hide_sticker\";N;}'),
(1, 'marketplace', 'a:5:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856360;s:7:\"enabled\";i:1;s:11:\"deactivated\";N;s:20:\"allow_remote_install\";i:0;}'),
(1, 'mobilemanagerapp', 'a:6:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856361;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:17:\"allow_user_groups\";a:2:{i:0;s:10:\"supervisor\";i:1;s:6:\"admins\";}s:11:\"push_enable\";s:1:\"1\";}'),
(1, 'mobilesiteapp', 'a:21:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856361;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:13:\"default_theme\";s:13:\"mobilesiteapp\";s:17:\"allow_user_groups\";a:4:{i:0;s:10:\"supervisor\";i:1;s:6:\"admins\";i:2;s:7:\"clients\";i:3;s:5:\"guest\";}s:11:\"disable_buy\";s:1:\"0\";s:11:\"push_enable\";s:1:\"1\";s:11:\"banner_zone\";s:1:\"0\";s:12:\"mobile_phone\";s:0:\"\";s:8:\"root_dir\";s:1:\"0\";s:21:\"tablet_root_dir_sizes\";s:10:\"ssMssMssss\";s:17:\"products_pagesize\";s:2:\"20\";s:13:\"menu_root_dir\";s:1:\"0\";s:16:\"top_products_dir\";s:1:\"0\";s:21:\"top_products_pagesize\";s:1:\"8\";s:18:\"top_products_order\";s:5:\"title\";s:20:\"mobile_products_size\";s:1:\"6\";s:20:\"tablet_products_size\";s:1:\"4\";s:21:\"article_root_category\";N;s:18:\"enable_app_sticker\";s:1:\"1\";}'),
(1, 'notes', 'a:5:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856366;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:22:\"widget_notes_page_size\";s:2:\"10\";}'),
(1, 'pageseo', 'a:4:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856367;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;}'),
(1, 'photo', 'a:8:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856369;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:22:\"original_photos_resize\";s:1:\"1\";s:21:\"original_photos_width\";s:4:\"1500\";s:22:\"original_photos_height\";s:4:\"1500\";s:23:\"product_sort_photo_desc\";s:1:\"0\";}'),
(1, 'photogalleries', 'a:4:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856370;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;}'),
(1, 'pushsender', 'a:6:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856371;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:20:\"googlefcm_server_key\";N;s:10:\"enable_log\";N;}'),
(1, 'search', 'a:8:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856372;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:14:\"search_service\";s:26:\"\\Search\\Model\\Engine\\Mysql\";s:11:\"search_type\";s:4:\"like\";s:41:\"search_type_likeplus_spell_checker_enable\";s:1:\"0\";s:35:\"search_type_likeplus_ignore_symbols\";s:50:\"`~!@#$%^&amp;*()-_=+\\|[]{};:&quot;\',.&lt;&gt;/?№\";}'),
(1, 'sitemap', 'a:11:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856373;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:8:\"priority\";s:3:\"0.5\";s:10:\"changefreq\";s:8:\"disabled\";s:28:\"set_generate_time_as_lastmod\";N;s:8:\"lifetime\";s:4:\"1440\";s:8:\"add_urls\";N;s:12:\"exclude_urls\";N;s:20:\"max_chunk_item_count\";s:5:\"50000\";}'),
(1, 'siteupdate', 'a:5:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856375;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:26:\"file_download_part_size_mb\";s:1:\"7\";}'),
(1, 'statistic', 'a:5:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856377;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:22:\"consider_orders_status\";a:1:{i:0;s:1:\"0\";}}'),
(1, 'support', 'a:6:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856377;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:25:\"send_admin_message_notice\";s:1:\"Y\";s:24:\"send_user_message_notice\";s:1:\"Y\";}'),
(1, 'tags', 'a:4:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856380;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;}'),
(1, 'templates', 'a:4:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856382;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;}'),
(1, 'yandexmarketcpa', 'a:52:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856385;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:15:\"secret_part_url\";s:8:\"4lkzqm3y\";s:10:\"auth_token\";N;s:6:\"ytoken\";N;s:13:\"ytoken_expire\";N;s:11:\"campaign_id\";N;s:10:\"enable_log\";N;s:20:\"ignore_city_unexists\";s:1:\"1\";s:20:\"disable_status_graph\";N;s:18:\"reserve_until_days\";s:1:\"3\";s:15:\"min_pickup_days\";s:1:\"1\";s:15:\"max_pickup_days\";s:2:\"14\";s:24:\"payment_cash_on_delivery\";i:2;s:24:\"payment_card_on_delivery\";i:3;s:15:\"payment_generic\";i:1;s:16:\"status_cancelled\";s:1:\"6\";s:24:\"status_cancelled_reverse\";a:1:{i:0;s:1:\"6\";}s:15:\"status_delivery\";i:7;s:23:\"status_delivery_reverse\";a:1:{i:0;i:7;}s:16:\"status_delivered\";s:1:\"5\";s:24:\"status_delivered_reverse\";a:1:{i:0;s:1:\"5\";}s:13:\"status_pickup\";i:8;s:21:\"status_pickup_reverse\";a:1:{i:0;i:9;}s:17:\"status_processing\";s:1:\"1\";s:25:\"status_processing_reverse\";a:1:{i:0;s:1:\"1\";}s:15:\"status_reserved\";i:9;s:23:\"status_reserved_reverse\";N;s:13:\"status_unpaid\";s:1:\"2\";s:21:\"status_unpaid_reverse\";a:1:{i:0;s:1:\"2\";}s:28:\"substatus_processing_expired\";s:1:\"1\";s:36:\"substatus_processing_expired_reverse\";a:1:{i:0;s:1:\"1\";}s:25:\"substatus_replacing_order\";s:1:\"2\";s:33:\"substatus_replacing_order_reverse\";a:1:{i:0;s:1:\"2\";}s:29:\"substatus_reservation_expired\";s:1:\"3\";s:37:\"substatus_reservation_expired_reverse\";a:1:{i:0;s:1:\"3\";}s:21:\"substatus_shop_failed\";s:1:\"4\";s:29:\"substatus_shop_failed_reverse\";a:1:{i:0;s:1:\"4\";}s:27:\"substatus_user_changed_mind\";s:1:\"5\";s:35:\"substatus_user_changed_mind_reverse\";a:1:{i:0;s:1:\"5\";}s:23:\"substatus_user_not_paid\";s:1:\"6\";s:31:\"substatus_user_not_paid_reverse\";a:1:{i:0;s:1:\"6\";}s:31:\"substatus_user_refused_delivery\";s:1:\"7\";s:39:\"substatus_user_refused_delivery_reverse\";a:1:{i:0;s:1:\"7\";}s:30:\"substatus_user_refused_product\";s:1:\"8\";s:38:\"substatus_user_refused_product_reverse\";a:1:{i:0;s:1:\"8\";}s:30:\"substatus_user_refused_quality\";s:1:\"9\";s:38:\"substatus_user_refused_quality_reverse\";a:1:{i:0;s:1:\"9\";}s:26:\"substatus_user_unreachable\";s:2:\"10\";s:34:\"substatus_user_unreachable_reverse\";a:1:{i:0;s:2:\"10\";}}'),
(1, 'catalog', 'a:75:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856402;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:12:\"default_cost\";i:1;s:8:\"old_cost\";s:1:\"0\";s:23:\"hide_unobtainable_goods\";s:1:\"N\";s:14:\"list_page_size\";s:2:\"12\";s:13:\"items_on_page\";N;s:18:\"list_default_order\";s:5:\"sortn\";s:28:\"list_default_order_direction\";s:3:\"asc\";s:23:\"list_order_instok_first\";i:0;s:20:\"list_default_view_as\";s:6:\"blocks\";s:12:\"default_unit\";s:10:\"грамм\";s:15:\"concat_dir_meta\";s:1:\"1\";s:12:\"auto_barcode\";s:6:\"a{n|6}\";s:20:\"disable_search_index\";s:1:\"0\";s:11:\"price_round\";s:4:\"0.01\";s:8:\"cbr_link\";N;s:24:\"cbr_auto_update_interval\";i:1440;s:18:\"cbr_percent_update\";i:0;s:14:\"use_offer_unit\";s:1:\"0\";s:21:\"import_photos_timeout\";s:2:\"20\";s:15:\"use_seo_filters\";s:1:\"0\";s:17:\"show_all_products\";s:1:\"0\";s:17:\"price_like_slider\";s:1:\"0\";s:13:\"search_fields\";a:5:{i:0;s:10:\"properties\";i:1;s:7:\"barcode\";i:2;s:5:\"brand\";i:3;s:17:\"short_description\";i:4;s:13:\"meta_keywords\";}s:23:\"not_public_category_404\";s:1:\"0\";s:22:\"not_public_product_404\";s:1:\"1\";s:27:\"not_public_property_dir_404\";s:1:\"1\";s:29:\"link_property_to_offer_amount\";N;s:17:\"dependent_filters\";s:1:\"0\";s:11:\"clickfields\";N;s:13:\"buyinoneclick\";s:1:\"1\";s:18:\"dont_buy_when_null\";s:1:\"0\";s:22:\"oneclick_name_required\";s:1:\"1\";s:13:\"csv_id_fields\";a:2:{i:0;s:5:\"title\";i:1;s:7:\"barcode\";}s:30:\"csv_offer_product_search_field\";s:5:\"title\";s:22:\"csv_offer_search_field\";s:5:\"sortn\";s:22:\"csv_dont_delete_stocks\";N;s:21:\"csv_dont_delete_costs\";N;s:20:\"csv_file_upload_type\";s:1:\"0\";s:22:\"csv_file_upload_access\";s:6:\"hidden\";s:22:\"brand_products_specdir\";s:1:\"0\";s:18:\"brand_products_cnt\";s:1:\"8\";s:32:\"brand_products_hide_unobtainable\";N;s:16:\"warehouse_sticks\";s:12:\"1,5,15,25,50\";s:24:\"inventory_control_enable\";s:1:\"0\";s:16:\"ic_enable_button\";i:0;s:19:\"provider_user_group\";N;s:16:\"csv_id_fields_ic\";s:7:\"barcode\";s:19:\"yuml_import_setting\";s:1:\"0\";s:18:\"import_yml_timeout\";s:2:\"20\";s:18:\"import_yml_cost_id\";N;s:22:\"catalog_element_action\";N;s:22:\"catalog_section_action\";N;s:19:\"save_product_public\";s:1:\"1\";s:16:\"save_product_dir\";s:1:\"1\";s:18:\"dont_update_fields\";N;s:14:\"use_htmlentity\";i:0;s:13:\"increase_cost\";i:0;s:14:\"use_vendorcode\";s:8:\"offer_id\";s:26:\"default_product_meta_title\";N;s:29:\"default_product_meta_keywords\";N;s:32:\"default_product_meta_description\";N;s:14:\"default_weight\";s:1:\"0\";s:11:\"weight_unit\";s:1:\"g\";s:23:\"property_product_length\";N;s:22:\"default_product_length\";s:1:\"0\";s:22:\"property_product_width\";N;s:21:\"default_product_width\";s:1:\"0\";s:23:\"property_product_height\";N;s:22:\"default_product_height\";s:1:\"0\";s:15:\"dimensions_unit\";s:2:\"sm\";s:27:\"affiliate_stock_restriction\";N;}'),
(1, 'shop', 'a:70:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856412;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:14:\"basketminlimit\";s:1:\"0\";s:20:\"basketminweightlimit\";N;s:14:\"check_quantity\";s:1:\"0\";s:28:\"allow_buy_num_less_min_order\";N;s:40:\"allow_buy_all_stock_ignoring_amount_step\";N;s:19:\"check_cost_for_zero\";N;s:18:\"first_order_status\";i:2;s:21:\"user_orders_page_size\";s:2:\"10\";s:11:\"reservation\";s:1:\"0\";s:27:\"reservation_required_fields\";s:11:\"phone_email\";s:28:\"allow_concomitant_count_edit\";s:1:\"0\";s:11:\"source_cost\";N;s:18:\"auto_change_status\";N;s:24:\"auto_change_timeout_days\";N;s:23:\"auto_change_from_status\";N;s:21:\"auto_change_to_status\";N;s:23:\"auto_send_supply_notice\";s:1:\"1\";s:18:\"courier_user_group\";N;s:15:\"ban_courier_del\";s:1:\"0\";s:25:\"remove_nopublic_from_cart\";s:1:\"0\";s:28:\"show_number_of_lines_in_cart\";s:1:\"1\";s:17:\"default_region_id\";s:1:\"0\";s:23:\"use_geolocation_address\";s:1:\"1\";s:32:\"use_selected_address_in_checkout\";s:1:\"1\";s:43:\"regions_marked_when_change_selected_address\";N;s:20:\"use_personal_account\";s:1:\"1\";s:20:\"nds_personal_account\";N;s:31:\"personal_account_payment_method\";s:7:\"advance\";s:32:\"personal_account_payment_subject\";s:7:\"payment\";s:10:\"userfields\";N;s:20:\"default_checkout_tab\";s:6:\"person\";s:15:\"default_zipcode\";s:0:\"\";s:15:\"require_country\";s:1:\"1\";s:14:\"require_region\";s:1:\"1\";s:12:\"require_city\";s:1:\"1\";s:15:\"require_zipcode\";s:1:\"0\";s:15:\"require_address\";s:1:\"1\";s:13:\"check_captcha\";s:1:\"1\";s:19:\"show_contact_person\";s:1:\"1\";s:27:\"require_email_in_noregister\";s:1:\"1\";s:27:\"require_phone_in_noregister\";s:1:\"0\";s:26:\"myself_delivery_is_default\";i:0;s:21:\"require_license_agree\";N;s:17:\"license_agreement\";N;s:23:\"use_generated_order_num\";s:1:\"0\";s:23:\"generated_ordernum_mask\";s:3:\"{n}\";s:26:\"generated_ordernum_numbers\";s:1:\"6\";s:13:\"hide_delivery\";s:1:\"0\";s:12:\"hide_payment\";s:1:\"0\";s:13:\"manager_group\";i:0;s:18:\"set_random_manager\";N;s:18:\"cashregister_class\";s:10:\"atolonline\";s:23:\"cashregister_enable_log\";s:1:\"0\";s:30:\"cashregister_enable_auto_check\";s:1:\"1\";s:3:\"ofd\";s:11:\"platformofd\";s:14:\"payment_method\";s:15:\"full_prepayment\";s:13:\"return_enable\";s:1:\"0\";s:12:\"return_rules\";s:2104:\"\n            <p>Статья 25. Право потребителя на обмен товара надлежащего качества</p>\n            <p>1. Потребитель вправе обменять непродовольственный товар надлежащего качества на аналогичный товар у продавца, у которого этот товар был\n            приобретен, если указанный товар не подошел по форме, габаритам, фасону, расцветке, размеру или комплектации.\n            Потребитель имеет право на обмен непродовольственного товара надлежащего качества в течение четырнадцати дней, не считая дня его покупки.\n            Обмен непродовольственного товара надлежащего качества проводится, если указанный товар не был в употреблении, сохранены его товарный вид,\n            потребительские свойства, пломбы, фабричные ярлыки, а также имеется товарный чек или кассовый чек либо иной подтверждающий оплату указанного\n            товара документ. Отсутствие у потребителя товарного чека или кассового чека либо иного подтверждающего оплату товара документа не лишает его\n            возможности ссылаться на свидетельские показания.</p>\n            <p>Перечень товаров, не подлежащих обмену по основаниям, указанным в настоящей статье, утверждается Правительством Российской Федерации.</p>\n            \n        \";s:21:\"return_print_form_tpl\";s:26:\"%shop%/return/pdf_form.tpl\";s:17:\"discount_code_len\";s:2:\"10\";s:32:\"fixed_discount_max_order_percent\";s:3:\"100\";s:20:\"discount_combination\";s:3:\"max\";s:26:\"old_cost_delta_as_discount\";N;s:22:\"cart_item_max_discount\";s:3:\"100\";s:31:\"check_conformity_uit_to_barcode\";s:1:\"1\";s:28:\"create_receipt_upon_shipment\";N;}'),
(1, 'affiliate', 'a:7:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856418;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:10:\"use_geo_ip\";N;s:18:\"coord_max_distance\";s:1:\"4\";s:19:\"confirm_city_select\";s:1:\"0\";}'),
(1, 'partnership', 'a:10:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600856419;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;s:10:\"main_title\";N;s:19:\"main_short_contacts\";N;s:13:\"main_contacts\";N;s:11:\"coordinates\";a:3:{s:7:\"address\";s:0:\"\";s:3:\"lat\";d:55.7533;s:3:\"lng\";d:37.6226;}s:23:\"redirect_to_geo_partner\";N;s:29:\"show_confirmation_geo_partner\";N;}'),
(0, 'ormeditor', 'a:4:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600868382;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;}'),
(1, 'codegen', 'a:4:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600868521;s:7:\"enabled\";b:1;s:11:\"deactivated\";N;}'),
(1, 'gallerist', 'a:5:{s:9:\"installed\";b:1;s:10:\"lastupdate\";i:1600869308;s:7:\"enabled\";i:1;s:11:\"deactivated\";N;s:13:\"city_property\";i:1;}');

-- --------------------------------------------------------

--
-- Структура таблицы `gr_module_license`
--

CREATE TABLE `gr_module_license` (
  `module` varchar(255) NOT NULL COMMENT 'Имя модуля',
  `data` blob COMMENT 'Данные лицензии'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_module_license`
--

INSERT INTO `gr_module_license` (`module`, `data`) VALUES
('designer', 0x3366646434313166366136323866386335346465643265363562353337313662376630303837633766393935643239613666313238656266356261623238646639663330383830316337626536373939663439346338336362393137363965353165663332343165393232303831393734633365346163633932623239393365626365656466613735393866343731626534343833333534633434323035306263653839386534326164646366613165666234396664366434353634366434646461306563663538336438303363336436656665643061393631633862633033626661353164653032633539646330383833633430383334346434353263396665663837663738333231343962396639306261383130333532666234303463313937333462363463353630653365333131396265383863326432643364373165653239336666376631383164373835336566653862353430336562323338336135393930353633663463373364643463333265336364333961326431363037653134666265383130643137323436353563323263643863383433616231386130356132303864666336656163326163656265633963343430613163303531613863656436636433373739336233396235336533636135643766333233386433373236303530366466613965346633376531333662346235663435343738356466),
('#default', 0x3834653234343030383434396530313637373565383266346136646635303265623930656266386330666663356331626331643636373135353162316232616537366336363863663336316462623363393664653235616534356362633535626133326137613062336565373432343864626335613766623333336363393139373230366663613762353334353236303839346365356563333563356163666334333739396634356334633738346330383032366566323531383032303362306361393937376663653638393834336336366234646638663864366238646264393761336231323437646138376337316332363438373734343764303261343565363863643531336234373063373765343636333961613630326232653935356636346565343161646666393033383933336131333762646432303132646265383339306539333561326539623836373865336561353562666663353934343164626631313061333939623739353965383033306238396132633563643035366566613461386634333238353536626333636561383736336338376238323835346661333133363933353163396265373237663139333939313334363337353461323132633030343532343163323664636236373339316635316165323964636261356333363439616364346131646539613337386165323538343234613437),
('#fashion', 0x3730306366323430306566396637646139383630383631653236646236366465633439383262653963343336383362363232376230353165353633643237623130666139343233626562333339366133383035363534306636646266613233646466306164366439633765373534326631393730616433616161323732366666303332306364393464643063383062383439336232316434326465643934636631303666616166323038366139383564313336376164643839386137376165306166656464633136373333616632356234326632666538303164366632666631343336326530363462346366383430623364376664313336383365363430333263663039633636333833323132396463386165393464643833343164633661613337323039343766613031303732356237356538633338306237356163373931373935643337346566383362386137653163363263656637366565336632346630643866363366373061616436383639313834653261626562623732626237346438303861373739313765376338393164633632316637363264316535326233356530633661666164363964303031326463353639306339333764626162613261336263343837353634646237383761633862613764343166306133366432626132346162326466393538346438616161353438346433353163666137386262),
('#flatlines', 0x3462333563663033653137323365383036306230613038383033333764396532333765316265323563363332313465346534383138613835663639316562313964613831326335343235316639396261636331303832313739623437653234623866376563333964373262346336653335393566383738643466326237383563643637626462663862343163343637346466656436306132616166623662343564353935343535626364323762313938653838633335383638393962623333316637666463363730383035313336623030383039313965333333626531623938333137633362393235663435353332613530316161386631326336616136623937323066346365666330616636613133306331396365666131346262336639323232663832653632636538373730383366393539306432643335366138363630333731623034636633663039613064373537363239323563643534626432646333653133316333343439323633353034653534396566326163376235636563323239393965386333626364323766313339666465303430643232363063326336643739326439323338623564336261626261343934373134333233333863363061653034306663306462366363636337383230613237393263373765303264346166613634353635623566373638393862656432373739313630666438646162),
('#perfume', 0x3766626562663835613462373230353961643833636561316231356639313962613461636465383138623535613263353262353761303030613236653738663833373562313939643737396462333235313061656365666432633065663835383431636531383636643332376138663562376233653566663866643265306464353534366635363935366336353236356564323630303630643933343431663838353432623832313833383263343031373537373433623030336137303437356337653535616135326535333837373736333565616531343465363764343563626631313938303531393934313365356366393531326163333639393431666331393966626637303533363862353466643739376161343530633338336330396338653066663633336131383032303834326637653465666161363263306264343265373164326131643436343435633930383632323138366463366639363930353932323430333062356439323739663237353935646663356362613263363963326366303835323464333562346661373438613061636463393434343334646136633938633566666331643161343766353365386139303363316337366333303066336462373334316161646133333230383662623763653763633732616130336564343863613032633132356565613735386562383963396236623765),
('#young', 0x3639353036333437623266353136623737633938626430653236326361633138353435613762313563393565313361623238333465366362616533646335643661636630313739366463333738663866363332333764366236653535316235663030313866623339383138376639313631346462303432643234343363626461626531366662343032303831616639346233316138383666656562326138626631316435373531343031353637303766303633326630613336306566373863626334316338383138353636396638653239656437666135613162326538336164356231393763636131353738663232636536353433626238393533343733336431383063653339343338313462323562353733313765343931316666333939393864343931653732303039386462643838653436376130393536303762366238313537366265366561353664316431343330326563373461613233373034333036326634303037666639663062643639356534373361613938633662356464633537656131663738343836613533353361313831396630303634376632616231346530353864613863333832346539383737303433383135343237373631633833356665313834653637656666646633646463623533646430343831316565663336643766366534343131663765363832633231366365613234623033326437),
('galerist', 0x3164303165333035316430383461393765643932646133386236643138363766336236376236663131323831326661356237396531666637373937653234303263343139346365373638393763366438333761613332646431326332303830633264663861343239653837313463383937323638386532323037666532333662313637356464653364393138653135383762326434626138326164313664353463333435653133396163393030323530373137343963396333623033633761623631303238303861313237363737343661386133363232653036333764633336373762346538623030396337313031373939393462316433393631353535396439646430353961663565323731343136336165396537313465613461653939306438373235393062623733633135393136633137336236356664323664326462353930633437386336643463646338323661346135666665653763306261336431663833353233343132643130396663323735653130366236636264363966303862336364346139383935353036313162386662626137666231346464623333313732356537313663653563333530643165643734313333623339303236343439303538383739663564386233663335303963383935343337633439663931386430623331303330623736316238653831653939373832613333633738396166),
('ormeditor', 0x3235326363373962336362613334363661633737316661613431386533363762663464653462386331626235376535366138386462663336613130396261313562393163346135616364623530376532396632623561396130306139356639386665306263316262326161373362356333303265366136623639343434643336303537633731303532386365663462303565316335343337666539386266346661646138366230646131343263393839393234353532363363633530353438356532363735306633636366633437396366343635303363383831393633316563646266383830613064373664656632623837333036343562363834653031393239633665626264346163393137306336346464646436323262663332653736373861326431616331623366313936343539373663653438313363333662633366303931353632383036373134666235366635383232616233613336613665326463363136373466386232376463303162323264383331306465343665356165316664323062636264636235376639343963613639633763343237306365393635643130646630613865343461313135336132386162353037333335363964383536656136386339626431666532396434636363383366326330323066346239613761366362313030343531336639613464353737626463393330623564656438),
('codegen', 0x6162383239343565616337633032303739353933633536333538626562353765663262363237633461313264303830653733336131323165396238356634656639366634363739346139643131363434376162666366656266303037633535363165346463343336623166343034646631396234623766323562343530346131613263653065396635306533393565333430616636396539613864333065376436373934633039366566336661666161386131646432656431386333643832626263326532363732373039323337633738636338303463613437663431363966353234656531646661306533613731626335343933643834656632373332623665323838626436316565663733356638363161353931373339643832343764646633383934393166306133383632653330306166316161313631633236323037663163353838613230363331386165393964663764313737656633353664383165306564663463363333386638376638633763636662636334333639383063363464663639636433383733313933306666363236383734333062623034643137666265633966323565666664396235643762343634666536623435326263336332663065373338636565613130633564626633326237363538383631346637303563343130383337313262393265643737383034663661303439646164613266),
('gallerist', 0x3235373763396264326264333839383566383264646230643235363130636366373863613161393830643233613836366134333431383263643464346536363139393364356665303563373962343364643131653264313233316631643335363836653639653836613366393964306262633838623861323631323938306230336563376630376236326263326237353062653136613739323938623561646437376365393637626135323336656563363662373436316133663230313337333438636331393733316439303739303561376536376663323762326534363632636239633864663939636634383830663034646637356361353636303232336430373630363339376564366664633033393562306533333063373564333631376531326235383131373430656163373630663264346463303339633965633231336361353030363033396333663661373066323933306366363335666330613063613235343266333030356638623864633136343736313233643436353930633166333230343962363834383539366238353234326234653233336531633932623066376431303361643263386139656136313834333633393431313131353363663434333732393739656165653738303235366538333762376137323435663330366131306262643063323633373266626266373265383735636263666133),
('#gallerist', 0x3930336438303239353564383964336437666637303963363437616237663231383234386362343336646666313435353530313535633831336431643835623861353132656533643163383064333565383466626333666637653137313437366364633732353464626361623036353365613531393366393037383130303263626535376238356639623430643234393138653065343235333962623331643034623264306266636435366138376530613231353464643566333232613938396232396661666566643664396633356366643235343164663836376463323734666266386535653530643162643531333030313365366665366561346563323361313432633631356165663161623234383039353633636565326136626132393935373630633461303566613536383439396438333264616338376134303436306265383337633339666338366562333966343832646132373332396136333164353731303063396439633264386463383633613537656132346664313666386634613534613461363539373732313931626562386462633264663635363466306436376133663161386433643364653634636231316161393236346434616463613331636461373138636437363062396265396531306234363330613532326639613831383835333734643837383037613964303130386662663334346538);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_notes_note`
--

CREATE TABLE `gr_notes_note` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `title` varchar(255) DEFAULT NULL COMMENT 'Краткий текст заметки',
  `status` enum('open','inwork','close') DEFAULT 'open' COMMENT 'Статус',
  `message` mediumtext COMMENT 'Сообщение',
  `date_of_create` datetime DEFAULT NULL COMMENT 'Дата создания заметки',
  `date_of_update` datetime DEFAULT NULL COMMENT 'Дата последнего обновления',
  `creator_user_id` bigint(11) DEFAULT NULL COMMENT 'Создатель заметки',
  `is_private` int(11) NOT NULL COMMENT 'Видна только мне'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_notice_config`
--

CREATE TABLE `gr_notice_config` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `enable_email` int(1) NOT NULL DEFAULT '1' COMMENT 'Отправка E-mail',
  `enable_sms` int(1) NOT NULL DEFAULT '1' COMMENT 'Отправка SMS',
  `enable_desktop` int(1) NOT NULL DEFAULT '1' COMMENT 'Отправка на ПК',
  `class` varchar(255) DEFAULT NULL COMMENT 'Класс уведомления',
  `template_email` varchar(255) DEFAULT NULL COMMENT 'E-Mail шаблон',
  `template_sms` varchar(255) DEFAULT NULL COMMENT 'SMS шаблон',
  `template_desktop` varchar(255) DEFAULT NULL COMMENT 'ПК шаблон',
  `additional_recipients` varchar(255) DEFAULT NULL COMMENT 'Дополнительные e-mail получателей'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_notice_config`
--

INSERT INTO `gr_notice_config` (`id`, `site_id`, `enable_email`, `enable_sms`, `enable_desktop`, `class`, `template_email`, `template_sms`, `template_desktop`, `additional_recipients`) VALUES
(1, 1, 1, 1, 1, '\\Install\\Model\\Notice\\InstallSuccess', NULL, NULL, NULL, NULL),
(2, 1, 1, 1, 1, '\\Users\\Model\\Notice\\UserRegisterUser', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_notice_item`
--

CREATE TABLE `gr_notice_item` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `dateofcreate` datetime DEFAULT NULL COMMENT 'Дата создания',
  `title` varchar(255) DEFAULT NULL COMMENT 'Заголовок уведомления',
  `short_message` varchar(400) DEFAULT NULL COMMENT 'Короткий текст уведомления',
  `full_message` mediumtext COMMENT 'Полный текст уведомления',
  `link` varchar(255) DEFAULT NULL COMMENT 'Ссылка',
  `link_title` varchar(255) DEFAULT NULL COMMENT 'Подпись к ссылке',
  `notice_type` varchar(255) DEFAULT NULL COMMENT 'Тип уведомления',
  `destination_user_id` int(11) NOT NULL COMMENT 'Пользователь-адресат уведомления'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_notice_lock`
--

CREATE TABLE `gr_notice_lock` (
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `user_id` int(11) DEFAULT NULL COMMENT 'Пользователь',
  `notice_type` varchar(100) DEFAULT NULL COMMENT 'Тип Desktop уведомления'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_one_click`
--

CREATE TABLE `gr_one_click` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `user_id` bigint(11) DEFAULT NULL COMMENT 'Пользователь',
  `user_fio` varchar(255) DEFAULT NULL COMMENT 'Ф.И.О. пользователя',
  `user_phone` varchar(50) DEFAULT NULL COMMENT 'Телефон пользователя',
  `title` varchar(150) DEFAULT NULL COMMENT 'Номер сообщения',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата отправки',
  `status` enum('new','viewed','cancelled') NOT NULL DEFAULT 'new' COMMENT 'Статус',
  `ip` varchar(150) DEFAULT NULL COMMENT 'IP Пользователя',
  `currency` varchar(5) DEFAULT NULL COMMENT 'Трехсимвольный идентификатор валюты на момент покупки',
  `sext_fields` mediumtext COMMENT 'Дополнительными сведения',
  `stext` mediumtext COMMENT 'Cведения о товарах',
  `partner_id` int(11) DEFAULT '0' COMMENT 'Партнёрский сайт',
  `source_id` int(11) DEFAULT '0' COMMENT 'Источник перехода пользователя',
  `utm_source` varchar(50) DEFAULT NULL COMMENT 'Рекламная система UTM_SOURCE',
  `utm_medium` varchar(50) DEFAULT NULL COMMENT 'Тип трафика UTM_MEDIUM',
  `utm_campaign` varchar(50) DEFAULT NULL COMMENT 'Рекламная кампания UTM_COMPAING',
  `utm_term` varchar(50) DEFAULT NULL COMMENT 'Ключевое слово UTM_TERM',
  `utm_content` varchar(50) DEFAULT NULL COMMENT 'Различия UTM_CONTENT',
  `utm_dateof` date DEFAULT NULL COMMENT 'Дата события'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order`
--

CREATE TABLE `gr_order` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `order_num` varchar(20) DEFAULT NULL COMMENT 'Уникальный идентификатор номера заказа',
  `user_id` bigint(11) NOT NULL COMMENT 'ID покупателя',
  `currency` varchar(5) DEFAULT NULL COMMENT 'Трехсимвольный идентификатор валюты на момент оформления заказа',
  `currency_ratio` float DEFAULT NULL COMMENT 'Курс относительно базовой валюты',
  `currency_stitle` varchar(10) DEFAULT NULL COMMENT 'Символ валюты',
  `ip` varchar(15) DEFAULT NULL COMMENT 'IP',
  `manager_user_id` int(11) NOT NULL COMMENT 'Менеджер заказа',
  `create_refund_receipt` int(11) DEFAULT NULL COMMENT 'Выбить чек возврата',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата заказа',
  `dateofupdate` datetime DEFAULT NULL COMMENT 'Дата обновления',
  `totalcost` decimal(15,2) NOT NULL COMMENT 'Общая стоимость',
  `profit` decimal(15,2) DEFAULT NULL COMMENT 'Доход',
  `user_delivery_cost` decimal(15,2) DEFAULT NULL COMMENT 'Стоимость доставки, определенная администратором',
  `is_payed` int(1) DEFAULT NULL COMMENT 'Заказ полностью оплачен?',
  `status` int(11) DEFAULT NULL COMMENT 'Статус',
  `admin_comments` mediumtext COMMENT 'Комментарии администратора (не отображаются пользователю)',
  `user_text` mediumtext COMMENT 'Текст для покупателя',
  `_serialized` mediumtext COMMENT 'Дополнительные сведения',
  `userfields` mediumtext COMMENT 'Дополнительные сведения',
  `hash` varchar(32) DEFAULT NULL,
  `is_exported` int(1) DEFAULT '0' COMMENT 'Выгружен ли заказ',
  `delivery_order_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор заказа доставки',
  `delivery_shipment_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор партии заказов доставки',
  `track_number` varchar(30) DEFAULT NULL COMMENT 'Трек-номер',
  `contact_person` varchar(255) DEFAULT NULL COMMENT 'Контактное лицо',
  `use_addr` int(11) DEFAULT NULL COMMENT 'ID адреса доставки',
  `delivery` int(11) DEFAULT NULL COMMENT 'Доставка',
  `deliverycost` decimal(15,2) DEFAULT NULL COMMENT 'Стоимость доставки',
  `courier_id` int(11) NOT NULL DEFAULT '0' COMMENT 'Курьер',
  `warehouse` int(11) DEFAULT NULL COMMENT 'Склад',
  `payment` int(11) DEFAULT NULL COMMENT 'Тип оплаты',
  `comments` mediumtext COMMENT 'Комментарий',
  `substatus` int(11) DEFAULT NULL COMMENT 'Причина отклонения заказа',
  `user_fio` varchar(255) DEFAULT NULL COMMENT 'Ф.И.О.',
  `user_email` varchar(255) DEFAULT NULL COMMENT 'E-mail',
  `user_phone` varchar(255) DEFAULT NULL COMMENT 'Телефон',
  `is_mobile_checkout` int(1) DEFAULT NULL COMMENT 'Оформлен через мобильное приложение?',
  `partner_id` int(11) DEFAULT NULL COMMENT 'ID партнера',
  `source_id` int(11) DEFAULT '0' COMMENT 'Источник перехода пользователя',
  `utm_source` varchar(50) DEFAULT NULL COMMENT 'Рекламная система UTM_SOURCE',
  `utm_medium` varchar(50) DEFAULT NULL COMMENT 'Тип трафика UTM_MEDIUM',
  `utm_campaign` varchar(50) DEFAULT NULL COMMENT 'Рекламная кампания UTM_COMPAING',
  `utm_term` varchar(50) DEFAULT NULL COMMENT 'Ключевое слово UTM_TERM',
  `utm_content` varchar(50) DEFAULT NULL COMMENT 'Различия UTM_CONTENT',
  `utm_dateof` date DEFAULT NULL COMMENT 'Дата события',
  `id_yandex_market_cpa_order` bigint(11) DEFAULT NULL COMMENT 'ID заказа в Яндекс.маркете'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_action_template`
--

CREATE TABLE `gr_order_action_template` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название действия (коротко)',
  `client_sms_message` mediumtext COMMENT 'Текст SMS сообщения, направляемого клиенту',
  `client_email_message` mediumtext COMMENT 'Текст Email сообщения, направляемого клиенту',
  `public` int(11) DEFAULT NULL COMMENT 'Включен'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_address`
--

CREATE TABLE `gr_order_address` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `user_id` int(11) DEFAULT '0' COMMENT 'Пользователь',
  `order_id` int(11) DEFAULT '0' COMMENT 'Заказ пользователя',
  `zipcode` varchar(20) DEFAULT NULL COMMENT 'Индекс',
  `country` varchar(100) DEFAULT NULL COMMENT 'Страна',
  `region` varchar(100) DEFAULT NULL COMMENT 'Регион',
  `city` varchar(100) DEFAULT NULL COMMENT 'Город',
  `address` varchar(255) DEFAULT NULL COMMENT 'Адрес',
  `street` varchar(100) DEFAULT NULL COMMENT 'Улица',
  `house` varchar(20) DEFAULT NULL COMMENT 'Дом',
  `block` varchar(20) DEFAULT NULL COMMENT 'Корпус',
  `apartment` varchar(20) DEFAULT NULL COMMENT 'Квартира',
  `entrance` varchar(20) DEFAULT NULL COMMENT 'Подъезд',
  `entryphone` varchar(20) DEFAULT NULL COMMENT 'Домофон',
  `floor` varchar(20) DEFAULT NULL COMMENT 'Этаж',
  `subway` varchar(20) DEFAULT NULL COMMENT 'Станция метро',
  `city_id` int(11) DEFAULT NULL COMMENT 'ID города',
  `region_id` int(11) DEFAULT NULL COMMENT 'ID региона',
  `country_id` int(11) DEFAULT NULL COMMENT 'ID страны',
  `deleted` int(1) DEFAULT '0' COMMENT 'Удалён?',
  `_extra` varchar(1000) DEFAULT NULL COMMENT 'Дополнительные данные (упакованные)'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_delivery`
--

CREATE TABLE `gr_order_delivery` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `admin_suffix` varchar(255) DEFAULT NULL COMMENT 'Пояснение',
  `description` mediumtext COMMENT 'Описание',
  `picture` varchar(255) DEFAULT NULL COMMENT 'Логотип',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT 'Категория',
  `free_price` int(11) NOT NULL DEFAULT '0' COMMENT 'Сумма заказа для бесплатной доставки',
  `first_status` int(11) DEFAULT NULL COMMENT 'Стартовый статус заказа',
  `user_type` enum('all','user','company') NOT NULL COMMENT 'Категория пользователей для данного способа доставки',
  `extrachange_discount` float DEFAULT '0' COMMENT 'Наценка/скидка на доставку',
  `extrachange_discount_type` int(1) DEFAULT '0' COMMENT 'Тип скидки или наценки',
  `extrachange_discount_implementation` float DEFAULT '1' COMMENT 'Наценка/скидка расчитывается от стоимости',
  `public` int(1) DEFAULT '1' COMMENT 'Публичный',
  `default` int(1) DEFAULT '0' COMMENT 'По умолчанию',
  `payment_method` varchar(255) NOT NULL DEFAULT '0' COMMENT 'Признак способа расчета для чека',
  `class` varchar(255) DEFAULT NULL COMMENT 'Расчетный класс (тип доставки)',
  `_serialized` mediumtext COMMENT 'Параметры расчетного класса',
  `sortn` int(11) DEFAULT NULL COMMENT 'Сорт. индекс',
  `min_price` decimal(20,2) DEFAULT NULL COMMENT 'Минимальная сумма заказа',
  `max_price` decimal(20,2) DEFAULT NULL COMMENT 'Максимальная сумма заказа',
  `min_weight` int(11) DEFAULT NULL COMMENT 'Минимальный вес заказа',
  `max_weight` int(11) DEFAULT NULL COMMENT 'Максимальный вес заказа',
  `min_cnt` int(11) NOT NULL DEFAULT '0' COMMENT 'Минимальное количество товаров в заказе',
  `_delivery_periods` mediumtext COMMENT 'Сроки доставки в регионы (Сохранение данных)',
  `_tax_ids` varchar(255) DEFAULT NULL COMMENT 'Налоги (сериализованные)',
  `_show_on_partners` varchar(255) DEFAULT NULL COMMENT 'Показывать на партнёрских сайтах (сериализованное)',
  `is_use_yandex_market_cpa` int(1) DEFAULT NULL COMMENT 'Использовать для доставки с Я.Маркета',
  `is_map_holiday` int(11) DEFAULT NULL COMMENT 'Проверять, чтобы дата доставки не выпадала на выходные и праздничные дни, согласно настройкам кампании Яндекс.Маркета'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_delivery_dir`
--

CREATE TABLE `gr_order_delivery_dir` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `sortn` int(11) DEFAULT NULL COMMENT 'Сорт. номер'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_delivery_x_zone`
--

CREATE TABLE `gr_order_delivery_x_zone` (
  `delivery_id` int(11) DEFAULT NULL COMMENT 'ID Доставки',
  `zone_id` int(11) DEFAULT NULL COMMENT 'ID Зоны'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_discount`
--

CREATE TABLE `gr_order_discount` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `code` varchar(50) DEFAULT NULL COMMENT 'Код',
  `descr` varchar(2000) DEFAULT NULL COMMENT 'Описание скидки',
  `active` int(1) DEFAULT NULL COMMENT 'Включен',
  `sproducts` mediumtext COMMENT 'Список товаров, на которые распространяется скидка',
  `period` enum('timelimit','forever') DEFAULT NULL COMMENT 'Срок действия',
  `endtime` datetime DEFAULT NULL COMMENT 'Время окончания действия скидки',
  `min_order_price` decimal(20,2) DEFAULT NULL COMMENT 'Минимальная сумма заказа',
  `discount` decimal(20,2) DEFAULT NULL COMMENT 'Скидка',
  `discount_type` enum('','%','base') DEFAULT NULL COMMENT 'Скидка указана в процентах или в базовой валюте?',
  `round` int(1) DEFAULT NULL COMMENT 'Округлять скидку до целых чисел?',
  `uselimit` int(5) DEFAULT NULL COMMENT 'Лимит использования, раз',
  `oneuserlimit` int(5) DEFAULT NULL COMMENT 'Лимит использования одним пользователем, раз',
  `wasused` int(5) NOT NULL DEFAULT '0' COMMENT 'Была использована, раз'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_items`
--

CREATE TABLE `gr_order_items` (
  `uniq` varchar(10) NOT NULL COMMENT 'ID в рамках одной корзины',
  `type` enum('product','coupon','commission','tax','delivery','order_discount','subtotal') DEFAULT NULL COMMENT 'Тип записи товар, услуга, скидочный купон',
  `entity_id` varchar(50) DEFAULT NULL COMMENT 'ID объекта type',
  `offer` int(11) DEFAULT NULL COMMENT 'Комплектация',
  `multioffers` mediumtext COMMENT 'Многомерные комплектации',
  `amount` decimal(11,3) DEFAULT '1.000' COMMENT 'Количество',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `extra` mediumtext COMMENT 'Дополнительные сведения (сериализованные)',
  `order_id` int(11) NOT NULL COMMENT 'ID заказа',
  `barcode` varchar(100) DEFAULT NULL COMMENT 'Артикул',
  `sku` varchar(50) DEFAULT NULL COMMENT 'Штрихкод',
  `model` varchar(255) DEFAULT NULL COMMENT 'Модель',
  `single_weight` double DEFAULT NULL COMMENT 'Вес',
  `single_cost` decimal(20,2) DEFAULT NULL COMMENT 'Цена за единицу продукции',
  `price` decimal(20,2) DEFAULT '0.00' COMMENT 'Стоимость',
  `profit` decimal(20,2) DEFAULT '0.00' COMMENT 'Доход',
  `discount` decimal(20,2) DEFAULT '0.00' COMMENT 'Скидка',
  `sortn` int(11) DEFAULT NULL COMMENT 'Порядок'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_item_uit`
--

CREATE TABLE `gr_order_item_uit` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `order_id` int(11) DEFAULT NULL COMMENT 'ID заказа',
  `order_item_uniq` varchar(255) DEFAULT NULL COMMENT 'ID позиции в рамках заказа',
  `gtin` varchar(14) DEFAULT NULL COMMENT 'Глобальный номер предмета торговли (GTIN)',
  `serial` varchar(30) DEFAULT NULL COMMENT 'Серийный номер'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_payment`
--

CREATE TABLE `gr_order_payment` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `admin_suffix` varchar(255) DEFAULT NULL COMMENT 'Пояснение',
  `description` mediumtext COMMENT 'Описание',
  `picture` varchar(255) DEFAULT NULL COMMENT 'Логотип',
  `first_status` int(11) DEFAULT NULL COMMENT 'Стартовый статус заказа',
  `user_type` enum('all','user','company') NOT NULL COMMENT 'Категория пользователей для данного типа оплаты',
  `target` enum('all','orders','refill') NOT NULL COMMENT 'Область применения',
  `_delivery` varchar(1500) DEFAULT NULL COMMENT 'Связь с доставками',
  `public` int(1) DEFAULT '1' COMMENT 'Публичный',
  `default_payment` int(1) DEFAULT '0' COMMENT 'Оплата по-умолчанию?',
  `commission` float DEFAULT '0' COMMENT 'Комиссия за оплату в %',
  `commission_include_delivery` int(1) DEFAULT '0' COMMENT 'Включать стоимость доставки в комиссию',
  `commission_as_product_discount` int(1) DEFAULT '0' COMMENT 'Присваивать комиссию в качестве скидки или наценки к товарам',
  `class` varchar(255) DEFAULT NULL COMMENT 'Расчетный класс (тип оплаты)',
  `_serialized` mediumtext COMMENT 'Параметры рассчетного класса',
  `sortn` int(11) DEFAULT NULL COMMENT 'Сорт. индекс',
  `min_price` decimal(20,2) DEFAULT NULL COMMENT 'Минимальная сумма заказа',
  `max_price` decimal(20,2) DEFAULT NULL COMMENT 'Максимальная сумма заказа',
  `success_status` int(11) DEFAULT '0' COMMENT 'Статус заказа в случае успешной оплаты',
  `holding_status` int(11) DEFAULT '0' COMMENT 'Статус заказа в случае холдирования',
  `holding_cancel_status` int(11) DEFAULT '0' COMMENT 'Статус заказа в случае отмены холдирования',
  `create_cash_receipt` int(1) DEFAULT '0' COMMENT 'Выбить чек после оплаты?',
  `payment_method` varchar(255) DEFAULT '0' COMMENT 'Признак способа расчета в чеке у заказа с этим способом оплаты',
  `create_order_transaction` int(11) DEFAULT '0' COMMENT 'Создавать транзакцию при создании заказа',
  `_show_on_partners` varchar(255) DEFAULT NULL COMMENT 'Показывать на партнёрских сайтах (сериализованное)'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_order_payment`
--

INSERT INTO `gr_order_payment` (`id`, `site_id`, `title`, `admin_suffix`, `description`, `picture`, `first_status`, `user_type`, `target`, `_delivery`, `public`, `default_payment`, `commission`, `commission_include_delivery`, `commission_as_product_discount`, `class`, `_serialized`, `sortn`, `min_price`, `max_price`, `success_status`, `holding_status`, `holding_cancel_status`, `create_cash_receipt`, `payment_method`, `create_order_transaction`, `_show_on_partners`) VALUES
(1, 1, 'Оплата через Яндекс (\"Заказах на Яндекс\")', NULL, NULL, NULL, NULL, 'all', 'all', 'N;', 0, 0, 0, 0, 0, 'ym-generic', 'N;', 1, NULL, NULL, 0, 0, 0, 0, '0', 0, NULL),
(2, 1, 'Оплата наличными при получении (\"Заказы на Яндекс\")', NULL, NULL, NULL, NULL, 'all', 'all', 'N;', 0, 0, 0, 0, 0, 'ym-cash-on-delivery', 'N;', 2, NULL, NULL, 0, 0, 0, 0, '0', 0, NULL),
(3, 1, 'Оплата картой при получении (\"Заказы на Яндекс\")', NULL, NULL, NULL, NULL, 'all', 'all', 'N;', 0, 0, 0, 0, 0, 'ym-card-on-delivery', 'N;', 3, NULL, NULL, 0, 0, 0, 0, '0', 0, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_products_return`
--

CREATE TABLE `gr_order_products_return` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `return_num` varchar(20) DEFAULT NULL COMMENT 'Номер возврата',
  `order_id` int(20) DEFAULT NULL COMMENT 'Id заказа',
  `user_id` bigint(11) NOT NULL COMMENT 'ID пользователя',
  `status` enum('new','in_progress','complete','refused') NOT NULL COMMENT 'Статус возврата',
  `name` varchar(255) DEFAULT NULL COMMENT 'Имя пользователя',
  `surname` varchar(255) DEFAULT NULL COMMENT 'Фамилия пользователя',
  `midname` varchar(255) DEFAULT NULL COMMENT 'Отчество пользователя',
  `passport_series` varchar(50) DEFAULT NULL COMMENT 'Серия паспорта',
  `passport_number` varchar(50) DEFAULT NULL COMMENT 'Номер паспорта',
  `passport_issued_by` varchar(100) DEFAULT NULL COMMENT 'Кем выдан паспорт',
  `phone` varchar(50) DEFAULT NULL COMMENT 'Номер телефона',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата оформления возврата',
  `date_exec` datetime DEFAULT NULL COMMENT 'Дата выполнения возврата',
  `return_reason` varchar(200) DEFAULT NULL COMMENT 'Причина возврата',
  `bank_name` varchar(100) DEFAULT NULL COMMENT 'Название банка',
  `bik` varchar(50) DEFAULT NULL COMMENT 'БИК',
  `bank_account` varchar(100) DEFAULT NULL COMMENT 'Рассчетный счет',
  `correspondent_account` varchar(100) DEFAULT NULL COMMENT 'Корреспондентский счет',
  `cost_total` decimal(10,0) DEFAULT NULL COMMENT 'Сумма возврата',
  `currency` varchar(20) DEFAULT NULL COMMENT 'Id валюты',
  `currency_ratio` decimal(20,0) DEFAULT NULL COMMENT 'Курс на момент оформления заказа',
  `currency_stitle` varchar(20) DEFAULT NULL COMMENT 'Символ курса валюты'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_products_return_item`
--

CREATE TABLE `gr_order_products_return_item` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL,
  `uniq` varchar(20) DEFAULT NULL COMMENT 'Уникальный идентификатор',
  `return_id` int(20) DEFAULT NULL COMMENT 'Id возврата',
  `entity_id` int(11) DEFAULT NULL COMMENT 'Id товара',
  `offer` int(11) DEFAULT NULL COMMENT 'Номер комплектации',
  `amount` int(20) DEFAULT NULL COMMENT 'Количество товара',
  `cost` decimal(20,0) DEFAULT NULL COMMENT 'Цена товара',
  `barcode` varchar(255) DEFAULT NULL COMMENT 'Артикул',
  `model` varchar(255) DEFAULT NULL COMMENT 'Модель',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_regions`
--

CREATE TABLE `gr_order_regions` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `parent_id` int(11) DEFAULT NULL COMMENT 'Родитель',
  `zipcode` varchar(20) DEFAULT NULL COMMENT 'Индекс',
  `is_city` int(1) DEFAULT '0' COMMENT 'Является городом?',
  `area` varchar(255) DEFAULT NULL COMMENT 'Муниципальный район',
  `sortn` int(11) DEFAULT '100' COMMENT 'Порядок',
  `kladr_id` varchar(255) DEFAULT NULL COMMENT 'ID по КЛАДР',
  `type_short` varchar(30) DEFAULT NULL COMMENT 'Тип субъекта, населенного пункта сокращенно',
  `processed` int(11) DEFAULT NULL COMMENT 'Обновлено только что',
  `russianpost_arriveinfo` varchar(255) DEFAULT NULL COMMENT 'Срок доставки Почтой России (строка)',
  `russianpost_arrive_min` varchar(10) DEFAULT NULL COMMENT 'Минимальное количество дней доставки Почтой России',
  `russianpost_arrive_max` varchar(10) DEFAULT NULL COMMENT 'Максимальное количество дней доставки Почтой России'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_order_regions`
--

INSERT INTO `gr_order_regions` (`id`, `site_id`, `title`, `parent_id`, `zipcode`, `is_city`, `area`, `sortn`, `kladr_id`, `type_short`, `processed`, `russianpost_arriveinfo`, `russianpost_arrive_min`, `russianpost_arrive_max`) VALUES
(1, 1, 'Россия', 0, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(2, 1, 'Мурманская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(3, 1, 'Мордовия', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(4, 1, 'Чувашия', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(5, 1, 'Оренбургская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(6, 1, 'Свердловская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(7, 1, 'Новгородская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(8, 1, 'Башкортостан', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(9, 1, 'Астраханская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(10, 1, 'Орловская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(11, 1, 'Пермский край', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(12, 1, 'Саха (Якутия)', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(13, 1, 'Северная Осетия', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(14, 1, 'Татарстан', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(15, 1, 'Тверская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(16, 1, 'Тульская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(17, 1, 'Псковская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(18, 1, 'Чечня', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(19, 1, 'Усть-Ордынский Бурятский АО', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(20, 1, 'Смоленская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(21, 1, 'Удмуртия', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(22, 1, 'Иркутская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(23, 1, 'Липецкая область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(24, 1, 'Курская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(25, 1, 'Курганская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(26, 1, 'Самарская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(27, 1, 'Кемеровская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(28, 1, 'Карачаево-Черкессия', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(29, 1, 'Калининградская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(30, 1, 'Красноярский край', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(31, 1, 'Дагестан', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(32, 1, 'Воронежская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(33, 1, 'Московская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(34, 1, 'Москва', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(35, 1, 'Крым', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(36, 1, 'Ярославская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(37, 1, 'Ростовская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(38, 1, 'Нижегородская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(39, 1, 'Ненецкий АО', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(40, 1, 'Омская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(41, 1, 'Новосибирская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(42, 1, 'Белгородская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(43, 1, 'Пензенская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(44, 1, 'Сахалинская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(45, 1, 'Ульяновская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(46, 1, 'Ханты-Мансийский АО', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(47, 1, 'Хакасия', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(48, 1, 'Томская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(49, 1, 'Тыва (Тува)', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(50, 1, 'Челябинская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(51, 1, 'Хабаровский край', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(52, 1, 'Тамбовская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(53, 1, 'Ставропольский край', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(54, 1, 'Тюменская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(55, 1, 'Приморский край', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(56, 1, 'Ингушетия', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(57, 1, 'Ямало-Ненецкий АО', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(58, 1, 'Коми', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(59, 1, 'Магаданская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(60, 1, 'Ленинградская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(61, 1, 'Рязанская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(62, 1, 'Кировская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(63, 1, 'Кабардино-Балкария', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(64, 1, 'Забайкальский край', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(65, 1, 'Карелия', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(66, 1, 'Камчатский край', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(67, 1, 'Калужская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(68, 1, 'Калмыкия', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(69, 1, 'Саратовская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(70, 1, 'Чукотский АО', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(71, 1, 'Ивановская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(72, 1, 'Брянская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(73, 1, 'Адыгея', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(74, 1, 'Алтай', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(75, 1, 'Амурская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(76, 1, 'Архангельская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(77, 1, 'Краснодарский край', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(78, 1, 'Еврейская АО', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(79, 1, 'Алтайский край', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(80, 1, 'Вологодская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(81, 1, 'Волгоградская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(82, 1, 'Владимирская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(83, 1, 'Бурятия', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(84, 1, 'Марий-Эл', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(85, 1, 'Костромская область', 1, '', 0, NULL, 100, '0', NULL, NULL, NULL, NULL, NULL),
(86, 1, 'Буй', 85, '157000', 1, NULL, 100, '4400300100000', NULL, NULL, NULL, NULL, NULL),
(87, 1, 'Волгореченск', 85, '156901', 1, NULL, 100, '4400000200000', NULL, NULL, NULL, NULL, NULL),
(88, 1, 'Галич', 85, '', 1, NULL, 100, '4400500100000', NULL, NULL, NULL, NULL, NULL),
(89, 1, 'Кологрив', 85, '157440', 1, NULL, 100, '4400700100000', NULL, NULL, NULL, NULL, NULL),
(90, 1, 'Кострома', 85, '156000', 1, NULL, 100, '4400000300000', NULL, NULL, NULL, NULL, NULL),
(91, 1, 'Макарьев', 85, '157461', 1, NULL, 100, '4400900100000', NULL, NULL, NULL, NULL, NULL),
(92, 1, 'Мантурово', 85, '157300', 1, NULL, 100, '4401000100000', NULL, NULL, NULL, NULL, NULL),
(93, 1, 'Нерехта', 85, '157800', 1, NULL, 100, '4401300100000', NULL, NULL, NULL, NULL, NULL),
(94, 1, 'Нея', 85, '157330', 1, NULL, 100, '4401200100000', NULL, NULL, NULL, NULL, NULL),
(95, 1, 'Солигалич', 85, '157170', 1, NULL, 100, '4402000100000', NULL, NULL, NULL, NULL, NULL),
(96, 1, 'Чухлома', 85, '157130', 1, NULL, 100, '4402300100000', NULL, NULL, NULL, NULL, NULL),
(97, 1, 'Шарья', 85, '157500', 1, NULL, 100, '4402400100000', NULL, NULL, NULL, NULL, NULL),
(98, 1, 'Апрелевка', 33, '143362', 1, NULL, 100, '5002000200000', NULL, NULL, NULL, NULL, NULL),
(99, 1, 'Балашиха', 33, '143900', 1, NULL, 100, '5000003600000', NULL, NULL, NULL, NULL, NULL),
(100, 1, 'Бронницы', 33, '140170', 1, NULL, 100, '5000000200000', NULL, NULL, NULL, NULL, NULL),
(101, 1, 'Верея', 33, '143330', 1, NULL, 100, '5002000300000', NULL, NULL, NULL, NULL, NULL),
(102, 1, 'Видное', 33, '142700', 1, NULL, 100, '5001400100000', NULL, NULL, NULL, NULL, NULL),
(103, 1, 'Волоколамск', 33, '143600', 1, NULL, 100, '5000300100000', NULL, NULL, NULL, NULL, NULL),
(104, 1, 'Воскресенск', 33, '140200', 1, NULL, 100, '5000400100000', NULL, NULL, NULL, NULL, NULL),
(105, 1, 'Высоковск', 33, '141650', 1, NULL, 100, '5001100200000', NULL, NULL, NULL, NULL, NULL),
(106, 1, 'Голицыно', 33, '143040', 1, NULL, 100, '5002200300000', NULL, NULL, NULL, NULL, NULL),
(107, 1, 'Дедовск', 33, '143530', 1, NULL, 100, '5000900200000', NULL, NULL, NULL, NULL, NULL),
(108, 1, 'Дзержинский', 33, '140090', 1, NULL, 100, '5000002300000', NULL, NULL, NULL, NULL, NULL),
(109, 1, 'Дмитров', 33, '141800', 1, NULL, 100, '5000006100000', NULL, NULL, NULL, NULL, NULL),
(110, 1, 'Долгопрудный', 33, '141700', 1, NULL, 100, '5000002900000', NULL, NULL, NULL, NULL, NULL),
(111, 1, 'Домодедово', 33, '142000', 1, NULL, 100, '5000000100000', NULL, NULL, NULL, NULL, NULL),
(112, 1, 'Дрезна', 33, '142660', 1, NULL, 100, '5002400200000', NULL, NULL, NULL, NULL, NULL),
(113, 1, 'Дубна', 33, '141980', 1, NULL, 100, '5000000300000', NULL, NULL, NULL, NULL, NULL),
(114, 1, 'Егорьевск', 33, '140300', 1, NULL, 100, '5000003900000', NULL, NULL, NULL, NULL, NULL),
(115, 1, 'Жуковский', 33, '140180', 1, NULL, 100, '5000000500000', NULL, NULL, NULL, NULL, NULL),
(116, 1, 'Зарайск', 33, '140600', 1, NULL, 100, '5000004600000', NULL, NULL, NULL, NULL, NULL),
(117, 1, 'Звенигород', 33, '143180', 1, NULL, 100, '5000000600000', NULL, NULL, NULL, NULL, NULL),
(118, 1, 'Ивантеевка', 33, '141280', 1, NULL, 100, '5000000700000', NULL, NULL, NULL, NULL, NULL),
(119, 1, 'Истра', 33, '143500', 1, NULL, 100, '5000005700000', NULL, NULL, NULL, NULL, NULL),
(120, 1, 'Кашира', 33, '142900', 1, NULL, 100, '5000003800000', NULL, NULL, NULL, NULL, NULL),
(121, 1, 'Климовск', 33, '142180', 1, NULL, 100, '5000000800000', NULL, NULL, NULL, NULL, NULL),
(122, 1, 'Клин', 33, '141600', 1, NULL, 100, '5000005500000', NULL, NULL, NULL, NULL, NULL),
(123, 1, 'Коломна', 33, '140400', 1, NULL, 100, '5000002700000', NULL, NULL, NULL, NULL, NULL),
(124, 1, 'Королев', 33, '141071', 1, NULL, 100, '5000000900000', NULL, NULL, NULL, NULL, NULL),
(125, 1, 'Котельники', 33, '140054', 1, NULL, 100, '5000003200000', NULL, NULL, NULL, NULL, NULL),
(126, 1, 'Красноармейск', 33, '141290', 1, NULL, 100, '5000001000000', NULL, NULL, NULL, NULL, NULL),
(127, 1, 'Красногорск', 33, '143401', 1, NULL, 100, '5000004900000', NULL, NULL, NULL, NULL, NULL),
(128, 1, 'Краснозаводск', 33, '141321', 1, NULL, 100, '5003000200000', NULL, NULL, NULL, NULL, NULL),
(129, 1, 'Кубинка', 33, '143070', 1, NULL, 100, '5002200400000', NULL, NULL, NULL, NULL, NULL),
(130, 1, 'Куровское', 33, '142620', 1, NULL, 100, '5002400300000', NULL, NULL, NULL, NULL, NULL),
(131, 1, 'Ликино-Дулево', 33, '142672', 1, NULL, 100, '5000005800000', NULL, NULL, NULL, NULL, NULL),
(132, 1, 'Лобня', 33, '141730', 1, NULL, 100, '5000001200000', NULL, NULL, NULL, NULL, NULL),
(133, 1, 'Лосино-Петровский', 33, '141150', 1, NULL, 100, '5000003100000', NULL, NULL, NULL, NULL, NULL),
(134, 1, 'Луховицы', 33, '140500', 1, NULL, 100, '5000004800000', NULL, NULL, NULL, NULL, NULL),
(135, 1, 'Лыткарино', 33, '140080', 1, NULL, 100, '5000001300000', NULL, NULL, NULL, NULL, NULL),
(136, 1, 'Люберцы', 33, '140000', 1, NULL, 100, '5000005000000', NULL, NULL, NULL, NULL, NULL),
(137, 1, 'Можайск', 33, '143204', 1, NULL, 100, '5000005600000', NULL, NULL, NULL, NULL, NULL),
(138, 1, 'Москва', 33, '101000', 1, NULL, 100, '7700000000000', NULL, NULL, NULL, NULL, NULL),
(139, 1, 'Мытищи', 33, '141000', 1, NULL, 100, '5000004400000', NULL, NULL, NULL, NULL, NULL),
(140, 1, 'Наро-Фоминск', 33, '143300', 1, NULL, 100, '5000005200000', NULL, NULL, NULL, NULL, NULL),
(141, 1, 'Ногинск', 33, '142400', 1, NULL, 100, '5000006000000', NULL, NULL, NULL, NULL, NULL),
(142, 1, 'Одинцово', 33, '143000', 1, NULL, 100, '5002200100000', NULL, NULL, NULL, NULL, NULL),
(143, 1, 'Озеры', 33, '140560', 1, NULL, 100, '5000004000000', NULL, NULL, NULL, NULL, NULL),
(144, 1, 'Орехово-Зуево', 33, '142600', 1, NULL, 100, '5000002600000', NULL, NULL, NULL, NULL, NULL),
(145, 1, 'Павловский Посад', 33, '142500', 1, NULL, 100, '5000004700000', NULL, NULL, NULL, NULL, NULL),
(146, 1, 'Пересвет', 33, '141320', 1, NULL, 100, '5003000400000', NULL, NULL, NULL, NULL, NULL),
(147, 1, 'Подольск', 33, '142100', 1, NULL, 100, '5000002400000', NULL, NULL, NULL, NULL, NULL),
(148, 1, 'Протвино', 33, '142280', 1, NULL, 100, '5000001400000', NULL, NULL, NULL, NULL, NULL),
(149, 1, 'Пушкино', 33, '141200', 1, NULL, 100, '5002700100000', NULL, NULL, NULL, NULL, NULL),
(150, 1, 'Пущино', 33, '142290', 1, NULL, 100, '5000001500000', NULL, NULL, NULL, NULL, NULL),
(151, 1, 'Раменское', 33, '140100', 1, NULL, 100, '5002800100000', NULL, NULL, NULL, NULL, NULL),
(152, 1, 'Реутов', 33, '143960', 1, NULL, 100, '5000001600000', NULL, NULL, NULL, NULL, NULL),
(153, 1, 'Рошаль', 33, '140730', 1, NULL, 100, '5000001700000', NULL, NULL, NULL, NULL, NULL),
(154, 1, 'Руза', 33, '143100', 1, NULL, 100, '5000004500000', NULL, NULL, NULL, NULL, NULL),
(155, 1, 'Сергиев Посад', 33, '141300', 1, NULL, 100, '5003000500000', NULL, NULL, NULL, NULL, NULL),
(156, 1, 'Сергиев Посад-7', 33, '141315', 1, NULL, 100, '5003000600000', NULL, NULL, NULL, NULL, NULL),
(157, 1, 'Серпухов', 33, '142200', 1, NULL, 100, '5000002800000', NULL, NULL, NULL, NULL, NULL),
(158, 1, 'Солнечногорск', 33, '141501', 1, NULL, 100, '5003300100000', NULL, NULL, NULL, NULL, NULL),
(159, 1, 'Солнечногорск-2', 33, '141502', 1, NULL, 100, '5003300400000', NULL, NULL, NULL, NULL, NULL),
(160, 1, 'Солнечногорск-25', 33, '141501', 1, NULL, 100, '5003300400000', NULL, NULL, NULL, NULL, NULL),
(161, 1, 'Солнечногорск-30', 33, '141504', 1, NULL, 100, '5003300500000', NULL, NULL, NULL, NULL, NULL),
(162, 1, 'Солнечногорск-7', 33, '141507', 1, NULL, 100, '5003300300000', NULL, NULL, NULL, NULL, NULL),
(163, 1, 'Старая Купавна', 33, '142450', 1, NULL, 100, '5002100400000', NULL, NULL, NULL, NULL, NULL),
(164, 1, 'Ступино', 33, '142800', 1, NULL, 100, '5000005400000', NULL, NULL, NULL, NULL, NULL),
(165, 1, 'Талдом', 33, '141900', 1, NULL, 100, '5000005900000', NULL, NULL, NULL, NULL, NULL),
(166, 1, 'Фрязино', 33, '141190', 1, NULL, 100, '5000001900000', NULL, NULL, NULL, NULL, NULL),
(167, 1, 'Химки', 33, '141400', 1, NULL, 100, '5000003000000', NULL, NULL, NULL, NULL, NULL),
(168, 1, 'Хотьково', 33, '141372', 1, NULL, 100, '5003000300000', NULL, NULL, NULL, NULL, NULL),
(169, 1, 'Черноголовка', 33, '142432', 1, NULL, 100, '5000003500000', NULL, NULL, NULL, NULL, NULL),
(170, 1, 'Чехов', 33, '142300', 1, NULL, 100, '5003700100051', NULL, NULL, NULL, NULL, NULL),
(171, 1, 'Чехов-2', 33, '142302', 1, NULL, 100, '5003700200000', NULL, NULL, NULL, NULL, NULL),
(172, 1, 'Чехов-3', 33, '142303', 1, NULL, 100, '5003700300000', NULL, NULL, NULL, NULL, NULL),
(173, 1, 'Чехов-8', 33, '142302', 1, NULL, 100, '5003700500000', NULL, NULL, NULL, NULL, NULL),
(174, 1, 'Шатура', 33, '140700', 1, NULL, 100, '5000005100000', NULL, NULL, NULL, NULL, NULL),
(175, 1, 'Щелково', 33, '141100', 1, NULL, 100, '5004000100000', NULL, NULL, NULL, NULL, NULL),
(176, 1, 'Электрогорск', 33, '142530', 1, NULL, 100, '5000003300000', NULL, NULL, NULL, NULL, NULL),
(177, 1, 'Электросталь', 33, '144000', 1, NULL, 100, '5000002100000', NULL, NULL, NULL, NULL, NULL),
(178, 1, 'Электроугли', 33, '142455', 1, NULL, 100, '5002100200000', NULL, NULL, NULL, NULL, NULL),
(179, 1, 'Яхрома', 33, '141840', 1, NULL, 100, '5000500200000', NULL, NULL, NULL, NULL, NULL),
(180, 1, 'Волжск', 84, '425000', 1, NULL, 100, '1200000200000', NULL, NULL, NULL, NULL, NULL),
(181, 1, 'Звенигово', 84, '425060', 1, NULL, 100, '1200400100000', NULL, NULL, NULL, NULL, NULL),
(182, 1, 'Йошкар-Ола', 84, '424000', 1, NULL, 100, '1200000100000', NULL, NULL, NULL, NULL, NULL),
(183, 1, 'Козьмодемьянск', 84, '425350', 1, NULL, 100, '1200000300000', NULL, NULL, NULL, NULL, NULL),
(184, 1, 'Бабушкин', 83, '671950', 1, NULL, 100, '0300900200000', NULL, NULL, NULL, NULL, NULL),
(185, 1, 'Гусиноозерск', 83, '671160', 1, NULL, 100, '0301800100000', NULL, NULL, NULL, NULL, NULL),
(186, 1, 'Закаменск', 83, '671950', 1, NULL, 100, '0300700100000', NULL, NULL, NULL, NULL, NULL),
(187, 1, 'Кяхта', 83, '446722', 1, NULL, 100, '0301200100000', NULL, NULL, NULL, NULL, NULL),
(188, 1, 'Северобайкальск', 83, '671700', 1, NULL, 100, '0300000200000', NULL, NULL, NULL, NULL, NULL),
(189, 1, 'Улан-Удэ', 83, '670000', 1, NULL, 100, '0300000100000', NULL, NULL, NULL, NULL, NULL),
(190, 1, 'Александров', 82, '347233', 1, NULL, 100, '3300200100000', NULL, NULL, NULL, NULL, NULL),
(191, 1, 'Владимир', 82, '600000', 1, NULL, 100, '3300000100000', NULL, NULL, NULL, NULL, NULL),
(192, 1, 'Вязники', 82, '601440', 1, NULL, 100, '3300300100000', NULL, NULL, NULL, NULL, NULL),
(193, 1, 'Гороховец', 82, '601480', 1, NULL, 100, '3300400100000', NULL, NULL, NULL, NULL, NULL),
(194, 1, 'Гусь-Хрустальный', 82, '601500', 1, NULL, 100, '3300000300000', NULL, NULL, NULL, NULL, NULL),
(195, 1, 'Камешково', 82, '601301', 1, NULL, 100, '3300600100000', NULL, NULL, NULL, NULL, NULL),
(196, 1, 'Карабаново', 82, '601640', 1, NULL, 100, '3300200200000', NULL, NULL, NULL, NULL, NULL),
(197, 1, 'Киржач', 82, '601010', 1, NULL, 100, '3300700100000', NULL, NULL, NULL, NULL, NULL),
(198, 1, 'Ковров', 82, '601900', 1, NULL, 100, '3300000400000', NULL, NULL, NULL, NULL, NULL),
(199, 1, 'Кольчугино', 82, '297551', 1, NULL, 100, '3300900100000', NULL, NULL, NULL, NULL, NULL),
(200, 1, 'Костерево', 82, '601110', 1, NULL, 100, '3301200200000', NULL, NULL, NULL, NULL, NULL),
(201, 1, 'Курлово', 82, '601570', 1, NULL, 100, '3300500200000', NULL, NULL, NULL, NULL, NULL),
(202, 1, 'Лакинск', 82, '601240', 1, NULL, 100, '3301400200000', NULL, NULL, NULL, NULL, NULL),
(203, 1, 'Меленки', 82, '602100', 1, NULL, 100, '3301000100000', NULL, NULL, NULL, NULL, NULL),
(204, 1, 'Муром', 82, '309257', 1, NULL, 100, '3300000500000', NULL, NULL, NULL, NULL, NULL),
(205, 1, 'Петушки', 82, '601144', 1, NULL, 100, '3301200100000', NULL, NULL, NULL, NULL, NULL),
(206, 1, 'Покров', 82, '601120', 1, NULL, 100, '3301200300000', NULL, NULL, NULL, NULL, NULL),
(207, 1, 'Радужный', 82, '600910', 1, NULL, 100, '3300000200000', NULL, NULL, NULL, NULL, NULL),
(208, 1, 'Собинка', 82, '601204', 1, NULL, 100, '3301400100000', NULL, NULL, NULL, NULL, NULL),
(209, 1, 'Струнино', 82, '601670', 1, NULL, 100, '3300200300000', NULL, NULL, NULL, NULL, NULL),
(210, 1, 'Судогда', 82, '601351', 1, NULL, 100, '3301500100000', NULL, NULL, NULL, NULL, NULL),
(211, 1, 'Суздаль', 82, '601293', 1, NULL, 100, '3301600100000', NULL, NULL, NULL, NULL, NULL),
(212, 1, 'Юрьев-Польский', 82, '601800', 1, NULL, 100, '3301700100000', NULL, NULL, NULL, NULL, NULL),
(213, 1, 'Волгоград', 81, '400000', 1, NULL, 100, '3400000100000', NULL, NULL, NULL, NULL, NULL),
(214, 1, 'Волжский', 81, '404100', 1, NULL, 100, '3400000200000', NULL, NULL, NULL, NULL, NULL),
(215, 1, 'Дубовка', 81, '356210', 1, NULL, 100, '3400600100000', NULL, NULL, NULL, NULL, NULL),
(216, 1, 'Жирновск', 81, '403790', 1, NULL, 100, '3400800100000', NULL, NULL, NULL, NULL, NULL),
(217, 1, 'Калач-на-Дону', 81, '404500', 1, NULL, 100, '3401000100000', NULL, NULL, NULL, NULL, NULL),
(218, 1, 'Камышин', 81, '403870', 1, NULL, 100, '3400000300000', NULL, NULL, NULL, NULL, NULL),
(219, 1, 'Котельниково', 81, '404350', 1, NULL, 100, '3401400100000', NULL, NULL, NULL, NULL, NULL),
(220, 1, 'Котово', 81, '403805', 1, NULL, 100, '3401500100000', NULL, NULL, NULL, NULL, NULL),
(221, 1, 'Краснослободск', 81, '404160', 1, NULL, 100, '3402800200000', NULL, NULL, NULL, NULL, NULL),
(222, 1, 'Ленинск', 81, '404620', 1, NULL, 100, '3401700100000', NULL, NULL, NULL, NULL, NULL),
(223, 1, 'Михайловка', 81, '161306', 1, NULL, 100, '3400000400000', NULL, NULL, NULL, NULL, NULL),
(224, 1, 'Николаевск', 81, '404030', 1, NULL, 100, '3402000100000', NULL, NULL, NULL, NULL, NULL),
(225, 1, 'Новоаннинский', 81, '403950', 1, NULL, 100, '3402100100000', NULL, NULL, NULL, NULL, NULL),
(226, 1, 'Палласовка', 81, '404260', 1, NULL, 100, '3402400100000', NULL, NULL, NULL, NULL, NULL),
(227, 1, 'Петров Вал', 81, '403840', 1, NULL, 100, '3401100200000', NULL, NULL, NULL, NULL, NULL),
(228, 1, 'Серафимович', 81, '403440', 1, NULL, 100, '3402700100000', NULL, NULL, NULL, NULL, NULL),
(229, 1, 'Суровикино', 81, '404415', 1, NULL, 100, '3403000100000', NULL, NULL, NULL, NULL, NULL),
(230, 1, 'Урюпинск', 81, '403110', 1, NULL, 100, '3400000500000', NULL, NULL, NULL, NULL, NULL),
(231, 1, 'Фролово', 81, '403531', 1, NULL, 100, '3400000600000', NULL, NULL, NULL, NULL, NULL),
(232, 1, 'Бабаево', 80, '162483', 1, NULL, 100, '3500200100000', NULL, NULL, NULL, NULL, NULL),
(233, 1, 'Белозерск', 80, '161201', 1, NULL, 100, '3500400100000', NULL, NULL, NULL, NULL, NULL),
(234, 1, 'Великий Устюг', 80, '162390', 1, NULL, 100, '3500600100000', NULL, NULL, NULL, NULL, NULL),
(235, 1, 'Вологда', 80, '160000', 1, NULL, 100, '3500000100000', NULL, NULL, NULL, NULL, NULL),
(236, 1, 'Вытегра', 80, '162900', 1, NULL, 100, '3500900100000', NULL, NULL, NULL, NULL, NULL),
(237, 1, 'Грязовец', 80, '162000', 1, NULL, 100, '3501000100000', NULL, NULL, NULL, NULL, NULL),
(238, 1, 'Кадников', 80, '162107', 1, NULL, 100, '3501700200000', NULL, NULL, NULL, NULL, NULL),
(239, 1, 'Кириллов', 80, '161101', 1, NULL, 100, '3501200100000', NULL, NULL, NULL, NULL, NULL),
(240, 1, 'Красавино', 80, '161390', 1, NULL, 100, '3500600200000', NULL, NULL, NULL, NULL, NULL),
(241, 1, 'Никольск', 80, '161440', 1, NULL, 100, '3501500100000', NULL, NULL, NULL, NULL, NULL),
(242, 1, 'Сокол', 80, '162130', 1, NULL, 100, '3501700100000', NULL, NULL, NULL, NULL, NULL),
(243, 1, 'Тотьма', 80, '161300', 1, NULL, 100, '3502000100000', NULL, NULL, NULL, NULL, NULL),
(244, 1, 'Устюжна', 80, '162840', 1, NULL, 100, '3502200100000', NULL, NULL, NULL, NULL, NULL),
(245, 1, 'Харовск', 80, '162250', 1, NULL, 100, '3502300100000', NULL, NULL, NULL, NULL, NULL),
(246, 1, 'Череповец', 80, '162600', 1, NULL, 100, '3500000200000', NULL, NULL, NULL, NULL, NULL),
(247, 1, 'Бобров', 32, '397700', 1, NULL, 100, '3600300100000', NULL, NULL, NULL, NULL, NULL),
(248, 1, 'Богучар', 32, '396790', 1, NULL, 100, '3600400100000', NULL, NULL, NULL, NULL, NULL),
(249, 1, 'Борисоглебск', 32, '397160', 1, NULL, 100, '3600500100000', NULL, NULL, NULL, NULL, NULL),
(250, 1, 'Бутурлиновка', 32, '397500', 1, NULL, 100, '3600600100000', NULL, NULL, NULL, NULL, NULL),
(251, 1, 'Воронеж', 32, '394000', 1, NULL, 100, '3600000100000', NULL, NULL, NULL, NULL, NULL),
(252, 1, 'Калач', 32, '397600', 1, NULL, 100, '3601100100000', NULL, NULL, NULL, NULL, NULL),
(253, 1, 'Лиски', 32, '397900', 1, NULL, 100, '3601500100000', NULL, NULL, NULL, NULL, NULL),
(254, 1, 'Нововоронеж', 32, '396070', 1, NULL, 100, '3600000300000', NULL, NULL, NULL, NULL, NULL),
(255, 1, 'Новохоперск', 32, '397400', 1, NULL, 100, '3601800100000', NULL, NULL, NULL, NULL, NULL),
(256, 1, 'Острогожск', 32, '397850', 1, NULL, 100, '3602000100000', NULL, NULL, NULL, NULL, NULL),
(257, 1, 'Павловск', 32, '196620', 1, NULL, 100, '3602100100000', NULL, NULL, NULL, NULL, NULL),
(258, 1, 'Поворино', 32, '397350', 1, NULL, 100, '3602400100000', NULL, NULL, NULL, NULL, NULL),
(259, 1, 'Россошь', 32, '346073', 1, NULL, 100, '3602800100000', NULL, NULL, NULL, NULL, NULL),
(260, 1, 'Семилуки', 32, '396900', 1, NULL, 100, '3602900100000', NULL, NULL, NULL, NULL, NULL),
(261, 1, 'Эртиль', 32, '397030', 1, NULL, 100, '3603300100000', NULL, NULL, NULL, NULL, NULL),
(262, 1, 'Алейск', 79, '658130', 1, NULL, 100, '2200000200000', NULL, NULL, NULL, NULL, NULL),
(263, 1, 'Барнаул', 79, '656000', 1, NULL, 100, '2200000100000', NULL, NULL, NULL, NULL, NULL),
(264, 1, 'Белокуриха', 79, '659900', 1, NULL, 100, '2200000300000', NULL, NULL, NULL, NULL, NULL),
(265, 1, 'Бийск', 79, '659300', 1, NULL, 100, '2200000400000', NULL, NULL, NULL, NULL, NULL),
(266, 1, 'Горняк', 79, '658423', 1, NULL, 100, '2202700100000', NULL, NULL, NULL, NULL, NULL),
(267, 1, 'Заринск', 79, '659100', 1, NULL, 100, '2200001100000', NULL, NULL, NULL, NULL, NULL),
(268, 1, 'Змеиногорск', 79, '658480', 1, NULL, 100, '2201500100000', NULL, NULL, NULL, NULL, NULL),
(269, 1, 'Камень-на-Оби', 79, '658700', 1, NULL, 100, '2201800100000', NULL, NULL, NULL, NULL, NULL),
(270, 1, 'Новоалтайск', 79, '658091', 1, NULL, 100, '2200000800000', NULL, NULL, NULL, NULL, NULL),
(271, 1, 'Рубцовск', 79, '658200', 1, NULL, 100, '2200000900000', NULL, NULL, NULL, NULL, NULL),
(272, 1, 'Славгород', 79, '658820', 1, NULL, 100, '2200001000000', NULL, NULL, NULL, NULL, NULL),
(273, 1, 'Яровое', 79, '627227', 1, NULL, 100, '2200001200000', NULL, NULL, NULL, NULL, NULL),
(274, 1, 'Буйнакск', 31, '368220', 1, NULL, 100, '0500001000000', NULL, NULL, NULL, NULL, NULL),
(275, 1, 'Дагестанские Огни', 31, '368670', 1, NULL, 100, '0500000200000', NULL, NULL, NULL, NULL, NULL),
(276, 1, 'Дербент', 31, '368607', 1, NULL, 100, '0500000600000', NULL, NULL, NULL, NULL, NULL),
(277, 1, 'Избербаш', 31, '368500', 1, NULL, 100, '0500000300000', NULL, NULL, NULL, NULL, NULL),
(278, 1, 'Каспийск', 31, '368300', 1, NULL, 100, '0500000400000', NULL, NULL, NULL, NULL, NULL),
(279, 1, 'Кизилюрт', 31, '368120', 1, NULL, 100, '0500000700000', NULL, NULL, NULL, NULL, NULL),
(280, 1, 'Кизляр', 31, '363709', 1, NULL, 100, '0500000800000', NULL, NULL, NULL, NULL, NULL),
(281, 1, 'Махачкала', 31, '367000', 1, NULL, 100, '0500000100000', NULL, NULL, NULL, NULL, NULL),
(282, 1, 'Хасавюрт', 31, '368000', 1, NULL, 100, '0500000900000', NULL, NULL, NULL, NULL, NULL),
(283, 1, 'Южно-Сухокумск', 31, '368890', 1, NULL, 100, '0500000500000', NULL, NULL, NULL, NULL, NULL),
(284, 1, 'Биробиджан', 78, '679000', 1, NULL, 100, '7900000100000', NULL, NULL, NULL, NULL, NULL),
(285, 1, 'Облучье', 78, '679100', 1, NULL, 100, '7900300100000', NULL, NULL, NULL, NULL, NULL),
(286, 1, 'Абинск', 77, '353320', 1, NULL, 100, '2300200100000', NULL, NULL, NULL, NULL, NULL),
(287, 1, 'Анапа', 77, '353457', 1, NULL, 100, '2300300100000', NULL, NULL, NULL, NULL, NULL),
(288, 1, 'Апшеронск', 77, '352690', 1, NULL, 100, '2300400100000', NULL, NULL, NULL, NULL, NULL),
(289, 1, 'Армавир', 77, '352900', 1, NULL, 100, '2300000200000', NULL, NULL, NULL, NULL, NULL),
(290, 1, 'Белореченск', 77, '352635', 1, NULL, 100, '2300600100000', NULL, NULL, NULL, NULL, NULL),
(291, 1, 'Геленджик', 77, '353460', 1, NULL, 100, '2300000300000', NULL, NULL, NULL, NULL, NULL),
(292, 1, 'Горячий Ключ', 77, '353290', 1, NULL, 100, '2300000400000', NULL, NULL, NULL, NULL, NULL),
(293, 1, 'Гулькевичи', 77, '352190', 1, NULL, 100, '2300900100000', NULL, NULL, NULL, NULL, NULL),
(294, 1, 'Ейск', 77, '353680', 1, NULL, 100, '2301100100000', NULL, NULL, NULL, NULL, NULL),
(295, 1, 'Кореновск', 77, '353182', 1, NULL, 100, '2301500100000', NULL, NULL, NULL, NULL, NULL),
(296, 1, 'Краснодар', 77, '350000', 1, NULL, 100, '2300000100000', NULL, NULL, NULL, NULL, NULL),
(297, 1, 'Кропоткин', 77, '352380', 1, NULL, 100, '2301200100000', NULL, NULL, NULL, NULL, NULL),
(298, 1, 'Крымск', 77, '353389', 1, NULL, 100, '2301800100000', NULL, NULL, NULL, NULL, NULL),
(299, 1, 'Курганинск', 77, '352430', 1, NULL, 100, '2301900100000', NULL, NULL, NULL, NULL, NULL),
(300, 1, 'Лабинск', 77, '352500', 1, NULL, 100, '2302100100000', NULL, NULL, NULL, NULL, NULL),
(301, 1, 'Новокубанск', 77, '352240', 1, NULL, 100, '2302400100000', NULL, NULL, NULL, NULL, NULL),
(302, 1, 'Новороссийск', 77, '353900', 1, NULL, 100, '2300000600000', NULL, NULL, NULL, NULL, NULL),
(303, 1, 'Приморско-Ахтарск', 77, '353861', 1, NULL, 100, '2302800100000', NULL, NULL, NULL, NULL, NULL),
(304, 1, 'Славянск-на-Кубани', 77, '353560', 1, NULL, 100, '2303000100000', NULL, NULL, NULL, NULL, NULL),
(305, 1, 'Сочи', 77, '354000', 1, NULL, 100, '2300000700000', NULL, NULL, NULL, NULL, NULL),
(306, 1, 'Темрюк', 77, '353500', 1, NULL, 100, '2303300100000', NULL, NULL, NULL, NULL, NULL),
(307, 1, 'Тимашевск', 77, '352700', 1, NULL, 100, '2303400100000', NULL, NULL, NULL, NULL, NULL),
(308, 1, 'Тихорецк', 77, '352120', 1, NULL, 100, '2303500100000', NULL, NULL, NULL, NULL, NULL),
(309, 1, 'Туапсе', 77, '352800', 1, NULL, 100, '2303600100000', NULL, NULL, NULL, NULL, NULL),
(310, 1, 'Усть-Лабинск', 77, '352330', 1, NULL, 100, '2303800100000', NULL, NULL, NULL, NULL, NULL),
(311, 1, 'Хадыженск', 77, '352681', 1, NULL, 100, '2300400200000', NULL, NULL, NULL, NULL, NULL),
(312, 1, 'Артемовск', 30, '662951', 1, NULL, 100, '2402400200000', NULL, NULL, NULL, NULL, NULL),
(313, 1, 'Ачинск', 30, '662150', 1, NULL, 100, '2400001200000', NULL, NULL, NULL, NULL, NULL),
(314, 1, 'Боготол', 30, '662060', 1, NULL, 100, '2400001300000', NULL, NULL, NULL, NULL, NULL),
(315, 1, 'Бородино', 30, '663980', 1, NULL, 100, '2400000200000', NULL, NULL, NULL, NULL, NULL),
(316, 1, 'Дивногорск', 30, '663090', 1, NULL, 100, '2400000300000', NULL, NULL, NULL, NULL, NULL),
(317, 1, 'Дудинка', 30, '647000', 1, NULL, 100, '2404800100000', NULL, NULL, NULL, NULL, NULL),
(318, 1, 'Енисейск', 30, '663180', 1, NULL, 100, '2400001400000', NULL, NULL, NULL, NULL, NULL),
(319, 1, 'Железногорск', 30, '307170', 1, NULL, 100, '2400000400000', NULL, NULL, NULL, NULL, NULL),
(320, 1, 'Заозерный', 30, '663960', 1, NULL, 100, '2403301500000', NULL, NULL, NULL, NULL, NULL),
(321, 1, 'Зеленогорск', 30, '663694', 1, NULL, 100, '2400000500000', NULL, NULL, NULL, NULL, NULL),
(322, 1, 'Игарка', 30, '663200', 1, NULL, 100, '2403801700000', NULL, NULL, NULL, NULL, NULL),
(323, 1, 'Иланский', 30, '663800', 1, NULL, 100, '2401600100000', NULL, NULL, NULL, NULL, NULL),
(324, 1, 'Канск', 30, '663600', 1, NULL, 100, '2400001600000', NULL, NULL, NULL, NULL, NULL),
(325, 1, 'Кодинск', 30, '663491', 1, NULL, 100, '2402100100000', NULL, NULL, NULL, NULL, NULL),
(326, 1, 'Красноярск', 30, '660000', 1, NULL, 100, '2400000100000', NULL, NULL, NULL, NULL, NULL),
(327, 1, 'Лесосибирск', 30, '662540', 1, NULL, 100, '2400000800000', NULL, NULL, NULL, NULL, NULL),
(328, 1, 'Минусинск', 30, '662600', 1, NULL, 100, '2400001700000', NULL, NULL, NULL, NULL, NULL),
(329, 1, 'Назарово', 30, '662206', 1, NULL, 100, '2400001800000', NULL, NULL, NULL, NULL, NULL),
(330, 1, 'Норильск', 30, '663300', 1, NULL, 100, '2400000900000', NULL, NULL, NULL, NULL, NULL),
(331, 1, 'Сосновоборск', 30, '442570', 1, NULL, 100, '2400001000000', NULL, NULL, NULL, NULL, NULL),
(332, 1, 'Ужур', 30, '662250', 1, NULL, 100, '2404000100000', NULL, NULL, NULL, NULL, NULL),
(333, 1, 'Уяр', 30, '663920', 1, NULL, 100, '2404100100000', NULL, NULL, NULL, NULL, NULL),
(334, 1, 'Шарыпово', 30, '662310', 1, NULL, 100, '2400001900000', NULL, NULL, NULL, NULL, NULL),
(335, 1, 'Архангельск', 76, '163000', 1, NULL, 100, '2900000100000', NULL, NULL, NULL, NULL, NULL),
(336, 1, 'Вельск', 76, '165151', 1, NULL, 100, '2900200100000', NULL, NULL, NULL, NULL, NULL),
(337, 1, 'Каргополь', 76, '164110', 1, NULL, 100, '2900600100000', NULL, NULL, NULL, NULL, NULL),
(338, 1, 'Коряжма', 76, '165650', 1, NULL, 100, '2900000500000', NULL, NULL, NULL, NULL, NULL),
(339, 1, 'Котлас', 76, '165300', 1, NULL, 100, '2900800100000', NULL, NULL, NULL, NULL, NULL),
(340, 1, 'Мезень', 76, '164750', 1, NULL, 100, '2901200100000', NULL, NULL, NULL, NULL, NULL),
(341, 1, 'Мирный', 76, '162236', 1, NULL, 100, '2900000200000', NULL, NULL, NULL, NULL, NULL),
(342, 1, 'Новодвинск', 76, '164900', 1, NULL, 100, '2900000300000', NULL, NULL, NULL, NULL, NULL),
(343, 1, 'Няндома', 76, '164200', 1, NULL, 100, '2901300100000', NULL, NULL, NULL, NULL, NULL),
(344, 1, 'Онега', 76, '164844', 1, NULL, 100, '2901400100000', NULL, NULL, NULL, NULL, NULL),
(345, 1, 'Северодвинск', 76, '164500', 1, NULL, 100, '2900000400000', NULL, NULL, NULL, NULL, NULL),
(346, 1, 'Сольвычегодск', 76, '165330', 1, NULL, 100, '2900800300000', NULL, NULL, NULL, NULL, NULL),
(347, 1, 'Шенкурск', 76, '165160', 1, NULL, 100, '2901900100000', NULL, NULL, NULL, NULL, NULL),
(348, 1, 'Белогорск', 75, '676853', 1, NULL, 100, '2800000300000', NULL, NULL, NULL, NULL, NULL),
(349, 1, 'Благовещенск', 75, '675000', 1, NULL, 100, '2800000100000', NULL, NULL, NULL, NULL, NULL),
(350, 1, 'Завитинск', 75, '676471', 1, NULL, 100, '2800500100000', NULL, NULL, NULL, NULL, NULL),
(351, 1, 'Зея', 75, '675824', 1, NULL, 100, '2800000400000', NULL, NULL, NULL, NULL, NULL),
(352, 1, 'Райчихинск', 75, '676770', 1, NULL, 100, '2800000200000', NULL, NULL, NULL, NULL, NULL),
(353, 1, 'Свободный', 75, '346958', 1, NULL, 100, '2800000500000', NULL, NULL, NULL, NULL, NULL),
(354, 1, 'Сковородино', 75, '676010', 1, NULL, 100, '2801700100000', NULL, NULL, NULL, NULL, NULL),
(355, 1, 'Тында', 75, '675828', 1, NULL, 100, '2800000600000', NULL, NULL, NULL, NULL, NULL),
(356, 1, 'Циолковский', 75, '676470', 1, NULL, 100, '2800001000000', NULL, NULL, NULL, NULL, NULL),
(357, 1, 'Шимановск', 75, '676301', 1, NULL, 100, '2800000700000', NULL, NULL, NULL, NULL, NULL),
(358, 1, 'Горно-Алтайск', 74, '649000', 1, NULL, 100, '0400000100000', NULL, NULL, NULL, NULL, NULL),
(359, 1, 'Адыгейск', 73, '385200', 1, NULL, 100, '0100000200000', NULL, NULL, NULL, NULL, NULL),
(360, 1, 'Майкоп', 73, '385000', 1, NULL, 100, '0100000100000', NULL, NULL, NULL, NULL, NULL),
(361, 1, 'Брянск', 72, '241000', 1, NULL, 100, '3200000100000', NULL, NULL, NULL, NULL, NULL),
(362, 1, 'Дятьково', 72, '242600', 1, NULL, 100, '3200600100000', NULL, NULL, NULL, NULL, NULL),
(363, 1, 'Жуковка', 72, '242700', 1, NULL, 100, '3200800100000', NULL, NULL, NULL, NULL, NULL),
(364, 1, 'Злынка', 72, '243600', 1, NULL, 100, '3200900100000', NULL, NULL, NULL, NULL, NULL),
(365, 1, 'Карачев', 72, '242500', 1, NULL, 100, '3201000100000', NULL, NULL, NULL, NULL, NULL),
(366, 1, 'Клинцы', 72, '243140', 1, NULL, 100, '3200000300000', NULL, NULL, NULL, NULL, NULL),
(367, 1, 'Мглин', 72, '243220', 1, NULL, 100, '3201600100000', NULL, NULL, NULL, NULL, NULL),
(368, 1, 'Новозыбков', 72, '243020', 1, NULL, 100, '3200000400000', NULL, NULL, NULL, NULL, NULL),
(369, 1, 'Почеп', 72, '243400', 1, NULL, 100, '3202000100000', NULL, NULL, NULL, NULL, NULL),
(370, 1, 'Севск', 72, '242440', 1, NULL, 100, '3202200100000', NULL, NULL, NULL, NULL, NULL),
(371, 1, 'Сельцо', 72, '187052', 1, NULL, 100, '3200000200000', NULL, NULL, NULL, NULL, NULL),
(372, 1, 'Стародуб', 72, '243240', 1, NULL, 100, '3200000600000', NULL, NULL, NULL, NULL, NULL),
(373, 1, 'Сураж', 72, '243500', 1, NULL, 100, '3202500100000', NULL, NULL, NULL, NULL, NULL),
(374, 1, 'Трубчевск', 72, '242220', 1, NULL, 100, '3202600100000', NULL, NULL, NULL, NULL, NULL),
(375, 1, 'Унеча', 72, '243300', 1, NULL, 100, '3202700100000', NULL, NULL, NULL, NULL, NULL),
(376, 1, 'Фокино', 72, '242610', 1, NULL, 100, '3200000500000', NULL, NULL, NULL, NULL, NULL),
(377, 1, 'Вичуга', 71, '155331', 1, NULL, 100, '3700300100000', NULL, NULL, NULL, NULL, NULL),
(378, 1, 'Гаврилов Посад', 71, '155000', 1, NULL, 100, '3700400100000', NULL, NULL, NULL, NULL, NULL),
(379, 1, 'Заволжск', 71, '155410', 1, NULL, 100, '3700500100000', NULL, NULL, NULL, NULL, NULL),
(380, 1, 'Иваново', 71, '153023', 1, NULL, 100, '3700000100000', NULL, NULL, NULL, NULL, NULL),
(381, 1, 'Кинешма', 71, '155800', 1, NULL, 100, '3700000200000', NULL, NULL, NULL, NULL, NULL),
(382, 1, 'Комсомольск', 71, '155150', 1, NULL, 100, '3700800100000', NULL, NULL, NULL, NULL, NULL),
(383, 1, 'Кохма', 71, '153510', 1, NULL, 100, '3700100200000', NULL, NULL, NULL, NULL, NULL),
(384, 1, 'Наволоки', 71, '155830', 1, NULL, 100, '3700700200000', NULL, NULL, NULL, NULL, NULL),
(385, 1, 'Плес', 71, '155555', 1, NULL, 100, '3701300200000', NULL, NULL, NULL, NULL, NULL),
(386, 1, 'Приволжск', 71, '155550', 1, NULL, 100, '3701300100000', NULL, NULL, NULL, NULL, NULL),
(387, 1, 'Пучеж', 71, '155360', 1, NULL, 100, '3701400100000', NULL, NULL, NULL, NULL, NULL),
(388, 1, 'Родники', 71, '140143', 1, NULL, 100, '3701500100000', NULL, NULL, NULL, NULL, NULL),
(389, 1, 'Тейково', 71, '155040', 1, NULL, 100, '3701700100000', NULL, NULL, NULL, NULL, NULL),
(390, 1, 'Фурманов', 71, '155520', 1, NULL, 100, '3701800100000', NULL, NULL, NULL, NULL, NULL),
(391, 1, 'Шуя', 71, '155900', 1, NULL, 100, '3701900100000', NULL, NULL, NULL, NULL, NULL),
(392, 1, 'Южа', 71, '155630', 1, NULL, 100, '3702000100000', NULL, NULL, NULL, NULL, NULL),
(393, 1, 'Юрьевец', 71, '155450', 1, NULL, 100, '3702100100000', NULL, NULL, NULL, NULL, NULL),
(394, 1, 'Анадырь', 70, '689000', 1, NULL, 100, '8700000100000', NULL, NULL, NULL, NULL, NULL),
(395, 1, 'Билибино', 70, '689450', 1, NULL, 100, '8700300100000', NULL, NULL, NULL, NULL, NULL),
(396, 1, 'Певек', 70, '689400', 1, NULL, 100, '8700600100000', NULL, NULL, NULL, NULL, NULL),
(397, 1, 'Аркадак', 69, '412210', 1, NULL, 100, '6400300100000', NULL, NULL, NULL, NULL, NULL),
(398, 1, 'Аткарск', 69, '412420', 1, NULL, 100, '6400000300000', NULL, NULL, NULL, NULL, NULL),
(399, 1, 'Балаково', 69, '413853', 1, NULL, 100, '6400000400000', NULL, NULL, NULL, NULL, NULL),
(400, 1, 'Балашов', 69, '412315', 1, NULL, 100, '6400000500000', NULL, NULL, NULL, NULL, NULL),
(401, 1, 'Вольск', 69, '412900', 1, NULL, 100, '6400000600000', NULL, NULL, NULL, NULL, NULL),
(402, 1, 'Вольск-18', 69, '412918', 1, NULL, 100, '6400000602500', NULL, NULL, NULL, NULL, NULL),
(403, 1, 'Ершов', 69, '413500', 1, NULL, 100, '6401400100000', NULL, NULL, NULL, NULL, NULL),
(404, 1, 'Калининск', 69, '412481', 1, NULL, 100, '6401600100000', NULL, NULL, NULL, NULL, NULL),
(405, 1, 'Красный Кут', 69, '413235', 1, NULL, 100, '6401800100000', NULL, NULL, NULL, NULL, NULL),
(406, 1, 'Маркс', 69, '413089', 1, NULL, 100, '6400000800000', NULL, NULL, NULL, NULL, NULL),
(407, 1, 'Новоузенск', 69, '413360', 1, NULL, 100, '6402300100000', NULL, NULL, NULL, NULL, NULL),
(408, 1, 'Петровск', 69, '412540', 1, NULL, 100, '6400000900000', NULL, NULL, NULL, NULL, NULL),
(409, 1, 'Пугачев', 69, '413720', 1, NULL, 100, '6400001000000', NULL, NULL, NULL, NULL, NULL),
(410, 1, 'Ртищево', 69, '303719', 1, NULL, 100, '6400001100000', NULL, NULL, NULL, NULL, NULL),
(411, 1, 'Саратов', 69, '410000', 1, NULL, 100, '6400000100000', NULL, NULL, NULL, NULL, NULL),
(412, 1, 'Хвалынск', 69, '412780', 1, NULL, 100, '6400001200000', NULL, NULL, NULL, NULL, NULL),
(413, 1, 'Шиханы', 69, '412950', 1, NULL, 100, '6400000200000', NULL, NULL, NULL, NULL, NULL),
(414, 1, 'Энгельс', 69, '413100', 1, NULL, 100, '6400001300000', NULL, NULL, NULL, NULL, NULL),
(415, 1, 'Багратионовск', 29, '238420', 1, NULL, 100, '3900200100000', NULL, NULL, NULL, NULL, NULL),
(416, 1, 'Балтийск', 29, '238520', 1, NULL, 100, '3901500100000', NULL, NULL, NULL, NULL, NULL),
(417, 1, 'Гвардейск', 29, '238210', 1, NULL, 100, '3900300100000', NULL, NULL, NULL, NULL, NULL),
(418, 1, 'Гурьевск', 29, '238300', 1, NULL, 100, '3900400100000', NULL, NULL, NULL, NULL, NULL),
(419, 1, 'Гусев', 29, '238050', 1, NULL, 100, '3900500100000', NULL, NULL, NULL, NULL, NULL),
(420, 1, 'Зеленоградск', 29, '238326', 1, NULL, 100, '3900600100000', NULL, NULL, NULL, NULL, NULL),
(421, 1, 'Калининград', 29, '236001', 1, NULL, 100, '3900000100000', NULL, NULL, NULL, NULL, NULL),
(422, 1, 'Краснознаменск', 29, '143090', 1, NULL, 100, '3900700100000', NULL, NULL, NULL, NULL, NULL),
(423, 1, 'Ладушкин', 29, '238460', 1, NULL, 100, '3900000800000', NULL, NULL, NULL, NULL, NULL),
(424, 1, 'Мамоново', 29, '238450', 1, NULL, 100, '3900000900000', NULL, NULL, NULL, NULL, NULL),
(425, 1, 'Неман', 29, '238710', 1, NULL, 100, '3900800100000', NULL, NULL, NULL, NULL, NULL),
(426, 1, 'Нестеров', 29, '238010', 1, NULL, 100, '3900900100000', NULL, NULL, NULL, NULL, NULL),
(427, 1, 'Озерск', 29, '238120', 1, NULL, 100, '3901000100000', NULL, NULL, NULL, NULL, NULL),
(428, 1, 'Пионерский', 29, '161061', 1, NULL, 100, '3900000300000', NULL, NULL, NULL, NULL, NULL),
(429, 1, 'Полесск', 29, '238630', 1, NULL, 100, '3901100100000', NULL, NULL, NULL, NULL, NULL),
(430, 1, 'Правдинск', 29, '238400', 1, NULL, 100, '3901200100000', NULL, NULL, NULL, NULL, NULL),
(431, 1, 'Приморск', 29, '188910', 1, NULL, 100, '3901500200000', NULL, NULL, NULL, NULL, NULL),
(432, 1, 'Светлогорск', 29, '238560', 1, NULL, 100, '3901600100000', NULL, NULL, NULL, NULL, NULL),
(433, 1, 'Светлый', 29, '164557', 1, NULL, 100, '3900000600000', NULL, NULL, NULL, NULL, NULL),
(434, 1, 'Славск', 29, '238600', 1, NULL, 100, '3901300100000', NULL, NULL, NULL, NULL, NULL),
(435, 1, 'Советск', 29, '236876', 1, NULL, 100, '3900000700000', NULL, NULL, NULL, NULL, NULL),
(436, 1, 'Черняховск', 29, '236816', 1, NULL, 100, '3901400100000', NULL, NULL, NULL, NULL, NULL),
(437, 1, 'Городовиковск', 68, '359050', 1, NULL, 100, '0800200100000', NULL, NULL, NULL, NULL, NULL),
(438, 1, 'Лагань', 68, '359220', 1, NULL, 100, '0800600100000', NULL, NULL, NULL, NULL, NULL),
(439, 1, 'Элиста', 68, '358000', 1, NULL, 100, '0800000100000', NULL, NULL, NULL, NULL, NULL),
(440, 1, 'Балабаново', 67, '249000', 1, NULL, 100, '4000400200000', NULL, NULL, NULL, NULL, NULL),
(441, 1, 'Белоусово', 67, '162930', 1, NULL, 100, '4000900200000', NULL, NULL, NULL, NULL, NULL),
(442, 1, 'Боровск', 67, '249010', 1, NULL, 100, '4000400100000', NULL, NULL, NULL, NULL, NULL),
(443, 1, 'Ермолино', 67, '141923', 1, NULL, 100, '4000400400000', NULL, NULL, NULL, NULL, NULL),
(444, 1, 'Жиздра', 67, '249340', 1, NULL, 100, '4000800100000', NULL, NULL, NULL, NULL, NULL),
(445, 1, 'Жуков', 67, '249190', 1, NULL, 100, '4000900100000', NULL, NULL, NULL, NULL, NULL),
(446, 1, 'Калуга', 67, '248000', 1, NULL, 100, '4000000100000', NULL, NULL, NULL, NULL, NULL),
(447, 1, 'Киров', 67, '249440', 1, NULL, 100, '4001100100000', NULL, NULL, NULL, NULL, NULL),
(448, 1, 'Козельск', 67, '249141', 1, NULL, 100, '4001200100000', NULL, NULL, NULL, NULL, NULL),
(449, 1, 'Кондрово', 67, '249830', 1, NULL, 100, '4000600100000', NULL, NULL, NULL, NULL, NULL),
(450, 1, 'Кременки', 67, '249185', 1, NULL, 100, '4000900400000', NULL, NULL, NULL, NULL, NULL),
(451, 1, 'Людиново', 67, '249342', 1, NULL, 100, '4001400100000', NULL, NULL, NULL, NULL, NULL),
(452, 1, 'Малоярославец', 67, '249091', 1, NULL, 100, '4001500100000', NULL, NULL, NULL, NULL, NULL),
(453, 1, 'Медынь', 67, '249950', 1, NULL, 100, '4001600100000', NULL, NULL, NULL, NULL, NULL),
(454, 1, 'Мещовск', 67, '249240', 1, NULL, 100, '4001700100000', NULL, NULL, NULL, NULL, NULL),
(455, 1, 'Мосальск', 67, '249930', 1, NULL, 100, '4001800100000', NULL, NULL, NULL, NULL, NULL),
(456, 1, 'Обнинск', 67, '249030', 1, NULL, 100, '4000000200000', NULL, NULL, NULL, NULL, NULL),
(457, 1, 'Сосенский', 67, '249710', 1, NULL, 100, '4001200200000', NULL, NULL, NULL, NULL, NULL),
(458, 1, 'Спас-Деменск', 67, '249610', 1, NULL, 100, '4000500100000', NULL, NULL, NULL, NULL, NULL),
(459, 1, 'Сухиничи', 67, '249270', 1, NULL, 100, '4002000100000', NULL, NULL, NULL, NULL, NULL),
(460, 1, 'Таруса', 67, '249100', 1, NULL, 100, '4002100100000', NULL, NULL, NULL, NULL, NULL),
(461, 1, 'Юхнов', 67, '249910', 1, NULL, 100, '4002500200000', NULL, NULL, NULL, NULL, NULL),
(462, 1, 'Вилючинск', 66, '684090', 1, NULL, 100, '4100000200000', NULL, NULL, NULL, NULL, NULL),
(463, 1, 'Елизово', 66, '684000', 1, NULL, 100, '4100500100000', NULL, NULL, NULL, NULL, NULL),
(464, 1, 'Петропавловск-Камчатский', 66, '683000', 1, NULL, 100, '4100000100000', NULL, NULL, NULL, NULL, NULL),
(465, 1, 'Карачаевск', 28, '369200', 1, NULL, 100, '0900000200000', NULL, NULL, NULL, NULL, NULL),
(466, 1, 'Теберда', 28, '369210', 1, NULL, 100, '0900000300000', NULL, NULL, NULL, NULL, NULL),
(467, 1, 'Усть-Джегута', 28, '369300', 1, NULL, 100, '0900800100000', NULL, NULL, NULL, NULL, NULL),
(468, 1, 'Черкесск', 28, '369000', 1, NULL, 100, '0900000100000', NULL, NULL, NULL, NULL, NULL),
(469, 1, 'Беломорск', 65, '186500', 1, NULL, 100, '1000200100000', NULL, NULL, NULL, NULL, NULL),
(470, 1, 'Кемь', 65, '186610', 1, NULL, 100, '1000400100000', NULL, NULL, NULL, NULL, NULL),
(471, 1, 'Кондопога', 65, '186215', 1, NULL, 100, '1000500100000', NULL, NULL, NULL, NULL, NULL),
(472, 1, 'Костомукша', 65, '186930', 1, NULL, 100, '1000000400000', NULL, NULL, NULL, NULL, NULL),
(473, 1, 'Лахденпохья', 65, '186730', 1, NULL, 100, '1000600100000', NULL, NULL, NULL, NULL, NULL),
(474, 1, 'Медвежьегорск', 65, '186302', 1, NULL, 100, '1000800100000', NULL, NULL, NULL, NULL, NULL),
(475, 1, 'Олонец', 65, '186000', 1, NULL, 100, '1001000100000', NULL, NULL, NULL, NULL, NULL),
(476, 1, 'Петрозаводск', 65, '185000', 1, NULL, 100, '1000000100000', NULL, NULL, NULL, NULL, NULL),
(477, 1, 'Питкяранта', 65, '186810', 1, NULL, 100, '1001100100000', NULL, NULL, NULL, NULL, NULL),
(478, 1, 'Пудож', 65, '186150', 1, NULL, 100, '1001300100000', NULL, NULL, NULL, NULL, NULL),
(479, 1, 'Сегежа', 65, '186420', 1, NULL, 100, '1001400100000', NULL, NULL, NULL, NULL, NULL),
(480, 1, 'Сортавала', 65, '186790', 1, NULL, 100, '1000000700000', NULL, NULL, NULL, NULL, NULL),
(481, 1, 'Суоярви', 65, '186870', 1, NULL, 100, '1001500100000', NULL, NULL, NULL, NULL, NULL),
(482, 1, 'Анжеро-Судженск', 27, '652470', 1, NULL, 100, '4200000200000', NULL, NULL, NULL, NULL, NULL),
(483, 1, 'Белово', 27, '157138', 1, NULL, 100, '4200001500000', NULL, NULL, NULL, NULL, NULL),
(484, 1, 'Березовский', 27, '249355', 1, NULL, 100, '4200000300000', NULL, NULL, NULL, NULL, NULL),
(485, 1, 'Калтан', 27, '652740', 1, NULL, 100, '4200000400000', NULL, NULL, NULL, NULL, NULL),
(486, 1, 'Кемерово', 27, '650000', 1, NULL, 100, '4200000900000', NULL, NULL, NULL, NULL, NULL),
(487, 1, 'Киселевск', 27, '652700', 1, NULL, 100, '4200000500000', NULL, NULL, NULL, NULL, NULL),
(488, 1, 'Ленинск-Кузнецкий', 27, '652500', 1, NULL, 100, '4200001000000', NULL, NULL, NULL, NULL, NULL),
(489, 1, 'Мариинск', 27, '652150', 1, NULL, 100, '4200700100000', NULL, NULL, NULL, NULL, NULL),
(490, 1, 'Междуреченск', 27, '169260', 1, NULL, 100, '4200001600000', NULL, NULL, NULL, NULL, NULL),
(491, 1, 'Мыски', 27, '652840', 1, NULL, 100, '4200000600000', NULL, NULL, NULL, NULL, NULL),
(492, 1, 'Новокузнецк', 27, '654000', 1, NULL, 100, '4200001200000', NULL, NULL, NULL, NULL, NULL),
(493, 1, 'Осинники', 27, '652800', 1, NULL, 100, '4200000700000', NULL, NULL, NULL, NULL, NULL),
(494, 1, 'Полысаево', 27, '652560', 1, NULL, 100, '4200001100000', NULL, NULL, NULL, NULL, NULL),
(495, 1, 'Прокопьевск', 27, '653000', 1, NULL, 100, '4200001300000', NULL, NULL, NULL, NULL, NULL),
(496, 1, 'Салаир', 27, '652770', 1, NULL, 100, '4200300200000', NULL, NULL, NULL, NULL, NULL),
(497, 1, 'Тайга', 27, '164644', 1, NULL, 100, '4200000800000', NULL, NULL, NULL, NULL, NULL),
(498, 1, 'Таштагол', 27, '652990', 1, NULL, 100, '4201200100000', NULL, NULL, NULL, NULL, NULL),
(499, 1, 'Топки', 27, '303187', 1, NULL, 100, '4201400100000', NULL, NULL, NULL, NULL, NULL),
(500, 1, 'Юрга', 27, '652050', 1, NULL, 100, '4200001400000', NULL, NULL, NULL, NULL, NULL),
(501, 1, 'Балей', 64, '673450', 1, NULL, 100, '7500400100000', NULL, NULL, NULL, NULL, NULL),
(502, 1, 'Борзя', 64, '674600', 1, NULL, 100, '7500500100000', NULL, NULL, NULL, NULL, NULL),
(503, 1, 'Краснокаменск', 64, '662955', 1, NULL, 100, '7501100100000', NULL, NULL, NULL, NULL, NULL),
(504, 1, 'Могоча', 64, '673730', 1, NULL, 100, '7501400100000', NULL, NULL, NULL, NULL, NULL),
(505, 1, 'Нерчинск', 64, '672840', 1, NULL, 100, '7501500100000', NULL, NULL, NULL, NULL, NULL),
(506, 1, 'Петровск-Забайкальский', 64, '672801', 1, NULL, 100, '7501900100000', NULL, NULL, NULL, NULL, NULL),
(507, 1, 'Сретенск', 64, '673500', 1, NULL, 100, '7502100100000', NULL, NULL, NULL, NULL, NULL),
(508, 1, 'Хилок', 64, '673200', 1, NULL, 100, '7502500100000', NULL, NULL, NULL, NULL, NULL),
(509, 1, 'Чита', 64, '422792', 1, NULL, 100, '7500000100000', NULL, NULL, NULL, NULL, NULL),
(510, 1, 'Шилка', 64, '673302', 1, NULL, 100, '7502800100000', NULL, NULL, NULL, NULL, NULL),
(511, 1, 'Баксан', 63, '361530', 1, NULL, 100, '0700000300000', NULL, NULL, NULL, NULL, NULL),
(512, 1, 'Майский', 63, '160508', 1, NULL, 100, '3500100000900', NULL, NULL, NULL, NULL, NULL),
(513, 1, 'Нальчик', 63, '360000', 1, NULL, 100, '0700000100000', NULL, NULL, NULL, NULL, NULL),
(514, 1, 'Нарткала', 63, '361330', 1, NULL, 100, '0700700100000', NULL, NULL, NULL, NULL, NULL),
(515, 1, 'Прохладный', 63, '361040', 1, NULL, 100, '0700000200000', NULL, NULL, NULL, NULL, NULL),
(516, 1, 'Терек', 63, '356837', 1, NULL, 100, '2600700001200', NULL, NULL, NULL, NULL, NULL),
(517, 1, 'Тырныауз', 63, '361621', 1, NULL, 100, '0701000100000', NULL, NULL, NULL, NULL, NULL),
(518, 1, 'Чегем', 63, '361400', 1, NULL, 100, '0700800100000', NULL, NULL, NULL, NULL, NULL),
(519, 1, 'Белая Холуница', 62, '613200', 1, NULL, 100, '4300400100000', NULL, NULL, NULL, NULL, NULL),
(520, 1, 'Вятские Поляны', 62, '612960', 1, NULL, 100, '4300800100000', NULL, NULL, NULL, NULL, NULL),
(521, 1, 'Зуевка', 62, '306137', 1, NULL, 100, '4301000100000', NULL, NULL, NULL, NULL, NULL),
(522, 1, 'Кирово-Чепецк', 62, '613040', 1, NULL, 100, '4300000400000', NULL, NULL, NULL, NULL, NULL),
(523, 1, 'Кирс', 62, '612820', 1, NULL, 100, '4300600100000', NULL, NULL, NULL, NULL, NULL),
(524, 1, 'Котельнич', 62, '612600', 1, NULL, 100, '4301400100000', NULL, NULL, NULL, NULL, NULL),
(525, 1, 'Луза', 62, '612423', 1, NULL, 100, '4301700100000', NULL, NULL, NULL, NULL, NULL),
(526, 1, 'Малмыж', 62, '612920', 1, NULL, 100, '4301800100000', NULL, NULL, NULL, NULL, NULL),
(527, 1, 'Мураши', 62, '613710', 1, NULL, 100, '4301900100000', NULL, NULL, NULL, NULL, NULL),
(528, 1, 'Нолинск', 62, '613440', 1, NULL, 100, '4302200100000', NULL, NULL, NULL, NULL, NULL),
(529, 1, 'Омутнинск', 62, '612704', 1, NULL, 100, '4302300100000', NULL, NULL, NULL, NULL, NULL),
(530, 1, 'Орлов', 62, '347135', 1, NULL, 100, '4302600100000', NULL, NULL, NULL, NULL, NULL),
(531, 1, 'Слободской', 62, '346652', 1, NULL, 100, '4303100100000', NULL, NULL, NULL, NULL, NULL),
(532, 1, 'Сосновка', 62, '140576', 1, NULL, 100, '4300800200000', NULL, NULL, NULL, NULL, NULL),
(533, 1, 'Уржум', 62, '613530', 1, NULL, 100, '4303600100000', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `gr_order_regions` (`id`, `site_id`, `title`, `parent_id`, `zipcode`, `is_city`, `area`, `sortn`, `kladr_id`, `type_short`, `processed`, `russianpost_arriveinfo`, `russianpost_arrive_min`, `russianpost_arrive_max`) VALUES
(534, 1, 'Яранск', 62, '612260', 1, NULL, 100, '4304000100000', NULL, NULL, NULL, NULL, NULL),
(535, 1, 'Жигулевск', 26, '445350', 1, NULL, 100, '6300000200000', NULL, NULL, NULL, NULL, NULL),
(536, 1, 'Кинель', 26, '446430', 1, NULL, 100, '6300001000000', NULL, NULL, NULL, NULL, NULL),
(537, 1, 'Нефтегорск', 26, '352685', 1, NULL, 100, '6301700100000', NULL, NULL, NULL, NULL, NULL),
(538, 1, 'Новокуйбышевск', 26, '446200', 1, NULL, 100, '6300000300000', NULL, NULL, NULL, NULL, NULL),
(539, 1, 'Октябрьск', 26, '445240', 1, NULL, 100, '6300000400000', NULL, NULL, NULL, NULL, NULL),
(540, 1, 'Отрадный', 26, '346605', 1, NULL, 100, '6300000500000', NULL, NULL, NULL, NULL, NULL),
(541, 1, 'Похвистнево', 26, '446450', 1, NULL, 100, '6300000900000', NULL, NULL, NULL, NULL, NULL),
(542, 1, 'Самара', 26, '443000', 1, NULL, 100, '6300000100000', NULL, NULL, NULL, NULL, NULL),
(543, 1, 'Сызрань', 26, '446000', 1, NULL, 100, '6300000800000', NULL, NULL, NULL, NULL, NULL),
(544, 1, 'Тольятти', 26, '445000', 1, NULL, 100, '6300000700000', NULL, NULL, NULL, NULL, NULL),
(545, 1, 'Чапаевск', 26, '446100', 1, NULL, 100, '6300000600000', NULL, NULL, NULL, NULL, NULL),
(546, 1, 'Касимов', 61, '391300', 1, NULL, 100, '6200000400000', NULL, NULL, NULL, NULL, NULL),
(547, 1, 'Кораблино', 61, '390515', 1, NULL, 100, '6200700100000', NULL, NULL, NULL, NULL, NULL),
(548, 1, 'Михайлов', 61, '347071', 1, NULL, 100, '6200900100000', NULL, NULL, NULL, NULL, NULL),
(549, 1, 'Новомичуринск', 61, '391160', 1, NULL, 100, '6201200200000', NULL, NULL, NULL, NULL, NULL),
(550, 1, 'Рыбное', 61, '391110', 1, NULL, 100, '6201400100000', NULL, NULL, NULL, NULL, NULL),
(551, 1, 'Ряжск', 61, '391960', 1, NULL, 100, '6201500100000', NULL, NULL, NULL, NULL, NULL),
(552, 1, 'Рязань', 61, '390000', 1, NULL, 100, '6200000100000', NULL, NULL, NULL, NULL, NULL),
(553, 1, 'Сасово', 61, '391430', 1, NULL, 100, '6200000200000', NULL, NULL, NULL, NULL, NULL),
(554, 1, 'Скопин', 61, '391800', 1, NULL, 100, '6200000300000', NULL, NULL, NULL, NULL, NULL),
(555, 1, 'Спас-Клепики', 61, '391030', 1, NULL, 100, '6200600100000', NULL, NULL, NULL, NULL, NULL),
(556, 1, 'Спасск-Рязанский', 61, '391050', 1, NULL, 100, '6202000100000', NULL, NULL, NULL, NULL, NULL),
(557, 1, 'Шацк', 61, '391550', 1, NULL, 100, '6202400100000', NULL, NULL, NULL, NULL, NULL),
(558, 1, 'Далматово', 25, '641730', 1, NULL, 100, '4500500100000', NULL, NULL, NULL, NULL, NULL),
(559, 1, 'Катайск', 25, '641700', 1, NULL, 100, '4500800100000', NULL, NULL, NULL, NULL, NULL),
(560, 1, 'Курган', 25, '618613', 1, NULL, 100, '4500000100000', NULL, NULL, NULL, NULL, NULL),
(561, 1, 'Куртамыш', 25, '641430', 1, NULL, 100, '4501000100000', NULL, NULL, NULL, NULL, NULL),
(562, 1, 'Макушино', 25, '182340', 1, NULL, 100, '4501200100000', NULL, NULL, NULL, NULL, NULL),
(563, 1, 'Петухово', 25, '641640', 1, NULL, 100, '4501500100000', NULL, NULL, NULL, NULL, NULL),
(564, 1, 'Шадринск', 25, '641804', 1, NULL, 100, '4500000200000', NULL, NULL, NULL, NULL, NULL),
(565, 1, 'Шумиха', 25, '622921', 1, NULL, 100, '4502300100000', NULL, NULL, NULL, NULL, NULL),
(566, 1, 'Щучье', 25, '172468', 1, NULL, 100, '4502400100000', NULL, NULL, NULL, NULL, NULL),
(567, 1, 'Дмитриев', 24, '307500', 1, NULL, 100, '4600600100000', NULL, NULL, NULL, NULL, NULL),
(568, 1, 'Курск', 24, '188442', 1, NULL, 100, '4600000100000', NULL, NULL, NULL, NULL, NULL),
(569, 1, 'Курчатов', 24, '307250', 1, NULL, 100, '4600000200000', NULL, NULL, NULL, NULL, NULL),
(570, 1, 'Льгов', 24, '303944', 1, NULL, 100, '4600000400000', NULL, NULL, NULL, NULL, NULL),
(571, 1, 'Обоянь', 24, '306230', 1, NULL, 100, '4601600100000', NULL, NULL, NULL, NULL, NULL),
(572, 1, 'Рыльск', 24, '307331', 1, NULL, 100, '4602000100000', NULL, NULL, NULL, NULL, NULL),
(573, 1, 'Суджа', 24, '307800', 1, NULL, 100, '4602300100000', NULL, NULL, NULL, NULL, NULL),
(574, 1, 'Фатеж', 24, '307100', 1, NULL, 100, '4602500100000', NULL, NULL, NULL, NULL, NULL),
(575, 1, 'Щигры', 24, '306509', 1, NULL, 100, '4600000500000', NULL, NULL, NULL, NULL, NULL),
(576, 1, 'Бокситогорск', 60, '187650', 1, NULL, 100, '4700200100000', NULL, NULL, NULL, NULL, NULL),
(577, 1, 'Волосово', 60, '188410', 1, NULL, 100, '4700300100000', NULL, NULL, NULL, NULL, NULL),
(578, 1, 'Волхов', 60, '187401', 1, NULL, 100, '4700400100000', NULL, NULL, NULL, NULL, NULL),
(579, 1, 'Всеволожск', 60, '188640', 1, NULL, 100, '4700500100000', NULL, NULL, NULL, NULL, NULL),
(580, 1, 'Выборг', 60, '188800', 1, NULL, 100, '4700600100000', NULL, NULL, NULL, NULL, NULL),
(581, 1, 'Высоцк', 60, '188909', 1, NULL, 100, '4700600200000', NULL, NULL, NULL, NULL, NULL),
(582, 1, 'Гатчина', 60, '188300', 1, NULL, 100, '4700700100000', NULL, NULL, NULL, NULL, NULL),
(583, 1, 'Ивангород', 60, '188490', 1, NULL, 100, '4700801100000', NULL, NULL, NULL, NULL, NULL),
(584, 1, 'Каменногорск', 60, '188950', 1, NULL, 100, '4700600300000', NULL, NULL, NULL, NULL, NULL),
(585, 1, 'Кингисепп', 60, '188452', 1, NULL, 100, '4700800100000', NULL, NULL, NULL, NULL, NULL),
(586, 1, 'Кириши', 60, '187110', 1, NULL, 100, '4700900100000', NULL, NULL, NULL, NULL, NULL),
(587, 1, 'Кировск', 60, '184250', 1, NULL, 100, '4701000100000', NULL, NULL, NULL, NULL, NULL),
(588, 1, 'Коммунар', 60, '188320', 1, NULL, 100, '4700700200000', NULL, NULL, NULL, NULL, NULL),
(589, 1, 'Лодейное Поле', 60, '187700', 1, NULL, 100, '4701100100000', NULL, NULL, NULL, NULL, NULL),
(590, 1, 'Луга', 60, '188229', 1, NULL, 100, '4701300100000', NULL, NULL, NULL, NULL, NULL),
(591, 1, 'Любань', 60, '187050', 1, NULL, 100, '4701800400000', NULL, NULL, NULL, NULL, NULL),
(592, 1, 'Никольское', 60, '143724', 1, NULL, 100, '4701800300000', NULL, NULL, NULL, NULL, NULL),
(593, 1, 'Новая Ладога', 60, '187450', 1, NULL, 100, '4700400200000', NULL, NULL, NULL, NULL, NULL),
(594, 1, 'Отрадное', 60, '143442', 1, NULL, 100, '4701000200000', NULL, NULL, NULL, NULL, NULL),
(595, 1, 'Пикалево', 60, '187602', 1, NULL, 100, '4700200200000', NULL, NULL, NULL, NULL, NULL),
(596, 1, 'Подпорожье', 60, '186164', 1, NULL, 100, '4701400100000', NULL, NULL, NULL, NULL, NULL),
(597, 1, 'Приозерск', 60, '188760', 1, NULL, 100, '4701500100000', NULL, NULL, NULL, NULL, NULL),
(598, 1, 'Санкт-Петербург', 60, '190000', 1, NULL, 100, '7800000000000', NULL, NULL, NULL, NULL, NULL),
(599, 1, 'Светогорск', 60, '188990', 1, NULL, 100, '4700600500000', NULL, NULL, NULL, NULL, NULL),
(600, 1, 'Сертолово', 60, '188650', 1, NULL, 100, '4700500200000', NULL, NULL, NULL, NULL, NULL),
(601, 1, 'Сланцы', 60, '188560', 1, NULL, 100, '4701600100000', NULL, NULL, NULL, NULL, NULL),
(602, 1, 'Сосновый Бор', 60, '182277', 1, NULL, 100, '4700000400000', NULL, NULL, NULL, NULL, NULL),
(603, 1, 'Сясьстрой', 60, '187420', 1, NULL, 100, '4700400300000', NULL, NULL, NULL, NULL, NULL),
(604, 1, 'Тихвин', 60, '187549', 1, NULL, 100, '4701700100000', NULL, NULL, NULL, NULL, NULL),
(605, 1, 'Тосно', 60, '187000', 1, NULL, 100, '4701800100000', NULL, NULL, NULL, NULL, NULL),
(606, 1, 'Шлиссельбург', 60, '187320', 1, NULL, 100, '4701000300000', NULL, NULL, NULL, NULL, NULL),
(607, 1, 'Грязи', 23, '399050', 1, NULL, 100, '4800300100000', NULL, NULL, NULL, NULL, NULL),
(608, 1, 'Данков', 23, '399835', 1, NULL, 100, '4800400100000', NULL, NULL, NULL, NULL, NULL),
(609, 1, 'Елец', 23, '399002', 1, NULL, 100, '4800000200000', NULL, NULL, NULL, NULL, NULL),
(610, 1, 'Задонск', 23, '399200', 1, NULL, 100, '4800900100000', NULL, NULL, NULL, NULL, NULL),
(611, 1, 'Лебедянь', 23, '399610', 1, NULL, 100, '4801200100000', NULL, NULL, NULL, NULL, NULL),
(612, 1, 'Липецк', 23, '398000', 1, NULL, 100, '4800000100000', NULL, NULL, NULL, NULL, NULL),
(613, 1, 'Усмань', 23, '399370', 1, NULL, 100, '4801600100000', NULL, NULL, NULL, NULL, NULL),
(614, 1, 'Чаплыгин', 23, '352185', 1, NULL, 100, '4801800100000', NULL, NULL, NULL, NULL, NULL),
(615, 1, 'Магадан', 59, '685000', 1, NULL, 100, '4900000100000', NULL, NULL, NULL, NULL, NULL),
(616, 1, 'Сусуман', 59, '686314', 1, NULL, 100, '4900600100000', NULL, NULL, NULL, NULL, NULL),
(617, 1, 'Воркута', 58, '169900', 1, NULL, 100, '1100000200000', NULL, NULL, NULL, NULL, NULL),
(618, 1, 'Вуктыл', 58, '169570', 1, NULL, 100, '1100000300000', NULL, NULL, NULL, NULL, NULL),
(619, 1, 'Емва', 58, '169200', 1, NULL, 100, '1100600100000', NULL, NULL, NULL, NULL, NULL),
(620, 1, 'Инта', 58, '169840', 1, NULL, 100, '1100000400000', NULL, NULL, NULL, NULL, NULL),
(621, 1, 'Микунь', 58, '169060', 1, NULL, 100, '1101700200000', NULL, NULL, NULL, NULL, NULL),
(622, 1, 'Печора', 58, '169600', 1, NULL, 100, '1100000500000', NULL, NULL, NULL, NULL, NULL),
(623, 1, 'Сосногорск', 58, '169500', 1, NULL, 100, '1100000600000', NULL, NULL, NULL, NULL, NULL),
(624, 1, 'Сыктывкар', 58, '167000', 1, NULL, 100, '1100000100000', NULL, NULL, NULL, NULL, NULL),
(625, 1, 'Усинск', 58, '169710', 1, NULL, 100, '1100000700000', NULL, NULL, NULL, NULL, NULL),
(626, 1, 'Ухта', 58, '169300', 1, NULL, 100, '1100000800000', NULL, NULL, NULL, NULL, NULL),
(627, 1, 'Губкинский', 57, '629830', 1, NULL, 100, '8900000200000', NULL, NULL, NULL, NULL, NULL),
(628, 1, 'Лабытнанги', 57, '629400', 1, NULL, 100, '8900000300000', NULL, NULL, NULL, NULL, NULL),
(629, 1, 'Муравленко', 57, '629601', 1, NULL, 100, '8900000400000', NULL, NULL, NULL, NULL, NULL),
(630, 1, 'Надым', 57, '629730', 1, NULL, 100, '8900000500000', NULL, NULL, NULL, NULL, NULL),
(631, 1, 'Новый Уренгой', 57, '629300', 1, NULL, 100, '8900000600000', NULL, NULL, NULL, NULL, NULL),
(632, 1, 'Ноябрьск', 57, '629800', 1, NULL, 100, '8900000700000', NULL, NULL, NULL, NULL, NULL),
(633, 1, 'Салехард', 57, '629000', 1, NULL, 100, '8900000100000', NULL, NULL, NULL, NULL, NULL),
(634, 1, 'Тарко-Сале', 57, '629850', 1, NULL, 100, '8900400100000', NULL, NULL, NULL, NULL, NULL),
(635, 1, 'Алзамай', 22, '665160', 1, NULL, 100, '3801600200000', NULL, NULL, NULL, NULL, NULL),
(636, 1, 'Ангарск', 22, '665800', 1, NULL, 100, '3800000400000', NULL, NULL, NULL, NULL, NULL),
(637, 1, 'Байкальск', 22, '665930', 1, NULL, 100, '3801800200000', NULL, NULL, NULL, NULL, NULL),
(638, 1, 'Бирюсинск', 22, '665050', 1, NULL, 100, '3801900200000', NULL, NULL, NULL, NULL, NULL),
(639, 1, 'Бодайбо', 22, '666900', 1, NULL, 100, '3800000600000', NULL, NULL, NULL, NULL, NULL),
(640, 1, 'Братск', 22, '664899', 1, NULL, 100, '3800000500000', NULL, NULL, NULL, NULL, NULL),
(641, 1, 'Вихоревка', 22, '665770', 1, NULL, 100, '3800500200000', NULL, NULL, NULL, NULL, NULL),
(642, 1, 'Железногорск-Илимский', 22, '665650', 1, NULL, 100, '3801500100000', NULL, NULL, NULL, NULL, NULL),
(643, 1, 'Зима', 22, '665382', 1, NULL, 100, '3800000700000', NULL, NULL, NULL, NULL, NULL),
(644, 1, 'Иркутск', 22, '664000', 1, NULL, 100, '3800000300000', NULL, NULL, NULL, NULL, NULL),
(645, 1, 'Киренск', 22, '666700', 1, NULL, 100, '3801200100000', NULL, NULL, NULL, NULL, NULL),
(646, 1, 'Нижнеудинск', 22, '664810', 1, NULL, 100, '3800000800000', NULL, NULL, NULL, NULL, NULL),
(647, 1, 'Саянск', 22, '662654', 1, NULL, 100, '3800000200000', NULL, NULL, NULL, NULL, NULL),
(648, 1, 'Свирск', 22, '665420', 1, NULL, 100, '3800001600000', NULL, NULL, NULL, NULL, NULL),
(649, 1, 'Слюдянка', 22, '665900', 1, NULL, 100, '3801800100000', NULL, NULL, NULL, NULL, NULL),
(650, 1, 'Тайшет', 22, '664802', 1, NULL, 100, '3800000900000', NULL, NULL, NULL, NULL, NULL),
(651, 1, 'Тулун', 22, '665250', 1, NULL, 100, '3800001000000', NULL, NULL, NULL, NULL, NULL),
(652, 1, 'Усолье-Сибирское', 22, '665450', 1, NULL, 100, '3800001100000', NULL, NULL, NULL, NULL, NULL),
(653, 1, 'Усть-Илимск', 22, '666670', 1, NULL, 100, '3800001200000', NULL, NULL, NULL, NULL, NULL),
(654, 1, 'Усть-Кут', 22, '666780', 1, NULL, 100, '3800001300000', NULL, NULL, NULL, NULL, NULL),
(655, 1, 'Черемхово', 22, '665400', 1, NULL, 100, '3800001400000', NULL, NULL, NULL, NULL, NULL),
(656, 1, 'Шелехов', 22, '666031', 1, NULL, 100, '3800001500000', NULL, NULL, NULL, NULL, NULL),
(657, 1, 'Карабулак', 56, '386230', 1, NULL, 100, '0600000200000', NULL, NULL, NULL, NULL, NULL),
(658, 1, 'Магас', 56, '386001', 1, NULL, 100, '0600000100000', NULL, NULL, NULL, NULL, NULL),
(659, 1, 'Малгобек', 56, '386300', 1, NULL, 100, '0600000400000', NULL, NULL, NULL, NULL, NULL),
(660, 1, 'Назрань', 56, '386100', 1, NULL, 100, '0600000300000', NULL, NULL, NULL, NULL, NULL),
(661, 1, 'Арсеньев', 55, '692330', 1, NULL, 100, '2500000200000', NULL, NULL, NULL, NULL, NULL),
(662, 1, 'Артем', 55, '692486', 1, NULL, 100, '2500000300000', NULL, NULL, NULL, NULL, NULL),
(663, 1, 'Большой Камень', 55, '628107', 1, NULL, 100, '2500000700000', NULL, NULL, NULL, NULL, NULL),
(664, 1, 'Владивосток', 55, '690000', 1, NULL, 100, '2500000100000', NULL, NULL, NULL, NULL, NULL),
(665, 1, 'Дальнегорск', 55, '692441', 1, NULL, 100, '2500000800000', NULL, NULL, NULL, NULL, NULL),
(666, 1, 'Дальнереченск', 55, '692102', 1, NULL, 100, '2500000900000', NULL, NULL, NULL, NULL, NULL),
(667, 1, 'Лесозаводск', 55, '692031', 1, NULL, 100, '2500001200000', NULL, NULL, NULL, NULL, NULL),
(668, 1, 'Находка', 55, '629360', 1, NULL, 100, '2500000400000', NULL, NULL, NULL, NULL, NULL),
(669, 1, 'Партизанск', 55, '663404', 1, NULL, 100, '2500000500000', NULL, NULL, NULL, NULL, NULL),
(670, 1, 'Спасск-Дальний', 55, '692230', 1, NULL, 100, '2500001000000', NULL, NULL, NULL, NULL, NULL),
(671, 1, 'Уссурийск', 55, '692500', 1, NULL, 100, '2500001100000', NULL, NULL, NULL, NULL, NULL),
(672, 1, 'Воткинск', 21, '427430', 1, NULL, 100, '1800000300000', NULL, NULL, NULL, NULL, NULL),
(673, 1, 'Глазов', 21, '427601', 1, NULL, 100, '1800000400000', NULL, NULL, NULL, NULL, NULL),
(674, 1, 'Ижевск', 21, '426000', 1, NULL, 100, '1800000100000', NULL, NULL, NULL, NULL, NULL),
(675, 1, 'Камбарка', 21, '427950', 1, NULL, 100, '1801100100000', NULL, NULL, NULL, NULL, NULL),
(676, 1, 'Можга', 21, '427327', 1, NULL, 100, '1800000500000', NULL, NULL, NULL, NULL, NULL),
(677, 1, 'Сарапул', 21, '427960', 1, NULL, 100, '1800000200000', NULL, NULL, NULL, NULL, NULL),
(678, 1, 'Заводоуковск', 54, '627139', 1, NULL, 100, '7200000400000', NULL, NULL, NULL, NULL, NULL),
(679, 1, 'Ишим', 54, '627705', 1, NULL, 100, '7200000300000', NULL, NULL, NULL, NULL, NULL),
(680, 1, 'Тобольск', 54, '626147', 1, NULL, 100, '7200000200000', NULL, NULL, NULL, NULL, NULL),
(681, 1, 'Тюмень', 54, '625000', 1, NULL, 100, '7200000100000', NULL, NULL, NULL, NULL, NULL),
(682, 1, 'Ялуторовск', 54, '625805', 1, NULL, 100, '7200000500000', NULL, NULL, NULL, NULL, NULL),
(683, 1, 'Велиж', 20, '216290', 1, NULL, 100, '6700200100000', NULL, NULL, NULL, NULL, NULL),
(684, 1, 'Вязьма', 20, '215110', 1, NULL, 100, '6700300100000', NULL, NULL, NULL, NULL, NULL),
(685, 1, 'Гагарин', 20, '215010', 1, NULL, 100, '6700400100000', NULL, NULL, NULL, NULL, NULL),
(686, 1, 'Демидов', 20, '216240', 1, NULL, 100, '6700600100000', NULL, NULL, NULL, NULL, NULL),
(687, 1, 'Десногорск', 20, '216400', 1, NULL, 100, '6700000200000', NULL, NULL, NULL, NULL, NULL),
(688, 1, 'Дорогобуж', 20, '215710', 1, NULL, 100, '6700700100000', NULL, NULL, NULL, NULL, NULL),
(689, 1, 'Духовщина', 20, '216200', 1, NULL, 100, '6700800100000', NULL, NULL, NULL, NULL, NULL),
(690, 1, 'Ельня', 20, '216330', 1, NULL, 100, '6700900100000', NULL, NULL, NULL, NULL, NULL),
(691, 1, 'Починок', 20, '157195', 1, NULL, 100, '6701500100000', NULL, NULL, NULL, NULL, NULL),
(692, 1, 'Рославль', 20, '216500', 1, NULL, 100, '6701600100000', NULL, NULL, NULL, NULL, NULL),
(693, 1, 'Рудня', 20, '216790', 1, NULL, 100, '6701700100000', NULL, NULL, NULL, NULL, NULL),
(694, 1, 'Сафоново', 20, '164767', 1, NULL, 100, '6701800100000', NULL, NULL, NULL, NULL, NULL),
(695, 1, 'Смоленск', 20, '214000', 1, NULL, 100, '6700000300000', NULL, NULL, NULL, NULL, NULL),
(696, 1, 'Сычевка', 20, '215279', 1, NULL, 100, '6701900100000', NULL, NULL, NULL, NULL, NULL),
(697, 1, 'Ярцево', 20, '215800', 1, NULL, 100, '6702500100000', NULL, NULL, NULL, NULL, NULL),
(698, 1, 'Благодарный', 53, '356420', 1, NULL, 100, '2600600100000', NULL, NULL, NULL, NULL, NULL),
(699, 1, 'Буденновск', 53, '356800', 1, NULL, 100, '2600700100000', NULL, NULL, NULL, NULL, NULL),
(700, 1, 'Георгиевск', 53, '357820', 1, NULL, 100, '2600000900000', NULL, NULL, NULL, NULL, NULL),
(701, 1, 'Ессентуки', 53, '357600', 1, NULL, 100, '2600000200000', NULL, NULL, NULL, NULL, NULL),
(702, 1, 'Железноводск', 53, '357400', 1, NULL, 100, '2600000300000', NULL, NULL, NULL, NULL, NULL),
(703, 1, 'Зеленокумск', 53, '357910', 1, NULL, 100, '2602300100000', NULL, NULL, NULL, NULL, NULL),
(704, 1, 'Изобильный', 53, '347674', 1, NULL, 100, '2601000100000', NULL, NULL, NULL, NULL, NULL),
(705, 1, 'Ипатово', 53, '356630', 1, NULL, 100, '2601100100000', NULL, NULL, NULL, NULL, NULL),
(706, 1, 'Кисловодск', 53, '357700', 1, NULL, 100, '2600000400000', NULL, NULL, NULL, NULL, NULL),
(707, 1, 'Лермонтов', 53, '357340', 1, NULL, 100, '2600000500000', NULL, NULL, NULL, NULL, NULL),
(708, 1, 'Минеральные Воды', 53, '357200', 1, NULL, 100, '2601700200000', NULL, NULL, NULL, NULL, NULL),
(709, 1, 'Невинномысск', 53, '357100', 1, NULL, 100, '2600000600000', NULL, NULL, NULL, NULL, NULL),
(710, 1, 'Нефтекумск', 53, '356880', 1, NULL, 100, '2601800100000', NULL, NULL, NULL, NULL, NULL),
(711, 1, 'Новоалександровск', 53, '356000', 1, NULL, 100, '2601900100000', NULL, NULL, NULL, NULL, NULL),
(712, 1, 'Новопавловск', 53, '357300', 1, NULL, 100, '2601200100000', NULL, NULL, NULL, NULL, NULL),
(713, 1, 'Пятигорск', 53, '357500', 1, NULL, 100, '2600000700000', NULL, NULL, NULL, NULL, NULL),
(714, 1, 'Светлоград', 53, '356530', 1, NULL, 100, '2602100100000', NULL, NULL, NULL, NULL, NULL),
(715, 1, 'Ставрополь', 53, '355000', 1, NULL, 100, '2600000100000', NULL, NULL, NULL, NULL, NULL),
(716, 1, 'Жердевка', 52, '393670', 1, NULL, 100, '6800400100000', NULL, NULL, NULL, NULL, NULL),
(717, 1, 'Кирсанов', 52, '393360', 1, NULL, 100, '6800000500000', NULL, NULL, NULL, NULL, NULL),
(718, 1, 'Котовск', 52, '393190', 1, NULL, 100, '6800000200000', NULL, NULL, NULL, NULL, NULL),
(719, 1, 'Мичуринск', 52, '393013', 1, NULL, 100, '6800000600000', NULL, NULL, NULL, NULL, NULL),
(720, 1, 'Моршанск', 52, '393931', 1, NULL, 100, '6800000300000', NULL, NULL, NULL, NULL, NULL),
(721, 1, 'Рассказово', 52, '393250', 1, NULL, 100, '6800000700000', NULL, NULL, NULL, NULL, NULL),
(722, 1, 'Тамбов', 52, '392000', 1, NULL, 100, '6800000400000', NULL, NULL, NULL, NULL, NULL),
(723, 1, 'Уварово', 52, '172882', 1, NULL, 100, '6800000800000', NULL, NULL, NULL, NULL, NULL),
(724, 1, 'Амурск', 51, '682640', 1, NULL, 100, '2700000300000', NULL, NULL, NULL, NULL, NULL),
(725, 1, 'Бикин', 51, '682970', 1, NULL, 100, '2700000400000', NULL, NULL, NULL, NULL, NULL),
(726, 1, 'Вяземский', 51, '682950', 1, NULL, 100, '2700700100000', NULL, NULL, NULL, NULL, NULL),
(727, 1, 'Комсомольск-на-Амуре', 51, '680801', 1, NULL, 100, '2700000500000', NULL, NULL, NULL, NULL, NULL),
(728, 1, 'Николаевск-на-Амуре', 51, '682455', 1, NULL, 100, '2700000600000', NULL, NULL, NULL, NULL, NULL),
(729, 1, 'Советская Гавань', 51, '680881', 1, NULL, 100, '2700000700000', NULL, NULL, NULL, NULL, NULL),
(730, 1, 'Хабаровск', 51, '680000', 1, NULL, 100, '2700000100000', NULL, NULL, NULL, NULL, NULL),
(731, 1, 'Аргун', 18, '366281', 1, NULL, 100, '2000000200000', NULL, NULL, NULL, NULL, NULL),
(732, 1, 'Грозный', 18, '364000', 1, NULL, 100, '2000000100000', NULL, NULL, NULL, NULL, NULL),
(733, 1, 'Гудермес', 18, '366200', 1, NULL, 100, '2000500100000', NULL, NULL, NULL, NULL, NULL),
(734, 1, 'Урус-Мартан', 18, '366500', 1, NULL, 100, '2001000000100', NULL, NULL, NULL, NULL, NULL),
(735, 1, 'Шали', 18, '366300', 1, NULL, 100, '2001200100000', NULL, NULL, NULL, NULL, NULL),
(736, 1, 'Аша', 50, '456010', 1, NULL, 100, '7400200300000', NULL, NULL, NULL, NULL, NULL),
(737, 1, 'Бакал', 50, '456900', 1, NULL, 100, '7401700100000', NULL, NULL, NULL, NULL, NULL),
(738, 1, 'Верхнеуральск', 50, '457670', 1, NULL, 100, '7402900100000', NULL, NULL, NULL, NULL, NULL),
(739, 1, 'Верхний Уфалей', 50, '456800', 1, NULL, 100, '7400000200000', NULL, NULL, NULL, NULL, NULL),
(740, 1, 'Еманжелинск', 50, '456580', 1, NULL, 100, '7404400100000', NULL, NULL, NULL, NULL, NULL),
(741, 1, 'Златоуст', 50, '456200', 1, NULL, 100, '7400000400000', NULL, NULL, NULL, NULL, NULL),
(742, 1, 'Карабаш', 50, '423229', 1, NULL, 100, '7400000500000', NULL, NULL, NULL, NULL, NULL),
(743, 1, 'Карталы', 50, '457350', 1, NULL, 100, '7400700100000', NULL, NULL, NULL, NULL, NULL),
(744, 1, 'Касли', 50, '456830', 1, NULL, 100, '7400900100000', NULL, NULL, NULL, NULL, NULL),
(745, 1, 'Катав-Ивановск', 50, '456110', 1, NULL, 100, '7401000200000', NULL, NULL, NULL, NULL, NULL),
(746, 1, 'Копейск', 50, '456600', 1, NULL, 100, '7400000600000', NULL, NULL, NULL, NULL, NULL),
(747, 1, 'Коркино', 50, '187045', 1, NULL, 100, '7404500100000', NULL, NULL, NULL, NULL, NULL),
(748, 1, 'Куса', 50, '456940', 1, NULL, 100, '7403400100000', NULL, NULL, NULL, NULL, NULL),
(749, 1, 'Кыштым', 50, '456870', 1, NULL, 100, '7400000800000', NULL, NULL, NULL, NULL, NULL),
(750, 1, 'Магнитогорск', 50, '455000', 1, NULL, 100, '7400000900000', NULL, NULL, NULL, NULL, NULL),
(751, 1, 'Миасс', 50, '456300', 1, NULL, 100, '7400001000000', NULL, NULL, NULL, NULL, NULL),
(752, 1, 'Миньяр', 50, '456007', 1, NULL, 100, '7400200100000', NULL, NULL, NULL, NULL, NULL),
(753, 1, 'Нязепетровск', 50, '456970', 1, NULL, 100, '7403600100000', NULL, NULL, NULL, NULL, NULL),
(754, 1, 'Пласт', 50, '457020', 1, NULL, 100, '7404600100000', NULL, NULL, NULL, NULL, NULL),
(755, 1, 'Сатка', 50, '456910', 1, NULL, 100, '7401700200000', NULL, NULL, NULL, NULL, NULL),
(756, 1, 'Сим', 50, '456020', 1, NULL, 100, '7400200200000', NULL, NULL, NULL, NULL, NULL),
(757, 1, 'Снежинск', 50, '456770', 1, NULL, 100, '7400001300000', NULL, NULL, NULL, NULL, NULL),
(758, 1, 'Трехгорный', 50, '456080', 1, NULL, 100, '7400001400000', NULL, NULL, NULL, NULL, NULL),
(759, 1, 'Усть-Катав', 50, '456040', 1, NULL, 100, '7400001500000', NULL, NULL, NULL, NULL, NULL),
(760, 1, 'Чебаркуль', 50, '456438', 1, NULL, 100, '7400003500000', NULL, NULL, NULL, NULL, NULL),
(761, 1, 'Челябинск', 50, '454000', 1, NULL, 100, '7400000100000', NULL, NULL, NULL, NULL, NULL),
(762, 1, 'Южноуральск', 50, '457018', 1, NULL, 100, '7400001600000', NULL, NULL, NULL, NULL, NULL),
(763, 1, 'Юрюзань', 50, '456120', 1, NULL, 100, '7401000100000', NULL, NULL, NULL, NULL, NULL),
(764, 1, 'Великие Луки', 17, '182100', 1, NULL, 100, '6000000200000', NULL, NULL, NULL, NULL, NULL),
(765, 1, 'Великие Луки-1', 17, '182171', 1, NULL, 100, '6000300100051', NULL, NULL, NULL, NULL, NULL),
(766, 1, 'Гдов', 17, '181600', 1, NULL, 100, '6000400100000', NULL, NULL, NULL, NULL, NULL),
(767, 1, 'Дно', 17, '182670', 1, NULL, 100, '6000600100000', NULL, NULL, NULL, NULL, NULL),
(768, 1, 'Невель', 17, '182500', 1, NULL, 100, '6001000100000', NULL, NULL, NULL, NULL, NULL),
(769, 1, 'Новоржев', 17, '182440', 1, NULL, 100, '6001100100000', NULL, NULL, NULL, NULL, NULL),
(770, 1, 'Новосокольники', 17, '182200', 1, NULL, 100, '6001200100000', NULL, NULL, NULL, NULL, NULL),
(771, 1, 'Опочка', 17, '182330', 1, NULL, 100, '6001300100000', NULL, NULL, NULL, NULL, NULL),
(772, 1, 'Остров', 17, '152235', 1, NULL, 100, '6001400100000', NULL, NULL, NULL, NULL, NULL),
(773, 1, 'Печоры', 17, '181500', 1, NULL, 100, '6001600100000', NULL, NULL, NULL, NULL, NULL),
(774, 1, 'Порхов', 17, '182620', 1, NULL, 100, '6001800100000', NULL, NULL, NULL, NULL, NULL),
(775, 1, 'Псков', 17, '180000', 1, NULL, 100, '6000000100000', NULL, NULL, NULL, NULL, NULL),
(776, 1, 'Пустошка', 17, '182300', 1, NULL, 100, '6001900100000', NULL, NULL, NULL, NULL, NULL),
(777, 1, 'Пыталово', 17, '181410', 1, NULL, 100, '6002100100000', NULL, NULL, NULL, NULL, NULL),
(778, 1, 'Себеж', 17, '182250', 1, NULL, 100, '6002200100000', NULL, NULL, NULL, NULL, NULL),
(779, 1, 'Ак-Довурак', 49, '668050', 1, NULL, 100, '1700000200000', NULL, NULL, NULL, NULL, NULL),
(780, 1, 'Кызыл', 49, '667000', 1, NULL, 100, '1700000100000', NULL, NULL, NULL, NULL, NULL),
(781, 1, 'Туран', 49, '668510', 1, NULL, 100, '1700900100000', NULL, NULL, NULL, NULL, NULL),
(782, 1, 'Чадан', 49, '668110', 1, NULL, 100, '1700400100000', NULL, NULL, NULL, NULL, NULL),
(783, 1, 'Шагонар', 49, '668210', 1, NULL, 100, '1701400100000', NULL, NULL, NULL, NULL, NULL),
(784, 1, 'Алексин', 16, '301360', 1, NULL, 100, '7100200100000', NULL, NULL, NULL, NULL, NULL),
(785, 1, 'Белев', 16, '301530', 1, NULL, 100, '7100400100000', NULL, NULL, NULL, NULL, NULL),
(786, 1, 'Богородицк', 16, '301830', 1, NULL, 100, '7100500100000', NULL, NULL, NULL, NULL, NULL),
(787, 1, 'Болохово', 16, '301280', 1, NULL, 100, '7101400200000', NULL, NULL, NULL, NULL, NULL),
(788, 1, 'Венев', 16, '301320', 1, NULL, 100, '7100600100000', NULL, NULL, NULL, NULL, NULL),
(789, 1, 'Донской', 16, '301760', 1, NULL, 100, '7100000200000', NULL, NULL, NULL, NULL, NULL),
(790, 1, 'Ефремов', 16, '301840', 1, NULL, 100, '7101000100000', NULL, NULL, NULL, NULL, NULL),
(791, 1, 'Кимовск', 16, '301720', 1, NULL, 100, '7101300100000', NULL, NULL, NULL, NULL, NULL),
(792, 1, 'Киреевск', 16, '301260', 1, NULL, 100, '7101400100000', NULL, NULL, NULL, NULL, NULL),
(793, 1, 'Липки', 16, '216461', 1, NULL, 100, '7101400300000', NULL, NULL, NULL, NULL, NULL),
(794, 1, 'Новомосковск', 16, '301650', 1, NULL, 100, '7101700100000', NULL, NULL, NULL, NULL, NULL),
(795, 1, 'Плавск', 16, '301470', 1, NULL, 100, '7101900100000', NULL, NULL, NULL, NULL, NULL),
(796, 1, 'Суворов', 16, '301430', 1, NULL, 100, '7102000100000', NULL, NULL, NULL, NULL, NULL),
(797, 1, 'Тула', 16, '300000', 1, NULL, 100, '7100000100000', NULL, NULL, NULL, NULL, NULL),
(798, 1, 'Узловая', 16, '301600', 1, NULL, 100, '7102200100000', NULL, NULL, NULL, NULL, NULL),
(799, 1, 'Чекалин', 16, '301414', 1, NULL, 100, '7102000200000', NULL, NULL, NULL, NULL, NULL),
(800, 1, 'Щекино', 16, '162361', 1, NULL, 100, '7102400100000', NULL, NULL, NULL, NULL, NULL),
(801, 1, 'Ясногорск', 16, '301030', 1, NULL, 100, '7102500100000', NULL, NULL, NULL, NULL, NULL),
(802, 1, 'Асино', 48, '636840', 1, NULL, 100, '7000300100000', NULL, NULL, NULL, NULL, NULL),
(803, 1, 'Кедровый', 48, '628544', 1, NULL, 100, '7000000200000', NULL, NULL, NULL, NULL, NULL),
(804, 1, 'Колпашево', 48, '636460', 1, NULL, 100, '7000900100000', NULL, NULL, NULL, NULL, NULL),
(805, 1, 'Северск', 48, '636000', 1, NULL, 100, '7000000300000', NULL, NULL, NULL, NULL, NULL),
(806, 1, 'Стрежевой', 48, '634878', 1, NULL, 100, '7000000400000', NULL, NULL, NULL, NULL, NULL),
(807, 1, 'Томск', 48, '634000', 1, NULL, 100, '7000000100000', NULL, NULL, NULL, NULL, NULL),
(808, 1, 'Андреаполь', 15, '172800', 1, NULL, 100, '6900200100000', NULL, NULL, NULL, NULL, NULL),
(809, 1, 'Бежецк', 15, '171980', 1, NULL, 100, '6900300100000', NULL, NULL, NULL, NULL, NULL),
(810, 1, 'Белый', 15, '172530', 1, NULL, 100, '6900400100000', NULL, NULL, NULL, NULL, NULL),
(811, 1, 'Бологое', 15, '171070', 1, NULL, 100, '6900500100000', NULL, NULL, NULL, NULL, NULL),
(812, 1, 'Весьегонск', 15, '171720', 1, NULL, 100, '6900600100000', NULL, NULL, NULL, NULL, NULL),
(813, 1, 'Вышний Волочек', 15, '171147', 1, NULL, 100, '6900000600000', NULL, NULL, NULL, NULL, NULL),
(814, 1, 'Западная Двина', 15, '172610', 1, NULL, 100, '6900900100000', NULL, NULL, NULL, NULL, NULL),
(815, 1, 'Зубцов', 15, '172332', 1, NULL, 100, '6901000100000', NULL, NULL, NULL, NULL, NULL),
(816, 1, 'Калязин', 15, '171571', 1, NULL, 100, '6901100100000', NULL, NULL, NULL, NULL, NULL),
(817, 1, 'Кашин', 15, '171591', 1, NULL, 100, '6900000900000', NULL, NULL, NULL, NULL, NULL),
(818, 1, 'Кимры', 15, '171500', 1, NULL, 100, '6900000500000', NULL, NULL, NULL, NULL, NULL),
(819, 1, 'Конаково', 15, '171250', 1, NULL, 100, '6901500100000', NULL, NULL, NULL, NULL, NULL),
(820, 1, 'Красный Холм', 15, '171660', 1, NULL, 100, '6901600100000', NULL, NULL, NULL, NULL, NULL),
(821, 1, 'Кувшиново', 15, '172110', 1, NULL, 100, '6901700100000', NULL, NULL, NULL, NULL, NULL),
(822, 1, 'Лихославль', 15, '171210', 1, NULL, 100, '6901900100000', NULL, NULL, NULL, NULL, NULL),
(823, 1, 'Нелидово', 15, '143628', 1, NULL, 100, '6900000400000', NULL, NULL, NULL, NULL, NULL),
(824, 1, 'Осташков', 15, '172218', 1, NULL, 100, '6900000800000', NULL, NULL, NULL, NULL, NULL),
(825, 1, 'Ржев', 15, '172380', 1, NULL, 100, '6900000300000', NULL, NULL, NULL, NULL, NULL),
(826, 1, 'Старица', 15, '171360', 1, NULL, 100, '6903200100000', NULL, NULL, NULL, NULL, NULL),
(827, 1, 'Тверь', 15, '170000', 1, NULL, 100, '6900000100000', NULL, NULL, NULL, NULL, NULL),
(828, 1, 'Торжок', 15, '172000', 1, NULL, 100, '6900000200000', NULL, NULL, NULL, NULL, NULL),
(829, 1, 'Торопец', 15, '172840', 1, NULL, 100, '6903400100000', NULL, NULL, NULL, NULL, NULL),
(830, 1, 'Удомля', 15, '171841', 1, NULL, 100, '6900000700000', NULL, NULL, NULL, NULL, NULL),
(831, 1, 'Агрыз', 14, '422230', 1, NULL, 100, '1600200100000', NULL, NULL, NULL, NULL, NULL),
(832, 1, 'Азнакаево', 14, '423330', 1, NULL, 100, '1600300100000', NULL, NULL, NULL, NULL, NULL),
(833, 1, 'Альметьевск', 14, '423403', 1, NULL, 100, '1600800100000', NULL, NULL, NULL, NULL, NULL),
(834, 1, 'Арск', 14, '422000', 1, NULL, 100, '1601000100000', NULL, NULL, NULL, NULL, NULL),
(835, 1, 'Бавлы', 14, '423930', 1, NULL, 100, '1601200100000', NULL, NULL, NULL, NULL, NULL),
(836, 1, 'Болгар', 14, '422840', 1, NULL, 100, '1603800100000', NULL, NULL, NULL, NULL, NULL),
(837, 1, 'Бугульма', 14, '423230', 1, NULL, 100, '1601400100000', NULL, NULL, NULL, NULL, NULL),
(838, 1, 'Буинск', 14, '422430', 1, NULL, 100, '1601500100000', NULL, NULL, NULL, NULL, NULL),
(839, 1, 'Елабуга', 14, '423600', 1, NULL, 100, '1601900100000', NULL, NULL, NULL, NULL, NULL),
(840, 1, 'Заинск', 14, '423520', 1, NULL, 100, '1602000100000', NULL, NULL, NULL, NULL, NULL),
(841, 1, 'Зеленодольск', 14, '422540', 1, NULL, 100, '1602100100000', NULL, NULL, NULL, NULL, NULL),
(842, 1, 'Иннополис', 14, '420500', 1, NULL, 100, '1601600100000', NULL, NULL, NULL, NULL, NULL),
(843, 1, 'Казань', 14, '420000', 1, NULL, 100, '1600000100000', NULL, NULL, NULL, NULL, NULL),
(844, 1, 'Лаишево', 14, '422610', 1, NULL, 100, '1602500100000', NULL, NULL, NULL, NULL, NULL),
(845, 1, 'Лениногорск', 14, '423250', 1, NULL, 100, '1602600100000', NULL, NULL, NULL, NULL, NULL),
(846, 1, 'Мамадыш', 14, '422190', 1, NULL, 100, '1602700100000', NULL, NULL, NULL, NULL, NULL),
(847, 1, 'Менделеевск', 14, '423650', 1, NULL, 100, '1602800100000', NULL, NULL, NULL, NULL, NULL),
(848, 1, 'Мензелинск', 14, '423700', 1, NULL, 100, '1602900100000', NULL, NULL, NULL, NULL, NULL),
(849, 1, 'Набережные Челны', 14, '423800', 1, NULL, 100, '1600000200000', NULL, NULL, NULL, NULL, NULL),
(850, 1, 'Нижнекамск', 14, '423544', 1, NULL, 100, '1603100100000', NULL, NULL, NULL, NULL, NULL),
(851, 1, 'Нурлат', 14, '423040', 1, NULL, 100, '1603300100000', NULL, NULL, NULL, NULL, NULL),
(852, 1, 'Тетюши', 14, '422370', 1, NULL, 100, '1603900100000', NULL, NULL, NULL, NULL, NULL),
(853, 1, 'Чистополь', 14, '422980', 1, NULL, 100, '1604300100000', NULL, NULL, NULL, NULL, NULL),
(854, 1, 'Абаза', 47, '655750', 1, NULL, 100, '1900000400000', NULL, NULL, NULL, NULL, NULL),
(855, 1, 'Абакан', 47, '655000', 1, NULL, 100, '1900000100000', NULL, NULL, NULL, NULL, NULL),
(856, 1, 'Саяногорск', 47, '655602', 1, NULL, 100, '1900000200000', NULL, NULL, NULL, NULL, NULL),
(857, 1, 'Сорск', 47, '655111', 1, NULL, 100, '1900000500000', NULL, NULL, NULL, NULL, NULL),
(858, 1, 'Черногорск', 47, '655151', 1, NULL, 100, '1900000300000', NULL, NULL, NULL, NULL, NULL),
(859, 1, 'Белоярский', 46, '412561', 1, NULL, 100, '6402200000400', NULL, NULL, NULL, NULL, NULL),
(860, 1, 'Когалым', 46, '628481', 1, NULL, 100, '8600000200000', NULL, NULL, NULL, NULL, NULL),
(861, 1, 'Лангепас', 46, '628671', 1, NULL, 100, '8600000300000', NULL, NULL, NULL, NULL, NULL),
(862, 1, 'Лянтор', 46, '628449', 1, NULL, 100, '8600900200000', NULL, NULL, NULL, NULL, NULL),
(863, 1, 'Мегион', 46, '628680', 1, NULL, 100, '8600000400000', NULL, NULL, NULL, NULL, NULL),
(864, 1, 'Нефтеюганск', 46, '628301', 1, NULL, 100, '8600001400000', NULL, NULL, NULL, NULL, NULL),
(865, 1, 'Нижневартовск', 46, '628600', 1, NULL, 100, '8600001100000', NULL, NULL, NULL, NULL, NULL),
(866, 1, 'Нягань', 46, '628180', 1, NULL, 100, '8600000500000', NULL, NULL, NULL, NULL, NULL),
(867, 1, 'Покачи', 46, '628660', 1, NULL, 100, '8600000600000', NULL, NULL, NULL, NULL, NULL),
(868, 1, 'Пыть-Ях', 46, '628380', 1, NULL, 100, '8600000700000', NULL, NULL, NULL, NULL, NULL),
(869, 1, 'Советский', 46, '157433', 1, NULL, 100, '4401100004000', NULL, NULL, NULL, NULL, NULL),
(870, 1, 'Сургут', 46, '446551', 1, NULL, 100, '8600001000000', NULL, NULL, NULL, NULL, NULL),
(871, 1, 'Урай', 46, '628280', 1, NULL, 100, '8600000900000', NULL, NULL, NULL, NULL, NULL),
(872, 1, 'Ханты-Мансийск', 46, '628000', 1, NULL, 100, '8600000100000', NULL, NULL, NULL, NULL, NULL),
(873, 1, 'Югорск', 46, '628260', 1, NULL, 100, '8600001600000', NULL, NULL, NULL, NULL, NULL),
(874, 1, 'Барыш', 45, '433750', 1, NULL, 100, '7300000300000', NULL, NULL, NULL, NULL, NULL),
(875, 1, 'Димитровград', 45, '433500', 1, NULL, 100, '7300000200000', NULL, NULL, NULL, NULL, NULL),
(876, 1, 'Инза', 45, '433030', 1, NULL, 100, '7300500100000', NULL, NULL, NULL, NULL, NULL),
(877, 1, 'Новоульяновск', 45, '433300', 1, NULL, 100, '7300000400000', NULL, NULL, NULL, NULL, NULL),
(878, 1, 'Сенгилей', 45, '433380', 1, NULL, 100, '7301500100000', NULL, NULL, NULL, NULL, NULL),
(879, 1, 'Ульяновск', 45, '432000', 1, NULL, 100, '7300000100000', NULL, NULL, NULL, NULL, NULL),
(880, 1, 'Алагир', 13, '363240', 1, NULL, 100, '1500200100000', NULL, NULL, NULL, NULL, NULL),
(881, 1, 'Ардон', 13, '363330', 1, NULL, 100, '1500300100000', NULL, NULL, NULL, NULL, NULL),
(882, 1, 'Беслан', 13, '363020', 1, NULL, 100, '1500800100000', NULL, NULL, NULL, NULL, NULL),
(883, 1, 'Владикавказ', 13, '362000', 1, NULL, 100, '1500000100000', NULL, NULL, NULL, NULL, NULL),
(884, 1, 'Дигора', 13, '363410', 1, NULL, 100, '1500400100000', NULL, NULL, NULL, NULL, NULL),
(885, 1, 'Моздок', 13, '362028', 1, NULL, 100, '1500700100000', NULL, NULL, NULL, NULL, NULL),
(886, 1, 'Алдан', 12, '678900', 1, NULL, 100, '1400300100000', NULL, NULL, NULL, NULL, NULL),
(887, 1, 'Верхоянск', 12, '678530', 1, NULL, 100, '1401000000000', NULL, NULL, NULL, NULL, NULL),
(888, 1, 'Вилюйск', 12, '678200', 1, NULL, 100, '1401100100000', NULL, NULL, NULL, NULL, NULL),
(889, 1, 'Ленск', 12, '617452', 1, NULL, 100, '1401500100000', NULL, NULL, NULL, NULL, NULL),
(890, 1, 'Нерюнгри', 12, '678960', 1, NULL, 100, '1400000200000', NULL, NULL, NULL, NULL, NULL),
(891, 1, 'Нюрба', 12, '678450', 1, NULL, 100, '1402100100000', NULL, NULL, NULL, NULL, NULL),
(892, 1, 'Олекминск', 12, '678100', 1, NULL, 100, '1402300100000', NULL, NULL, NULL, NULL, NULL),
(893, 1, 'Покровск', 12, '249718', 1, NULL, 100, '4001200001200', NULL, NULL, NULL, NULL, NULL),
(894, 1, 'Среднеколымск', 12, '678790', 1, NULL, 100, '1402500100000', NULL, NULL, NULL, NULL, NULL),
(895, 1, 'Томмот', 12, '678953', 1, NULL, 100, '1400300200000', NULL, NULL, NULL, NULL, NULL),
(896, 1, 'Удачный', 12, '678188', 1, NULL, 100, '1401700200000', NULL, NULL, NULL, NULL, NULL),
(897, 1, 'Якутск', 12, '677000', 1, NULL, 100, '1400000100000', NULL, NULL, NULL, NULL, NULL),
(898, 1, 'Александровск-Сахалинский', 44, '694420', 1, NULL, 100, '6501800100000', NULL, NULL, NULL, NULL, NULL),
(899, 1, 'Анива', 44, '694030', 1, NULL, 100, '6500200100000', NULL, NULL, NULL, NULL, NULL),
(900, 1, 'Долинск', 44, '694051', 1, NULL, 100, '6500300100000', NULL, NULL, NULL, NULL, NULL),
(901, 1, 'Корсаков', 44, '694020', 1, NULL, 100, '6500400100000', NULL, NULL, NULL, NULL, NULL),
(902, 1, 'Курильск', 44, '694530', 1, NULL, 100, '6500500100000', NULL, NULL, NULL, NULL, NULL),
(903, 1, 'Макаров', 44, '694140', 1, NULL, 100, '6500600100000', NULL, NULL, NULL, NULL, NULL),
(904, 1, 'Невельск', 44, '694740', 1, NULL, 100, '6500700100000', NULL, NULL, NULL, NULL, NULL),
(905, 1, 'Оха', 44, '694490', 1, NULL, 100, '6500900100000', NULL, NULL, NULL, NULL, NULL),
(906, 1, 'Поронайск', 44, '694240', 1, NULL, 100, '6501000100000', NULL, NULL, NULL, NULL, NULL),
(907, 1, 'Северо-Курильск', 44, '694550', 1, NULL, 100, '6501100100000', NULL, NULL, NULL, NULL, NULL),
(908, 1, 'Томари', 44, '694820', 1, NULL, 100, '6501300100000', NULL, NULL, NULL, NULL, NULL),
(909, 1, 'Холмск', 44, '694620', 1, NULL, 100, '6501600100000', NULL, NULL, NULL, NULL, NULL),
(910, 1, 'Шахтерск', 44, '694910', 1, NULL, 100, '6501500200000', NULL, NULL, NULL, NULL, NULL),
(911, 1, 'Южно-Сахалинск', 44, '693000', 1, NULL, 100, '6500000100000', NULL, NULL, NULL, NULL, NULL),
(912, 1, 'Александровск', 11, '618320', 1, NULL, 100, '5900000300000', NULL, NULL, NULL, NULL, NULL),
(913, 1, 'Березники', 11, '152183', 1, NULL, 100, '5900000200000', NULL, NULL, NULL, NULL, NULL),
(914, 1, 'Верещагино', 11, '152334', 1, NULL, 100, '5900500100000', NULL, NULL, NULL, NULL, NULL),
(915, 1, 'Горнозаводск', 11, '618820', 1, NULL, 100, '5900600100000', NULL, NULL, NULL, NULL, NULL),
(916, 1, 'Гремячинск', 11, '618270', 1, NULL, 100, '5900000400000', NULL, NULL, NULL, NULL, NULL),
(917, 1, 'Губаха', 11, '618250', 1, NULL, 100, '5900000500000', NULL, NULL, NULL, NULL, NULL),
(918, 1, 'Добрянка', 11, '618740', 1, NULL, 100, '5900000600000', NULL, NULL, NULL, NULL, NULL),
(919, 1, 'Кизел', 11, '618350', 1, NULL, 100, '5900000700000', NULL, NULL, NULL, NULL, NULL),
(920, 1, 'Красновишерск', 11, '618590', 1, NULL, 100, '5901300100000', NULL, NULL, NULL, NULL, NULL),
(921, 1, 'Краснокамск', 11, '617060', 1, NULL, 100, '5900001500000', NULL, NULL, NULL, NULL, NULL),
(922, 1, 'Кудымкар', 11, '619000', 1, NULL, 100, '5900001400000', NULL, NULL, NULL, NULL, NULL),
(923, 1, 'Кунгур', 11, '617470', 1, NULL, 100, '5900000900000', NULL, NULL, NULL, NULL, NULL),
(924, 1, 'Лысьва', 11, '618441', 1, NULL, 100, '5900001000000', NULL, NULL, NULL, NULL, NULL),
(925, 1, 'Нытва', 11, '617000', 1, NULL, 100, '5901400100000', NULL, NULL, NULL, NULL, NULL),
(926, 1, 'Оса', 11, '612621', 1, NULL, 100, '5901600100000', NULL, NULL, NULL, NULL, NULL),
(927, 1, 'Оханск', 11, '618100', 1, NULL, 100, '5901800100000', NULL, NULL, NULL, NULL, NULL),
(928, 1, 'Очер', 11, '617140', 1, NULL, 100, '5901900100000', NULL, NULL, NULL, NULL, NULL),
(929, 1, 'Пермь', 11, '614000', 1, NULL, 100, '5900000100000', NULL, NULL, NULL, NULL, NULL),
(930, 1, 'Соликамск', 11, '618540', 1, NULL, 100, '5900001100000', NULL, NULL, NULL, NULL, NULL),
(931, 1, 'Усолье', 11, '446733', 1, NULL, 100, '5902400100000', NULL, NULL, NULL, NULL, NULL),
(932, 1, 'Чайковский', 11, '617760', 1, NULL, 100, '5900001200000', NULL, NULL, NULL, NULL, NULL),
(933, 1, 'Чердынь', 11, '618601', 1, NULL, 100, '5902700100000', NULL, NULL, NULL, NULL, NULL),
(934, 1, 'Чермоз', 11, '617040', 1, NULL, 100, '5900800200000', NULL, NULL, NULL, NULL, NULL),
(935, 1, 'Чернушка', 11, '613573', 1, NULL, 100, '5902800100000', NULL, NULL, NULL, NULL, NULL),
(936, 1, 'Чусовой', 11, '618200', 1, NULL, 100, '5900001300000', NULL, NULL, NULL, NULL, NULL),
(937, 1, 'Белинский', 43, '442250', 1, NULL, 100, '5800500100000', NULL, NULL, NULL, NULL, NULL),
(938, 1, 'Городище', 43, '142811', 1, NULL, 100, '5800800100000', NULL, NULL, NULL, NULL, NULL),
(939, 1, 'Заречный', 43, '442960', 1, NULL, 100, '5800000200000', NULL, NULL, NULL, NULL, NULL),
(940, 1, 'Каменка', 43, '141894', 1, NULL, 100, '5801100100000', NULL, NULL, NULL, NULL, NULL),
(941, 1, 'Кузнецк', 43, '442530', 1, NULL, 100, '5800000300000', NULL, NULL, NULL, NULL, NULL),
(942, 1, 'Кузнецк-12', 43, '442542', 1, NULL, 100, '5800000300200', NULL, NULL, NULL, NULL, NULL),
(943, 1, 'Кузнецк-8', 43, '442538', 1, NULL, 100, '5800000300100', NULL, NULL, NULL, NULL, NULL),
(944, 1, 'Нижний Ломов', 43, '442150', 1, NULL, 100, '5802200100000', NULL, NULL, NULL, NULL, NULL),
(945, 1, 'Пенза', 43, '440000', 1, NULL, 100, '5800000100000', NULL, NULL, NULL, NULL, NULL),
(946, 1, 'Сердобск', 43, '442890', 1, NULL, 100, '5802500100000', NULL, NULL, NULL, NULL, NULL),
(947, 1, 'Спасск', 43, '442600', 1, NULL, 100, '5800300100000', NULL, NULL, NULL, NULL, NULL),
(948, 1, 'Сурск', 43, '442300', 1, NULL, 100, '5800800200000', NULL, NULL, NULL, NULL, NULL),
(949, 1, 'Болхов', 10, '303140', 1, NULL, 100, '5700200100000', NULL, NULL, NULL, NULL, NULL),
(950, 1, 'Дмитровск', 10, '303240', 1, NULL, 100, '5700500100000', NULL, NULL, NULL, NULL, NULL),
(951, 1, 'Ливны', 10, '303850', 1, NULL, 100, '5700000200000', NULL, NULL, NULL, NULL, NULL),
(952, 1, 'Малоархангельск', 10, '303369', 1, NULL, 100, '5701400100000', NULL, NULL, NULL, NULL, NULL),
(953, 1, 'Мценск', 10, '303030', 1, NULL, 100, '5700000300000', NULL, NULL, NULL, NULL, NULL),
(954, 1, 'Новосиль', 10, '303500', 1, NULL, 100, '5701700100000', NULL, NULL, NULL, NULL, NULL),
(955, 1, 'Орел', 10, '181603', 1, NULL, 100, '5700000100000', NULL, NULL, NULL, NULL, NULL),
(956, 1, 'Астрахань', 9, '414000', 1, NULL, 100, '3000000100000', NULL, NULL, NULL, NULL, NULL),
(957, 1, 'Ахтубинск', 9, '416500', 1, NULL, 100, '3000200100000', NULL, NULL, NULL, NULL, NULL),
(958, 1, 'Знаменск', 9, '238200', 1, NULL, 100, '3000000200000', NULL, NULL, NULL, NULL, NULL),
(959, 1, 'Камызяк', 9, '416340', 1, NULL, 100, '3000600100000', NULL, NULL, NULL, NULL, NULL),
(960, 1, 'Нариманов', 9, '416111', 1, NULL, 100, '3000900100000', NULL, NULL, NULL, NULL, NULL),
(961, 1, 'Харабали', 9, '416009', 1, NULL, 100, '3001100100000', NULL, NULL, NULL, NULL, NULL),
(962, 1, 'Агидель', 8, '452920', 1, NULL, 100, '0200000200000', NULL, NULL, NULL, NULL, NULL),
(963, 1, 'Баймак', 8, '453630', 1, NULL, 100, '0200600100000', NULL, NULL, NULL, NULL, NULL),
(964, 1, 'Белебей', 8, '452000', 1, NULL, 100, '0200900100000', NULL, NULL, NULL, NULL, NULL),
(965, 1, 'Белорецк', 8, '453500', 1, NULL, 100, '0201100100000', NULL, NULL, NULL, NULL, NULL),
(966, 1, 'Бирск', 8, '452450', 1, NULL, 100, '0201300100000', NULL, NULL, NULL, NULL, NULL),
(967, 1, 'Давлеканово', 8, '453400', 1, NULL, 100, '0205900100000', NULL, NULL, NULL, NULL, NULL),
(968, 1, 'Дюртюли', 8, '452320', 1, NULL, 100, '0206000100000', NULL, NULL, NULL, NULL, NULL),
(969, 1, 'Ишимбай', 8, '453200', 1, NULL, 100, '0202600100000', NULL, NULL, NULL, NULL, NULL),
(970, 1, 'Кумертау', 8, '453300', 1, NULL, 100, '0200000700000', NULL, NULL, NULL, NULL, NULL),
(971, 1, 'Межгорье', 8, '453570', 1, NULL, 100, '0200000800000', NULL, NULL, NULL, NULL, NULL),
(972, 1, 'Мелеуз', 8, '453850', 1, NULL, 100, '0203500100000', NULL, NULL, NULL, NULL, NULL),
(973, 1, 'Нефтекамск', 8, '452680', 1, NULL, 100, '0200000300000', NULL, NULL, NULL, NULL, NULL),
(974, 1, 'Октябрьский', 8, '140060', 1, NULL, 100, '0200000400000', NULL, NULL, NULL, NULL, NULL),
(975, 1, 'Салават', 8, '453250', 1, NULL, 100, '0200000500000', NULL, NULL, NULL, NULL, NULL),
(976, 1, 'Сибай', 8, '453830', 1, NULL, 100, '0200000600000', NULL, NULL, NULL, NULL, NULL),
(977, 1, 'Стерлитамак', 8, '453100', 1, NULL, 100, '0200001400000', NULL, NULL, NULL, NULL, NULL),
(978, 1, 'Туймазы', 8, '452750', 1, NULL, 100, '0204400100000', NULL, NULL, NULL, NULL, NULL),
(979, 1, 'Уфа', 8, '450000', 1, NULL, 100, '0200000100000', NULL, NULL, NULL, NULL, NULL),
(980, 1, 'Учалы', 8, '453700', 1, NULL, 100, '0204600100000', NULL, NULL, NULL, NULL, NULL),
(981, 1, 'Янаул', 8, '452800', 1, NULL, 100, '0205200100000', NULL, NULL, NULL, NULL, NULL),
(982, 1, 'Алексеевка', 42, '181309', 1, NULL, 100, '3100200100000', NULL, NULL, NULL, NULL, NULL),
(983, 1, 'Белгород', 42, '308000', 1, NULL, 100, '3100000100000', NULL, NULL, NULL, NULL, NULL),
(984, 1, 'Бирюч', 42, '309910', 1, NULL, 100, '3101200100000', NULL, NULL, NULL, NULL, NULL),
(985, 1, 'Валуйки', 42, '309990', 1, NULL, 100, '3100400100000', NULL, NULL, NULL, NULL, NULL),
(986, 1, 'Грайворон', 42, '309370', 1, NULL, 100, '3100700100000', NULL, NULL, NULL, NULL, NULL),
(987, 1, 'Губкин', 42, '309180', 1, NULL, 100, '3100000400000', NULL, NULL, NULL, NULL, NULL),
(988, 1, 'Короча', 42, '309210', 1, NULL, 100, '3101000100000', NULL, NULL, NULL, NULL, NULL),
(989, 1, 'Новый Оскол', 42, '309626', 1, NULL, 100, '3101400100000', NULL, NULL, NULL, NULL, NULL),
(990, 1, 'Старый Оскол', 42, '309500', 1, NULL, 100, '3100000200000', NULL, NULL, NULL, NULL, NULL),
(991, 1, 'Строитель', 42, '309062', 1, NULL, 100, '3102100100000', NULL, NULL, NULL, NULL, NULL),
(992, 1, 'Шебекино', 42, '309290', 1, NULL, 100, '3100000300000', NULL, NULL, NULL, NULL, NULL),
(993, 1, 'Барабинск', 41, '630833', 1, NULL, 100, '5400301200000', NULL, NULL, NULL, NULL, NULL),
(994, 1, 'Бердск', 41, '633000', 1, NULL, 100, '5400000200000', NULL, NULL, NULL, NULL, NULL),
(995, 1, 'Болотное', 41, '633340', 1, NULL, 100, '5400400100000', NULL, NULL, NULL, NULL, NULL),
(996, 1, 'Искитим', 41, '633200', 1, NULL, 100, '5400000500000', NULL, NULL, NULL, NULL, NULL),
(997, 1, 'Карасук', 41, '632860', 1, NULL, 100, '5400900100000', NULL, NULL, NULL, NULL, NULL),
(998, 1, 'Каргат', 41, '632400', 1, NULL, 100, '5401000100000', NULL, NULL, NULL, NULL, NULL),
(999, 1, 'Куйбышев', 41, '404146', 1, NULL, 100, '5401501800000', NULL, NULL, NULL, NULL, NULL),
(1000, 1, 'Купино', 41, '309263', 1, NULL, 100, '5401600100000', NULL, NULL, NULL, NULL, NULL),
(1001, 1, 'Новосибирск', 41, '630000', 1, NULL, 100, '5400000100000', NULL, NULL, NULL, NULL, NULL),
(1002, 1, 'Обь', 41, '633100', 1, NULL, 100, '5400000300000', NULL, NULL, NULL, NULL, NULL),
(1003, 1, 'Татарск', 41, '216156', 1, NULL, 100, '5402302200000', NULL, NULL, NULL, NULL, NULL),
(1004, 1, 'Тогучин', 41, '633450', 1, NULL, 100, '5402400100000', NULL, NULL, NULL, NULL, NULL),
(1005, 1, 'Черепаново', 41, '461227', 1, NULL, 100, '5402800100000', NULL, NULL, NULL, NULL, NULL),
(1006, 1, 'Чулым', 41, '632550', 1, NULL, 100, '5403000100000', NULL, NULL, NULL, NULL, NULL),
(1007, 1, 'Чулым-3', 41, '632553', 1, NULL, 100, '5403000005700', NULL, NULL, NULL, NULL, NULL),
(1008, 1, 'Боровичи', 7, '174400', 1, NULL, 100, '5300300100000', NULL, NULL, NULL, NULL, NULL),
(1009, 1, 'Валдай', 7, '175400', 1, NULL, 100, '5300400100000', NULL, NULL, NULL, NULL, NULL),
(1010, 1, 'Великий Новгород', 7, '173000', 1, NULL, 100, '5300000100000', NULL, NULL, NULL, NULL, NULL),
(1011, 1, 'Малая Вишера', 7, '174260', 1, NULL, 100, '5300900100000', NULL, NULL, NULL, NULL, NULL),
(1012, 1, 'Окуловка', 7, '174350', 1, NULL, 100, '5301200100000', NULL, NULL, NULL, NULL, NULL),
(1013, 1, 'Пестово', 7, '174510', 1, NULL, 100, '5301400100000', NULL, NULL, NULL, NULL, NULL),
(1014, 1, 'Сольцы', 7, '175040', 1, NULL, 100, '5301600200000', NULL, NULL, NULL, NULL, NULL),
(1015, 1, 'Сольцы 2', 7, '175042', 1, NULL, 100, '5301600200000', NULL, NULL, NULL, NULL, NULL),
(1016, 1, 'Старая Русса', 7, '175200', 1, NULL, 100, '5301700100000', NULL, NULL, NULL, NULL, NULL),
(1017, 1, 'Холм', 7, '152876', 1, NULL, 100, '5301900100000', NULL, NULL, NULL, NULL, NULL),
(1018, 1, 'Чудово', 7, '174210', 1, NULL, 100, '5302000100000', NULL, NULL, NULL, NULL, NULL),
(1019, 1, 'Алапаевск', 6, '624600', 1, NULL, 100, '6600002400000', NULL, NULL, NULL, NULL, NULL),
(1020, 1, 'Арамиль', 6, '624000', 1, NULL, 100, '6602500200000', NULL, NULL, NULL, NULL, NULL),
(1021, 1, 'Артемовский', 6, '623780', 1, NULL, 100, '6600300100000', NULL, NULL, NULL, NULL, NULL),
(1022, 1, 'Асбест', 6, '624260', 1, NULL, 100, '6600000200000', NULL, NULL, NULL, NULL, NULL),
(1023, 1, 'Богданович', 6, '623530', 1, NULL, 100, '6600800100000', NULL, NULL, NULL, NULL, NULL),
(1024, 1, 'Верхний Тагил', 6, '624162', 1, NULL, 100, '6600003700000', NULL, NULL, NULL, NULL, NULL),
(1025, 1, 'Верхняя Пышма', 6, '624090', 1, NULL, 100, '6600000400000', NULL, NULL, NULL, NULL, NULL),
(1026, 1, 'Верхняя Салда', 6, '624760', 1, NULL, 100, '6600004500000', NULL, NULL, NULL, NULL, NULL),
(1027, 1, 'Верхняя Тура', 6, '624320', 1, NULL, 100, '6600004000000', NULL, NULL, NULL, NULL, NULL),
(1028, 1, 'Верхотурье', 6, '624380', 1, NULL, 100, '6601000100000', NULL, NULL, NULL, NULL, NULL),
(1029, 1, 'Волчанск', 6, '624941', 1, NULL, 100, '6600003900000', NULL, NULL, NULL, NULL, NULL),
(1030, 1, 'Дегтярск', 6, '623271', 1, NULL, 100, '6600004100000', NULL, NULL, NULL, NULL, NULL),
(1031, 1, 'Екатеринбург', 6, '620000', 1, NULL, 100, '6600000100000', NULL, NULL, NULL, NULL, NULL),
(1032, 1, 'Ивдель', 6, '624445', 1, NULL, 100, '6600000600000', NULL, NULL, NULL, NULL, NULL),
(1033, 1, 'Ирбит', 6, '623850', 1, NULL, 100, '6600002900000', NULL, NULL, NULL, NULL, NULL),
(1034, 1, 'Каменск-Уральский', 6, '623400', 1, NULL, 100, '6600002200000', NULL, NULL, NULL, NULL, NULL),
(1035, 1, 'Камышлов', 6, '624860', 1, NULL, 100, '6600003000000', NULL, NULL, NULL, NULL, NULL),
(1036, 1, 'Карпинск', 6, '624930', 1, NULL, 100, '6600000700000', NULL, NULL, NULL, NULL, NULL),
(1037, 1, 'Качканар', 6, '624350', 1, NULL, 100, '6600000800000', NULL, NULL, NULL, NULL, NULL),
(1038, 1, 'Кировград', 6, '624140', 1, NULL, 100, '6600000900000', NULL, NULL, NULL, NULL, NULL),
(1039, 1, 'Краснотурьинск', 6, '624440', 1, NULL, 100, '6600001000000', NULL, NULL, NULL, NULL, NULL),
(1040, 1, 'Красноуральск', 6, '461348', 1, NULL, 100, '6600001100000', NULL, NULL, NULL, NULL, NULL),
(1041, 1, 'Красноуфимск', 6, '623300', 1, NULL, 100, '6600003100000', NULL, NULL, NULL, NULL, NULL),
(1042, 1, 'Кушва', 6, '624300', 1, NULL, 100, '6600001200000', NULL, NULL, NULL, NULL, NULL),
(1043, 1, 'Лесной', 6, '140451', 1, NULL, 100, '6600001300000', NULL, NULL, NULL, NULL, NULL),
(1044, 1, 'Михайловск', 6, '356240', 1, NULL, 100, '6601700200000', NULL, NULL, NULL, NULL, NULL),
(1045, 1, 'Невьянск', 6, '624191', 1, NULL, 100, '6600004300000', NULL, NULL, NULL, NULL, NULL),
(1046, 1, 'Нижние Серги', 6, '623090', 1, NULL, 100, '6601700100000', NULL, NULL, NULL, NULL, NULL),
(1047, 1, 'Нижние Серги-3', 6, '623093', 1, NULL, 100, '6601700000100', NULL, NULL, NULL, NULL, NULL),
(1048, 1, 'Нижний Тагил', 6, '622000', 1, NULL, 100, '6600002300000', NULL, NULL, NULL, NULL, NULL),
(1049, 1, 'Нижняя Салда', 6, '624740', 1, NULL, 100, '6600002700000', NULL, NULL, NULL, NULL, NULL),
(1050, 1, 'Нижняя Тура', 6, '624220', 1, NULL, 100, '6600001400000', NULL, NULL, NULL, NULL, NULL),
(1051, 1, 'Новая Ляля', 6, '624400', 1, NULL, 100, '6601800100000', NULL, NULL, NULL, NULL, NULL),
(1052, 1, 'Новоуральск', 6, '462232', 1, NULL, 100, '6600001500000', NULL, NULL, NULL, NULL, NULL),
(1053, 1, 'Первоуральск', 6, '623100', 1, NULL, 100, '6600001600000', NULL, NULL, NULL, NULL, NULL),
(1054, 1, 'Полевской', 6, '623380', 1, NULL, 100, '6600001700000', NULL, NULL, NULL, NULL, NULL),
(1055, 1, 'Ревда', 6, '184580', 1, NULL, 100, '6600001800000', NULL, NULL, NULL, NULL, NULL),
(1056, 1, 'Реж', 6, '623750', 1, NULL, 100, '6602100100000', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `gr_order_regions` (`id`, `site_id`, `title`, `parent_id`, `zipcode`, `is_city`, `area`, `sortn`, `kladr_id`, `type_short`, `processed`, `russianpost_arriveinfo`, `russianpost_arrive_min`, `russianpost_arrive_max`) VALUES
(1057, 1, 'Североуральск', 6, '624480', 1, NULL, 100, '6600002100000', NULL, NULL, NULL, NULL, NULL),
(1058, 1, 'Серов', 6, '624980', 1, NULL, 100, '6600003400000', NULL, NULL, NULL, NULL, NULL),
(1059, 1, 'Среднеуральск', 6, '624070', 1, NULL, 100, '6600003800000', NULL, NULL, NULL, NULL, NULL),
(1060, 1, 'Сухой Лог', 6, '624800', 1, NULL, 100, '6602400100000', NULL, NULL, NULL, NULL, NULL),
(1061, 1, 'Сысерть', 6, '624021', 1, NULL, 100, '6602500100000', NULL, NULL, NULL, NULL, NULL),
(1062, 1, 'Тавда', 6, '623950', 1, NULL, 100, '6600004200000', NULL, NULL, NULL, NULL, NULL),
(1063, 1, 'Талица', 6, '155456', 1, NULL, 100, '6602800100000', NULL, NULL, NULL, NULL, NULL),
(1064, 1, 'Туринск', 6, '623900', 1, NULL, 100, '6603000100000', NULL, NULL, NULL, NULL, NULL),
(1065, 1, 'Исилькуль', 40, '646020', 1, NULL, 100, '5500700100000', NULL, NULL, NULL, NULL, NULL),
(1066, 1, 'Калачинск', 40, '646900', 1, NULL, 100, '5500800100000', NULL, NULL, NULL, NULL, NULL),
(1067, 1, 'Называевск', 40, '646100', 1, NULL, 100, '5501600100000', NULL, NULL, NULL, NULL, NULL),
(1068, 1, 'Омск', 40, '644000', 1, NULL, 100, '5500000100000', NULL, NULL, NULL, NULL, NULL),
(1069, 1, 'Тара', 40, '646530', 1, NULL, 100, '5502800100000', NULL, NULL, NULL, NULL, NULL),
(1070, 1, 'Тюкалинск', 40, '646330', 1, NULL, 100, '5503000100000', NULL, NULL, NULL, NULL, NULL),
(1071, 1, 'Абдулино', 5, '461740', 1, NULL, 100, '5605500100000', NULL, NULL, NULL, NULL, NULL),
(1072, 1, 'Бугуруслан', 5, '461630', 1, NULL, 100, '5600000500000', NULL, NULL, NULL, NULL, NULL),
(1073, 1, 'Бузулук', 5, '461040', 1, NULL, 100, '5600000600000', NULL, NULL, NULL, NULL, NULL),
(1074, 1, 'Гай', 5, '462631', 1, NULL, 100, '5600000700000', NULL, NULL, NULL, NULL, NULL),
(1075, 1, 'Кувандык', 5, '462240', 1, NULL, 100, '5600000800000', NULL, NULL, NULL, NULL, NULL),
(1076, 1, 'Медногорск', 5, '462271', 1, NULL, 100, '5600000200000', NULL, NULL, NULL, NULL, NULL),
(1077, 1, 'Новотроицк', 5, '462351', 1, NULL, 100, '5600000300000', NULL, NULL, NULL, NULL, NULL),
(1078, 1, 'Оренбург', 5, '460000', 1, NULL, 100, '5600000100000', NULL, NULL, NULL, NULL, NULL),
(1079, 1, 'Орск', 5, '462400', 1, NULL, 100, '5600000400000', NULL, NULL, NULL, NULL, NULL),
(1080, 1, 'Соль-Илецк', 5, '461500', 1, NULL, 100, '5601500100000', NULL, NULL, NULL, NULL, NULL),
(1081, 1, 'Сорочинск', 5, '461900', 1, NULL, 100, '5600000900000', NULL, NULL, NULL, NULL, NULL),
(1082, 1, 'Ясный', 5, '462781', 1, NULL, 100, '5600001000000', NULL, NULL, NULL, NULL, NULL),
(1083, 1, 'Алатырь', 4, '429805', 1, NULL, 100, '2100002200000', NULL, NULL, NULL, NULL, NULL),
(1084, 1, 'Канаш', 4, '422584', 1, NULL, 100, '1601600002000', NULL, NULL, NULL, NULL, NULL),
(1085, 1, 'Козловка', 4, '216527', 1, NULL, 100, '2100800100000', NULL, NULL, NULL, NULL, NULL),
(1086, 1, 'Мариинский Посад', 4, '429570', 1, NULL, 100, '2101200100000', NULL, NULL, NULL, NULL, NULL),
(1087, 1, 'Новочебоксарск', 4, '429950', 1, NULL, 100, '2100002400000', NULL, NULL, NULL, NULL, NULL),
(1088, 1, 'Цивильск', 4, '429900', 1, NULL, 100, '2101600100000', NULL, NULL, NULL, NULL, NULL),
(1089, 1, 'Чебоксары', 4, '428000', 1, NULL, 100, '2100000100000', NULL, NULL, NULL, NULL, NULL),
(1090, 1, 'Шумерля', 4, '429120', 1, NULL, 100, '2100002500000', NULL, NULL, NULL, NULL, NULL),
(1091, 1, 'Ядрин', 4, '429060', 1, NULL, 100, '2102000100000', NULL, NULL, NULL, NULL, NULL),
(1092, 1, 'Ардатов', 3, '431860', 1, NULL, 100, '1300200100000', NULL, NULL, NULL, NULL, NULL),
(1093, 1, 'Инсар', 3, '431430', 1, NULL, 100, '1301000100000', NULL, NULL, NULL, NULL, NULL),
(1094, 1, 'Ковылкино', 3, '431350', 1, NULL, 100, '1300000200000', NULL, NULL, NULL, NULL, NULL),
(1095, 1, 'Рузаевка', 3, '431440', 1, NULL, 100, '1300000300000', NULL, NULL, NULL, NULL, NULL),
(1096, 1, 'Саранск', 3, '430000', 1, NULL, 100, '1300000100000', NULL, NULL, NULL, NULL, NULL),
(1097, 1, 'Темников', 3, '431220', 1, NULL, 100, '1302000100000', NULL, NULL, NULL, NULL, NULL),
(1098, 1, 'Апатиты', 2, '184200', 1, NULL, 100, '5100000200000', NULL, NULL, NULL, NULL, NULL),
(1099, 1, 'Гаджиево', 2, '184670', 1, NULL, 100, '5100001200000', NULL, NULL, NULL, NULL, NULL),
(1100, 1, 'Заозерск', 2, '184310', 1, NULL, 100, '5100000300000', NULL, NULL, NULL, NULL, NULL),
(1101, 1, 'Заполярный', 2, '184430', 1, NULL, 100, '5100500200000', NULL, NULL, NULL, NULL, NULL),
(1102, 1, 'Кандалакша', 2, '184012', 1, NULL, 100, '5100100100000', NULL, NULL, NULL, NULL, NULL),
(1103, 1, 'Ковдор', 2, '184141', 1, NULL, 100, '5100200100000', NULL, NULL, NULL, NULL, NULL),
(1104, 1, 'Кола', 2, '184380', 1, NULL, 100, '5100300100000', NULL, NULL, NULL, NULL, NULL),
(1105, 1, 'Мончегорск', 2, '184505', 1, NULL, 100, '5100000600000', NULL, NULL, NULL, NULL, NULL),
(1106, 1, 'Мурманск', 2, '183000', 1, NULL, 100, '5100000100000', NULL, NULL, NULL, NULL, NULL),
(1107, 1, 'Оленегорск', 2, '184530', 1, NULL, 100, '5100000700000', NULL, NULL, NULL, NULL, NULL),
(1108, 1, 'Оленегорск-1', 2, '184531', 1, NULL, 100, '5100001500000', NULL, NULL, NULL, NULL, NULL),
(1109, 1, 'Оленегорск-2', 2, '184532', 1, NULL, 100, '5100001600000', NULL, NULL, NULL, NULL, NULL),
(1110, 1, 'Островной', 2, '184640', 1, NULL, 100, '5100000800000', NULL, NULL, NULL, NULL, NULL),
(1111, 1, 'Полярные Зори', 2, '184230', 1, NULL, 100, '5100000900000', NULL, NULL, NULL, NULL, NULL),
(1112, 1, 'Полярный', 2, '184650', 1, NULL, 100, '5100001000000', NULL, NULL, NULL, NULL, NULL),
(1113, 1, 'Североморск', 2, '184601', 1, NULL, 100, '5100001100000', NULL, NULL, NULL, NULL, NULL),
(1114, 1, 'Снежногорск', 2, '184682', 1, NULL, 100, '5100001300000', NULL, NULL, NULL, NULL, NULL),
(1115, 1, 'Нарьян-Мар', 39, '166000', 1, NULL, 100, '8300000100000', NULL, NULL, NULL, NULL, NULL),
(1116, 1, 'Арзамас', 38, '607220', 1, NULL, 100, '5200000400000', NULL, NULL, NULL, NULL, NULL),
(1117, 1, 'Балахна', 38, '399221', 1, NULL, 100, '5200400100000', NULL, NULL, NULL, NULL, NULL),
(1118, 1, 'Богородск', 38, '168057', 1, NULL, 100, '5200500100000', NULL, NULL, NULL, NULL, NULL),
(1119, 1, 'Бор', 38, '606443', 1, NULL, 100, '5200000500000', NULL, NULL, NULL, NULL, NULL),
(1120, 1, 'Ветлуга', 38, '606860', 1, NULL, 100, '5201300100000', NULL, NULL, NULL, NULL, NULL),
(1121, 1, 'Володарск', 38, '606070', 1, NULL, 100, '5201600100000', NULL, NULL, NULL, NULL, NULL),
(1122, 1, 'Ворсма', 38, '606120', 1, NULL, 100, '5203200200000', NULL, NULL, NULL, NULL, NULL),
(1123, 1, 'Выкса', 38, '607060', 1, NULL, 100, '5200000700000', NULL, NULL, NULL, NULL, NULL),
(1124, 1, 'Горбатов', 38, '606125', 1, NULL, 100, '5203200300000', NULL, NULL, NULL, NULL, NULL),
(1125, 1, 'Городец', 38, '606504', 1, NULL, 100, '5202000100000', NULL, NULL, NULL, NULL, NULL),
(1126, 1, 'Дзержинск', 38, '606000', 1, NULL, 100, '5200000200000', NULL, NULL, NULL, NULL, NULL),
(1127, 1, 'Заволжье', 38, '606520', 1, NULL, 100, '5202000200000', NULL, NULL, NULL, NULL, NULL),
(1128, 1, 'Княгинино', 38, '606340', 1, NULL, 100, '5202300100000', NULL, NULL, NULL, NULL, NULL),
(1129, 1, 'Кстово', 38, '607650', 1, NULL, 100, '5202700100000', NULL, NULL, NULL, NULL, NULL),
(1130, 1, 'Кулебаки', 38, '607010', 1, NULL, 100, '5200001000000', NULL, NULL, NULL, NULL, NULL),
(1131, 1, 'Лукоянов', 38, '607800', 1, NULL, 100, '5202900100000', NULL, NULL, NULL, NULL, NULL),
(1132, 1, 'Лысково', 38, '606210', 1, NULL, 100, '5203000100000', NULL, NULL, NULL, NULL, NULL),
(1133, 1, 'Навашино', 38, '607100', 1, NULL, 100, '5203100100000', NULL, NULL, NULL, NULL, NULL),
(1134, 1, 'Нижний Новгород', 38, '603000', 1, NULL, 100, '5200000100000', NULL, NULL, NULL, NULL, NULL),
(1135, 1, 'Павлово', 38, '606100', 1, NULL, 100, '5203200100000', NULL, NULL, NULL, NULL, NULL),
(1136, 1, 'Первомайск', 38, '431530', 1, NULL, 100, '5200000800000', NULL, NULL, NULL, NULL, NULL),
(1137, 1, 'Перевоз', 38, '607400', 1, NULL, 100, '5203400100000', NULL, NULL, NULL, NULL, NULL),
(1138, 1, 'Саров', 38, '607180', 1, NULL, 100, '5200000300000', NULL, NULL, NULL, NULL, NULL),
(1139, 1, 'Семенов', 38, '606650', 1, NULL, 100, '5200000600000', NULL, NULL, NULL, NULL, NULL),
(1140, 1, 'Сергач', 38, '607510', 1, NULL, 100, '5203800100000', NULL, NULL, NULL, NULL, NULL),
(1141, 1, 'Урень', 38, '606800', 1, NULL, 100, '5204500100000', NULL, NULL, NULL, NULL, NULL),
(1142, 1, 'Чкаловск', 38, '606540', 1, NULL, 100, '5204600100000', NULL, NULL, NULL, NULL, NULL),
(1143, 1, 'Шахунья', 38, '606910', 1, NULL, 100, '5200000900000', NULL, NULL, NULL, NULL, NULL),
(1144, 1, 'Азов', 37, '346780', 1, NULL, 100, '6100001300000', NULL, NULL, NULL, NULL, NULL),
(1145, 1, 'Аксай', 37, '346720', 1, NULL, 100, '6100300100000', NULL, NULL, NULL, NULL, NULL),
(1146, 1, 'Батайск', 37, '346880', 1, NULL, 100, '6100000300000', NULL, NULL, NULL, NULL, NULL),
(1147, 1, 'Белая Калитва', 37, '347040', 1, NULL, 100, '6100500100000', NULL, NULL, NULL, NULL, NULL),
(1148, 1, 'Волгодонск', 37, '346686', 1, NULL, 100, '6100000400000', NULL, NULL, NULL, NULL, NULL),
(1149, 1, 'Гуково', 37, '346399', 1, NULL, 100, '6100000500000', NULL, NULL, NULL, NULL, NULL),
(1150, 1, 'Донецк', 37, '346330', 1, NULL, 100, '6100000600000', NULL, NULL, NULL, NULL, NULL),
(1151, 1, 'Зверево', 37, '346310', 1, NULL, 100, '6100000700000', NULL, NULL, NULL, NULL, NULL),
(1152, 1, 'Зерноград', 37, '347740', 1, NULL, 100, '6101300100000', NULL, NULL, NULL, NULL, NULL),
(1153, 1, 'Каменск-Шахтинский', 37, '347800', 1, NULL, 100, '6100000800000', NULL, NULL, NULL, NULL, NULL),
(1154, 1, 'Константиновск', 37, '347250', 1, NULL, 100, '6101800100000', NULL, NULL, NULL, NULL, NULL),
(1155, 1, 'Красный Сулин', 37, '346350', 1, NULL, 100, '6101900100000', NULL, NULL, NULL, NULL, NULL),
(1156, 1, 'Миллерово', 37, '346130', 1, NULL, 100, '6102300100000', NULL, NULL, NULL, NULL, NULL),
(1157, 1, 'Морозовск', 37, '347210', 1, NULL, 100, '6102500100000', NULL, NULL, NULL, NULL, NULL),
(1158, 1, 'Новочеркасск', 37, '346400', 1, NULL, 100, '6100000900000', NULL, NULL, NULL, NULL, NULL),
(1159, 1, 'Новошахтинск', 37, '346900', 1, NULL, 100, '6100001000000', NULL, NULL, NULL, NULL, NULL),
(1160, 1, 'Пролетарск', 37, '347540', 1, NULL, 100, '6103200100000', NULL, NULL, NULL, NULL, NULL),
(1161, 1, 'Ростов-на-Дону', 37, '344000', 1, NULL, 100, '6100000100000', NULL, NULL, NULL, NULL, NULL),
(1162, 1, 'Сальск', 37, '347630', 1, NULL, 100, '6103500100000', NULL, NULL, NULL, NULL, NULL),
(1163, 1, 'Семикаракорск', 37, '346630', 1, NULL, 100, '6103600100000', NULL, NULL, NULL, NULL, NULL),
(1164, 1, 'Таганрог', 37, '347900', 1, NULL, 100, '6100001100000', NULL, NULL, NULL, NULL, NULL),
(1165, 1, 'Цимлянск', 37, '347320', 1, NULL, 100, '6104200100000', NULL, NULL, NULL, NULL, NULL),
(1166, 1, 'Шахты', 37, '346500', 1, NULL, 100, '6100001200000', NULL, NULL, NULL, NULL, NULL),
(1167, 1, 'Гаврилов-Ям', 36, '152240', 1, NULL, 100, '7600500100000', NULL, NULL, NULL, NULL, NULL),
(1168, 1, 'Данилов', 36, '152070', 1, NULL, 100, '7600600100000', NULL, NULL, NULL, NULL, NULL),
(1169, 1, 'Любим', 36, '152470', 1, NULL, 100, '7600700100000', NULL, NULL, NULL, NULL, NULL),
(1170, 1, 'Мышкин', 36, '152830', 1, NULL, 100, '7600800100000', NULL, NULL, NULL, NULL, NULL),
(1171, 1, 'Переславль-Залесский', 36, '152020', 1, NULL, 100, '7600000200000', NULL, NULL, NULL, NULL, NULL),
(1172, 1, 'Пошехонье', 36, '152850', 1, NULL, 100, '7601300100000', NULL, NULL, NULL, NULL, NULL),
(1173, 1, 'Ростов', 36, '152150', 1, NULL, 100, '7601400100000', NULL, NULL, NULL, NULL, NULL),
(1174, 1, 'Рыбинск', 36, '152900', 1, NULL, 100, '7601500100000', NULL, NULL, NULL, NULL, NULL),
(1175, 1, 'Тутаев', 36, '152300', 1, NULL, 100, '7601600100000', NULL, NULL, NULL, NULL, NULL),
(1176, 1, 'Углич', 36, '152610', 1, NULL, 100, '7601700100000', NULL, NULL, NULL, NULL, NULL),
(1177, 1, 'Ярославль', 36, '150000', 1, NULL, 100, '7600000100000', NULL, NULL, NULL, NULL, NULL),
(1178, 1, 'Алупка', 35, '298600', 1, NULL, 100, '9100000800100', NULL, NULL, NULL, NULL, NULL),
(1179, 1, 'Алушта', 35, '298500', 1, NULL, 100, '9100001100000', NULL, NULL, NULL, NULL, NULL),
(1180, 1, 'Армянск', 35, '296012', 1, NULL, 100, '9100000200000', NULL, NULL, NULL, NULL, NULL),
(1181, 1, 'Бахчисарай', 35, '298400', 1, NULL, 100, '9100100100000', NULL, NULL, NULL, NULL, NULL),
(1182, 1, 'Джанкой', 35, '296100', 1, NULL, 100, '9100000600000', NULL, NULL, NULL, NULL, NULL),
(1183, 1, 'Евпатория', 35, '297402', 1, NULL, 100, '9100000900000', NULL, NULL, NULL, NULL, NULL),
(1184, 1, 'Керчь', 35, '298233', 1, NULL, 100, '9100000100000', NULL, NULL, NULL, NULL, NULL),
(1185, 1, 'Красноперекопск', 35, '296000', 1, NULL, 100, '9100000400000', NULL, NULL, NULL, NULL, NULL),
(1186, 1, 'Саки', 35, '296500', 1, NULL, 100, '9100000300000', NULL, NULL, NULL, NULL, NULL),
(1187, 1, 'Симферополь', 35, '295000', 1, NULL, 100, '9100000700000', NULL, NULL, NULL, NULL, NULL),
(1188, 1, 'Старый Крым', 35, '297345', 1, NULL, 100, '9100400100000', NULL, NULL, NULL, NULL, NULL),
(1189, 1, 'Судак', 35, '298000', 1, NULL, 100, '9100000500000', NULL, NULL, NULL, NULL, NULL),
(1190, 1, 'Феодосия', 35, '297183', 1, NULL, 100, '9100001000000', NULL, NULL, NULL, NULL, NULL),
(1191, 1, 'Щелкино', 35, '298213', 1, NULL, 100, '9100700100000', NULL, NULL, NULL, NULL, NULL),
(1192, 1, 'Ялта', 35, '298600', 1, NULL, 100, '9100000800000', NULL, NULL, NULL, NULL, NULL),
(1193, 1, 'Зеленоград', 34, '124489', 1, NULL, 100, '7700000200000', NULL, NULL, NULL, NULL, NULL),
(1194, 1, 'Московский', 34, '142784', 1, NULL, 100, '7701100100051', NULL, NULL, NULL, NULL, NULL),
(1195, 1, 'Троицк', 34, '142190', 1, NULL, 100, '7700000500000', NULL, NULL, NULL, NULL, NULL),
(1196, 1, 'Щербинка', 34, '142170', 1, NULL, 100, '7700000300000', NULL, NULL, NULL, NULL, NULL),
(1197, 1, 'Санкт-Петербург', 1, NULL, 0, NULL, 100, NULL, NULL, NULL, NULL, NULL, NULL),
(1198, 1, 'Колпино', 1197, '196650', 1, NULL, 100, '7800000300000', NULL, NULL, NULL, NULL, NULL),
(1199, 1, 'Красное Село', 1197, '198301', 1, NULL, 100, '7800000400000', NULL, NULL, NULL, NULL, NULL),
(1200, 1, 'Кронштадт', 1197, '197760', 1, NULL, 100, '7800000500000', NULL, NULL, NULL, NULL, NULL),
(1201, 1, 'Ломоносов', 1197, '198411', 1, NULL, 100, '7800000600000', NULL, NULL, NULL, NULL, NULL),
(1202, 1, 'Петергоф', 1197, '198504', 1, NULL, 100, '7800000800000', NULL, NULL, NULL, NULL, NULL),
(1203, 1, 'Пушкин', 1197, '196601', 1, NULL, 100, '7800000900000', NULL, NULL, NULL, NULL, NULL),
(1204, 1, 'Сестрорецк', 1197, '197701', 1, NULL, 100, '7800001000000', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_shipment`
--

CREATE TABLE `gr_order_shipment` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `order_id` int(11) DEFAULT NULL COMMENT 'id заказа',
  `date` datetime DEFAULT NULL COMMENT 'Дата',
  `info_order_num` varchar(255) DEFAULT NULL COMMENT 'Номер заказа',
  `info_total_sum` decimal(10,2) DEFAULT NULL COMMENT 'Сумма отгрузки'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_shipment_item`
--

CREATE TABLE `gr_order_shipment_item` (
  `order_id` int(11) DEFAULT NULL COMMENT 'id заказа',
  `shipment_id` int(11) DEFAULT NULL COMMENT 'id отгрузки',
  `order_item_uniq` varchar(255) DEFAULT NULL COMMENT 'Идентификатор товарной позиции',
  `amount` decimal(10,3) DEFAULT NULL COMMENT 'Количество',
  `uit_id` int(11) DEFAULT NULL COMMENT 'УИТ',
  `cost` decimal(15,2) DEFAULT NULL COMMENT 'Сумма'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_substatus`
--

CREATE TABLE `gr_order_substatus` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название статуса',
  `alias` varchar(255) DEFAULT NULL COMMENT 'Псевдоним',
  `sortn` int(11) DEFAULT NULL COMMENT 'Порядок сортировки'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_order_substatus`
--

INSERT INTO `gr_order_substatus` (`id`, `site_id`, `title`, `alias`, `sortn`) VALUES
(1, 1, 'Магазин не обработал заказ вовремя', 'processing_expired', 1),
(2, 1, 'Покупатель изменяет состав заказа', 'replacing_order', 2),
(3, 1, 'Покупатель не завершил оформление зарезервированного заказа вовремя', 'reservation_expired', 3),
(4, 1, 'Магазин не может выполнить заказ', 'shop_failed', 4),
(5, 1, 'Покупатель отменил заказ по собственным причинам', 'user_changed_mind', 5),
(6, 1, 'Покупатель не оплатил заказ', 'user_not_paid', 6),
(7, 1, 'Покупателя не устраивают условия доставки', 'user_refused_delivery', 7),
(8, 1, 'Покупателю не подошел товар', 'user_refused_product', 8),
(9, 1, 'Покупателя не устраивает качество товара', 'user_refused_quality', 9),
(10, 1, 'Не удалось связаться с покупателем', 'user_unreachable', 10);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_tax`
--

CREATE TABLE `gr_order_tax` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `alias` varchar(255) DEFAULT NULL COMMENT 'Идентификатор (Английские буквы или цифры)',
  `description` varchar(255) DEFAULT NULL COMMENT 'Описание',
  `enabled` int(11) DEFAULT NULL COMMENT 'Включен',
  `user_type` enum('all','user','company') DEFAULT NULL COMMENT 'Тип плательщиков',
  `included` int(11) DEFAULT NULL COMMENT 'Входит в цену',
  `is_nds` int(11) DEFAULT '1' COMMENT 'Это НДС',
  `sortn` int(11) DEFAULT NULL COMMENT 'Порядок применения'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_tax_rate`
--

CREATE TABLE `gr_order_tax_rate` (
  `tax_id` int(11) DEFAULT NULL COMMENT 'Название',
  `region_id` int(11) DEFAULT NULL COMMENT 'ID региона',
  `rate` decimal(12,4) DEFAULT NULL COMMENT 'Ставка налога'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_userstatus`
--

CREATE TABLE `gr_order_userstatus` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Статус',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT 'Родитель',
  `bgcolor` varchar(7) DEFAULT NULL COMMENT 'Цвет фона',
  `type` varchar(20) DEFAULT NULL COMMENT 'Идентификатор(Англ.яз)',
  `copy_type` varchar(20) DEFAULT NULL COMMENT 'Дублирует системный статус',
  `is_system` int(1) NOT NULL DEFAULT '0' COMMENT 'Это системный статус. (его нельзя удалять)'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_order_userstatus`
--

INSERT INTO `gr_order_userstatus` (`id`, `site_id`, `title`, `parent_id`, `bgcolor`, `type`, `copy_type`, `is_system`) VALUES
(1, 1, 'Новый', 0, '#83b7b3', 'new', NULL, 1),
(2, 1, 'Ожидает оплату', 0, '#687482', 'waitforpay', NULL, 1),
(3, 1, 'В обработке', 0, '#f2aa17', 'inprogress', NULL, 1),
(4, 1, 'Ожидание чека', 0, '#808000', 'needreceipt', NULL, 1),
(5, 1, 'Выполнен и закрыт', 0, '#5f8456', 'success', NULL, 1),
(6, 1, 'Отменен', 0, '#ef533a', 'cancelled', NULL, 1),
(7, 1, 'Заказ передан в доставку', 0, '#68d4b4', 'delivery', NULL, 1),
(8, 1, 'Заказ доставлен в пункт самовывоза', 0, '#a1b019', 'pickup', NULL, 1),
(9, 1, 'Заказ в резерве', 0, '#e07445', 'reserved', NULL, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_x_region`
--

CREATE TABLE `gr_order_x_region` (
  `zone_id` int(11) DEFAULT NULL COMMENT 'ID Зоны',
  `region_id` int(11) DEFAULT NULL COMMENT 'ID Региона'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_order_x_region`
--

INSERT INTO `gr_order_x_region` (`zone_id`, `region_id`) VALUES
(1, 12),
(1, 22),
(1, 64),
(1, 75),
(1, 83),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 11),
(2, 13),
(2, 14),
(2, 17),
(2, 18),
(2, 21),
(2, 26),
(2, 28),
(2, 29),
(2, 37),
(2, 39),
(2, 42),
(2, 43),
(2, 45),
(2, 50),
(2, 53),
(2, 56),
(2, 58),
(2, 60),
(2, 62),
(2, 63),
(2, 65),
(2, 68),
(2, 69),
(2, 73),
(2, 76),
(2, 77),
(2, 81),
(2, 84),
(3, 44),
(3, 51),
(3, 55),
(3, 59),
(3, 66),
(3, 70),
(3, 78),
(4, 10),
(4, 15),
(4, 16),
(4, 20),
(4, 23),
(4, 24),
(4, 32),
(4, 33),
(4, 34),
(4, 36),
(4, 38),
(4, 52),
(4, 61),
(4, 67),
(4, 71),
(4, 72),
(4, 80),
(4, 82),
(4, 85),
(4, 1197),
(5, 25),
(5, 27),
(5, 30),
(5, 31),
(5, 40),
(5, 41),
(5, 46),
(5, 47),
(5, 48),
(5, 49),
(5, 54),
(5, 57),
(5, 74),
(5, 79);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_order_zone`
--

CREATE TABLE `gr_order_zone` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_order_zone`
--

INSERT INTO `gr_order_zone` (`id`, `site_id`, `title`) VALUES
(1, 1, 'Магистральный пояс 4'),
(2, 1, 'Магистральный пояс 2'),
(3, 1, 'Магистральный пояс 5'),
(4, 1, 'Магистральный пояс 1'),
(5, 1, 'Магистральный пояс 3');

-- --------------------------------------------------------

--
-- Структура таблицы `gr_ormeditor_customfield`
--

CREATE TABLE `gr_ormeditor_customfield` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `orm_class` varchar(255) DEFAULT NULL COMMENT 'Расширяемый класс ORM объекта',
  `tab` varchar(255) DEFAULT NULL COMMENT 'Вкладка',
  `field` varchar(255) DEFAULT NULL COMMENT 'Свойство для расширения',
  `hide` varchar(255) DEFAULT NULL COMMENT 'Скрыть',
  `is_base` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL COMMENT 'Тип поля',
  `description` varchar(255) DEFAULT NULL COMMENT 'Описание поля',
  `default` varchar(255) DEFAULT NULL COMMENT 'Значение по умолчанию',
  `allow_empty` int(11) DEFAULT NULL COMMENT 'Разрешить NULL'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_page_seo`
--

CREATE TABLE `gr_page_seo` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `route_id` varchar(255) DEFAULT NULL COMMENT 'Маршрут',
  `meta_title` varchar(1000) DEFAULT NULL COMMENT 'Заголовок',
  `meta_keywords` varchar(1000) DEFAULT NULL COMMENT 'Ключевые слова',
  `meta_description` varchar(1000) DEFAULT NULL COMMENT 'Описание'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_partnership`
--

CREATE TABLE `gr_partnership` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название партнера',
  `user_id` bigint(11) DEFAULT NULL COMMENT 'Пользователь',
  `logo` varchar(255) DEFAULT NULL COMMENT 'Логотип',
  `favicon` varchar(255) DEFAULT NULL COMMENT 'Иконка сайта 16x16 (PNG, ICO)',
  `slogan` varchar(255) DEFAULT NULL COMMENT 'Слоган',
  `short_contacts` varchar(255) DEFAULT NULL COMMENT 'Короткая контактная информация',
  `contacts` mediumtext COMMENT 'Контактная информация',
  `price_base_id` int(11) DEFAULT NULL COMMENT 'Базовая цена для расчета',
  `price_inc_value` int(11) DEFAULT NULL COMMENT 'Увеличения стоимости, %',
  `cost_type_id` int(11) DEFAULT NULL COMMENT 'Привязанная к партнеру цена',
  `domains` mediumtext COMMENT 'Доменные имена (через запятую или с новой строки)',
  `city_id` int(11) DEFAULT NULL COMMENT 'Город из справочника',
  `address` varchar(255) DEFAULT NULL COMMENT 'Адрес партнёра',
  `coordinate_lat` float DEFAULT NULL COMMENT 'Координата широты партнёра',
  `coordinate_lng` float DEFAULT NULL COMMENT 'Координата долготы партнёра',
  `redirect_to_https` int(11) NOT NULL COMMENT 'Перенаправлять на https',
  `theme` varchar(255) DEFAULT NULL COMMENT 'Тема оформления партнера',
  `_products` mediumtext,
  `is_closed` int(11) DEFAULT NULL COMMENT 'Закрыть доступ к сайту',
  `close_message` varchar(255) DEFAULT NULL COMMENT 'Причина закрытия сайта',
  `notice_from` varchar(255) DEFAULT NULL COMMENT 'Будет указано в письме в поле  ''От''',
  `notice_reply` varchar(255) DEFAULT NULL COMMENT 'Куда присылать ответные письма? (поле Reply)'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_photogalleries_album`
--

CREATE TABLE `gr_photogalleries_album` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(250) DEFAULT NULL COMMENT 'Название альбома',
  `alias` varchar(255) DEFAULT NULL COMMENT 'URL имя',
  `public` int(1) DEFAULT '1' COMMENT 'Публичный',
  `sortn` int(11) DEFAULT NULL COMMENT 'Сорт. индекс'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product`
--

CREATE TABLE `gr_product` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Короткое название',
  `alias` varchar(150) DEFAULT NULL COMMENT 'URL имя',
  `short_description` mediumtext COMMENT 'Краткое описание',
  `description` mediumtext COMMENT 'Описание товара',
  `barcode` varchar(50) DEFAULT NULL COMMENT 'Артикул',
  `weight` float DEFAULT NULL COMMENT 'Вес',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата поступления',
  `num` decimal(11,3) NOT NULL COMMENT 'Доступно',
  `waiting` decimal(11,3) NOT NULL COMMENT 'Ожидание',
  `reserve` decimal(11,3) NOT NULL COMMENT 'Зарезервировано',
  `remains` decimal(11,3) NOT NULL COMMENT 'Остаток',
  `amount_step` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT 'Шаг изменения количества товара в корзине',
  `unit` int(11) DEFAULT NULL COMMENT 'Единица измерения',
  `min_order` decimal(11,3) DEFAULT NULL COMMENT 'Минимальное количество товара для заказа',
  `max_order` decimal(11,3) DEFAULT NULL COMMENT 'Максимальное количество товара для заказа',
  `public` int(1) DEFAULT NULL COMMENT 'Показывать товар',
  `no_export` int(1) DEFAULT '0' COMMENT 'Не экспортировать',
  `maindir` int(11) DEFAULT NULL COMMENT 'Основная категория',
  `reservation` enum('default','throughout','forced') NOT NULL DEFAULT 'default' COMMENT 'Предварительный заказ',
  `brand_id` int(11) DEFAULT '0' COMMENT 'Бренд товара',
  `format` varchar(20) DEFAULT NULL COMMENT 'Загружен из',
  `rating` decimal(3,1) DEFAULT NULL COMMENT 'Средний балл(рейтинг)',
  `comments` int(11) DEFAULT NULL COMMENT 'Кол-во комментариев',
  `last_id` varchar(36) DEFAULT NULL COMMENT 'Прошлый ID',
  `processed` int(2) DEFAULT NULL,
  `is_new` int(1) DEFAULT NULL COMMENT 'Служебное поле',
  `group_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор группы товаров',
  `xml_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор в системе 1C',
  `import_hash` varchar(32) DEFAULT NULL COMMENT 'Хэш данных импорта',
  `sku` varchar(50) DEFAULT NULL COMMENT 'Штрихкод',
  `sortn` int(11) DEFAULT '100' COMMENT 'Сортировочный вес',
  `recommended` varchar(4000) DEFAULT NULL COMMENT 'Рекомендуемые товары',
  `concomitant` varchar(4000) DEFAULT NULL COMMENT 'Сопутствующие товары',
  `offer_caption` varchar(200) DEFAULT NULL COMMENT 'Подпись к комплектациям',
  `meta_title` varchar(1000) DEFAULT NULL COMMENT 'SEO Заголовок',
  `meta_keywords` varchar(1000) DEFAULT NULL COMMENT 'SEO Ключевые слова(keywords)',
  `meta_description` varchar(1000) DEFAULT NULL COMMENT 'SEO Описание(description)',
  `disallow_manually_add_to_cart` int(1) DEFAULT '0' COMMENT 'Запретить ручное добавление товара в корзину',
  `payment_subject` varchar(255) DEFAULT 'commodity' COMMENT 'Признак предмета расчета для чека',
  `payment_method` varchar(255) NOT NULL DEFAULT '0' COMMENT 'Признак способа расчета для чека',
  `tax_ids` varchar(255) DEFAULT 'category' COMMENT 'Налоги',
  `marked_class` varchar(255) DEFAULT '' COMMENT 'Класс маркируемых товаров',
  `owner` int(3) DEFAULT NULL COMMENT 'Владелец'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_product`
--

INSERT INTO `gr_product` (`id`, `site_id`, `title`, `alias`, `short_description`, `description`, `barcode`, `weight`, `dateof`, `num`, `waiting`, `reserve`, `remains`, `amount_step`, `unit`, `min_order`, `max_order`, `public`, `no_export`, `maindir`, `reservation`, `brand_id`, `format`, `rating`, `comments`, `last_id`, `processed`, `is_new`, `group_id`, `xml_id`, `import_hash`, `sku`, `sortn`, `recommended`, `concomitant`, `offer_caption`, `meta_title`, `meta_keywords`, `meta_description`, `disallow_manually_add_to_cart`, `payment_subject`, `payment_method`, `tax_ids`, `marked_class`, `owner`) VALUES
(1, 1, 'test2', 'rewrer', '', '', 'a000001', 0, '2020-10-18 14:30:18', '0.000', '0.000', '0.000', '0.000', '0.000', 0, '0.000', '0.000', 1, 0, 1, 'default', 0, NULL, '0.0', NULL, NULL, NULL, NULL, '', NULL, NULL, '', 100, 'a:0:{}', 'a:0:{}', '', '', '', '', 0, 'commodity', '0', 'category', '', NULL),
(8, 1, 'fsbfdvbfdfdsbfdb', 'cxvbcvxbxcvbvcbb', 'cvxbvcbxcvb', '', NULL, NULL, NULL, '0.000', '0.000', '0.000', '0.000', '0.000', NULL, NULL, NULL, 1, 0, NULL, 'default', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'commodity', '0', 'category', '', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_dir`
--

CREATE TABLE `gr_product_dir` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `name` varchar(255) DEFAULT NULL COMMENT 'Название категории',
  `alias` varchar(150) DEFAULT NULL COMMENT 'Псевдоним',
  `parent` int(11) DEFAULT NULL COMMENT 'Родитель',
  `public` int(1) DEFAULT NULL COMMENT 'Публичный',
  `sortn` int(11) DEFAULT NULL COMMENT 'Порядк. N',
  `is_spec_dir` varchar(1) DEFAULT NULL COMMENT 'Это спец. список?',
  `is_label` int(1) NOT NULL DEFAULT '0' COMMENT 'Показывать как ярлык у товаров',
  `itemcount` int(11) DEFAULT NULL COMMENT 'Количество элементов',
  `level` int(11) DEFAULT NULL COMMENT 'Уровень вложенности',
  `image` varchar(255) DEFAULT NULL COMMENT 'Изображение',
  `weight` int(11) DEFAULT NULL COMMENT 'Вес товара по умолчанию, грамм',
  `xml_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор в системе 1C',
  `processed` int(2) DEFAULT NULL,
  `description` mediumtext COMMENT 'Описание категории',
  `meta_title` varchar(1000) DEFAULT NULL COMMENT 'Заголовок',
  `meta_keywords` varchar(1000) DEFAULT NULL COMMENT 'Ключевые слова',
  `meta_description` varchar(1000) DEFAULT NULL COMMENT 'Описание',
  `product_meta_title` varchar(1000) DEFAULT NULL COMMENT 'Заголовок товаров',
  `product_meta_keywords` varchar(1000) DEFAULT NULL COMMENT 'Ключевые слова товаров',
  `product_meta_description` varchar(1000) DEFAULT NULL COMMENT 'Описание товаров',
  `in_list_properties` mediumtext COMMENT 'Характеристики списка',
  `is_virtual` int(11) DEFAULT NULL COMMENT 'Включить подбор товаров',
  `virtual_data` mediumtext COMMENT 'Параметры выборки товаров',
  `export_name` varchar(255) DEFAULT NULL COMMENT 'Название категории при экспорте',
  `recommended` varchar(4000) DEFAULT NULL COMMENT 'Рекомендуемые товары',
  `concomitant` varchar(4000) DEFAULT NULL COMMENT 'Сопутствующие товары',
  `mobile_background_color` varchar(11) DEFAULT '#E0E0E0' COMMENT 'Цвет фона для планшета',
  `mobile_tablet_background_image` varchar(255) DEFAULT NULL COMMENT 'Картинка для планшета',
  `mobile_tablet_icon` varchar(255) DEFAULT NULL COMMENT 'Картинка для мобильной версии',
  `tax_ids` varchar(255) DEFAULT 'all' COMMENT 'Налоги'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_product_dir`
--

INSERT INTO `gr_product_dir` (`id`, `site_id`, `name`, `alias`, `parent`, `public`, `sortn`, `is_spec_dir`, `is_label`, `itemcount`, `level`, `image`, `weight`, `xml_id`, `processed`, `description`, `meta_title`, `meta_keywords`, `meta_description`, `product_meta_title`, `product_meta_keywords`, `product_meta_description`, `in_list_properties`, `is_virtual`, `virtual_data`, `export_name`, `recommended`, `concomitant`, `mobile_background_color`, `mobile_tablet_background_image`, `mobile_tablet_icon`, `tax_ids`) VALUES
(1, 1, 'Картины', 'kartiny', 0, 1, 1, 'N', 0, 2, 0, NULL, 0, NULL, NULL, '', '', '', '', '', '', '', 'a:0:{}', 0, NULL, '', 'a:0:{}', 'a:0:{}', '#e0e0e0', NULL, NULL, 'all');

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_favorite`
--

CREATE TABLE `gr_product_favorite` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `guest_id` varchar(50) DEFAULT NULL COMMENT 'id гостя',
  `user_id` int(11) DEFAULT NULL COMMENT 'id пользователя',
  `product_id` int(11) DEFAULT NULL COMMENT 'id товара'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_multioffer`
--

CREATE TABLE `gr_product_multioffer` (
  `product_id` int(11) DEFAULT NULL COMMENT 'id товара',
  `prop_id` int(11) DEFAULT NULL COMMENT 'id характеристики',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название уровня',
  `is_photo` int(11) DEFAULT '0' COMMENT 'Представление в виде фото?',
  `sortn` int(11) DEFAULT '0' COMMENT 'Индекс сортировки'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_offer`
--

CREATE TABLE `gr_product_offer` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `product_id` int(11) DEFAULT NULL COMMENT 'ID товара',
  `title` varchar(300) DEFAULT NULL COMMENT 'Название',
  `barcode` varchar(50) NOT NULL COMMENT 'Артикул',
  `weight` float DEFAULT '0' COMMENT 'Вес',
  `pricedata` text COMMENT 'Цена (сериализован)',
  `propsdata` text COMMENT 'Характеристики комплектации (сериализован)',
  `num` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT 'Остаток на складе',
  `waiting` decimal(11,3) NOT NULL COMMENT 'Ожидание',
  `reserve` decimal(11,3) NOT NULL COMMENT 'Зарезервировано',
  `remains` decimal(11,3) NOT NULL COMMENT 'Остаток',
  `photos` varchar(1000) DEFAULT NULL COMMENT 'Фотографии комплектаций',
  `sortn` int(11) DEFAULT NULL COMMENT 'Порядковый номер',
  `unit` int(11) DEFAULT '0' COMMENT 'Единица измерения',
  `processed` int(2) DEFAULT NULL COMMENT 'Флаг обработанной во время импорта комплектации',
  `xml_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор товара в системе 1C',
  `import_hash` varchar(32) DEFAULT NULL COMMENT 'Хэш данных импорта',
  `sku` varchar(50) DEFAULT NULL COMMENT 'Штрихкод'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_product_offer`
--

INSERT INTO `gr_product_offer` (`id`, `site_id`, `product_id`, `title`, `barcode`, `weight`, `pricedata`, `propsdata`, `num`, `waiting`, `reserve`, `remains`, `photos`, `sortn`, `unit`, `processed`, `xml_id`, `import_hash`, `sku`) VALUES
(1, 1, 1, '', '', 0, 'a:0:{}', 'a:0:{}', '0.000', '0.000', '0.000', '0.000', 'a:0:{}', 0, 0, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_prop`
--

CREATE TABLE `gr_product_prop` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название характеристики',
  `alias` varchar(255) DEFAULT NULL COMMENT 'Англ. псевдоним',
  `type` varchar(10) DEFAULT 'string' COMMENT 'Тип',
  `description` mediumtext COMMENT 'Описание',
  `sortn` int(11) DEFAULT NULL COMMENT 'Сорт. индекс',
  `parent_sortn` int(11) DEFAULT NULL COMMENT 'Сорт. индекс группы',
  `unit` varchar(30) DEFAULT NULL COMMENT 'Единица измерения',
  `unit_export` varchar(30) DEFAULT NULL COMMENT 'Размерная сетка',
  `name_for_export` varchar(30) DEFAULT NULL COMMENT 'Имя, выгружаемое на Яндекс маркет',
  `xml_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор товара в системе 1C',
  `parent_id` int(11) NOT NULL COMMENT 'Группа',
  `int_hide_inputs` int(1) DEFAULT '0' COMMENT 'Скрывать поля ввода границ диапазона',
  `hidden` int(1) DEFAULT '0' COMMENT 'Не отображать в карточке товара',
  `no_export` int(1) DEFAULT '0' COMMENT 'Не экспортировать'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_product_prop`
--

INSERT INTO `gr_product_prop` (`id`, `site_id`, `title`, `alias`, `type`, `description`, `sortn`, `parent_sortn`, `unit`, `unit_export`, `name_for_export`, `xml_id`, `parent_id`, `int_hide_inputs`, `hidden`, `no_export`) VALUES
(1, 1, 'Город', 'city', 'list', '', 1, 1, '', '', '', NULL, 1, 0, 0, 0),
(2, 1, 'Первая', NULL, 'string', NULL, 2, 1, '', NULL, NULL, NULL, 1, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_prop_dir`
--

CREATE TABLE `gr_product_prop_dir` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `hidden` int(1) DEFAULT '0' COMMENT 'Не отображать в карточке товара',
  `sortn` int(11) DEFAULT NULL COMMENT 'Сорт. номер'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_product_prop_dir`
--

INSERT INTO `gr_product_prop_dir` (`id`, `site_id`, `title`, `hidden`, `sortn`) VALUES
(1, 1, 'Картины', 0, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_prop_link`
--

CREATE TABLE `gr_product_prop_link` (
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `prop_id` int(11) DEFAULT NULL COMMENT 'ID характеристики',
  `product_id` int(11) DEFAULT NULL COMMENT 'ID товара',
  `group_id` int(11) DEFAULT NULL COMMENT 'ID группы товаров',
  `val_str` varchar(255) DEFAULT NULL COMMENT 'Строковое значение',
  `val_int` float DEFAULT NULL COMMENT 'Числовое значение',
  `val_list_id` int(11) DEFAULT NULL COMMENT 'Списковое значение',
  `available` int(1) NOT NULL DEFAULT '1' COMMENT 'Есть в наличии товары с такой характеристикой',
  `public` int(1) DEFAULT NULL COMMENT 'Участие в фильтрах. Для group_id>0',
  `is_expanded` int(1) NOT NULL DEFAULT '0' COMMENT 'Показывать всегда развернутым',
  `xml_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор товара в системе 1C',
  `extra` varchar(255) DEFAULT NULL COMMENT 'Дополнительное поле для данных'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_product_prop_link`
--

INSERT INTO `gr_product_prop_link` (`site_id`, `prop_id`, `product_id`, `group_id`, `val_str`, `val_int`, `val_list_id`, `available`, `public`, `is_expanded`, `xml_id`, `extra`) VALUES
(1, 1, NULL, 1, NULL, NULL, 0, 1, 1, 1, '', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_prop_value`
--

CREATE TABLE `gr_product_prop_value` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `prop_id` int(11) DEFAULT NULL COMMENT 'Характеристика',
  `value` varchar(255) DEFAULT NULL COMMENT 'Значение характеристики',
  `alias` varchar(255) DEFAULT NULL COMMENT 'Англ. псевдоним',
  `color` varchar(7) DEFAULT NULL COMMENT 'Цвет',
  `image` varchar(255) DEFAULT NULL COMMENT 'Изображение',
  `sortn` int(11) DEFAULT NULL COMMENT 'Порядок',
  `xml_id` varchar(255) DEFAULT NULL COMMENT 'Внешний идентификатор'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_reservation`
--

CREATE TABLE `gr_product_reservation` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `product_id` int(11) DEFAULT NULL COMMENT 'ID товара',
  `product_barcode` varchar(255) DEFAULT NULL COMMENT 'Артикул товара',
  `product_title` varchar(255) DEFAULT NULL COMMENT 'Название товара',
  `offer` varchar(255) DEFAULT NULL COMMENT 'Название комплектации товара',
  `offer_id` int(11) DEFAULT NULL COMMENT 'Комплектация товара',
  `currency` varchar(255) DEFAULT NULL COMMENT 'Валюта на момент оформления заявки',
  `multioffer` varchar(255) DEFAULT NULL COMMENT 'Многомерная комплектация товара',
  `amount` decimal(11,3) DEFAULT NULL COMMENT 'Количество',
  `phone` varchar(50) DEFAULT NULL COMMENT 'Телефон пользователя',
  `email` varchar(255) DEFAULT NULL COMMENT 'E-mail пользователя',
  `is_notify` enum('1','0') NOT NULL DEFAULT '0' COMMENT 'Уведомлять о поступлении на склад',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата заказа',
  `user_id` bigint(11) DEFAULT NULL COMMENT 'ID пользователя',
  `status` enum('open','close') NOT NULL COMMENT 'Статус',
  `comment` mediumtext COMMENT 'Комментарий администратора',
  `partner_id` int(11) DEFAULT '0' COMMENT 'Партнёрский сайт',
  `source_id` int(11) DEFAULT '0' COMMENT 'Источники прихода',
  `utm_source` varchar(50) DEFAULT NULL COMMENT 'Рекламная система UTM_SOURCE',
  `utm_medium` varchar(50) DEFAULT NULL COMMENT 'Тип трафика UTM_MEDIUM',
  `utm_campaign` varchar(50) DEFAULT NULL COMMENT 'Рекламная кампания UTM_COMPAING',
  `utm_term` varchar(50) DEFAULT NULL COMMENT 'Ключевое слово UTM_TERM',
  `utm_content` varchar(50) DEFAULT NULL COMMENT 'Различия UTM_CONTENT',
  `utm_dateof` date DEFAULT NULL COMMENT 'Дата события'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_typecost`
--

CREATE TABLE `gr_product_typecost` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `xml_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор в системе 1C',
  `title` varchar(150) DEFAULT NULL COMMENT 'Название',
  `type` enum('manual','auto') DEFAULT 'manual' COMMENT 'Тип цены',
  `val_znak` varchar(1) DEFAULT NULL COMMENT 'Знак значения',
  `val` float DEFAULT NULL COMMENT 'Величина увеличения стоимости',
  `val_type` enum('sum','percent') DEFAULT NULL COMMENT 'Тип увеличения стоимости',
  `depend` int(11) DEFAULT NULL COMMENT 'Цена, от которой ведется расчет',
  `round` decimal(10,2) DEFAULT NULL COMMENT 'Округление',
  `old_cost` int(11) NOT NULL DEFAULT '0' COMMENT 'Старая(зачеркнутая) цена'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_product_typecost`
--

INSERT INTO `gr_product_typecost` (`id`, `site_id`, `xml_id`, `title`, `type`, `val_znak`, `val`, `val_type`, `depend`, `round`, `old_cost`) VALUES
(1, 1, NULL, 'Розничная', 'manual', NULL, NULL, NULL, NULL, '0.00', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_unit`
--

CREATE TABLE `gr_product_unit` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `code` int(11) DEFAULT NULL COMMENT 'Код ОКЕИ',
  `icode` varchar(25) DEFAULT NULL COMMENT 'Международное сокращение',
  `title` varchar(70) DEFAULT NULL COMMENT 'Полное название единицы измерения',
  `stitle` varchar(25) DEFAULT NULL COMMENT 'Короткое обозначение',
  `amount_step` decimal(11,3) NOT NULL DEFAULT '1.000' COMMENT 'Шаг изменения количества товара в корзине',
  `min_order_quantity` decimal(11,3) DEFAULT NULL COMMENT 'Минимальное количество товара для заказа',
  `max_order_quantity` decimal(11,3) DEFAULT NULL COMMENT 'Максимальное количество товара для заказа',
  `sortn` int(11) DEFAULT NULL COMMENT 'Сорт. номер'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_x_cost`
--

CREATE TABLE `gr_product_x_cost` (
  `product_id` int(11) DEFAULT NULL COMMENT 'ID товара',
  `cost_id` int(11) DEFAULT NULL COMMENT 'ID цены',
  `cost_val` decimal(20,2) NOT NULL COMMENT 'Рассчитанная цена в базовой валюте',
  `cost_original_val` decimal(20,2) NOT NULL COMMENT 'Оригинальная цена товара',
  `cost_original_currency` int(11) NOT NULL DEFAULT '0' COMMENT 'ID валюты оригинальной цены товара'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_product_x_cost`
--

INSERT INTO `gr_product_x_cost` (`product_id`, `cost_id`, `cost_val`, `cost_original_val`, `cost_original_currency`) VALUES
(1, 1, '0.00', '0.00', 1),
(8, 1, '0.00', '0.00', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_x_dir`
--

CREATE TABLE `gr_product_x_dir` (
  `product_id` int(11) DEFAULT NULL COMMENT 'ID товара',
  `dir_id` int(11) DEFAULT NULL COMMENT 'ID категории'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_product_x_dir`
--

INSERT INTO `gr_product_x_dir` (`product_id`, `dir_id`) VALUES
(1, 1),
(8, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_product_x_stock`
--

CREATE TABLE `gr_product_x_stock` (
  `product_id` int(11) DEFAULT NULL COMMENT 'ID товара',
  `offer_id` int(11) DEFAULT NULL COMMENT 'ID комплектации',
  `warehouse_id` int(11) DEFAULT NULL COMMENT 'ID склада',
  `stock` decimal(11,3) DEFAULT '0.000' COMMENT 'Доступно',
  `reserve` decimal(11,3) DEFAULT '0.000' COMMENT 'Резерв',
  `waiting` decimal(11,3) DEFAULT '0.000' COMMENT 'Ожидание',
  `remains` decimal(11,3) DEFAULT '0.000' COMMENT 'Остаток'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_product_x_stock`
--

INSERT INTO `gr_product_x_stock` (`product_id`, `offer_id`, `warehouse_id`, `stock`, `reserve`, `waiting`, `remains`) VALUES
(1, 1, 1, '0.000', '0.000', '0.000', '0.000');

-- --------------------------------------------------------

--
-- Структура таблицы `gr_purchase`
--

CREATE TABLE `gr_purchase` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `customer_id` int(10) DEFAULT NULL COMMENT 'покупатель',
  `seller_id` int(2) DEFAULT NULL COMMENT 'продавец',
  `comment` varchar(255) DEFAULT NULL COMMENT 'комментарий покупателя',
  `phone` varchar(20) DEFAULT NULL COMMENT 'телефон',
  `email` varchar(255) DEFAULT NULL COMMENT 'email'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_pushsender_push_lock`
--

CREATE TABLE `gr_pushsender_push_lock` (
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `user_id` int(11) DEFAULT NULL COMMENT 'Пользователь',
  `app` varchar(100) DEFAULT NULL COMMENT 'Приложение',
  `push_class` varchar(100) DEFAULT NULL COMMENT 'Класс уведомлений, all - запретить все'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_pushsender_user_token`
--

CREATE TABLE `gr_pushsender_user_token` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `user_id` int(11) DEFAULT NULL COMMENT 'ID пользователя',
  `push_token` varchar(300) DEFAULT NULL COMMENT 'Токен пользователя в Firebase',
  `dateofcreate` datetime DEFAULT NULL COMMENT 'Дата создания',
  `app` varchar(50) DEFAULT NULL COMMENT 'Приложение, для которого выписан token',
  `uuid` varchar(255) DEFAULT NULL COMMENT 'Уникальный идентификатор устройства',
  `model` varchar(80) DEFAULT NULL COMMENT 'Модель устройства',
  `manufacturer` varchar(80) DEFAULT NULL COMMENT 'Производитель',
  `platform` varchar(50) DEFAULT NULL COMMENT 'Платформа на устройстве',
  `version` varchar(255) DEFAULT NULL COMMENT 'Версия платформы на устройстве',
  `cordova` varchar(255) DEFAULT NULL COMMENT 'Версия cordova js',
  `ip` varchar(20) DEFAULT NULL COMMENT 'IP адрес'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_readed_item`
--

CREATE TABLE `gr_readed_item` (
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `user_id` bigint(11) DEFAULT NULL COMMENT 'Пользователь',
  `entity` varchar(50) DEFAULT NULL COMMENT 'Тип прочитанного объекта',
  `entity_id` int(11) DEFAULT NULL COMMENT 'ID прочитанного объекта',
  `last_id` int(11) DEFAULT NULL COMMENT 'ID последнего прочитанного объекта'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_receipt`
--

CREATE TABLE `gr_receipt` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `sign` varchar(255) DEFAULT NULL COMMENT 'Подпись чека',
  `uniq_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор транзакции от провайдера',
  `type` enum('sell','sell_refund','sell_correction') NOT NULL COMMENT 'Тип чека',
  `provider` varchar(50) DEFAULT NULL COMMENT 'Провайдер',
  `url` varchar(255) DEFAULT NULL COMMENT 'Ссылка на чек покупателю',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата транзакции',
  `transaction_id` int(11) DEFAULT NULL COMMENT 'ID связанной транзакции',
  `total` decimal(20,2) DEFAULT NULL COMMENT 'Сумма в чеке',
  `status` enum('success','fail','wait') NOT NULL COMMENT 'Статус чека',
  `error` mediumtext COMMENT 'Ошибка',
  `extra` mediumtext COMMENT 'Дополнительное поле для данных'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_search_index`
--

CREATE TABLE `gr_search_index` (
  `result_class` varchar(100) NOT NULL COMMENT 'Класс результата',
  `entity_id` int(11) NOT NULL COMMENT 'id сущности',
  `title` varchar(255) DEFAULT NULL COMMENT 'Заголовок результата',
  `indextext` mediumtext COMMENT 'Описание сущности (индексируемый)',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата добавления в индекс'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_search_index`
--

INSERT INTO `gr_search_index` (`result_class`, `entity_id`, `title`, `indextext`, `dateof`) VALUES
('Catalog\\Model\\Orm\\Product', 1, 'test2', '', '2020-10-18 14:30:18'),
('Gallerist\\Model\\Orm\\Picture', 6, 'csdfdsf', '', '2020-10-20 15:18:55'),
('Gallerist\\Model\\Orm\\Picture', 7, 'xcvxcvzxvxcv', '', '2020-10-20 15:21:33'),
('Gallerist\\Model\\Orm\\Picture', 8, 'fsbfdvbfdfdsbfdb', '', '2020-10-20 15:24:27');

-- --------------------------------------------------------

--
-- Структура таблицы `gr_sections`
--

CREATE TABLE `gr_sections` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `page_id` varchar(255) DEFAULT NULL COMMENT 'Страница',
  `parent_id` int(11) DEFAULT NULL COMMENT 'Родительская секция',
  `alias` varchar(255) DEFAULT NULL COMMENT 'Название секции для автоматической вставки модулей',
  `width_xs` int(5) DEFAULT NULL COMMENT 'Ширина (XS)',
  `width_sm` int(5) DEFAULT NULL COMMENT 'Ширина (SM)',
  `width` int(5) DEFAULT NULL COMMENT 'Ширина',
  `width_lg` int(5) DEFAULT NULL COMMENT 'Ширина',
  `width_xl` int(5) DEFAULT NULL COMMENT 'Ширина',
  `inset_align_xs` varchar(255) DEFAULT NULL COMMENT 'Горизонтальное выравнивание',
  `inset_align_sm` varchar(255) DEFAULT NULL COMMENT 'Горизонтальное выравнивание',
  `inset_align` varchar(255) DEFAULT NULL COMMENT 'Горизонтальное выравнивание',
  `inset_align_lg` varchar(255) DEFAULT NULL COMMENT 'Горизонтальное выравнивание',
  `inset_align_xl` varchar(255) DEFAULT NULL COMMENT 'Горизонтальное выравнивание',
  `align_items_xs` varchar(255) DEFAULT NULL COMMENT 'Вертикальное выравнивание',
  `align_items_sm` varchar(255) DEFAULT NULL COMMENT 'Вертикальное выравнивание',
  `align_items` varchar(255) DEFAULT NULL COMMENT 'Вертикальное выравнивание',
  `align_items_lg` varchar(255) DEFAULT NULL COMMENT 'Вертикальное выравнивание',
  `align_items_xl` varchar(255) DEFAULT NULL COMMENT 'Вертикальное выравнивание',
  `prefix_xs` int(11) DEFAULT NULL COMMENT 'Отступ слева (XS)',
  `prefix_sm` int(11) DEFAULT NULL COMMENT 'Отступ слева (SM)',
  `prefix` int(11) DEFAULT NULL COMMENT 'Отступ слева (prefix)',
  `prefix_lg` int(11) DEFAULT NULL COMMENT 'Остступ слева (offset)',
  `prefix_xl` int(11) DEFAULT NULL COMMENT 'Остступ слева (offset)',
  `suffix` int(11) DEFAULT NULL COMMENT 'Отступ справа (suffix)',
  `pull_xs` int(11) DEFAULT NULL COMMENT 'Сдвиг влево (xs)',
  `pull_sm` int(11) DEFAULT NULL COMMENT 'Сдвиг влево (sm)',
  `pull` int(11) DEFAULT NULL COMMENT 'Сдвиг влево (pull)',
  `pull_lg` int(11) DEFAULT NULL COMMENT 'Сдвиг влево (pull)',
  `pull_xl` int(11) DEFAULT NULL COMMENT 'Сдвиг влево (pull)',
  `push_xs` int(11) DEFAULT NULL COMMENT 'Сдвиг вправо (xs)',
  `push_sm` int(11) DEFAULT NULL COMMENT 'Сдвиг вправо (sm)',
  `push` int(11) DEFAULT NULL COMMENT 'Сдвиг вправо (push)',
  `push_lg` int(11) DEFAULT NULL COMMENT 'Сдвиг вправо (push)',
  `push_xl` int(11) DEFAULT NULL COMMENT 'Сдвиг вправо (push)',
  `order_xs` int(5) DEFAULT NULL COMMENT 'Порядок',
  `order_sm` int(5) DEFAULT NULL COMMENT 'Порядок',
  `order` int(5) DEFAULT NULL COMMENT 'Порядок',
  `order_lg` int(5) DEFAULT NULL COMMENT 'Порядок',
  `order_xl` int(5) DEFAULT NULL COMMENT 'Порядок',
  `css_class` varchar(255) DEFAULT NULL COMMENT 'Пользовательский CSS класс',
  `is_clearfix_after` int(1) DEFAULT NULL COMMENT 'Очистка после элемента(clearfix)',
  `clearfix_after_css` varchar(150) DEFAULT NULL COMMENT 'Пользовательский CSS класс для clearfix',
  `inset_template` varchar(255) DEFAULT NULL COMMENT 'Внутренний шаблон',
  `outside_template` varchar(255) DEFAULT NULL COMMENT 'Внешний шаблон',
  `element_type` enum('col','row') NOT NULL COMMENT 'Тип элемента',
  `sortn` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_section_containers`
--

CREATE TABLE `gr_section_containers` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `page_id` int(11) DEFAULT NULL,
  `columns` int(11) DEFAULT NULL COMMENT 'Ширина',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `css_class` varchar(255) DEFAULT NULL COMMENT 'CSS класс',
  `is_fluid` int(1) NOT NULL COMMENT 'Ширина 100%',
  `wrap_element` varchar(255) DEFAULT NULL COMMENT 'Внешний элемент',
  `wrap_css_class` varchar(255) DEFAULT NULL COMMENT 'CSS-класс оборачивающего блока',
  `outside_template` varchar(255) DEFAULT NULL COMMENT 'Внешний шаблон',
  `inside_template` varchar(255) DEFAULT NULL COMMENT 'Внутренний шаблон',
  `type` int(5) DEFAULT NULL COMMENT 'Порядковый номер контейнера на странице'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_section_context`
--

CREATE TABLE `gr_section_context` (
  `site_id` int(11) NOT NULL COMMENT 'ID сайта',
  `context` varchar(50) NOT NULL COMMENT 'Контекст темы оформления',
  `grid_system` enum('none','gs960','bootstrap','bootstrap4') NOT NULL COMMENT 'Тип сеточного фреймворка',
  `options` mediumtext COMMENT 'Настройки темы в сериализованном виде'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_section_context`
--

INSERT INTO `gr_section_context` (`site_id`, `context`, `grid_system`, `options`) VALUES
(1, 'theme', 'gs960', 'a:11:{s:21:\"enable_one_click_cart\";s:1:\"1\";s:15:\"enable_favorite\";s:1:\"1\";s:14:\"enable_compare\";s:1:\"1\";s:22:\"cat_description_bottom\";s:1:\"0\";s:15:\"enable_comments\";s:1:\"1\";s:29:\"enable_amount_in_product_card\";s:1:\"0\";s:13:\"phone_number1\";s:15:\"8-800-000-00-00\";s:18:\"phone_description1\";s:31:\"Интернет-магазин\";s:13:\"phone_number2\";s:15:\"8-800-000-00-01\";s:18:\"phone_description2\";s:26:\"Тех. поддержка\";s:16:\"enable_page_fade\";s:1:\"0\";}');

-- --------------------------------------------------------

--
-- Структура таблицы `gr_section_modules`
--

CREATE TABLE `gr_section_modules` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `page_id` int(11) DEFAULT NULL COMMENT 'Страница',
  `section_id` int(11) DEFAULT NULL COMMENT 'ID секции',
  `template_block_id` bigint(11) DEFAULT NULL COMMENT 'id блока в теме без сетки',
  `context` varchar(50) DEFAULT NULL COMMENT 'Дополнительный идентификатор темы',
  `module_controller` varchar(150) DEFAULT NULL COMMENT 'Модуль',
  `public` int(1) DEFAULT '1' COMMENT 'Публичный',
  `sortn` int(11) DEFAULT NULL,
  `params` mediumtext COMMENT 'Параметры'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_section_page`
--

CREATE TABLE `gr_section_page` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `route_id` varchar(255) NOT NULL COMMENT 'Маршрут',
  `context` varchar(32) DEFAULT NULL COMMENT 'Дополнительный идентификатор темы',
  `template` varchar(255) DEFAULT NULL COMMENT 'Шаблон',
  `inherit` int(1) DEFAULT '1' COMMENT 'Наследовать шаблон по-умолчанию?'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_section_page`
--

INSERT INTO `gr_section_page` (`id`, `site_id`, `route_id`, `context`, `template`, `inherit`) VALUES
(20, 1, 'shop-front-checkout', 'theme', '%THEME%/wrapper_checkout.tpl', 1),
(19, 1, 'shop-front-cartpage', 'theme', '%THEME%/wrapper_cart.tpl', 1),
(18, 1, 'main.index', 'theme', '%THEME%/index.tpl', 1),
(17, 1, 'default', 'theme', '%THEME%/default.tpl', 1),
(16, 1, 'catalog-front-listproducts', 'theme', '%THEME%/wrapper_catalog.tpl', 1),
(15, 1, 'catalog-front-compare', 'theme', '%THEME%/fullscreen.tpl', 1),
(14, 1, 'article-front-view', 'theme', '%THEME%/wrapper_article.tpl', 1),
(21, 1, 'shop-front-mybalance', 'theme', '%THEME%/wrapper_profile.tpl', 1),
(22, 1, 'shop-front-myorders', 'theme', '%THEME%/wrapper_profile.tpl', 1),
(23, 1, 'shop-front-myorderview', 'theme', '%THEME%/wrapper_profile.tpl', 1),
(24, 1, 'shop-front-myproductsreturn', 'theme', '%THEME%/wrapper_profile.tpl', 1),
(25, 1, 'support-front-support', 'theme', '%THEME%/wrapper_profile.tpl', 1),
(26, 1, 'users-front-profile', 'theme', '%THEME%/wrapper_profile.tpl', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_sites`
--

CREATE TABLE `gr_sites` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `title` varchar(255) DEFAULT NULL COMMENT 'Краткое название сайта',
  `full_title` varchar(255) DEFAULT NULL COMMENT 'Полное название сайта',
  `domains` mediumtext COMMENT 'Доменные имена (через запятую)',
  `folder` varchar(255) DEFAULT NULL COMMENT 'Папка сайта',
  `language` varchar(255) DEFAULT NULL COMMENT 'Язык',
  `default` int(11) DEFAULT NULL COMMENT 'По умолчанию',
  `redirect_to_main_domain` int(11) NOT NULL COMMENT 'Перенаправлять на основной домен',
  `redirect_to_https` int(11) NOT NULL COMMENT 'Перенаправлять на https',
  `sortn` int(11) DEFAULT NULL COMMENT 'Сортировка',
  `is_closed` int(11) DEFAULT NULL COMMENT 'Закрыть доступ к сайту',
  `close_message` varchar(255) DEFAULT NULL COMMENT 'Причина закрытия сайта',
  `rating` decimal(3,1) DEFAULT '0.0' COMMENT 'Средний балл(рейтинг)',
  `comments` int(11) DEFAULT '0' COMMENT 'Кол-во комментариев к сайту'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_sites`
--

INSERT INTO `gr_sites` (`id`, `title`, `full_title`, `domains`, `folder`, `language`, `default`, `redirect_to_main_domain`, `redirect_to_https`, `sortn`, `is_closed`, `close_message`, `rating`, `comments`) VALUES
(1, 'Сайт galerist.local', 'Сайт galerist.local', 'galerist.local', NULL, 'ru', 1, 0, 0, 1, NULL, NULL, '0.0', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_site_options`
--

CREATE TABLE `gr_site_options` (
  `site_id` int(11) NOT NULL COMMENT 'ID сайта',
  `admin_email` varchar(150) DEFAULT NULL COMMENT 'E-mail администратора(ов)',
  `admin_phone` varchar(150) DEFAULT NULL COMMENT 'Телефон администратора',
  `theme` varchar(150) DEFAULT NULL COMMENT 'Тема',
  `favicon` varchar(255) DEFAULT NULL COMMENT 'Иконка сайта 16x16 (PNG, ICO)',
  `logo` varchar(200) DEFAULT NULL COMMENT 'Логотип',
  `slogan` varchar(255) DEFAULT NULL COMMENT 'Лозунг',
  `firm_name` varchar(255) DEFAULT NULL COMMENT 'Наименование организации',
  `firm_inn` varchar(12) DEFAULT NULL COMMENT 'ИНН организации',
  `firm_kpp` varchar(12) DEFAULT NULL COMMENT 'КПП организации',
  `firm_bank` varchar(255) DEFAULT NULL COMMENT 'Наименование банка',
  `firm_bik` varchar(10) DEFAULT NULL COMMENT 'БИК',
  `firm_rs` varchar(20) DEFAULT NULL COMMENT 'Расчетный счет',
  `firm_ks` varchar(20) DEFAULT NULL COMMENT 'Корреспондентский счет',
  `firm_director` varchar(70) DEFAULT NULL COMMENT 'Фамилия, инициалы руководителя',
  `firm_accountant` varchar(70) DEFAULT NULL COMMENT 'Фамилия, инициалы главного бухгалтера',
  `firm_v_lice` varchar(255) DEFAULT NULL COMMENT 'Компания представлена в лице ...',
  `firm_deistvuet` varchar(255) DEFAULT NULL COMMENT 'действует на основании ...',
  `firm_address` varchar(255) DEFAULT NULL COMMENT 'Фактический адрес компании',
  `firm_legal_address` varchar(255) DEFAULT NULL COMMENT 'Юридический адрес компании',
  `firm_email` varchar(255) DEFAULT NULL COMMENT 'Официальный Email компании',
  `notice_from` varchar(255) DEFAULT NULL COMMENT 'Будет указано в письме в поле  ''От''',
  `notice_reply` varchar(255) DEFAULT NULL COMMENT 'Куда присылать ответные письма? (поле Reply)',
  `smtp_is_use` int(11) DEFAULT NULL COMMENT 'Использовать SMTP для отправки писем',
  `smtp_host` varchar(255) DEFAULT NULL COMMENT 'SMTP сервер',
  `smtp_port` varchar(10) DEFAULT NULL COMMENT 'SMTP порт',
  `smtp_secure` varchar(255) DEFAULT NULL COMMENT 'Тип шифрования',
  `smtp_auth` int(11) DEFAULT NULL COMMENT 'Требуется авторизация на SMTP сервере',
  `smtp_username` varchar(100) DEFAULT NULL COMMENT 'Имя пользователя SMTP',
  `smtp_password` varchar(100) DEFAULT NULL COMMENT 'Пароль SMTP',
  `dkim_is_use` int(11) DEFAULT NULL COMMENT 'Устанавливать DKIM подпись с помощью ReadyScript',
  `dkim_domain` varchar(255) DEFAULT NULL COMMENT 'DKIM домен',
  `dkim_private` varchar(255) DEFAULT NULL COMMENT 'Приватный ключ DKIM',
  `dkim_selector` varchar(255) DEFAULT NULL COMMENT 'Селектор DKIM записи в доменной зоне',
  `dkim_passphrase` varchar(255) DEFAULT NULL COMMENT 'Пароль для приватного ключа (если есть)',
  `facebook_group` varchar(255) DEFAULT NULL COMMENT 'Ссылка на группу в Facebook',
  `vkontakte_group` varchar(255) DEFAULT NULL COMMENT 'Ссылка на группу ВКонтакте',
  `twitter_group` varchar(255) DEFAULT NULL COMMENT 'Ссылка на страницу в Twitter',
  `instagram_group` varchar(255) DEFAULT NULL COMMENT 'Ссылка на страницу в Instagram',
  `youtube_group` varchar(255) DEFAULT NULL COMMENT 'Ссылка на страницу в YouTube',
  `viber_group` varchar(255) DEFAULT NULL COMMENT 'Ссылка на Viber',
  `telegram_group` varchar(255) DEFAULT NULL COMMENT 'Ссылка на Telegram',
  `whatsapp_group` varchar(255) DEFAULT NULL COMMENT 'Ссылка на WhatsApp',
  `policy_personal_data` mediumtext COMMENT 'Политика обработки персональных данных (ссылка /policy/)',
  `agreement_personal_data` mediumtext COMMENT 'Соглашение на обработку персональных данных (ссылка /policy-agreement/)',
  `enable_agreement_personal_data` int(11) DEFAULT NULL COMMENT 'Включить отображение соглашения на обработку персональных данных в формах',
  `firm_name_for_notice` varchar(255) DEFAULT NULL COMMENT 'Наименование организации в письмах'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_site_options`
--

INSERT INTO `gr_site_options` (`site_id`, `admin_email`, `admin_phone`, `theme`, `favicon`, `logo`, `slogan`, `firm_name`, `firm_inn`, `firm_kpp`, `firm_bank`, `firm_bik`, `firm_rs`, `firm_ks`, `firm_director`, `firm_accountant`, `firm_v_lice`, `firm_deistvuet`, `firm_address`, `firm_legal_address`, `firm_email`, `notice_from`, `notice_reply`, `smtp_is_use`, `smtp_host`, `smtp_port`, `smtp_secure`, `smtp_auth`, `smtp_username`, `smtp_password`, `dkim_is_use`, `dkim_domain`, `dkim_private`, `dkim_selector`, `dkim_passphrase`, `facebook_group`, `vkontakte_group`, `twitter_group`, `instagram_group`, `youtube_group`, `viber_group`, `telegram_group`, `whatsapp_group`, `policy_personal_data`, `agreement_personal_data`, `enable_agreement_personal_data`, `firm_name_for_notice`) VALUES
(1, NULL, NULL, 'gallerist', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_statistic_events`
--

CREATE TABLE `gr_statistic_events` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `dateof` date DEFAULT NULL COMMENT 'Дата события',
  `type` varchar(255) DEFAULT NULL COMMENT 'Тип события',
  `details` mediumtext COMMENT 'Детали события',
  `count` int(11) NOT NULL DEFAULT '1' COMMENT 'Количество событий за данный день'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_statistic_source`
--

CREATE TABLE `gr_statistic_source` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `partner_id` int(11) DEFAULT NULL COMMENT 'Партнёрский сайт',
  `source_type` int(11) DEFAULT NULL COMMENT 'Идентификатор типа источника на сайте',
  `referer_site` varchar(255) DEFAULT NULL COMMENT 'Сайт источник из поля реферер',
  `referer_source` mediumtext COMMENT 'Полный источник из поля реферер',
  `landing_page` varchar(255) DEFAULT NULL COMMENT 'Страница первого посещения',
  `utm_source` varchar(255) DEFAULT NULL COMMENT 'Рекламная система UTM_SOURCE',
  `utm_medium` varchar(255) DEFAULT NULL COMMENT 'Тип трафика UTM_MEDIUM',
  `utm_campaign` varchar(255) DEFAULT NULL COMMENT 'Рекламная кампания UTM_COMPAING',
  `utm_term` varchar(255) DEFAULT NULL COMMENT 'Ключевое слово UTM_TERM',
  `utm_content` varchar(255) DEFAULT NULL COMMENT 'Различия UTM_CONTENT',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата события'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_statistic_user_source_type`
--

CREATE TABLE `gr_statistic_user_source_type` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `parent_id` int(11) DEFAULT NULL COMMENT 'Категория',
  `referer_site` varchar(255) DEFAULT NULL COMMENT 'Домен источника перехода',
  `referer_request_uri_regular` int(1) DEFAULT '0' COMMENT 'Использовать регулярное выражения для части адреса источника',
  `referer_request_uri` varchar(255) DEFAULT NULL COMMENT 'Часть адреса источника до знака ?',
  `params` mediumtext COMMENT 'Массив параметров адреса источника после знака ? в сериализованном виде',
  `sortn` int(11) DEFAULT '10' COMMENT 'Приоритет'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_statistic_user_source_type_dir`
--

CREATE TABLE `gr_statistic_user_source_type_dir` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название источника'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_subscribe_email`
--

CREATE TABLE `gr_subscribe_email` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `email` varchar(250) DEFAULT NULL COMMENT 'E-mail',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата подписки',
  `confirm` int(1) DEFAULT '0' COMMENT 'Подтверждён?',
  `signature` varchar(250) DEFAULT NULL COMMENT 'Подпись для E-mail'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_support`
--

CREATE TABLE `gr_support` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `topic` varchar(255) DEFAULT NULL COMMENT 'Тема',
  `user_id` int(11) DEFAULT NULL COMMENT 'Пользователь',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата отправки',
  `message` mediumtext COMMENT 'Сообщение',
  `processed` int(1) DEFAULT NULL COMMENT 'Флаг прочтения',
  `is_admin` int(1) DEFAULT NULL COMMENT 'Это администратор',
  `topic_id` int(11) DEFAULT NULL COMMENT 'ID темы'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_support_topic`
--

CREATE TABLE `gr_support_topic` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Тема',
  `user_id` bigint(11) DEFAULT NULL COMMENT 'Пользователь',
  `updated` datetime DEFAULT NULL COMMENT 'Дата обновления',
  `msgcount` int(11) DEFAULT NULL COMMENT 'Всего сообщений',
  `newcount` int(11) DEFAULT NULL COMMENT 'Новых сообщений',
  `newadmcount` int(11) DEFAULT NULL COMMENT 'Новых для администратора'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_tags_links`
--

CREATE TABLE `gr_tags_links` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `word_id` bigint(11) DEFAULT NULL COMMENT 'ID тега',
  `type` varchar(20) DEFAULT NULL COMMENT 'Тип связи',
  `link_id` int(11) DEFAULT NULL COMMENT 'ID объекта, с которым связан тег'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_tags_words`
--

CREATE TABLE `gr_tags_words` (
  `id` bigint(11) NOT NULL,
  `stemmed` varchar(255) DEFAULT NULL COMMENT 'Тег без окончания',
  `word` varchar(255) DEFAULT NULL COMMENT 'Тег',
  `alias` varchar(255) DEFAULT NULL COMMENT 'Английское название тега'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_testmodule_gallerist`
--

CREATE TABLE `gr_testmodule_gallerist` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_tpl_hook_sort`
--

CREATE TABLE `gr_tpl_hook_sort` (
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `context` varchar(100) DEFAULT NULL COMMENT 'Контекст темы оформления',
  `hook_name` varchar(100) DEFAULT NULL COMMENT 'Идентификатор хука',
  `module` varchar(50) DEFAULT NULL COMMENT 'Идентификатор модуля',
  `sortn` varchar(255) DEFAULT NULL COMMENT 'Порядковый номер'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_transaction`
--

CREATE TABLE `gr_transaction` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата транзакции',
  `user_id` bigint(11) DEFAULT NULL COMMENT 'Пользователь',
  `order_id` int(11) DEFAULT NULL COMMENT 'ID заказа',
  `personal_account` int(1) DEFAULT NULL COMMENT 'Транзакция изменяющая баланс лицевого счета',
  `cost` decimal(15,2) DEFAULT NULL COMMENT 'Сумма',
  `comission` decimal(15,2) DEFAULT NULL COMMENT 'Сумма комиссии платежной системы',
  `payment` int(11) DEFAULT NULL COMMENT 'Тип оплаты',
  `reason` mediumtext COMMENT 'Назначение платежа',
  `error` varchar(255) DEFAULT NULL COMMENT 'Ошибка',
  `status` enum('new','hold','success','fail') NOT NULL COMMENT 'Статус транзакции',
  `receipt` enum('no_receipt','receipt_in_progress','receipt_success','refund_success','fail') NOT NULL DEFAULT 'no_receipt' COMMENT 'Последний статус получения чека',
  `refunded` int(1) DEFAULT '0' COMMENT 'Дополнительное поле для данных',
  `sign` varchar(255) DEFAULT NULL COMMENT 'Подпись транзакции',
  `entity` varchar(50) DEFAULT NULL COMMENT 'Сущность к которой привязана транзакция',
  `entity_id` varchar(50) DEFAULT NULL COMMENT 'ID сущности, к которой привязана транзакция',
  `extra` varchar(4096) DEFAULT NULL COMMENT 'Дополнительное поле для данных',
  `cashregister_last_operation_uuid` varchar(255) DEFAULT NULL COMMENT 'Последний уникальный идентификатор полученный в ответ от кассы',
  `partner_id` int(11) DEFAULT '0' COMMENT 'Партнёрский сайт'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_transaction_changelog`
--

CREATE TABLE `gr_transaction_changelog` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `transaction_id` int(11) DEFAULT NULL COMMENT 'id транзакции',
  `date` datetime DEFAULT NULL COMMENT 'Дата изменения',
  `change` varchar(255) DEFAULT NULL COMMENT 'Изменение',
  `entity_type` varchar(255) DEFAULT NULL COMMENT 'Тип связанной сущности',
  `entity_id` int(11) DEFAULT NULL COMMENT 'id связанной сущности'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_try_auth`
--

CREATE TABLE `gr_try_auth` (
  `ip` varchar(255) NOT NULL COMMENT 'IP-адрес',
  `total` int(11) DEFAULT NULL COMMENT 'Количество попыток авторизации',
  `last_try_dateof` datetime DEFAULT NULL COMMENT 'Дата последней попытки авторизации',
  `try_login` varchar(255) DEFAULT NULL COMMENT 'Логин, последней попытки авторизации'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_users`
--

CREATE TABLE `gr_users` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `name` varchar(100) DEFAULT NULL COMMENT 'Имя',
  `surname` varchar(100) DEFAULT NULL COMMENT 'Фамилия',
  `midname` varchar(100) DEFAULT NULL COMMENT 'Отчество',
  `e_mail` varchar(150) DEFAULT NULL COMMENT 'E-mail',
  `login` varchar(64) DEFAULT NULL COMMENT 'Логин',
  `pass` varchar(32) DEFAULT NULL COMMENT 'Пароль',
  `phone` varchar(50) DEFAULT NULL COMMENT 'Телефон',
  `sex` varchar(1) DEFAULT NULL COMMENT 'Пол',
  `hash` varchar(64) DEFAULT NULL COMMENT 'Ключ',
  `subscribe_on` int(1) DEFAULT NULL COMMENT 'Получать рассылку',
  `dateofreg` datetime DEFAULT NULL COMMENT 'Дата регистрации',
  `balance` decimal(15,2) NOT NULL COMMENT 'Баланс',
  `balance_sign` varchar(255) DEFAULT NULL COMMENT 'Подпись баланса',
  `ban_expire` datetime DEFAULT NULL COMMENT 'Заблокировать до ...',
  `ban_reason` varchar(255) DEFAULT NULL COMMENT 'Причина блокировки',
  `last_visit` datetime DEFAULT NULL COMMENT 'Последний визит',
  `last_ip` varchar(100) DEFAULT NULL COMMENT 'Последний IP, который использовался',
  `registration_ip` varchar(100) DEFAULT NULL COMMENT 'IP пользователя при регистрации',
  `is_enable_two_factor` int(11) NOT NULL COMMENT 'Включить двухфакторную авторизацию для данного пользователя',
  `is_company` int(1) DEFAULT NULL COMMENT 'Это юридическое лицо?',
  `company` varchar(255) DEFAULT NULL COMMENT 'Название организации',
  `company_inn` varchar(12) DEFAULT NULL COMMENT 'ИНН организации',
  `_serialized` mediumtext,
  `cost_id` varchar(1000) DEFAULT NULL COMMENT 'Персональная цена (сериализованная)',
  `manager_user_id` int(11) NOT NULL COMMENT 'Менеджер пользователя',
  `source_id` int(11) DEFAULT '0' COMMENT 'Источник перехода',
  `date_arrive` datetime DEFAULT NULL COMMENT 'Дата первого посещения',
  `is_artist` int(1) DEFAULT NULL COMMENT 'Художник или покупатель',
  `city` varchar(255) DEFAULT NULL COMMENT 'Город',
  `photo` varchar(255) DEFAULT NULL COMMENT 'Фото'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_users`
--

INSERT INTO `gr_users` (`id`, `name`, `surname`, `midname`, `e_mail`, `login`, `pass`, `phone`, `sex`, `hash`, `subscribe_on`, `dateofreg`, `balance`, `balance_sign`, `ban_expire`, `ban_reason`, `last_visit`, `last_ip`, `registration_ip`, `is_enable_two_factor`, `is_company`, `company`, `company_inn`, `_serialized`, `cost_id`, `manager_user_id`, `source_id`, `date_arrive`, `is_artist`, `city`, `photo`) VALUES
(1, 'Супервизор', ' ', ' ', '92279@inbox.ru', '92279@inbox.ru', '98a6311fb314ceec13a9c0350f45ca05', NULL, '', '6c04fd44db407fd784525b582ff7f37970e0661cf5ce19c037c2b8e36b4c3962', 0, '2020-09-23 13:18:54', '0.00', NULL, NULL, '', '2020-10-21 10:31:01', '127.0.0.1', '127.0.0.1', 0, 0, '', '', 'a:0:{}', 'a:1:{i:1;s:1:\"0\";}', 0, 0, NULL, 0, '', ''),
(2, 'Жудожник', 'От слова худо', '', '111@site.ru', '111@site.ru', '98a6311fb314ceec13a9c0350f45ca05', '+79000000000', '', '11289bbd77b0a3d932bc3e0626322a53f669437270ea2429458679deb778c29c', 0, '2020-10-14 14:21:24', '0.00', NULL, NULL, '', NULL, '', '127.0.0.1', 0, 0, '', '', 'a:0:{}', 'a:1:{i:1;s:1:\"0\";}', 0, 0, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_users_group`
--

CREATE TABLE `gr_users_group` (
  `alias` varchar(50) NOT NULL COMMENT 'Псевдоним(англ.яз)',
  `name` varchar(100) DEFAULT NULL COMMENT 'Название группы',
  `description` mediumtext COMMENT 'Описание',
  `is_admin` int(1) DEFAULT NULL COMMENT 'Администратор',
  `sortn` int(11) DEFAULT NULL COMMENT 'Сортировочный индекс',
  `cost_id` varchar(1000) DEFAULT NULL COMMENT 'Персональная цена (сериализованная)'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_users_group`
--

INSERT INTO `gr_users_group` (`alias`, `name`, `description`, `is_admin`, `sortn`, `cost_id`) VALUES
('supervisor', 'Супервизоры', 'Пользователь имеющий доступ абсолютно всегда ко всем  модулям и сайтам', 1, 1, NULL),
('admins', 'Администраторы', 'Пользователи, имеющие права на удаление, добавление, изменение контента', 1, 2, NULL),
('clients', 'Клиенты', 'Авторизованные пользователи', 0, 3, NULL),
('guest', 'Гости', 'Неавторизованные пользователи', 0, 4, NULL),
('artist', 'Художники', 'Для художников. С возможностью добавления картин', 1, 5, 'a:1:{i:1;s:1:\"0\";}');

-- --------------------------------------------------------

--
-- Структура таблицы `gr_users_in_group`
--

CREATE TABLE `gr_users_in_group` (
  `user` int(11) NOT NULL COMMENT 'ID пользователя',
  `group` varchar(255) NOT NULL COMMENT 'ID группы пользователей'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_users_in_group`
--

INSERT INTO `gr_users_in_group` (`user`, `group`) VALUES
(1, 'supervisor'),
(2, 'artist');

-- --------------------------------------------------------

--
-- Структура таблицы `gr_users_log`
--

CREATE TABLE `gr_users_log` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `dateof` datetime DEFAULT NULL COMMENT 'Дата',
  `class` varchar(255) DEFAULT NULL COMMENT 'Класс события',
  `oid` int(11) DEFAULT NULL COMMENT 'ID объекта над которым произошло событие',
  `group` int(11) DEFAULT NULL COMMENT 'ID Группы (перезаписывается, если событие происходит в рамках одной группы)',
  `user_id` bigint(11) DEFAULT NULL COMMENT 'ID Пользователя',
  `_serialized` varchar(4000) DEFAULT NULL COMMENT 'Дополнительные данные (скрыто)'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_users_log`
--

INSERT INTO `gr_users_log` (`id`, `site_id`, `dateof`, `class`, `oid`, `group`, `user_id`, `_serialized`) VALUES
(1, 1, '2020-09-23 13:20:52', 'Users\\Model\\Logtype\\AdminAuth', 1, NULL, -2231964802, 'a:1:{s:2:\"ip\";s:9:\"127.0.0.1\";}'),
(2, 1, '2020-10-13 21:34:17', 'Users\\Model\\Logtype\\AdminAuth', 1, NULL, -2231964802, 'a:1:{s:2:\"ip\";s:9:\"127.0.0.1\";}'),
(3, 1, '2020-10-13 21:39:09', 'Users\\Model\\Logtype\\AdminAuth', 1, NULL, -2231964802, 'a:1:{s:2:\"ip\";s:9:\"127.0.0.1\";}'),
(4, 1, '2020-10-13 21:40:40', 'Users\\Model\\Logtype\\AdminAuth', 1, NULL, -2231964802, 'a:1:{s:2:\"ip\";s:9:\"127.0.0.1\";}'),
(5, 1, '2020-10-13 21:42:37', 'Users\\Model\\Logtype\\AdminAuth', 1, NULL, -2231964802, 'a:1:{s:2:\"ip\";s:9:\"127.0.0.1\";}'),
(6, 1, '2020-10-14 10:33:11', 'Users\\Model\\Logtype\\AdminAuth', 1, NULL, -2231964802, 'a:1:{s:2:\"ip\";s:9:\"127.0.0.1\";}'),
(7, 1, '2020-10-14 14:23:31', 'Users\\Model\\Logtype\\AdminAuth', 2, NULL, -2231964802, 'a:1:{s:2:\"ip\";s:9:\"127.0.0.1\";}'),
(8, 0, '2020-10-14 14:23:41', 'Users\\Model\\Logtype\\AdminAuth', 1, NULL, 2, 'a:1:{s:2:\"ip\";s:9:\"127.0.0.1\";}'),
(9, 1, '2020-10-14 14:24:14', 'Users\\Model\\Logtype\\AdminAuth', 2, NULL, -2231964802, 'a:1:{s:2:\"ip\";s:9:\"127.0.0.1\";}'),
(10, 1, '2020-10-14 14:25:26', 'Users\\Model\\Logtype\\AdminAuth', 1, NULL, -2231964802, 'a:1:{s:2:\"ip\";s:9:\"127.0.0.1\";}'),
(11, 1, '2020-10-19 19:02:55', 'Users\\Model\\Logtype\\AdminAuth', 1, NULL, -2231964802, 'a:1:{s:2:\"ip\";s:9:\"127.0.0.1\";}'),
(12, 1, '2020-10-20 14:18:22', 'Users\\Model\\Logtype\\AdminAuth', 1, NULL, -2231964802, 'a:1:{s:2:\"ip\";s:9:\"127.0.0.1\";}'),
(13, 1, '2020-10-20 14:47:42', 'Users\\Model\\Logtype\\AdminAuth', 1, NULL, 1, 'a:1:{s:2:\"ip\";s:9:\"127.0.0.1\";}');

-- --------------------------------------------------------

--
-- Структура таблицы `gr_users_verification_session`
--

CREATE TABLE `gr_users_verification_session` (
  `uniq` varchar(255) NOT NULL COMMENT 'Уникальный ключ сессии верификации',
  `ip` varchar(50) DEFAULT NULL COMMENT 'IP-адрес пользователя',
  `user_session_id` varchar(255) DEFAULT NULL COMMENT 'ID сессии пользователя',
  `creator_user_id` bigint(11) DEFAULT NULL COMMENT 'Пользователь, создатель сессии',
  `verification_provider` varchar(255) DEFAULT NULL COMMENT 'Идентификатор провайдера доставки кода',
  `phone` varchar(255) DEFAULT NULL COMMENT 'Номер телефона для отправки кода',
  `code_hash` varchar(255) DEFAULT NULL COMMENT 'Хэш от кода верификации',
  `code_debug` varchar(255) DEFAULT NULL COMMENT 'Код врификации в открытом виде (для режима отладки)',
  `code_expire` int(11) DEFAULT NULL COMMENT 'Время истечения действия кода',
  `send_counter` int(11) NOT NULL COMMENT 'Счетчик отправки кодов',
  `send_last_time` int(11) DEFAULT NULL COMMENT 'Последняя дата отправки кода',
  `try_counter` int(11) NOT NULL COMMENT 'Счетчик ввода кодов',
  `try_last_time` int(11) DEFAULT NULL COMMENT 'Последняя дата попытки ввода кода',
  `action` varchar(100) DEFAULT NULL COMMENT 'Идентификатор класса действия',
  `action_data` mediumtext COMMENT 'Данные для действия',
  `last_initialized` int(11) DEFAULT NULL COMMENT 'Последняя дата инициализации сессии',
  `is_resolved` int(1) DEFAULT NULL COMMENT 'Код был введен успешно',
  `resolved_time` int(11) DEFAULT NULL COMMENT 'Время успешного ввода кода'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_warehouse`
--

CREATE TABLE `gr_warehouse` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `title` varchar(255) DEFAULT NULL COMMENT 'Короткое название',
  `alias` varchar(150) DEFAULT NULL COMMENT 'URL имя',
  `group_id` int(11) NOT NULL DEFAULT '0' COMMENT 'Группа',
  `image` varchar(255) DEFAULT NULL COMMENT 'Картинка',
  `description` mediumtext COMMENT 'Описание',
  `adress` varchar(255) DEFAULT NULL COMMENT 'Адрес',
  `phone` varchar(255) DEFAULT NULL COMMENT 'Телефон',
  `work_time` varchar(255) DEFAULT NULL COMMENT 'Время работы',
  `coor_x` float DEFAULT '55.7533' COMMENT 'Координата X магазина',
  `coor_y` float DEFAULT '37.6226' COMMENT 'Координата Y магазина',
  `default_house` int(1) DEFAULT NULL COMMENT 'Склад по умолчанию',
  `public` int(1) DEFAULT NULL COMMENT 'Показывать склад в карточке товара',
  `checkout_public` int(1) DEFAULT NULL COMMENT 'Показывать склад как пункт самовывоза',
  `dont_change_stocks` int(11) DEFAULT NULL COMMENT 'Не списывать остатки с данного склада',
  `use_in_sitemap` int(11) DEFAULT '0' COMMENT 'Добавлять в sitemap',
  `xml_id` varchar(255) DEFAULT NULL COMMENT 'Идентификатор в системе 1C',
  `sortn` int(11) DEFAULT NULL COMMENT 'Индекс сортировки',
  `meta_title` varchar(1000) DEFAULT NULL COMMENT 'Заголовок',
  `meta_keywords` varchar(1000) DEFAULT NULL COMMENT 'Ключевые слова',
  `meta_description` varchar(1000) DEFAULT NULL COMMENT 'Описание',
  `affiliate_id` int(11) NOT NULL DEFAULT '0' COMMENT 'Филиал',
  `yandex_market_point_id` varchar(255) DEFAULT NULL COMMENT 'ID точки продаж в Яндекс.Маркет'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `gr_warehouse`
--

INSERT INTO `gr_warehouse` (`id`, `site_id`, `title`, `alias`, `group_id`, `image`, `description`, `adress`, `phone`, `work_time`, `coor_x`, `coor_y`, `default_house`, `public`, `checkout_public`, `dont_change_stocks`, `use_in_sitemap`, `xml_id`, `sortn`, `meta_title`, `meta_keywords`, `meta_description`, `affiliate_id`, `yandex_market_point_id`) VALUES
(1, 1, 'Основной склад', 'sklad', 0, NULL, '<p>Наш склад находится в центре города. Предусмотрена удобная парковка для автомобилей и велосипедов. </p>', 'г. Краснодар, улица Красных Партизан, 246', '+7(123)456-78-90', 'с 9:00 до 18:00', 45.0483, 38.9745, 1, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `gr_warehouse_group`
--

CREATE TABLE `gr_warehouse_group` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `alias` varchar(50) DEFAULT NULL COMMENT 'Идентификатор (англ.яз)',
  `title` varchar(255) DEFAULT NULL COMMENT 'Название',
  `short_description` varchar(255) DEFAULT NULL COMMENT 'Короткое описание',
  `sortn` int(11) DEFAULT NULL COMMENT 'Индекс сортировки'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `gr_widgets`
--

CREATE TABLE `gr_widgets` (
  `id` int(11) NOT NULL COMMENT 'Уникальный идентификатор (ID)',
  `site_id` int(11) DEFAULT NULL COMMENT 'ID сайта',
  `user_id` int(11) DEFAULT NULL,
  `mode2_column` int(5) DEFAULT NULL COMMENT 'Колонка виджета в двухколоночной сетке',
  `mode3_column` int(5) DEFAULT NULL COMMENT 'Колонка виджета в трехколоночной сетке',
  `mode1_position` int(5) DEFAULT NULL COMMENT 'Позиция виджета в одноколоночной сетке',
  `mode2_position` int(5) DEFAULT NULL COMMENT 'Позиция виджета в двухколоночной сетке',
  `mode3_position` int(5) DEFAULT NULL COMMENT 'Позиция виджета в трехколоночной сетке',
  `class` varchar(255) DEFAULT NULL,
  `vars` mediumtext
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `gr_access_menu`
--
ALTER TABLE `gr_access_menu`
  ADD KEY `site_id_menu_type` (`site_id`,`menu_type`);

--
-- Индексы таблицы `gr_access_module`
--
ALTER TABLE `gr_access_module`
  ADD UNIQUE KEY `site_id_module_user_id_group_alias` (`site_id`,`module`,`user_id`,`group_alias`);

--
-- Индексы таблицы `gr_access_module_right`
--
ALTER TABLE `gr_access_module_right`
  ADD UNIQUE KEY `site_id_group_alias_module_right` (`site_id`,`group_alias`,`module`,`right`);

--
-- Индексы таблицы `gr_access_site`
--
ALTER TABLE `gr_access_site`
  ADD UNIQUE KEY `site_id_group_alias` (`site_id`,`group_alias`),
  ADD UNIQUE KEY `site_id_user_id` (`site_id`,`user_id`);

--
-- Индексы таблицы `gr_affiliate`
--
ALTER TABLE `gr_affiliate`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_alias` (`site_id`,`alias`),
  ADD KEY `title` (`title`);

--
-- Индексы таблицы `gr_antivirus_events`
--
ALTER TABLE `gr_antivirus_events`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_antivirus_excluded_files`
--
ALTER TABLE `gr_antivirus_excluded_files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `file` (`file`(333));

--
-- Индексы таблицы `gr_antivirus_request_count`
--
ALTER TABLE `gr_antivirus_request_count`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ip` (`ip`);

--
-- Индексы таблицы `gr_article`
--
ALTER TABLE `gr_article`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_parent_alias` (`site_id`,`parent`,`alias`),
  ADD KEY `site_id_parent` (`site_id`,`parent`),
  ADD KEY `alias` (`alias`),
  ADD KEY `parent` (`parent`),
  ADD KEY `dateof` (`dateof`);

--
-- Индексы таблицы `gr_article_category`
--
ALTER TABLE `gr_article_category`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `parent_site_id_alias` (`parent`,`site_id`,`alias`);

--
-- Индексы таблицы `gr_banner`
--
ALTER TABLE `gr_banner`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_banner_x_zone`
--
ALTER TABLE `gr_banner_x_zone`
  ADD UNIQUE KEY `zone_id_banner_id` (`zone_id`,`banner_id`);

--
-- Индексы таблицы `gr_banner_zone`
--
ALTER TABLE `gr_banner_zone`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_blocked_ip`
--
ALTER TABLE `gr_blocked_ip`
  ADD PRIMARY KEY (`ip`);

--
-- Индексы таблицы `gr_brand`
--
ALTER TABLE `gr_brand`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_alias` (`site_id`,`alias`),
  ADD KEY `public` (`public`),
  ADD KEY `sortn` (`sortn`);

--
-- Индексы таблицы `gr_cart`
--
ALTER TABLE `gr_cart`
  ADD PRIMARY KEY (`site_id`,`session_id`,`uniq`);

--
-- Индексы таблицы `gr_comments`
--
ALTER TABLE `gr_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `type` (`type`);

--
-- Индексы таблицы `gr_comments_votes`
--
ALTER TABLE `gr_comments_votes`
  ADD UNIQUE KEY `ip_comment_id` (`ip`,`comment_id`);

--
-- Индексы таблицы `gr_connect_form`
--
ALTER TABLE `gr_connect_form`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_connect_form_field`
--
ALTER TABLE `gr_connect_form_field`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_connect_form_result`
--
ALTER TABLE `gr_connect_form_result`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_crm_autotaskrule`
--
ALTER TABLE `gr_crm_autotaskrule`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_crm_custom_data`
--
ALTER TABLE `gr_crm_custom_data`
  ADD PRIMARY KEY (`object_type_alias`,`object_id`,`field`),
  ADD KEY `object_type_alias_object_id_value_float` (`object_type_alias`,`object_id`,`value_float`),
  ADD KEY `object_type_alias_object_id_value_string` (`object_type_alias`,`object_id`,`value_string`);

--
-- Индексы таблицы `gr_crm_deal`
--
ALTER TABLE `gr_crm_deal`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `deal_num` (`deal_num`);

--
-- Индексы таблицы `gr_crm_interaction`
--
ALTER TABLE `gr_crm_interaction`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_crm_link`
--
ALTER TABLE `gr_crm_link`
  ADD UNIQUE KEY `source_type_source_id_link_type_link_id` (`source_type`,`source_id`,`link_type`,`link_id`);

--
-- Индексы таблицы `gr_crm_statuses`
--
ALTER TABLE `gr_crm_statuses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `object_type_alias_alias` (`object_type_alias`,`alias`),
  ADD KEY `object_type_alias` (`object_type_alias`);

--
-- Индексы таблицы `gr_crm_task`
--
ALTER TABLE `gr_crm_task`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `task_num` (`task_num`),
  ADD KEY `expiration_notice_is_send_date_of_planned_end_status_id` (`expiration_notice_is_send`,`date_of_planned_end`,`status_id`);

--
-- Индексы таблицы `gr_crm_task_filter`
--
ALTER TABLE `gr_crm_task_filter`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_crm_tel_call_history`
--
ALTER TABLE `gr_crm_tel_call_history`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `call_id` (`call_id`),
  ADD KEY `caller_number` (`caller_number`),
  ADD KEY `called_number` (`called_number`),
  ADD KEY `record_id` (`record_id`);

--
-- Индексы таблицы `gr_csv_map`
--
ALTER TABLE `gr_csv_map`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_currency`
--
ALTER TABLE `gr_currency`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title_site_id` (`title`,`site_id`);

--
-- Индексы таблицы `gr_document_inventorization`
--
ALTER TABLE `gr_document_inventorization`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_document_inventory`
--
ALTER TABLE `gr_document_inventory`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_document_inventory_products`
--
ALTER TABLE `gr_document_inventory_products`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_document_movement`
--
ALTER TABLE `gr_document_movement`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_document_movement_products`
--
ALTER TABLE `gr_document_movement_products`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_document_products`
--
ALTER TABLE `gr_document_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `product_id_offer_id_warehouse` (`product_id`,`offer_id`,`warehouse`),
  ADD KEY `document_id` (`document_id`);

--
-- Индексы таблицы `gr_document_products_archive`
--
ALTER TABLE `gr_document_products_archive`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `product_id_offer_id_warehouse` (`product_id`,`offer_id`,`warehouse`),
  ADD KEY `document_id` (`document_id`);

--
-- Индексы таблицы `gr_document_products_start_num`
--
ALTER TABLE `gr_document_products_start_num`
  ADD UNIQUE KEY `product_id_offer_id_warehouse_id` (`product_id`,`offer_id`,`warehouse_id`),
  ADD KEY `offer_id` (`offer_id`),
  ADD KEY `warehouse_id` (`warehouse_id`);

--
-- Индексы таблицы `gr_exchange_history`
--
ALTER TABLE `gr_exchange_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dateof` (`dateof`);

--
-- Индексы таблицы `gr_export_external_link`
--
ALTER TABLE `gr_export_external_link`
  ADD UNIQUE KEY `profile_id_product_id_offer_id` (`profile_id`,`product_id`,`offer_id`);

--
-- Индексы таблицы `gr_export_profile`
--
ALTER TABLE `gr_export_profile`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_export_vk_cat`
--
ALTER TABLE `gr_export_vk_cat`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `profile_id_vk_id` (`profile_id`,`vk_id`);

--
-- Индексы таблицы `gr_export_vk_cat_link`
--
ALTER TABLE `gr_export_vk_cat_link`
  ADD PRIMARY KEY (`dir_id`,`profile_id`,`vk_cat_id`);

--
-- Индексы таблицы `gr_external_api_log`
--
ALTER TABLE `gr_external_api_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dateof` (`dateof`);

--
-- Индексы таблицы `gr_external_request_cache`
--
ALTER TABLE `gr_external_request_cache`
  ADD PRIMARY KEY (`id`),
  ADD KEY `date` (`date`);

--
-- Индексы таблицы `gr_fast_link`
--
ALTER TABLE `gr_fast_link`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_files`
--
ALTER TABLE `gr_files`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `servername_link_type_class_link_id` (`servername`,`link_type_class`,`link_id`),
  ADD UNIQUE KEY `xml_id` (`xml_id`),
  ADD UNIQUE KEY `uniq` (`uniq`),
  ADD UNIQUE KEY `uniq_name` (`uniq_name`),
  ADD KEY `access` (`access`);

--
-- Индексы таблицы `gr_hash_store`
--
ALTER TABLE `gr_hash_store`
  ADD PRIMARY KEY (`hash`);

--
-- Индексы таблицы `gr_images`
--
ALTER TABLE `gr_images`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `servername_type_linkid` (`servername`,`type`,`linkid`),
  ADD KEY `linkid_type` (`linkid`,`type`),
  ADD KEY `linkid_sortn` (`linkid`,`sortn`),
  ADD KEY `servername` (`servername`);

--
-- Индексы таблицы `gr_license`
--
ALTER TABLE `gr_license`
  ADD PRIMARY KEY (`license`);

--
-- Индексы таблицы `gr_long_polling_event`
--
ALTER TABLE `gr_long_polling_event`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expire_user_id` (`expire`,`user_id`);

--
-- Индексы таблицы `gr_menu`
--
ALTER TABLE `gr_menu`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_alias_parent` (`site_id`,`alias`,`parent`),
  ADD KEY `parent_sortn` (`parent`,`sortn`),
  ADD KEY `site_id` (`site_id`);

--
-- Индексы таблицы `gr_module_config`
--
ALTER TABLE `gr_module_config`
  ADD PRIMARY KEY (`site_id`,`module`);

--
-- Индексы таблицы `gr_module_license`
--
ALTER TABLE `gr_module_license`
  ADD PRIMARY KEY (`module`);

--
-- Индексы таблицы `gr_notes_note`
--
ALTER TABLE `gr_notes_note`
  ADD PRIMARY KEY (`id`),
  ADD KEY `status` (`status`),
  ADD KEY `creator_user_id` (`creator_user_id`);

--
-- Индексы таблицы `gr_notice_config`
--
ALTER TABLE `gr_notice_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_class` (`site_id`,`class`);

--
-- Индексы таблицы `gr_notice_item`
--
ALTER TABLE `gr_notice_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `destination_user_id_notice_type` (`destination_user_id`,`notice_type`);

--
-- Индексы таблицы `gr_notice_lock`
--
ALTER TABLE `gr_notice_lock`
  ADD UNIQUE KEY `site_id_user_id_notice_type` (`site_id`,`user_id`,`notice_type`);

--
-- Индексы таблицы `gr_one_click`
--
ALTER TABLE `gr_one_click`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_order`
--
ALTER TABLE `gr_order`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_order_num` (`site_id`,`order_num`),
  ADD KEY `dateof_profit` (`dateof`,`profit`),
  ADD KEY `dateof_totalcost` (`dateof`,`totalcost`),
  ADD KEY `manager_user_id` (`manager_user_id`),
  ADD KEY `status` (`status`);

--
-- Индексы таблицы `gr_order_action_template`
--
ALTER TABLE `gr_order_action_template`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_order_address`
--
ALTER TABLE `gr_order_address`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_order_delivery`
--
ALTER TABLE `gr_order_delivery`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_order_delivery_dir`
--
ALTER TABLE `gr_order_delivery_dir`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_order_delivery_x_zone`
--
ALTER TABLE `gr_order_delivery_x_zone`
  ADD UNIQUE KEY `delivery_id_zone_id` (`delivery_id`,`zone_id`);

--
-- Индексы таблицы `gr_order_discount`
--
ALTER TABLE `gr_order_discount`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_code` (`site_id`,`code`);

--
-- Индексы таблицы `gr_order_items`
--
ALTER TABLE `gr_order_items`
  ADD PRIMARY KEY (`order_id`,`uniq`),
  ADD KEY `type_entity_id` (`type`,`entity_id`),
  ADD KEY `type` (`type`);

--
-- Индексы таблицы `gr_order_item_uit`
--
ALTER TABLE `gr_order_item_uit`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_order_payment`
--
ALTER TABLE `gr_order_payment`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_order_products_return`
--
ALTER TABLE `gr_order_products_return`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `return_num` (`return_num`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `dateof` (`dateof`);

--
-- Индексы таблицы `gr_order_products_return_item`
--
ALTER TABLE `gr_order_products_return_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `return_id` (`return_id`),
  ADD KEY `entity_id` (`entity_id`);

--
-- Индексы таблицы `gr_order_regions`
--
ALTER TABLE `gr_order_regions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `site_id_parent_id_is_city` (`site_id`,`parent_id`,`is_city`),
  ADD KEY `title` (`title`);

--
-- Индексы таблицы `gr_order_shipment`
--
ALTER TABLE `gr_order_shipment`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_order_shipment_item`
--
ALTER TABLE `gr_order_shipment_item`
  ADD UNIQUE KEY `order_id_shipment_id_order_item_uniq_uit_id` (`order_id`,`shipment_id`,`order_item_uniq`,`uit_id`),
  ADD KEY `shipment_id` (`shipment_id`);

--
-- Индексы таблицы `gr_order_substatus`
--
ALTER TABLE `gr_order_substatus`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_alias` (`site_id`,`alias`);

--
-- Индексы таблицы `gr_order_tax`
--
ALTER TABLE `gr_order_tax`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_order_tax_rate`
--
ALTER TABLE `gr_order_tax_rate`
  ADD UNIQUE KEY `tax_id_region_id` (`tax_id`,`region_id`);

--
-- Индексы таблицы `gr_order_userstatus`
--
ALTER TABLE `gr_order_userstatus`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_type` (`site_id`,`type`);

--
-- Индексы таблицы `gr_order_x_region`
--
ALTER TABLE `gr_order_x_region`
  ADD UNIQUE KEY `zone_id_region_id` (`zone_id`,`region_id`);

--
-- Индексы таблицы `gr_order_zone`
--
ALTER TABLE `gr_order_zone`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_ormeditor_customfield`
--
ALTER TABLE `gr_ormeditor_customfield`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_page_seo`
--
ALTER TABLE `gr_page_seo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_route_id` (`site_id`,`route_id`);

--
-- Индексы таблицы `gr_partnership`
--
ALTER TABLE `gr_partnership`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_photogalleries_album`
--
ALTER TABLE `gr_photogalleries_album`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_alias` (`site_id`,`alias`),
  ADD KEY `public` (`public`);

--
-- Индексы таблицы `gr_product`
--
ALTER TABLE `gr_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `public` (`public`);

--
-- Индексы таблицы `gr_product_dir`
--
ALTER TABLE `gr_product_dir`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_xml_id` (`site_id`,`xml_id`),
  ADD UNIQUE KEY `site_id_alias` (`site_id`,`alias`),
  ADD KEY `site_id_parent` (`site_id`,`parent`),
  ADD KEY `site_id_name_parent` (`site_id`,`name`,`parent`),
  ADD KEY `level` (`level`);

--
-- Индексы таблицы `gr_product_favorite`
--
ALTER TABLE `gr_product_favorite`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `guest_id_user_id_product_id` (`guest_id`,`user_id`,`product_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Индексы таблицы `gr_product_multioffer`
--
ALTER TABLE `gr_product_multioffer`
  ADD UNIQUE KEY `product_id_prop_id` (`product_id`,`prop_id`);

--
-- Индексы таблицы `gr_product_offer`
--
ALTER TABLE `gr_product_offer`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_xml_id` (`site_id`,`xml_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `barcode` (`barcode`);

--
-- Индексы таблицы `gr_product_prop`
--
ALTER TABLE `gr_product_prop`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_alias` (`site_id`,`alias`),
  ADD UNIQUE KEY `site_id_xml_id` (`site_id`,`xml_id`),
  ADD KEY `title` (`title`);

--
-- Индексы таблицы `gr_product_prop_dir`
--
ALTER TABLE `gr_product_prop_dir`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_product_prop_link`
--
ALTER TABLE `gr_product_prop_link`
  ADD UNIQUE KEY `site_id_product_id_group_id` (`site_id`,`product_id`,`group_id`),
  ADD KEY `site_id_prop_id` (`site_id`,`prop_id`),
  ADD KEY `product_id_prop_id_val_str_available` (`product_id`,`prop_id`,`val_str`,`available`),
  ADD KEY `product_id_prop_id_val_int_available` (`product_id`,`prop_id`,`val_int`,`available`),
  ADD KEY `product_id_prop_id_val_list_id_available` (`product_id`,`prop_id`,`val_list_id`,`available`),
  ADD KEY `prop_id_val_list_id` (`prop_id`,`val_list_id`),
  ADD KEY `group_id_public` (`group_id`,`public`);

--
-- Индексы таблицы `gr_product_prop_value`
--
ALTER TABLE `gr_product_prop_value`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `prop_id_value` (`prop_id`,`value`),
  ADD UNIQUE KEY `site_id_xml_id` (`site_id`,`xml_id`),
  ADD UNIQUE KEY `site_id_alias_prop_id` (`site_id`,`alias`,`prop_id`);

--
-- Индексы таблицы `gr_product_reservation`
--
ALTER TABLE `gr_product_reservation`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_product_typecost`
--
ALTER TABLE `gr_product_typecost`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_xml_id` (`site_id`,`xml_id`);

--
-- Индексы таблицы `gr_product_unit`
--
ALTER TABLE `gr_product_unit`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_product_x_cost`
--
ALTER TABLE `gr_product_x_cost`
  ADD UNIQUE KEY `product_id_cost_id` (`product_id`,`cost_id`);

--
-- Индексы таблицы `gr_product_x_dir`
--
ALTER TABLE `gr_product_x_dir`
  ADD UNIQUE KEY `dir_id_product_id` (`dir_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Индексы таблицы `gr_product_x_stock`
--
ALTER TABLE `gr_product_x_stock`
  ADD UNIQUE KEY `product_id_offer_id_warehouse_id` (`product_id`,`offer_id`,`warehouse_id`),
  ADD KEY `offer_id` (`offer_id`),
  ADD KEY `warehouse_id` (`warehouse_id`);

--
-- Индексы таблицы `gr_purchase`
--
ALTER TABLE `gr_purchase`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_pushsender_push_lock`
--
ALTER TABLE `gr_pushsender_push_lock`
  ADD UNIQUE KEY `site_id_user_id_app_push_class` (`site_id`,`user_id`,`app`,`push_class`);

--
-- Индексы таблицы `gr_pushsender_user_token`
--
ALTER TABLE `gr_pushsender_user_token`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id_push_token` (`user_id`,`push_token`),
  ADD UNIQUE KEY `app_uuid` (`app`,`uuid`),
  ADD KEY `model_platform` (`model`,`platform`);

--
-- Индексы таблицы `gr_readed_item`
--
ALTER TABLE `gr_readed_item`
  ADD UNIQUE KEY `site_id_user_id_entity_entity_id` (`site_id`,`user_id`,`entity`,`entity_id`);

--
-- Индексы таблицы `gr_receipt`
--
ALTER TABLE `gr_receipt`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sign` (`sign`),
  ADD KEY `uniq_id` (`uniq_id`);

--
-- Индексы таблицы `gr_search_index`
--
ALTER TABLE `gr_search_index`
  ADD PRIMARY KEY (`result_class`,`entity_id`);
ALTER TABLE `gr_search_index` ADD FULLTEXT KEY `title_indextext` (`title`,`indextext`);

--
-- Индексы таблицы `gr_sections`
--
ALTER TABLE `gr_sections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Индексы таблицы `gr_section_containers`
--
ALTER TABLE `gr_section_containers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `page_id` (`page_id`);

--
-- Индексы таблицы `gr_section_context`
--
ALTER TABLE `gr_section_context`
  ADD PRIMARY KEY (`site_id`,`context`);

--
-- Индексы таблицы `gr_section_modules`
--
ALTER TABLE `gr_section_modules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `context` (`context`),
  ADD KEY `page_id` (`page_id`);

--
-- Индексы таблицы `gr_section_page`
--
ALTER TABLE `gr_section_page`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_route_id_context` (`site_id`,`route_id`,`context`);

--
-- Индексы таблицы `gr_sites`
--
ALTER TABLE `gr_sites`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_site_options`
--
ALTER TABLE `gr_site_options`
  ADD PRIMARY KEY (`site_id`);

--
-- Индексы таблицы `gr_statistic_events`
--
ALTER TABLE `gr_statistic_events`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_dateof_type` (`site_id`,`dateof`,`type`),
  ADD KEY `dateof` (`dateof`);

--
-- Индексы таблицы `gr_statistic_source`
--
ALTER TABLE `gr_statistic_source`
  ADD PRIMARY KEY (`id`),
  ADD KEY `partner_id` (`partner_id`),
  ADD KEY `dateof` (`dateof`);

--
-- Индексы таблицы `gr_statistic_user_source_type`
--
ALTER TABLE `gr_statistic_user_source_type`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_statistic_user_source_type_dir`
--
ALTER TABLE `gr_statistic_user_source_type_dir`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_subscribe_email`
--
ALTER TABLE `gr_subscribe_email`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email_confirm` (`email`,`confirm`),
  ADD KEY `signature` (`signature`);

--
-- Индексы таблицы `gr_support`
--
ALTER TABLE `gr_support`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_support_topic`
--
ALTER TABLE `gr_support_topic`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_tags_links`
--
ALTER TABLE `gr_tags_links`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `word_id_type_link_id` (`word_id`,`type`,`link_id`);

--
-- Индексы таблицы `gr_tags_words`
--
ALTER TABLE `gr_tags_words`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `alias` (`alias`),
  ADD KEY `stemmed` (`stemmed`);

--
-- Индексы таблицы `gr_testmodule_gallerist`
--
ALTER TABLE `gr_testmodule_gallerist`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_tpl_hook_sort`
--
ALTER TABLE `gr_tpl_hook_sort`
  ADD UNIQUE KEY `site_id_context_hook_name_module` (`site_id`,`context`,`hook_name`,`module`),
  ADD KEY `sortn` (`sortn`);

--
-- Индексы таблицы `gr_transaction`
--
ALTER TABLE `gr_transaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `entity_entity_id` (`entity`,`entity_id`);

--
-- Индексы таблицы `gr_transaction_changelog`
--
ALTER TABLE `gr_transaction_changelog`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `gr_try_auth`
--
ALTER TABLE `gr_try_auth`
  ADD PRIMARY KEY (`ip`);

--
-- Индексы таблицы `gr_users`
--
ALTER TABLE `gr_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `login` (`login`),
  ADD KEY `hash` (`hash`),
  ADD KEY `manager_user_id` (`manager_user_id`);

--
-- Индексы таблицы `gr_users_group`
--
ALTER TABLE `gr_users_group`
  ADD PRIMARY KEY (`alias`),
  ADD KEY `sortn` (`sortn`);

--
-- Индексы таблицы `gr_users_in_group`
--
ALTER TABLE `gr_users_in_group`
  ADD PRIMARY KEY (`user`,`group`);

--
-- Индексы таблицы `gr_users_log`
--
ALTER TABLE `gr_users_log`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `class_user_id_group` (`class`,`user_id`,`group`),
  ADD KEY `site_id_class` (`site_id`,`class`);

--
-- Индексы таблицы `gr_users_verification_session`
--
ALTER TABLE `gr_users_verification_session`
  ADD PRIMARY KEY (`uniq`),
  ADD KEY `ip_action_is_resolved_last_initialized` (`ip`,`action`,`is_resolved`,`last_initialized`);

--
-- Индексы таблицы `gr_warehouse`
--
ALTER TABLE `gr_warehouse`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_xml_id` (`site_id`,`xml_id`),
  ADD UNIQUE KEY `site_id_alias` (`site_id`,`alias`),
  ADD KEY `coor_x_coor_y` (`coor_x`,`coor_y`),
  ADD KEY `alias` (`alias`),
  ADD KEY `public` (`public`);

--
-- Индексы таблицы `gr_warehouse_group`
--
ALTER TABLE `gr_warehouse_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_alias` (`site_id`,`alias`);

--
-- Индексы таблицы `gr_widgets`
--
ALTER TABLE `gr_widgets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `site_id_user_id_class` (`site_id`,`user_id`,`class`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `gr_affiliate`
--
ALTER TABLE `gr_affiliate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_antivirus_events`
--
ALTER TABLE `gr_antivirus_events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_antivirus_excluded_files`
--
ALTER TABLE `gr_antivirus_excluded_files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_antivirus_request_count`
--
ALTER TABLE `gr_antivirus_request_count`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `gr_article`
--
ALTER TABLE `gr_article`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_article_category`
--
ALTER TABLE `gr_article_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_banner`
--
ALTER TABLE `gr_banner`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_banner_zone`
--
ALTER TABLE `gr_banner_zone`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_brand`
--
ALTER TABLE `gr_brand`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_comments`
--
ALTER TABLE `gr_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_connect_form`
--
ALTER TABLE `gr_connect_form`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `gr_connect_form_field`
--
ALTER TABLE `gr_connect_form_field`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `gr_connect_form_result`
--
ALTER TABLE `gr_connect_form_result`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_crm_autotaskrule`
--
ALTER TABLE `gr_crm_autotaskrule`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_crm_deal`
--
ALTER TABLE `gr_crm_deal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_crm_interaction`
--
ALTER TABLE `gr_crm_interaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_crm_statuses`
--
ALTER TABLE `gr_crm_statuses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `gr_crm_task`
--
ALTER TABLE `gr_crm_task`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_crm_task_filter`
--
ALTER TABLE `gr_crm_task_filter`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_crm_tel_call_history`
--
ALTER TABLE `gr_crm_tel_call_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_csv_map`
--
ALTER TABLE `gr_csv_map`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_currency`
--
ALTER TABLE `gr_currency`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `gr_document_inventorization`
--
ALTER TABLE `gr_document_inventorization`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_document_inventory`
--
ALTER TABLE `gr_document_inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_document_inventory_products`
--
ALTER TABLE `gr_document_inventory_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_document_movement`
--
ALTER TABLE `gr_document_movement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_document_movement_products`
--
ALTER TABLE `gr_document_movement_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_document_products`
--
ALTER TABLE `gr_document_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_document_products_archive`
--
ALTER TABLE `gr_document_products_archive`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_exchange_history`
--
ALTER TABLE `gr_exchange_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_export_profile`
--
ALTER TABLE `gr_export_profile`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_export_vk_cat`
--
ALTER TABLE `gr_export_vk_cat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_external_api_log`
--
ALTER TABLE `gr_external_api_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_external_request_cache`
--
ALTER TABLE `gr_external_request_cache`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_fast_link`
--
ALTER TABLE `gr_fast_link`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_files`
--
ALTER TABLE `gr_files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_images`
--
ALTER TABLE `gr_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `gr_long_polling_event`
--
ALTER TABLE `gr_long_polling_event`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_menu`
--
ALTER TABLE `gr_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `gr_notes_note`
--
ALTER TABLE `gr_notes_note`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_notice_config`
--
ALTER TABLE `gr_notice_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `gr_notice_item`
--
ALTER TABLE `gr_notice_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_one_click`
--
ALTER TABLE `gr_one_click`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_order`
--
ALTER TABLE `gr_order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_order_action_template`
--
ALTER TABLE `gr_order_action_template`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_order_address`
--
ALTER TABLE `gr_order_address`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_order_delivery`
--
ALTER TABLE `gr_order_delivery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_order_delivery_dir`
--
ALTER TABLE `gr_order_delivery_dir`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_order_discount`
--
ALTER TABLE `gr_order_discount`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_order_item_uit`
--
ALTER TABLE `gr_order_item_uit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_order_payment`
--
ALTER TABLE `gr_order_payment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `gr_order_products_return`
--
ALTER TABLE `gr_order_products_return`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_order_products_return_item`
--
ALTER TABLE `gr_order_products_return_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_order_regions`
--
ALTER TABLE `gr_order_regions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=1205;

--
-- AUTO_INCREMENT для таблицы `gr_order_shipment`
--
ALTER TABLE `gr_order_shipment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_order_substatus`
--
ALTER TABLE `gr_order_substatus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `gr_order_tax`
--
ALTER TABLE `gr_order_tax`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_order_userstatus`
--
ALTER TABLE `gr_order_userstatus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `gr_order_zone`
--
ALTER TABLE `gr_order_zone`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `gr_ormeditor_customfield`
--
ALTER TABLE `gr_ormeditor_customfield`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_page_seo`
--
ALTER TABLE `gr_page_seo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_partnership`
--
ALTER TABLE `gr_partnership`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_photogalleries_album`
--
ALTER TABLE `gr_photogalleries_album`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_product`
--
ALTER TABLE `gr_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `gr_product_dir`
--
ALTER TABLE `gr_product_dir`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `gr_product_favorite`
--
ALTER TABLE `gr_product_favorite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_product_offer`
--
ALTER TABLE `gr_product_offer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `gr_product_prop`
--
ALTER TABLE `gr_product_prop`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `gr_product_prop_dir`
--
ALTER TABLE `gr_product_prop_dir`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `gr_product_prop_value`
--
ALTER TABLE `gr_product_prop_value`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_product_reservation`
--
ALTER TABLE `gr_product_reservation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_product_typecost`
--
ALTER TABLE `gr_product_typecost`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `gr_product_unit`
--
ALTER TABLE `gr_product_unit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_purchase`
--
ALTER TABLE `gr_purchase`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_pushsender_user_token`
--
ALTER TABLE `gr_pushsender_user_token`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_receipt`
--
ALTER TABLE `gr_receipt`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_sections`
--
ALTER TABLE `gr_sections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT для таблицы `gr_section_containers`
--
ALTER TABLE `gr_section_containers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT для таблицы `gr_section_modules`
--
ALTER TABLE `gr_section_modules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT для таблицы `gr_section_page`
--
ALTER TABLE `gr_section_page`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT для таблицы `gr_sites`
--
ALTER TABLE `gr_sites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `gr_statistic_events`
--
ALTER TABLE `gr_statistic_events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_statistic_source`
--
ALTER TABLE `gr_statistic_source`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_statistic_user_source_type`
--
ALTER TABLE `gr_statistic_user_source_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_statistic_user_source_type_dir`
--
ALTER TABLE `gr_statistic_user_source_type_dir`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_subscribe_email`
--
ALTER TABLE `gr_subscribe_email`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_support`
--
ALTER TABLE `gr_support`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_support_topic`
--
ALTER TABLE `gr_support_topic`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_tags_links`
--
ALTER TABLE `gr_tags_links`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_tags_words`
--
ALTER TABLE `gr_tags_words`
  MODIFY `id` bigint(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `gr_testmodule_gallerist`
--
ALTER TABLE `gr_testmodule_gallerist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_transaction`
--
ALTER TABLE `gr_transaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_transaction_changelog`
--
ALTER TABLE `gr_transaction_changelog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_users`
--
ALTER TABLE `gr_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `gr_users_log`
--
ALTER TABLE `gr_users_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `gr_warehouse`
--
ALTER TABLE `gr_warehouse`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `gr_warehouse_group`
--
ALTER TABLE `gr_warehouse_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)';

--
-- AUTO_INCREMENT для таблицы `gr_widgets`
--
ALTER TABLE `gr_widgets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор (ID)', AUTO_INCREMENT=17;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

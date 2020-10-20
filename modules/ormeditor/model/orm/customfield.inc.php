<?php
namespace OrmEditor\Model\Orm;

use RS\Orm\OrmObject;
use RS\Orm\Type;

/**
 * ORM объект, описывающий кастомное поле или видимость существующего поля
 * --/--
 * @property integer $id Уникальный идентификатор (ID)
 * @property string $orm_class Расширяемый класс ORM объекта
 * @property string $tab Вкладка
 * @property string $field Свойство для расширения
 * @property string $hide Скрыть
 * @property string $is_base 
 * @property string $type Тип поля
 * @property string $description Описание поля
 * @property string $default Значение по умолчанию
 * @property integer $allow_empty Разрешить NULL
 * --\--
 */
class CustomField extends OrmObject
{
    const
        TYPE_TEXT = 'text',
        TYPE_USER = 'user',
        TYPE_REAL = 'real',
        TYPE_LONGTEXT = 'longtext',
        TYPE_INTEGER = 'integer',
        TYPE_IMAGE = 'image',
        TYPE_FILE = 'file',
        TYPE_DECIMAL = 'decimal',
        TYPE_DATE = 'date',
        TYPE_DATETIME = 'datetime',
        TYPE_COLOR = 'color',
        TYPE_BLOB = 'blob',
        TYPE_BIGINT = 'bigint',
        TYPE_RICHTEXT = 'richtext',
        TYPE_TINYTEXT = 'tinytext',
        TYPE_VARCHAR = 'varchar',
        TYPE_CHECKBOX = 'checkbox';

    protected static $table = 'ormeditor_customfield';

    /**
     * Инициализирует поля ORM объекта
     *
     * @return \RS\Orm\PropertyIterator|void
     */
    function _init()
    {
        parent::_init()->append(array(
            'orm_class' => new Type\Varchar(array(
                'description' => t('Расширяемый класс ORM объекта')
            )),
            'tab' => new Type\Varchar(array(
                'description' => t('Вкладка')
            )),
            'field' => new Type\Varchar(array(
                'description' => t('Свойство для расширения')
            )),
            'hide' => new Type\Varchar(array(
                'description' => t('Скрыть')
            )),
            'is_base' => new Type\Varchar(array(
                'descirption' => t('Это базовое свойство ORM объекта?')
            )),
            'type' => new Type\Varchar(array(
                'description' => t('Тип поля'),
                'listFromArray' => array(self::getTypeTitles())
            )),
            'description' => new Type\Varchar(array(
                'description' => t('Описание поля')
            )),
            'default' => new Type\Varchar(array(
                'description' => t('Значение по умолчанию')
            )),
            'allow_empty' => new Type\Integer(array(
                'description' => t('Разрешить NULL'),
                'checkboxView' => array(1,0)
            ))

        ));
    }

    /**
     * Возвращает полный список возможных значений типов
     *
     * @return array
     */
    public static function getTypeTitles()
    {
        return array(
            self::TYPE_VARCHAR => t('Строка (VARCHAR)'),
            self::TYPE_INTEGER => t('Число (INT)'),
            self::TYPE_RICHTEXT => t('Текстовый редактор (RICHTEXT)'),
            self::TYPE_IMAGE => t('Изображение (IMAGE)'),
            self::TYPE_FILE => t('Файл (FILE)'),
            self::TYPE_TEXT => t('Текст (MEDIUMTEXT)'),
            self::TYPE_USER => t('Пользователь (USER)'),
            self::TYPE_REAL => t('Дробное число (FLOAT)'),
            self::TYPE_LONGTEXT => t('Длинный текст (LONGTEXT)'),
            self::TYPE_DECIMAL => t('Деньги (DECIMAL 20,2)'),
            self::TYPE_DATE => t('Дата (DATE)'),
            self::TYPE_DATETIME => t('Дата и время (DATETIME)'),
            self::TYPE_COLOR => t('Выбор цвета (COLOR)'),
            self::TYPE_BIGINT => t('Большое число (BIGINT)'),
            self::TYPE_TINYTEXT => t('Небольшой текст (TINYTEXT)'),
            self::TYPE_CHECKBOX => t('Флажок (Да/Нет)')
        );
    }

    /**
     * Возвращает объект свойства
     *
     * @return Type\AbstractType
     */
    public function getOrmType()
    {
        switch ($this['type']) {
            case self::TYPE_CHECKBOX:
                $class_type = 'Integer'; break;
            default:
                $class_type = $this['type'];
        }

        $class_name = '\RS\Orm\Type\\'.$class_type;
        /**
         * @var $orm_type Type\AbstractType
         */
        $orm_type = new $class_name();
        $orm_type->setName($this['field']);
        $orm_type->setDescription($this['description']);
        if ($this['default'] !== '') {
            $orm_type->setDefault($this['default']);
        }
        $orm_type->is_custom_field = true;
        $orm_type->custom_field = $this;

        switch ($this['type']) {
            case self::TYPE_DECIMAL:
                $orm_type->setMaxLength(20);
                $orm_type->setDecimal(2);
                break;
            case self::TYPE_CHECKBOX:
                $orm_type->setMaxLength(1);
                $orm_type->setCheckboxView(1,0);
        }

        return $orm_type;
    }
}
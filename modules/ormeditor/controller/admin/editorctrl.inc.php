<?php
namespace OrmEditor\Controller\Admin;

use OrmEditor\Model\Orm\CustomField;
use OrmEditor\Model\OrmEditorApi;
use OrmEditor\Model\OrmEditorDirApi;
use RS\Controller\Admin\Front;
use RS\Controller\Admin\Helper\CrudCollection;
use RS\Html\Table;
use RS\Html\Table\Type as TableType;
use RS\Html\Category;
use RS\Html\Toolbar;
use RS\Html\Toolbar\Button as ToolbarButton;
use RS\Html\Filter;

/**
 * Контроллер, позволяет редактировать любой ORM объект в системе
 */
class EditorCtrl extends Front
{
    protected
        $orm_object,
        $orm_class,
        $dir,
        $orm_editor_api,
        $orm_editor_dir_api;

    function __construct()
    {
        parent::__construct();
        $this->orm_editor_api = new OrmEditorApi();
        $this->orm_editor_dir_api = new OrmEditorDirApi();
    }

    /**
     * Формирует разметку административного раздела
     *
     * @return CrudCollection
     */
    function helperIndex()
    {
        $this->dir = $this->url->request('dir', TYPE_STRING);

        $this->orm_editor_api->setMouduleFilter($this->dir);

        $helper = new CrudCollection($this, $this->orm_editor_api);
        $helper->setTopTitle(t('Редактор ORM объектов'));
        $helper->setTopHelp(t('С помощью данного раздела, вы сможете скрыть ненужные поля в различных объектах, а также добавить необходимые поля любому ORM объекту в системе. <br>Каждое поле реально создается в соответствующей таблице базы данных и может быть использовано в любом месте системы через ORM-объект, в том числе в шаблонах.'));
        $helper->viewAsTableCategory();

        $helper->setTable(new Table\Element(array(
            'Columns' => array(
                new TableType\Text('title', t('Объект'), array('LinkAttr' => array('class' => 'crud-edit'), 'Sortable' => SORTABLE_ASC, 'CurrentSort' => SORTABLE_ASC, 'href' => $this->router->getAdminPattern('edit', array(':id' => '@id', 'dir' => $this->dir)))),
                new TableType\Actions('id', array(
                    new TableType\Action\Edit($this->router->getAdminPattern('edit', array(':id' => '~field~', 'dir' => $this->dir)), null,
                        array(
                            'attr' => array(
                                '@data-id' => '@id'
                            )
                        )
                    )
                ))
            )
        )));

        $helper->setCategoryListFunction('getCategoryList');
        $helper->setCategory(new Category\Element(array(
            'noCheckbox' => true,
            'sortIdField' => 'id',
            'activeField' => 'id',
            'activeValue' => $this->dir,
            'sortable' => false,
            'mainColumn' => new TableType\Text('title', t('Название'), array('href' => $this->router->getAdminPattern(false, array(':dir' => '@id', 'c' => $this->url->get('c', TYPE_ARRAY))))),
            'headButtons' => array(
                array(
                    'text' => t('Название модуля'),
                    'tag' => 'span',
                    'attr' => array(
                        'class' => 'lefttext'
                    )
                )
            )
        )), $this->orm_editor_dir_api);

        $helper->setFilter(new Filter\Control(array(
            'Caption' => t('Поиск объекта'),
            'Container' => new Filter\Container(array(
                'Lines' => array(
                    new Filter\Line(array('Items' => array(
                        new Filter\Type\Text('id', 'Объект'),
                    )))
                )
        )))));

        $helper->setCategoryFilter(new Filter\Control(array(
            'Caption' => t('Поиск по названию'),
            'Container' => new Filter\Container(array(
                'Lines' => array(
                    new Filter\Line(array('Items' => array(
                        new Filter\Type\Text('module', 'Модуль'),
                    )))
                )
            )))));

        return $helper;
    }

    /**
     * Отображает список ORM оъектов
     *
     * @return \RS\Controller\Result\Standard
     */
    function actionIndex()
    {
        $helper = $this->helperIndex();
        $helper->active();
        return $this->result->setTemplate( $helper->getTemplate() );
    }

    /**
     * Формирует разметку страницы для редактирования ORM-объекта
     *
     * @return CrudCollection
     * @throws \RS\Controller\ExceptionPageNotFound
     * @throws \RS\Orm\Exception
     * @throws \SmartyException
     */
    function helperEdit()
    {
        $this->orm_class = $this->url->get('id', TYPE_STRING);

        if (!is_subclass_of($this->orm_class, '\RS\Orm\AbstractObject')) {
            $this->e404(t('Неверный идентификатор ORM объекта'));
        }

        $this->orm_object = new $this->orm_class();

        $helper = new CrudCollection($this);
        $helper->setTopTitle(t('Редактировать ORM объект %0', array($this->orm_class)));
        $helper->setBottomToolbar(new Toolbar\Element(array(
            'Items' => array(
                'save' => new ToolbarButton\SaveForm(null, null, array('attr' => array(
                    'class' => 'btn-success'
                )),true),
                'cancel' => new ToolbarButton\Cancel($this->url->getSavedUrl($this->controller_name . 'index')),
            )
        )));
        $helper->viewAsForm();

        $this->view->assign(array(
            'orm_object' => $this->orm_object,
            'field_data' => $this->orm_editor_api->getFieldData($this->orm_object)
        ));

        $helper->setForm($this->view->fetch('fieldform.tpl'));

        return $helper;
    }

    /**
     * Отображает страницу редактирования ORM-объекта
     *
     * @return \RS\Controller\Result\Standard
     *
     * @throws \RS\Controller\ExceptionPageNotFound
     * @throws \RS\Db\Exception
     * @throws \RS\Event\Exception
     * @throws \RS\Orm\Exception
     * @throws \SmartyException
     */
    function actionEdit()
    {
        $helper = $this->helperEdit();
        if ($this->url->isPost()) {
            $field_data = $this->url->post('field', TYPE_ARRAY);
            if ($this->orm_editor_api->save($this->orm_object, $field_data)) {
                return $this->result->setSuccessText(t('Изменения успешно сохранены'))->setSuccess(true);

            } else {
                return $this->result->setErrors($this->orm_editor_api->getDisplayErrors());
            }
        }

        return $this->result->setTemplate($helper->getTemplate());
    }

    /**
     * Возвращает одну строку с полем
     *
     * @return \RS\Controller\Result\Standard
     */
    function actionGetCustomFieldLine()
    {
        $group = $this->url->get('group', TYPE_STRING);
        $field = new CustomField();
        $field['type'] = CustomField::TYPE_VARCHAR;

        $this->view->assign(array(
            'item' => $field->getOrmType(),
            'uniq' => uniqid(),
            'group' => $group
        ));

        return $this->result->setSuccess(true)->setTemplate('%ormeditor%/custom_property.tpl');
    }

    /**
     * Возвращает HTML нового таба
     *
     * @return \RS\Controller\Result\Standard
     * @throws \SmartyException
     */
    function actionGetCustomTab()
    {
        $group = $this->url->get('group', TYPE_STRING);

        $this->view->assign(array(
            'group' => $group,
            'index' => uniqid(),
            'remove' => true
        ));

        return $this->result->setSuccess(true)->addSection(array(
            'tab'     => $this->view->fetch('%ormeditor%/field_tab.tpl'),
            'tabPane' => $this->view->fetch('%ormeditor%/field_list.tpl')
        ));
    }
}
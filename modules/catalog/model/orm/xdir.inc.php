<?php
/**
* ReadyScript (http://readyscript.ru)
*
* @copyright Copyright (c) ReadyScript lab. (http://readyscript.ru)
* @license http://readyscript.ru/licenseAgreement/
*/
namespace Catalog\Model\Orm;
use \RS\Orm\Type;

/**
 * --/--
 * @property integer $product_id ID товара
 * @property integer $dir_id ID категории
 * --\--
 */
class Xdir extends \RS\Orm\AbstractObject
{
	protected static
		$table = 'product_x_dir';
		
	function _init()
	{
        $this->getPropertyIterator()->append(array(
            'product_id' => new Type\Integer(array(
                'description' => t('ID товара')
            )),
            'dir_id' => new Type\Integer(array(
                'description' => t('ID категории')
            )),
        ));
        
        $this->addIndex(array('dir_id', 'product_id'), self::INDEX_UNIQUE);
        $this->addIndex(array('product_id'), self::INDEX_KEY);
	}
}

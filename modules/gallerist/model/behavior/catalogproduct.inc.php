<?php
namespace Gallerist\Model\Behavior;
use \RS\Orm\Type;

/**
* Объект - Расширения пользователя
*/
class CatalogProduct extends \RS\Behavior\BehaviorAbstract
{
    /**
     * Получить ФИО автора картины
     * @param bool $midname - выводить отчество
     * @return string
     */
    public function getAuthorName($midname = false)
    {
        /**
         * @var \Catalog\Model\Orm\Product $product
         */
        $product = $this->owner;
        $author = new \Users\Model\Orm\User($product['owner']);
        if($midname && !empty($author['midname'])){
            return $author['name'].' '.$author['midname'].' '.$author['surname'];
        }
        return $author['name'].' '.$author['surname'];
    }

    /**
     * Получить автора картины
     * @return \Users\Model\Orm\User
     */
    public function getAuthor()
    {
        /**
         * @var \Catalog\Model\Orm\Product $product
         */
        $product = $this->owner;
        $author = new \Users\Model\Orm\User($product['owner']);
        return $author;
    }

    /**
     * Получить размер картины
     * @param string $format - 'sm' - в сантиметрах, 'mm' - в милиметрах
     * @return bool|string
     */
    public function getSize($format = 'sm')
    {
        /**
         * @var \Catalog\Model\Orm\Product $product
         */
        $product = $this->owner;
        if($format == 'sm' && $product['height'] && $product['width']){
            return $product['width'].'x'.$product['height'].' см';
        }
        if ($format == 'mm' && $product['height'] && $product['width']){
            return ($product['width']*10).'x'.($product['height']*10).' см';
        }
        return false;
    }

    /**
     * Получить стиль картины по значению характеристики Стиль
     * @return bool
     */
    public function getCity()
    {
        /**
         * @var \Catalog\Model\Orm\Product $product
         */
        $product = $this->owner;
        $config = \RS\Config\Loader::byModule('gallerist');
        $city = $product['city'];
        if($city[0] != 0){
            $prop_style = $config['prop_city'];
            $proprty = new \Catalog\Model\Orm\Property\Item($prop_style);
            $values = $proprty->getAllowedValues();
            return $values[$city];
        }
        return false;
    }

    public function getRegion()
    {
        /**
         * @var \Catalog\Model\Orm\Product $product
         */
        $product = $this->owner;
        $config = \RS\Config\Loader::byModule('gallerist');
        $city = $product['region'];
        if($city[0] != 0){
            $prop_style = $config['prop_region'];
            $proprty = new \Catalog\Model\Orm\Property\Item($prop_style);
            $values = $proprty->getAllowedValues();
            return $values[$city];
        }
        return false;
    }

    public function getPropValue($prop_name)
    {
        /**
         * @var \Catalog\Model\Orm\Product $product
         */
        $product = $this->owner;
        $config = \RS\Config\Loader::byModule('gallerist');
        $product_prop = @unserialize($product['_'.$prop_name]);
        $prop_style = $config['prop_'.$prop_name];
        $property = new \Catalog\Model\Orm\Property\Item($prop_style);
        $values = $property->getAllowedValues();
        if(is_array($product_prop)){
            if($product_prop[0] != 0) {
                return $values[$product_prop[0]];
            }else {
                return false;
            }
        }else{
            if($product_prop != 0)
                return $values[$product_prop];
            else
                return false;
        }
    }

    /**
     * Проверяет возможность отправки заявки на покупку картины
     * @return bool
     */
    public function canSendRequest()
    {
        $product = $this->owner;
        $author = $product->getAuthor();
        $is_auth = \RS\Application\Auth::isAuthorize();
        $current_user = \RS\Application\Auth::getCurrentUser();
        if($is_auth && $author['id'] == $current_user['id']){
            return false;
        }
        return true;
    }
}


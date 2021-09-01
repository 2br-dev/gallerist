<?php
namespace Gallerist\Model\Behavior;
use \RS\Orm\Type;

/**
* Объект - Расширения пользователя
*/
class UsersUser extends \RS\Behavior\BehaviorAbstract
{
    /**
     * Возвращает true если авторизованный пользователь зарегистрирован как художник
     * @return bool
     */
    public function isAuthor()
    {
        /**
         * @var \Users\Model\Orm\User $user
         */
        $user = $this->owner;
        $is_author = false;
        if($user->inGroup('artist')){
            $is_author = true;
        }
        return $is_author;
    }

    /**
     * Возвращает общее количество опубликованных картин
     * @return int
     */
    public function getCountArt()
    {
        $user = $this->owner;
        $product_api = new \Catalog\Model\Api();
        $arts = $product_api->setFilter('owner', $user['id'])->setFilter('public', 1)->getList();
        return count($arts);
    }

    /**
     * Возвращает минимальную стоимость картины одного автора
     * @return mixed
     */
    public function getMinCost()
    {
        $user = $this->owner;
        $product_api = new \Catalog\Model\Api();
        $products = $product_api->setFilter('owner', $user['id'])->getList();
        $price = [];
        foreach ($products as $product){
            /**
             * @var \Catalog\Model\Orm\Product $product
             */
            if($product->getCost()) {
                $price[] =  (int)str_replace(' ', '', $product->getCost());
//                array_push($price,  $product->getCost());
            }
        }
        return number_format(min($price), 0, ".", ' ');
    }

    /**
     * Возвращает тэги для автора - темы, стиль, материал работ
     * @param bool $limit - сколько вывести тэгов
     * @return array
     */
    public function getTags($limit = false)
    {
        $user = $this->owner;
        $product_api = new \Catalog\Model\Api();
        $products = $product_api->setFilter('owner', $user['id'])->getList();
        $tags = [];
        foreach ($products as $product){
            /**
             * @var \Catalog\Model\Orm\Product $product
             */
            if($product->getPropValue('theme')){
                $tags[] = $product->getPropValue('theme');
            }
            if($product->getPropValue('style')){
                $tags[] = $product->getPropValue('style');
            }
            if($product->getPropValue('material')){
                $tags[] = $product->getPropValue('material');
            }
            $tags = array_unique($tags);
        }
        if($limit){
            return array_slice($tags, 0, $limit);
        }
        return $tags;
    }

    /**
     * Возвращает картины автора
     * @param $limit - сколько картин показать
     * @return array - ['arts'] - объекты картин, ['count'] - число картин, ['lost'] - если присутствует $limit сколько картин осталось еще (котороые не отображены)
     */
    public function getArts($limit = false)
    {
        $user = $this->owner;
        $product_api = new \Catalog\Model\Api();
        $products = $product_api->setFilter('owner', $user['id'])->setFilter('public', 1)->getList();
        $return = [];
        if($products){
            $return['arts'] = $products;
            $return['count'] = count($products);
            $return['lost'] = 0;
            if($limit){
                $return['arts'] = array_slice($products, 0, $limit);
                $return['lost'] = count($products) - $limit;
            }
        }
        return $return;
    }

    public function changeLocationAllArts()
    {
        $user = $this->owner;
        $product_api = new \Gallerist\Model\PictureApi();
        $arts = $product_api->setFilter('owner', $user['id'])->getList();
        if(count($arts)){
            foreach ($arts as $art) {
                $art->update();
            }
        }
    }

    /**
     * Проверяет есть ли автор с одинаковой Фамилией и Именем
     * @return bool
     */
    public function checkTheSameNameAndSurname(){
        $orm = $this->owner;
        $same = \RS\Orm\Request::make()
            ->from(new \Users\Model\Orm\User())
            ->where([
                'name' => $orm['name'],
                'surname' => $orm['surname']
            ])->exec()->fetchAll();
        if(count($same)){
            return count($same);
        }
        return false;
    }
}


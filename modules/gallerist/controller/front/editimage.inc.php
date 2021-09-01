<?php

namespace gallerist\Controller\Front;

use Catalog\Model\Api as ProductApi;
use Catalog\Model\DirApi;
use RS\Config\Loader as ConfigLoader;
use RS\Controller\Front;

/**
 * Фронт контроллер
 */
class EditImage extends Front
{
    protected $id;
    public $product_api;
    public $config;

    function init()
    {
        $this->id     = $this->url->get('id', TYPE_STRING);
        $this->product_api    = new ProductApi();
        $this->config = ConfigLoader::byModule($this);
    }

    function actionIndex()
    {
        $user = \RS\Application\Auth::getCurrentUser();
        $is_auth = \RS\Application\Auth::isAuthorize();
        $success = false;
        $item = $this->product_api->getById($this->id);
        if($is_auth && $item['owner'] == $user['id']){
            $success = true;
        }
        if($success){
            $this->view->assign('art', $item);
        }
        $this->view->assign('success', $success);
        return $this->result->setTemplate('editimage.tpl');
    }

    public function actionSaveEditedImage()
    {
        $src = $this->request('src', TYPE_STRING, '');
        $data = $this->request('file', TYPE_STRING, '');
        $extension = explode('.' ,$src);
        if (preg_match('/^data:image\/(\w+);base64,/', $data, $type)) {

            $data = substr($data, strpos($data, ',') + 1);
            $type = strtolower($type[1]); // jpg, png, gif

            if (!in_array($type, [ 'jpg', 'jpeg', 'gif', 'png' ])) {
                throw new \Exception('invalid image type');
            }
            $data = str_replace( ' ', '+', $data );
            $data = base64_decode($data);

            if ($data === false) {
                throw new \Exception('base64_decode failed');
            }
        } else {
            throw new \Exception('did not match data URI with image data');
        }
        $path = substr($extension[0], 1);
        $success = file_put_contents("{$path}.{$type}", $data);
        if($extension[1] != 'png'){
            $image = imagecreatefrompng("{$path}.{$type}");
            imagejpeg($image, "{$path}.{$extension[1]}", 100);
            imagedestroy($image);
            @unlink("{$path}.{$type}");
        }
        $this->result->addSection('success', $success);
        $this->result->addSection('file', $src);
        return $this->result;
    }
}

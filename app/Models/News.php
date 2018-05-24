<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use App\Models\UserModel;
use Illuminate\Http\Request;

use Encore\Admin\Form;
use Encore\Admin\Grid;

class News extends Model
{
    protected $table = 'news';

    protected $expire_at;

    protected $primaryKey = "id";        //指定主键

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'author_id', 'title', 'content', 'status', 'visited','displayorder',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [

    ];

    public function __construct(array $attributes = [])
    {

        parent::__construct($attributes);
    }

    public function getRow($id)
    {
        if (!$id) {
            return false;
        }
        return $this->where(['id'=>$id,'status'=>'ACTIVE'])->first();
    }

    public function createNews($data) 
    {
        return $this->insert([
            'author_id'     => (int) $data['author_id'], 
            'category_id'   => (int) $data['category_id'], 
            'title'         => (string) $data['title'], 
            'description'   => (string) $data['description'],
            'content'       => (string) $data['content'], 
            'status'        => (string) $data['status'],
            'visited'       => 0,
        ]);
    }

    // 保存提交的form数据
    // public function save(array $options = [])
    // {
    //     $attributes = $this->getAttributes();

    //     foreach ($attributes as $key => &$value) {
    //         if(is_string($value) || empty($value)) {
    //             $attributes[$key] = (string) $value;
    //         } 
    //     }

    //     if(!isset($attributes['id'])) {
    //         return $this->createNews($attributes);
    //     }

    //     $id = $attributes['id'];
    //     unset($attributes['id']);
    //     return $this->where('id', '=', $id)->update($attributes);
    // }

    public function getList($cond, $page = 1, $pageSize = 10)
    {   
        $field = ['id','title','description','author_id','created_at'];
        return $this->where($cond)->orderBy('created_at','desc')->paginate($pageSize, $field, 'page', $page);
    }

    public function user()
    {
        return $this->hasOne(UserModel::class, 'id', 'author_id');
    }

    public static function grid($callback)
    {
        return new Grid(new static, $callback);
    }

    public static function form($callback)
    {
        return new Form(new static, $callback);
    }
}

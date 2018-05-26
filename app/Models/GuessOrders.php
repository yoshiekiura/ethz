<?php

namespace App\Models;

use App\Models\BaseModel as Model;
use App\User;
use App\Models\CurrencyModel;

class GuessOrders extends Model
{
	protected $table = 'guess_orders';

    protected $primaryKey = "id";        //指定主键

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'currency', 'guess_id', 'expect_price', 'amount',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [

    ];

    /**
     * Log belongs to users.
     *
     * @return BelongsTo
     */
    public function user()
    {
        return $this->hasOne(User::class, 'id','uid');
    }

    /**
     * Log belongs to users.
     *
     * @return BelongsTo
     */
    public function currencyTo()
    {
        return $this->hasOne(CurrencyModel::class, 'id', 'currency');
    }

    public function updateGuess($cond, $saveData)
    {
        if(empty($cond) || empty($saveData)) {
            return null;
        }

        return $this->where($cond)->update($saveData);
    }

    public function createGuess($data) 
    {
        $this->fillable(array_keys($data));
        $id = $this->insertGetId($data);
        if($id > 0) {
            return $id;
        } else {
            return null;
        }
    }

    // 保存提交的form数据
    public function save(array $options = [])
    {
        $attributes = $this->getAttributes();

        if(!isset($attributes['id'])) {
            return $this->createGuess($attributes);
        }

        $id = $attributes['id'];
        unset($attributes['id']);
        $this->updateGuess(['id' => $id], $attributes);
    }
}

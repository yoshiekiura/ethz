<?php

namespace App\Models;

use App\Models\BaseModel as Model;
use App\User;
use App\Models\CurrencyModel;

// 竞猜涨跌
class GuessOrdersRose extends Model
{
	protected $table = 'guess_orders_rose';

    protected $primaryKey = "id";        //指定主键

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'currency', 'guess_id', 'betting', 'amount', 'is_win',
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

    public function guess()
    {
        return $this->hasOne(Guess::class, 'id', 'guess_id');
    }

    public function updateOrder($cond, $saveData)
    {
        if(empty($cond) || empty($saveData)) {
            return null;
        }

        return $this->where($cond)->update($saveData);
    }

    public function createOrder($data) 
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

    public function getOrderGroup($guess_id)
    {
        if(empty($guess_id)) {
            return null;
        }
        $riseTotal = $this->where(['guess_id' => $guess_id, 'betting' => '1'])->sum('amount');
        $flatTotal = $this->where(['guess_id' => $guess_id, 'betting' => '0'])->sum('amount');
        $fallTotal = $this->where(['guess_id' => $guess_id, 'betting' => '-1'])->sum('amount');

        return [
            'rise' => (float) $riseTotal,
            'flat' => (float) $flatTotal,
            'fall' => (float) $fallTotal
        ];
    }
}

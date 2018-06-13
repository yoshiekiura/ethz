<?php

namespace App\Models;

use App\User;
use App\Models\Guess;
use App\Models\CurrencyModel;
use App\Models\BaseModel as Model;

class GuessItems extends Model
{
	protected $table = 'guess_items';

    protected $primaryKey = "id";        //指定主键

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'guess_id', 'open_price', 'last_price', 'start_time', 'end_time', 'sum_amount', 'number', 'status', 'is_reward', 'betting',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [

    ];

    /**
     * Log belongs to guess.
     *
     * @return BelongsTo
     */
    public function guess()
    {
        return $this->hasOne(Guess::class, 'id', 'guess_id');
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

    public function updateItems($cond, $saveData)
    {
        if(empty($cond) || empty($saveData)) {
            return null;
        }

        return $this->where($cond)->update($saveData);
    }

    public function createItems($data) 
    {
        $this->fillable(array_keys($data));
        $id = $this->insertGetId($data);
        if($id > 0) {
            return $id;
        } else {
            return null;
        }
    }
}

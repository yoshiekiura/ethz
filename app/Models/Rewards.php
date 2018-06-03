<?php

namespace App\Models;

use App\Models\BaseModel as Model;
use App\User;
use App\Models\CurrencyModel;

class Rewards extends Model
{
	protected $table = 'rewards';

    protected $primaryKey = "id";        //指定主键

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'uid', 'target_user', 'amount', 'rewardable_type', 'rewardable_id',
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
    public function target()
    {
        return $this->hasOne(User::class, 'id','target_user');
    }

    public function createReward($data) 
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

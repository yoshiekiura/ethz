<?php

namespace App\Models;

use App\Models\BaseModel as Model;
use App\User;
use App\Models\CurrencyModel;

class UserInvit extends Model
{
	protected $table = 'users_invit';

    protected $primaryKey = "id";        //指定主键

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'uid', 'first_uid', 'second_uid',
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
}

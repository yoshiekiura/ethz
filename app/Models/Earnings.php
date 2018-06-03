<?php

namespace App\Models;

use App\User;
use Illuminate\Database\Eloquent\Model;

class Earnings extends Model
{

    protected $table = 'earnings';

    protected $primaryKey = 'id';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'currency', 'sum_amount', 'amount', 'reward', 'target_id',
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

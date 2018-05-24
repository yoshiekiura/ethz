<?php

namespace App\Models;

use Encore\Admin\Traits\AdminBuilder;
use App\User;
use Encore\Admin\Traits\ModelTree;
use Illuminate\Database\Eloquent\Model;

class UserInvit extends Model
{
    use ModelTree, AdminBuilder;
    protected $table = 'users_invit';

    protected $primaryKey = 'uid';

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

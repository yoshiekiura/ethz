<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Relations\BelongsTo;

use App\Models\BaseModel as Model;
use App\Models\CurrencyModel;
use App\User;

class DepositsAddressesRelated extends Model
{
	protected $table = 'deposits_addresses_related';

    protected $primaryKey = "id";        //指定主键

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'uid', 'address_id', 'currency'
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [

    ];

    public function user()
    {
        $data= $this->hasOne('App\User','id','uid');
        return $data;
    }

    public function getByUid($uid)
    {
        $row = $this->where(['uid'=>$uid,'status'=>1])->first();
        if ($row) {
            return $row->toArray();
        }

        return false;
    }

    /**
     * Log belongs to users.
     *
     * @return BelongsTo
     */
    public function currencyTo()
    {
        return $this->hasOne(CurrenciesModel::class, 'currency');
    }

    public function createAddress($data) 
    {
        if(empty($data)) {
            return null;
        }

        return $this->insertGetId([
            'uid'        => (int) $data['uid'], 
            'currency'   => (int) $data['currency'], 
            'address_id' => (int) $data['address_id'], 
            'status'     => 1,
        ]);
    }

    /**
     * 设置全局货币ID
     * @param [type] $currency [description]
     */
    public function setCurrency($currency)
    {
        $this->currency = $currency;
        return $this;
    }

    /**
     * 获取货币ID
     * @return [type] [description]
     */
    public function getCurrency()
    {
        return $this->currency;
    }

    public function getInfo($id) 
    {
        if(empty($id)) {
            return null;
        }

        return $this->where('id', '=', $id)->first();
    }

    /**
     * 获取所有充值地址
     * @param  [type] $uid [description]
     * @return [type]      [description]
     */
    public function getListByUid($uid, $page, $pageSize = 10)
    {
        if(empty($uid)) {
            return null;
        }

        $cond['uid'] = $uid;
        return $this->where($cond)->orderByDesc('id')->simplePaginate($pageSize, ['*'], 'page', $page);
    }

    public function getInfoByUid($uid)
    {
        if(empty($uid)) {
            return null;
        }

        return $this->where([
            'uid'      => (int) $uid,
            'currency' => (int) $this->getCurrency(),
            'status'   => 1,
        ])->first();
    }

}

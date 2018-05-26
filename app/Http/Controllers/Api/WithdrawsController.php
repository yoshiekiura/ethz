<?php

declare(strict_types=1);

/*
 * +----------------------------------------------------------------------+
 * |                          ThinkSNS Plus                               |
 * +----------------------------------------------------------------------+
 * | Copyright (c) 2017 Chengdu ZhiYiChuangXiang Technology Co., Ltd.     |
 * +----------------------------------------------------------------------+
 * | This source file is subject to version 2.0 of the Apache license,    |
 * | that is bundled with this package in the file LICENSE, and is        |
 * | available through the world-wide-web at the following url:           |
 * | http://www.apache.org/licenses/LICENSE-2.0.html                      |
 * +----------------------------------------------------------------------+
 * | Author: Slim Kit Group <master@zhiyicx.com>                          |
 * | Homepage: www.thinksns.com                                           |
 * +----------------------------------------------------------------------+
 */

namespace Zhiyi\Plus\Http\Controllers\APIs\V3;

use Illuminate\Http\Request;
use Zhiyi\Plus\Services\Transfer;
use Zhiyi\Plus\Services\CurrenciesWithdraws;
use Zhiyi\Plus\Models\MtsCurrencis;
use Zhiyi\Plus\Models\User;
use Zhiyi\Plus\Http\Controllers\APIs\V2\ApiController;
use function App\Lib\my_number_format;

class WithdrawsController extends ApiController
{

    /**
     * 创建提款地址.
     *
     * @param StoreCurrencyRecharge $request
     * @return mixed
     * @author BS <414606094@qq.com>
     */
    public function store(Request $request)
    {
        $code = $request->code;
        $address = $request->address;
        $amount = $request->amount;
        $remark = $request->remark;
        $fee = $request->fee;
        $user = $this->getUser();

        if(empty($user)) {
            return $this->setStatusCode(400)->responseError('请登录');
        }

        if(empty($address)) {
            return $this->setStatusCode(400)->responseError('请输入转账地址');
        }

        if(empty($code)) {
            return $this->setStatusCode(400)->responseError('缺少虚拟币编码');
        }

        if(empty($amount)) {
            return $this->setStatusCode(400)->responseError('请输入提现金额');
        }

        if(empty($fee)) {
            return $this->setStatusCode(400)->responseError('请输入手续费');
        }

        $params = [
            'address' => $address,
            'amount' => $amount,
            'fee' => $fee,
            'remark' => $remark,
            'code' => $code,
        ];

        $result = $this->getCurrenciesWithdraws()->apply($user->id, $params);

        if (!empty($result)) {
            $data['id'] = $result;
            $data['type'] = 'out';
            return $this->setStatusCode(200)->responseSuccess($data);
        }

        return $this->setStatusCode(400)->responseError('操作失败');
    }

    private function getCurrenciesWithdraws()
    {
        return new CurrenciesWithdraws();
    }]

}

<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Services\DepositsAddresses;
use App\Http\Controllers\ApiController as Controller;

class DepositsController extends Controller
{

    // 充值地址查询
    public function address(Request $request)
    {
        $code = $request->input('code', 'ETH');

        if(empty($this->uid)) {
            return $this->setStatusCode(400)->responseNotFound('请先登录');
        }
        if(empty($code)) {
            return $this->setStatusCode(400)->responseNotFound('缺少货币编码');
        }
        $code = strtoupper($code);

        $address = $this->getDepositsAdress()->getUserAddress($this->uid, $code);
        if(isset($address->id)) {
            return $this->setStatusCode(200)->responseSuccess($address, 'success');
        } else {
            return $this->setStatusCode(404)->responseNotFound('生成错误');
        }
    }

    private function getDepositsAdress()
    {
        return new DepositsAddresses();
    }
}

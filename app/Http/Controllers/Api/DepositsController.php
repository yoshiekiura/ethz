<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Services\DepositsAddresses;
use App\Models\DepositsOrdersModel as DepositsOrders;
use App\Http\Controllers\ApiController as Controller;
use QrCode;

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
            $address->qrcodeUrl = env('APP_URL') . '/api/v1/deposits/qrcode?text=' . $address->address;
            return $this->setStatusCode(200)->responseSuccess($address, 'success');
        } else {
            return $this->setStatusCode(404)->responseNotFound('生成错误');
        }
    }

    public function qrcode(Request $request)
    {
        $text = $request->text;
        if(!empty($text)) {
            return QrCode::format('png')->size(500)->generate($text);
        }
    }

    public function list(Request $request)
    {
        $limit = $request->input('limit', '10');
        $sinceId = $request->input('sinceId');

        if(is_numeric($sinceId) && $sinceId == 0) {
            $this->setStatusCode(404)->responseError('查无数据');
        }

        $user = $this->getUser();

        $builders = with(new DepositsOrders())->setHidden([])->newQuery();

        if($sinceId > 0) {
            $builders->where('id', '<', $sinceId);
        }

        $orders = $builders->where('uid', $user->id)->orderBy('id', 'DESC')->limit($limit)->get();

        if($orders->isEmpty()) {
            return $this->setStatusCode(403)->responseError('查无数据');
        }

        $lastId = 0;
        $datas['list'] = $orders->map(function ($order) use (&$lastId) {
            $order->load('currencyTo');
            $order->code = $order->currencyTo->code;
            unset($order->currencyTo);
            $lastId = $order->id;
            return $order;
        });
        $datas['lastId'] = $lastId;

        return $this->responseSuccess($datas, 'success');
    }

    public function show(Request $request, DepositsOrders $order)
    {
        return $order->getConnection()->transaction(function () use ($order){
            $order->amount = (float) $order->amount;
            $order->tx_url = 'https://etherscan.io/tx/' . $order->txid;
            $order->address_url = 'https://etherscan.io/address/' . $order->address;

            return $this->responseSuccess($order, 'success');
        });
    }

    private function getDepositsAdress()
    {
        return new DepositsAddresses();
    }
}

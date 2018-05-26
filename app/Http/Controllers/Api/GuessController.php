<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Controllers\ApiController as Controller;
use App\Http\Resources\GuessResource;
use App\Models\Guess;
use App\Models\GuessOrders;
use App\Services\Guess as GuessSer;


class GuessController extends Controller
{
    public function index(Request $request)
    {
        $builder = with(new Guess())->setHidden([])->newQuery();
        $guess = $builder->where('status', 1)->get();

        if($guess->isEmpty()) {
            $this->setStatusCode(404)->responseError('查无数据');
        }

        $list = array();
        foreach ($guess as $key => $item) {
            $data = new GuessResource($item);
            $list[$key] = $data->toArray($data->resource);
        }

        return $this->responseSuccess(['list' => $list], 'success');
    }

    public function show(Request $request, Guess $guess)
    {
        $data = new GuessResource($guess);
        $data = $data->toArray($data->resource);
        $data['currency'] = 1;
        $data['last'] = rand(1000, 9999);
        return $this->responseSuccess($data, 'success');
    }

    public function attendance(Request $request)
    {
        $guessId = $request->input('guess_id');
        $sinceId = $request->input('sinceId', 0);
        $limit = $request->input('limit', 20);

        if(empty($guessId)) {
            $this->setStatusCode(404)->responseError('缺少ID');
        }

        $data['list'] = array(
            ['uid' => 1, 'name' => 'Jack', 'createdAt' => date('Y-m-d'), 'price' => rand(1000, 9999), 'amount' => rand(1, 100)],
            ['uid' => 2, 'name' => 'Red', 'createdAt' => date('Y-m-d'), 'price' => rand(1000, 9999), 'amount' => rand(1, 100)],
            ['uid' => 3, 'name' => 'Ken', 'createdAt' => date('Y-m-d'), 'price' => rand(1000, 9999), 'amount' => rand(1, 100)],
            ['uid' => 4, 'name' => 'Make', 'createdAt' => date('Y-m-d'), 'price' => rand(1000, 9999), 'amount' => rand(1, 100)],
        );
        return $this->responseSuccess($data, 'success');
    }

    public function guess(Request $request, Guess $guess)
    {
        if(empty($this->uid)) {
            $this->setStatusCode(404)->responseError('请先登录');
        }

        $number = $request->input('number');
        $price = $request->input('price');
        $user = $this->getUser();

        if(empty($number)) {
            $this->setStatusCode(404)->responseError('请输入投注数');
        }

        if(empty($price)) {
            $this->setStatusCode(404)->responseError('请输入竞猜价格');
        }

        $amount = bcmul($guess->expect_price, $number);
        $order = json_encode(['price' => $price, 'amount' => $amount]);
        $order = json_decode($order);

        $orderId = with(new GuessSer())->order($user, $guess, $order);

        if($orderId > 0) {
            return $this->responseSuccess(['id' => $orderId], 'success');
        } else {
            $this->setStatusCode(404)->responseError('竞猜失败');
        }
    }
}


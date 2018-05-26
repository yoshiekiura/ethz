<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Controllers\ApiController as Controller;
use App\Http\Resources\GuessResource;
use App\Models\Guess;
use App\Models\GuessOrders;


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
        $amount = $request->input('amount');
        $price = $request->input('price');

        $id = GuessOrders::create([
            'uid' => $this->uid??0,
            'guess_id' => $guess->id,
            'currency' => 1,
            'expect_price' => $price,
            'amount' => $amount,
        ]);

        return $this->responseSuccess($id, 'success');
    }
}


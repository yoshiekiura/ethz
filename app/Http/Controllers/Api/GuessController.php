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
            $list[] = $data->toArray($data->resource);
        }

        return $this->responseSuccess(['list' => $list], 'success');
    }

    public function show(Request $request, Guess $guess)
    {
        $data = new GuessResource($guess);
        $data = $data->toArray($data->resource);
        $data['currency'] = 1;
        $data['last'] = rand(1000, 9999);
        $data['unit'] = '0.01';
        return $this->responseSuccess($data, 'success');
    }

    public function showNew(Request $request)
    {
        $model = new Guess();
        $guess = $model->orderBy('id', 'DESC')->first();
        $data = new GuessResource($guess);
        $data = $data->toArray($data->resource);
        $data['currency'] = 1;
        $data['last'] = rand(1000, 9999);
        $data['unit'] = '0.01';
        return $this->responseSuccess($data, 'success');
    }

    public function attendance(Request $request)
    {
        $guessId = $request->input('guess_id');
        $sinceId = $request->input('sinceId', 0);
        $limit = $request->input('limit', 20);

        if(empty($guessId)) {
            return $this->setStatusCode(404)->responseError('缺少ID');
        }

        $builders = with(new GuessOrders())->setHidden([])->newQuery();

        if($sinceId > 0) {
            $builders->where('id', '<', $sinceId);
        }

        $items = $builders->where('guess_id', $guessId)->orderBy('id', 'DRSC')->get();

        if($items->isEmpty()) {
            return $this->setStatusCode(403)->responseError('查无数据');
        }
        
        $data['list'] = [];
        foreach ($items as $key => $item) {
            $data['list'][$key]['id'] = $item->id;
            $data['list'][$key]['uid'] = $item->uid;
            $data['list'][$key]['name'] = $item->user->name;
            $data['list'][$key]['createdAt'] = (string) $item->created_at;
            $data['list'][$key]['avatar'] = env('APP_URL') . "/avatars/avatar_".$item->user->avatar.".png";
            $data['list'][$key]['price'] = my_number_format($item->expect_price, 4);
            $data['list'][$key]['amount'] = my_number_format($item->amount, 4);
        }
        if(!empty($data['list'])) {
            $last = end($data['list']);
            $data['last'] = $last['id'];
        }
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


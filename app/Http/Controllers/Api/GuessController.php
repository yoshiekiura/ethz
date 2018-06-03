<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Controllers\ApiController as Controller;
use App\Http\Resources\GuessResource;
use App\Models\Guess;
use App\Models\GuessOrders;
use App\Models\UserModel;
use App\Services\Guess as GuessSer;
use App\Services\Rewards;


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

        if($guessId == 'current') {
            $guess = with(new Guess())->orderBy('id', 'DESC')->first();
            if(isset($guess->id)) {
                $guessId = $guess->id;
            }
        }

        $builders = with(new GuessOrders())->setHidden([])->newQuery();

        if($sinceId > 0) {
            $builders->where('id', '<', $sinceId);
        }

        $items = $builders->where('guess_id', $guessId)->orderBy('is_win', 'DESC')->orderBy('id', 'DRSC')->limit($limit)->get();

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
            $data['list'][$key]['price'] = (int) my_number_format($item->expect_price, 4);
            $data['list'][$key]['amount'] = my_number_format($item->amount, 4);
            if($item->is_win == 0) {
                $data['list'][$key]['price'] = substr_replace($data['list'][$key]['price'], "**", 3, 1);
            }
            $data['list'][$key]['is_win'] = $item->is_win;
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
            return $this->setStatusCode(404)->responseError('请先登录');
        }

        $number = 1;
        // $number = $request->input('amount');
        $price = $request->input('price');
        $user = $this->getUser();

        // if(empty($number)) {
        //     $this->setStatusCode(404)->responseError('请输入投注数');
        // }

        if(empty($price)) {
            return $this->setStatusCode(404)->responseError('请输入竞猜价格');
        }


        if(!preg_match('/^[0-9]+(.[0-9]{1,})?$/', $price)) {
            return $this->setStatusCode(404)->responseError('竞猜价格必须为数字');
        }

        $amount = $guess->expect_price*$number;
        $order = json_encode(['price' => $price, 'amount' => $amount]);
        $order = json_decode($order);

        $orderId = with(new GuessSer())->order($user, $guess, $order);

        if($orderId > 0) {
            // 一级邀请奖励
            with(new Rewards())->doReward($amount, 1, $user, $guess);

            // 二级奖励
            if($user->invite_uid > 0) {
                $inviteUser = UserModel::find($user->invite_uid);
                with(new Rewards())->doReward($amount, 2, $inviteUser, $guess);
            }

            return $this->responseSuccess(['id' => $orderId], 'success');
        } else {
            return $this->setStatusCode(404)->responseError('竞猜失败');
        }
    }
}


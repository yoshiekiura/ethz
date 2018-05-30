<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Controllers\ApiController as Controller;
use App\Models\Guess;
use App\Models\GuessOrders;


class RewardsController extends Controller
{
    public function index(Request $request)
    {
        $price = 5000;

        $rdate = date('Y-m-d H:i:s');
        $cond = [
            ['open_time', '<=', $rdate],
        ];
        $cond['is_reward'] = 0;

        $builders = with(new Guess())->setHidden([])->newQuery();
        $guess = $builders->where($cond)->orderBy('id', 'DESC')->first();

        if(empty($guess->id)) {
            return $this->setStatusCode(403)->responseError('查无数据');
        }

        $orders = GuessOrders::where('guess_id', $guess->id)->get();

        $rewards = [];
        $orders->map(function($order) use (&$rewards, $price){
            $order->reward = abs($price - $order->expect_price);
            $rewards[$order->id] = $order->toArray();
        });
        array_multisort(array_column($rewards,'reward'), SORT_ASC, $rewards);

        // asort($rewards);

        $open = current($rewards);
        prev($rewards);

        $wins = array();
        foreach ($rewards as $key => $value) {
            if($value['reward'] == $open['reward']) {
                $wins[] = $value;
            }
        }
        array_multisort(array_column($wins, 'created_at'), SORT_ASC, $wins);

        $last = current($wins);

        // 最终胜出者
        $order = GuessOrders::find($last['id']);
        $order->is_win = 1;
        $order->save();

        $guess->is_reward = 1;
        $guess->save();

        return $this->responseSuccess('更新成功');
    }
}


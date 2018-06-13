<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Controllers\ApiController as Controller;
// use App\Http\Resources\GuessResource;
use App\Models\Guess;
use App\Models\GuessItems;
use App\Services\Coins;


class ItemsController extends Controller
{
    public function index(Request $request)
    {
        // return 111;
        $builder = with(new Guess())->setHidden([])->newQuery();
        $guess = $builder->where('status', 1)->orderBy('id', 'desc')->first();

        if(!isset($guess->id)) {
            return $this->setStatusCode(404)->responseError('查无数据');
        }

        $guessItemsModel = new GuessItems();
        $ctime = time();

        // 查询当前最新活动
        $currentGuess = $guessItemsModel->where('status', 1)->orderBy('id', 'DESC')->first();
        if(isset($currentGuess->id) && $currentGuess->end_time > $ctime) {
            return $this->setStatusCode(202)->responseError('活动正在进行中');
        }

        $minute = intval(date('i')/10)*$guess->interval;
        // $endMinute = $minute + $guess->interval;
        $start_time = strtotime(date("Y-m-d H:{$minute}:00"));
        $end_time = intval($start_time) + ($guess->interval * 60);

        $ticker = with(new Coins())->ticker('eth_usdt');
        $itemsId = $guessItemsModel->createItems([
            'guess_id' => $guess->id,
            'open_price' => $ticker['last'],
            'last_price' => 0,
            'start_time' => $start_time,
            'end_time' => $end_time,
            'sum_amount' => 0,
            'number' => 0,
            'status' => 1,
            'betting' => NULL,
            'is_reward' => 0,
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s'),
        ]);

        $items = $guessItemsModel->find($itemsId);

        return $this->responseSuccess($items, 'success');
    }
}


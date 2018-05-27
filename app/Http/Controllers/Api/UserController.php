<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Controllers\ApiController as Controller;
use App\Http\Resources\GuessResource;
use App\Models\Guess;


class UserController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $user->earnings_count = 9998;
        $user->avatar = env('APP_URL') . "/avatars/avatar_".intval($user->avatar).".png";
        $user->wallet = array(['code' => 'eth', 'amount' => 2000]);
        return $this->responseSuccess($user, '查询成功');
    }

    public function items(Request $request)
    {
    	$data['list'] = [
    		[
    			'item_title' => '项目名',
    			'item_rdate' => date('Y-m-d'),
    			'item_price' => rand(1000, 9999),
    			'item_amount' => rand(1, 100),
    			'item_code' => 'eth',
    		],
    		[
    			'item_title' => '项目名2',
    			'item_rdate' => date('Y-m-d'),
    			'item_price' => rand(1000, 9999),
    			'item_amount' => rand(1, 100),
    			'item_code' => 'eth',
    		]
    	];
    	$data['lastId'] = 1;
    	return $this->responseSuccess($data, '查询成功');
    }



    public function friends(Request $request)
    {
        $sinceId = $request->input('sinceId', 0);
        $limit = $request->input('limit', 20);

        $data['list'] = array(
            ['uid' => 1, 'name' => 'Jack', 'createdAt' => date('Y-m-d'),  'avatar' => env('APP_URL') . "/avatars/avatar_".rand(1, 8).".png"],
            ['uid' => 2, 'name' => 'Red', 'createdAt' => date('Y-m-d'),  'avatar' => env('APP_URL') . ("/avatars/avatar_".rand(1, 8).".png")],
            ['uid' => 3, 'name' => 'Ken', 'createdAt' => date('Y-m-d'),  'avatar' => env('APP_URL') . ("/avatars/avatar_".rand(1, 8).".png")],
            ['uid' => 4, 'name' => 'Make', 'createdAt' => date('Y-m-d'),  'avatar' => env('APP_URL') . ("/avatars/avatar_".rand(1, 8).".png")],
        );
        $data['lastId'] = 4;
        return $this->responseSuccess($data, 'success');
    }
}


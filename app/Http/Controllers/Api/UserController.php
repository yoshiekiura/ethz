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
}


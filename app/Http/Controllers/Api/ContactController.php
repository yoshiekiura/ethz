<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Controllers\ApiController as Controller;
use App\Http\Resources\GuessResource;
use App\Models\Guess;


class ContactController extends Controller
{
    public function index(Request $request)
    {
        $list = array(['name' => '微信号', 'value' => '333333']);
        return $this->responseSuccess(['list' => $list], 'success');
    }
}


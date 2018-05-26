<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Controllers\ApiController as Controller;
use App\Http\Resources\GuessResource;
use App\Models\Guess;


class FeedbackController extends Controller
{
    public function index(Request $request)
    {
    	$post = $request->all();
        return $this->responseSuccess($post, '提交成功');
    }
}


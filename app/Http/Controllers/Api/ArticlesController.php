<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Controllers\ApiController as Controller;
use App\Http\Resources\GuessResource;
use App\Models\News;


class ArticlesController extends Controller
{
    public function index(Request $request)
    {
        $builder = with(new News())->setHidden([])->newQuery();
        $guess = $builder->where('status', 1)->get();

        if($guess->isEmpty()) {
            $this->setStatusCode(404)->responseError('查无数据');
        }

        return $this->responseSuccess(['list' => $guess], 'success');
    }

    public function show(Request $request, News $news)
    {
        return $this->responseSuccess($news, 'success');
    }

    public function showByCode(Request $request)
    {
        $slug = $request->input('slug');
        if(empty($slug)) {
            $this->setStatusCode(404)->responseError('缺少参数');
        }

        $news = News::where('slug', $slug)->first();
        if($news->isEmpty()) {
            $this->setStatusCode(404)->responseError('查无数据');
        }

        return $this->responseSuccess($news, 'success');
    }
}


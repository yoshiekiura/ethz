<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Controllers\ApiController as Controller;
use App\Http\Resources\GuessResource;
use App\Models\Guess;
use App\Models\GuessOrders;
use App\Models\GuessOrdersRose;
use App\Models\UserModel;
use App\Models\AccountsModel;
use App\Services\Guess as GuessSer;
use App\Services\Rewards;
use App\Models\GuessItems;
use Hash;


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


    public function histories(Request $request)
    {

        $limit = $request->input('limit', '10');
        $sinceId = $request->input('sinceId');

        if(is_numeric($sinceId) && $sinceId == 0) {
            $this->setStatusCode(404)->responseError('查无数据');
        }

        $ctime = time();
        $ordersRoseNode = new GuessOrdersRose();
        $guessItems = with(new GuessItems())->setHidden([])->newQuery();

        $cond[] = ['end_time', '<', time()];
        if(!empty($sinceId)) {
            $cond[] = ['id', '<', $sinceId];
        }
        $items = $guessItems->where($cond)->orderBy('id', 'desc')->limit($limit)->get();

        $lastId = 0;
        $datas['list'] = $items->map(function ($item) use ($ordersRoseNode, $ctime, &$lastId){
            $item->load('guess');
            $item->title = $item->guess->title . " 第 {$item->id} 期 场次：{$item->guess->interval} 分钟";

            $item->open_price = my_number_format($item->open_price, 4);
            $item->last_price = my_number_format($item->last_price, 4);
            $item->sum_amount = my_number_format($item->sum_amount, 4);
            $itemBetting = $item->betting;

            $users['rise'] = $ordersRoseNode->where(['guess_id' => $item->guess_id,'betting' => 1])->count();
            $users['flat'] = $ordersRoseNode->where(['guess_id' => $item->guess_id,'betting' => 0])->count();
            $users['fall'] = $ordersRoseNode->where(['guess_id' => $item->guess_id,'betting' => -1])->count();
            $item->user = $users;

            $betting['rise'] = $ordersRoseNode->where(['guess_id' => $item->guess_id,'betting' => 1])->sum('amount');
            $betting['rise'] = my_number_format($betting['rise'], 4);
            $betting['flat'] = $ordersRoseNode->where(['guess_id' => $item->guess_id,'betting' => 0])->sum('amount');
            $betting['flat'] = my_number_format($betting['flat'], 4);
            $betting['fall'] = $ordersRoseNode->where(['guess_id' => $item->guess_id,'betting' => -1])->sum('amount');
            $betting['fall'] = my_number_format($betting['fall'], 4);
            $item->betting = $betting;

            $item->betting_win = '';
            if($itemBetting == 1) {
                $item->betting_win = 'rise';
            } else if ($itemBetting == 0) {
                $item->betting_win = 'flat';
            } else if ($itemBetting == -1) {
                $item->betting_win = 'fall';
            }

            if($item->start_time > $ctime) {
                $item->state = 'coming_soon';
            } else if ($item->start_time < $ctime && $ctime < $item->end_time) {
                $item->state = 'in_progress';
            } else {
                $item->state = 'completed';
            }

            if ($item->betting_win == 'rise') {
                $item->win_total = $item->user['rise'];
            } else if ($item->betting_win == 'flat') {
                $item->win_total = $item->user['flat'];
            } else if ($item->betting_win == 'fall') {
                $item->win_total = $item->user['fall'];
            }
            $item->open_time = date('Y-m-d H:i:s', $item->end_time);

            $lastId = $item->id;
            unset($item->created_at, $item->updated_at, $item->guess);
            return $item;
        });
        $datas['code'] = 'ETH';
        $datas['lastId'] = $lastId;

        return $this->responseSuccess($datas, 'success');
    }

    public function show(Request $request, Guess $guess)
    {
        $user = $request->user('api');
        $data = new GuessResource($guess);
        $data = $data->toArray($data->resource);
        $data['currency'] = 1;
        $data['last'] = rand(1000, 9999);
        $data['open'] = rand(1000, 9999);
        $data['expect'] = strtotime($guess->end_time) - strtotime($guess->start_time);

        if(isset($guess->id)) {
            $info = with(new GuessOrdersRose())->getOrderGroup($guess->id);
            $data['rise'] = $info['rise'];
            $data['flat'] = $info['flat'];
            $data['fall'] = $info['fall'];
        } else {
            $data['rise'] = $data['flat'] = $data['fall'] = 0;
        }

        $user = $request->user('api');
        $data['user'][$data['code']] = 0;
        if(isset($user->id)) {
            $accounts = with(new AccountsModel())->getListByUid($user->id);
            if(!empty($accounts)) {
                foreach ($accounts as $account) {
                    $data['user'][$account->currencyTo->code] = (float) $account->balance;
                }
            }

        }

        return $this->responseSuccess($data, 'success');
    }

    public function showNew(Request $request)
    {
        $this->getNewGuess();
        $ctime = time();
        $user = $request->user('api');
        $orderRose = with(new GuessOrdersRose());
        $accountsNode = with(new AccountsModel());
        $model = new GuessItems();
        $items = $model->where('status', '=', 1)->orderBy('id', 'DESC')->first();

        return $model->getConnection()->transaction(function () use ( $items, $user, $orderRose, $accountsNode, $ctime ) {
            $items->load('guess');
            $data['id'] = $items->id;
            $data['name'] = $items->id . ' 期';
            $data['period'] = $items->id;
            $data['number'] = $items->guess->number;
            $data['currency'] = $items->guess->currency;
            $data['sumAmount'] = my_number_format($items->guess->sum_amount,2);
            $data['last'] = my_number_format($items->last_price, 2);
            $data['open'] = my_number_format($items->open_price, 2);
            $data['openTime'] = date('Y-m-d H:i:s', $items->end_time);
            $data['startTime'] = date('Y-m-d H:i:s', $items->start_time);
            $data['endTime'] = date('Y-m-d H:i:s', $items->end_time);

            if(isset($items->guess->id)) {
                $data['expect'] = $items->guess->interval;
                $info = $orderRose->getOrderGroup($items->id);
                $data['rise'] = $info['rise'];
                $data['flat'] = $info['flat'];
                $data['fall'] = $info['fall'];
                $data['code'] = $items->guess->currencyTo->code;
                $data['user'][$items->guess->currencyTo->code] = 0;
            } else {
                $data['expect'] = 0;
                $data['rise'] = $data['flat'] = $data['fall'] = 0;
                $data['code'] = '';
                $data['user'] = [];
            }

            if($items->start_time > $ctime) {
                $data['state'] = 'coming_soon';
            } else if ($items->start_time < $ctime && $ctime < $items->end_time) {
                $data['state'] = 'in_progress';
            } else {
                $data['state'] = 'completed';
            }

            if(isset($user->id)) {
                $accounts = $accountsNode->getListByUid($user->id);
                if(!empty($accounts)) {
                    foreach ($accounts as $account) {
                        $data['user'][$account->currencyTo->code] = (float) $account->balance;
                    }
                }
            }

            return $this->responseSuccess($data, 'success');
        });
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

        if($guess->status == 0) {
            return $this->setStatusCode(404)->responseError('项目暂未开放');
        }

        $number = 1;
        // $number = $request->input('amount');
        $price = $request->input('price');
        $password = $request->input('password');
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

        $userInfo = UserModel::find($user->id);
        if(!Hash::check($password, $userInfo->password)) {
            return $this->setStatusCode(404)->responseError('登录密码错误');
        }

        $amount = $guess->unit_price*$number;
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

            return $this->responseSuccess(['id' => $orderId], '投注成功');
        } else {
            return $this->setStatusCode(404)->responseError('竞猜失败');
        }
    }

    public function betRose(Request $request, GuessItems $guess)
    {
        if(empty($this->uid)) {
            return $this->setStatusCode(404)->responseError('请先登录');
        }

        if($guess->status == 0) {
            return $this->setStatusCode(404)->responseError('暂未开放');
        }

        if($guess->end_time <= time()) {
            return $this->setStatusCode(404)->responseError('已结束');
        }

        if($guess->start_time > time()) {
            return $this->setStatusCode(404)->responseError('未开始');
        }

        $betting = $request->input('betting');
        $amount = $request->input('amount');
        $password = $request->input('password');
        $user = $this->getUser();

        if(empty($amount)) {
            $this->setStatusCode(404)->responseError('请输入投注数');
        }

        if(!preg_match('/^[0-9]+(.[0-9]{1,})?$/', $amount)) {
            return $this->setStatusCode(404)->responseError('竞猜价格必须为数字');
        }

        if(empty($betting)) {
            return $this->setStatusCode(404)->responseError('请输选择你投注选项');
        }

        if(!in_array($betting, ['rise', 'flat', 'fall'])) {
            return $this->setStatusCode(404)->responseError('投注类型不正确');
        }

        $userInfo = UserModel::find($user->id);
        if(!Hash::check($password, $userInfo->password)) {
            return $this->setStatusCode(404)->responseError('登录密码错误');
        }

        if($betting == 'rise') {
            $betting = 1;
        } else if($betting == 'flat') {
            $betting = 0;
        } else if($betting == 'fall') {
            $betting = -1;
        }

        $order = json_encode(['betting' => $betting, 'amount' => $amount]);
        $order = json_decode($order);

        $result = with(new GuessSer())->orderRose($user, $guess, $order);

        if(!isset($result['error'])) {
            return $this->responseSuccess(['id' => $result], '投注成功');
        } else {
            return $this->setStatusCode(404)->responseError($result['error']);
        }
    }

    public function attendanceRose(Request $request)
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

        $builders = with(new GuessOrdersRose())->setHidden([])->newQuery();

        if($sinceId > 0) {
            $builders->where('id', '<', $sinceId);
        }

        $items = $builders->where('item_id', $guessId)->orderBy('is_win', 'DESC')->orderBy('id', 'DRSC')->limit($limit)->get();

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
            $data['list'][$key]['betting'] = $item->betting == '0' ? 'flat' : ($item->betting == '1' ? 'rise' : 'fall');
            $data['list'][$key]['amount'] = my_number_format($item->amount, 4);
            $data['list'][$key]['is_win'] = $item->is_win;
        }
        if(!empty($data['list'])) {
            $last = end($data['list']);
            $data['last'] = $last['id'];
        }
        return $this->responseSuccess($data, 'success');
    }

    public function getNewGuess()
    {
        $client = new \GuzzleHttp\Client(['verify' => false]);
        $response = $client->request('POST', env('APP_URL') . '/api/v1/guess/items');
        $guess = json_decode((string)$response->getBody());
        return $guess;
    }
}


<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Controllers\ApiController as Controller;
use App\Models\Guess;
use App\Models\GuessOrders;
use App\Models\Rewards;
use App\Models\Earnings;
use App\Models\UsersEarnings;
use App\Models\AccountsModel;
use App\Models\AccountsDetailsModel;
use DB;


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

        $openTime = strtotime($guess->open_time);
        if($openTime < time()) {
            return $this->setStatusCode(403)->responseError('暂未开奖');
        }

        $guessOrdersBuilders = new GuessOrders();

        $orders = $guessOrdersBuilders->where('guess_id', $guess->id)->get();

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

        $rewardUser = current($wins);

        $rewards = new Rewards();
        $earnings = new Earnings();
        $usersEarnings = new UsersEarnings();
        $accountsModel = new AccountsModel();
        $detailsModel = new AccountsDetailsModel();
        DB::beginTransaction();
        try {

            // 最终胜出者
            $order = $guessOrdersBuilders->lockForUpdate()->find($rewardUser['id']);
            $order->is_win = 1;
            $order->updated_at = date('Y-m-d H:i:s');
            $order->save();

            $sumAmount = $guessOrdersBuilders->where('guess_id', $guess->id)->sum('amount');

            $usrAmount = bcmul($sumAmount, '0.8', 18);

            $siteAmount = bcsub($sumAmount, $usrAmount);

            $rewardAmount = $rewards->where('rewardable_id', $guess->id)->sum('amount');

            // 平台收益
            $earningsId = $earnings->insertGetId([
                "currency" => $guess->currency,
                "sum_amount" => $siteAmount,
                "reward" => $rewardAmount,
                "amount" => bcsub($siteAmount, $rewardAmount, 18),
                "target_id" => $guess->id,
                "updated_at" => date('Y-m-d H:i:s'),
                "created_at" => date('Y-m-d H:i:s')
            ]);

            // 用户收益
            $accountRest = $accountsModel->where([
                'currency' => $guess->currency,
                'uid' => $rewardUser['uid']
            ])->increment('balance', $usrAmount);

            $accounts = $accountsModel->setCurrency($rewardUser['currency'])->getAccountLock($rewardUser['uid']);

            // 用户收益详细
            $uenId = $usersEarnings->insertGetId([
                'uid' => $rewardUser['uid'],
                'currency' => $guess->currency,
                'amount' => $usrAmount,
                'rewardable_type' => 'guess',
                'rewardable_id' => $guess->id,
                "updated_at" => date('Y-m-d H:i:s'),
                "created_at" => date('Y-m-d H:i:s')
            ]);

            // 账户详情
            $detailId = $detailsModel->createDetail([
                'uid' => $rewardUser['uid'],
                'currency' => $guess->currency,
                'type' => 4,
                'change_balance' => $usrAmount,
                'balance' => $accounts->balance,
                'target_id' => $uenId,
                'remark' => "竞猜：{$usrAmount} {$guess->currencyTo->code}"
            ]);

            $guess->is_reward = 1;
            $guess->save();

            if($earningsId && $accountRest && $uenId && $detailId) {
                DB::commit();
                return $this->responseSuccess($detailId);
            } else {
                DB::rollback();
                return $this->setStatusCode(401)->responseError('奖励失败');
            }

        }catch (Exception $e) {
            DB::rollBack();
            return $this->setStatusCode(402)->responseError('奖励失败');
        }

        $this->setStatusCode(404)->responseError('奖励失败');
    }
}


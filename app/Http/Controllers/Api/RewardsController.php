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
use App\Models\GuessItems;
use App\Models\GuessOrdersRose;
use App\Services\Coins;
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

            $siteAmount = bcmul($sumAmount, $guess->change, 18);

            $usrAmount = bcsub($sumAmount, $siteAmount, 18);

            // $siteAmount = bcsub($sumAmount, $usrAmount);

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

    public function rose(Request $request)
    {
        $coins = new Coins();
        $ticker = $coins->ticker('eth_usdt');
        $price = $ticker['last'];

        $ctime = time();
        $cond = [
            ['end_time', '<=', $ctime],
        ];
        $cond['is_reward'] = 0;

        $builders = with(new GuessItems())->setHidden([])->newQuery();
        $items = $builders->where($cond)->orderBy('id', 'DESC')->first();

        if(empty($items->id)) {
            return $this->setStatusCode(403)->responseError('查无数据');
        }

        if($items->is_reward == 1) {
            return $this->setStatusCode(403)->responseError('已开奖');
        }

        $openTime = $items->end_time;
        if($openTime > time()) {
            return $this->setStatusCode(403)->responseError('暂未开奖');
        }

        $items->load('guess');
        $guess = $items->guess;
        $charges = $guess->charges/100;

        $betting = bccomp((string) $price, (string) $items->open_price);

        $guessOrdersBuilders = new GuessOrdersRose();

        $orders = $guessOrdersBuilders->where('item_id', $items->id)->get();

        $winning = 0;
        $rewardsAmount = 0;
        $rewardsOrders = [];
        $orders->map(function($order) use ($betting, &$rewardsAmount, &$winning, &$rewardsOrders){
            $order->is_win = bccomp((string) $betting, (string) $order->betting) == 0 ? 1 : 0;
            if($order->is_win == 1) {
                $winning += $order->amount;
                $rewardsOrders[] = $order;
            } else {
                $rewardsAmount += $order->amount;
            }
        });

        $ratios = [];
        $accountsModel = new AccountsModel();
        foreach($rewardsOrders as $raw) {
            $ratios[$raw->id] = $raw->amount / $winning;
            $accountsModel->setCurrency($guess->currency)->getAccount($raw['uid']);
        }

        $rewards = new Rewards();
        $earnings = new Earnings();
        $usersEarnings = new UsersEarnings();
        $detailsModel = new AccountsDetailsModel();
        DB::beginTransaction();
        try {

            $sumAmount = $guessOrdersBuilders->where('item_id', $items->id)->sum('amount');

            $siteAmount = bcmul((string) $rewardsAmount, (string) $charges, 18);

            $userAmount = bcsub((string) $rewardsAmount, (string) $siteAmount, 18);

            $trans = 0;
            $toAmount = 0;
            foreach ($rewardsOrders as $key => $rew) {
                $totalAmount = $rew->amount + ($userAmount * $ratios[$rew->id]);

                $accountRest = $accountsModel->where([
                    'currency' => $guess->currency,
                    'uid' => $rew['uid']
                ])->increment('balance', $totalAmount);

                 // 用户收益详细
                $uenId = $usersEarnings->insertGetId([
                    'uid' => $rew['uid'],
                    'currency' => $guess->currency,
                    'amount' => $totalAmount,
                    'rewardable_type' => 'guess_item',
                    'rewardable_id' => $rew->item_id,
                    "updated_at" => date('Y-m-d H:i:s'),
                    "created_at" => date('Y-m-d H:i:s')
                ]);

                $account = $accountsModel->setCurrency($guess->currency)->getAccountLock($rew['uid']);

                // 账户详情
                $detailId = $detailsModel->createDetail([
                    'uid' => $rew['uid'],
                    'currency' => $guess->currency,
                    'type' => 4,
                    'change_balance' => $totalAmount,
                    'balance' => $account->balance,
                    'target_id' => $rew['id'],
                    'remark' => "第 {$rew->item_id} 期竞猜奖励：{$totalAmount} {$guess->currencyTo->code}"
                ]);

                $res = $guessOrdersBuilders->where('id', $rew->id)->update([
                    'is_win' => 1,
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);

                if($accountRest && $uenId && $detailId && $res) {
                    $trans += 1;
                    $toAmount += ($userAmount * $ratios[$rew->id]);
                }
            }

            $rewardAmount = $rewards->where('rewardable_id', $guess->id)->sum('amount');

            $surplus = bcsub((string) $userAmount, (string) $toAmount, 18);

            $siteAmount = bcadd($surplus, $siteAmount, 18);

            // 平台收益
            $earningsId = $earnings->insertGetId([
                "currency" => $guess->currency,
                "sum_amount" => $siteAmount,
                "reward" => $rewardAmount,
                "amount" => bcsub($siteAmount, $rewardAmount, 18),
                "target_id" => $items->id,
                "updated_at" => date('Y-m-d H:i:s'),
                "created_at" => date('Y-m-d H:i:s')
            ]);

            $items->betting = $betting;
            $items->last_price = $price;
            $items->is_reward = 1;
            $items->status = 0;
            $items->updated_at = date('Y-m-d H:i:s');
            if($earningsId && count($rewardsOrders) == $trans && $items->save()) {
                DB::commit();
                return $this->responseSuccess($earningsId);
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


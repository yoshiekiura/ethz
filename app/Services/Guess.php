<?php

namespace App\Services;

use Illuminate\Support\Facades\Cookie;
use App\Services\BaseService;
use App\Models\UserModel;
use App\Models\AccountsModel;
use App\Models\GuessOrders;
use App\Models\AccountsDetailsModel as AccountsDetails;
use DB;

class Guess extends BaseService
{

    public function order($user, $guess, $order)
    {
        $detailsModel = $this->getAccountsDetails();
        $guessOrders = $this->getGuessOrders();
        $accountModel = $this->getAccounts();
        $accountModel->setCurrency($guess->currency)->getAccountLock($user->id);

        $amount = $order->amount;
        $price = $order->price;

        DB::beginTransaction();

        $account = $accountModel->setCurrency($guess->currency)->getAccountLock($user->id);

        $incrRes = $accountModel->where([
                    'uid' => $user->id ?? 0,
                    'currency' => $guess->currency,
                ])->decrement('balance', $amount);

        $orderId = $guessOrders->createGuess([
            'uid' => $user->id ?? 0,
            'guess_id' => $guess->id,
            'currency' => $guess->currency,
            'expect_price' => $price,
            'amount' => $amount,
        ]);

        $detailId = $detailsModel->createDetail([
            'uid' => $user->id,
            'currency' => $guess->currency,
            'type' => 3,
            'change_balance' => $amount,
            'balance' => bcadd($account->balance, $amount, 18),
            'target_id' => $orderId,
            'remark' => "竞猜：{$amount} {$guess->currencyTo->code}"
        ]);

        $incrNumber = $guess->increment('number', 1);
        $incrSum = $guess->increment('sum_amount', $amount);

        if($incrRes && $orderId && $detailId && $incrNumber && $incrSum) {
            DB::commit();
            return $orderId;
        } else {
            DB::rollback();
            return null;
        }

    }

    private function getAccounts()
    {
        return new AccountsModel();
    }

    private function getUserModel()
    {
        return new UserModel();
    }

    private function getAccountsDetails()
    {
        return new AccountsDetails();
    }

    private function getGuessOrders()
    {
        return new GuessOrders();
    }

}

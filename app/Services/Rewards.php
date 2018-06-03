<?php

namespace App\Services;

use App\Services\BaseService;

use App\Models\Rewards as RewardsModel;
use App\Models\UserInvit;
use App\Models\UserModel;
use App\Models\AccountsModel;
use App\Models\AccountsDetailsModel;
use DB;

class Rewards extends BaseService
{
    /**
     * 获取虚拟货币充值地址
     * @param  [type] $uid      [description]
     * @param  [type] $currency [description]
     * @return [type]           [description]
     */
    public function doReward($amount, $level, $user, $guess)
    {

        if(empty($user->invite_uid)) {
            return null;
        }

        // 一级用户
        $inviteUid = $user->invite_uid;
        $targetUser = $this->getUserModel()->find($inviteUid);
        if($targetUser->rewards >= 20) {
            return null;
        }
        $inviteCount = $this->getUserInvit()->where('first_uid', $user->id)->count('uid');

        if($level == 1) {
            $firstRewards = bcmul($amount, '0.05', 18);
        } else if($level == 2) {
            if($inviteCount > 5 && $inviteCount < 20) {
                $firstRewards = bcmul($amount, '0.03', 18);
            } else if($inviteCount > 19) {
                $firstRewards = bcmul($amount, '0.05', 18);
            }
        }

        $accountsModel = $this->getAccounts();
        $detailsModel = $this->getAccountsDetails();
        $rewardsModel = $this->getRewards();

        DB::beginTransaction();
        try {
            $userAccount = $accountsModel->setCurrency($guess->currency)->getAccountLock($targetUser->id);
            $actResult = $accountsModel->where(['uid'=>$targetUser->id,'currency'=>$guess->currency])->increment('balance', $firstRewards);

            $rewardId = $rewardsModel->createReward([
                'uid'             => (int) $targetUser->id,
                'target_user'     => (int) $targetUser->id,
                'amount'          => $firstRewards,
                'rewardable_type' => 'guess',
                'rewardable_id'   => $guess->id,
                'created_at'      => date('Y-m-d H:i:s'),
                'updated_at'      => date('Y-m-d H:i:s'),
            ]);

            // 账单
            $detailId = $detailsModel->createDetail([
                'uid'            => $targetUser->id,
                'currency'       => $guess->currency,
                'type'           => 4,
                'target_id'      => $rewardId,
                'change_balance' => $firstRewards,
                'balance'        => bcadd($userAccount->balance, $firstRewards, 18),
                'remark'         => "{$user->name}竞猜，邀请奖励：{$firstRewards}",
            ]);
            $targetUser->increment('rewards', 1);

            if ($actResult && $rewardId && $detailId) {
                DB::commit();
                return true;
            }

            DB::rollBack();
            return false;

        }catch (Exception $e) {
            DB::rollBack();
            return false;
        }
    }

    private function getRewards()
    {
        return new RewardsModel();
    }

    private function getUserModel()
    {
        return new UserModel();
    }

    private function getUserInvit()
    {
        return new UserInvit();
    }

    private function getAccounts()
    {
        return new AccountsModel();
    }

    private function getAccountsDetails()
    {
        return new AccountsDetailsModel();
    }
}

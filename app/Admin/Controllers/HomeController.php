<?php

namespace App\Admin\Controllers;

use App\Http\Controllers\Controller;
use Encore\Admin\Controllers\Dashboard;
use Encore\Admin\Facades\Admin;
use Encore\Admin\Layout\Column;
use Encore\Admin\Layout\Content;
use Encore\Admin\Layout\Row;
use Encore\Admin\Widgets\InfoBox;

use App\Models\Earnings;
use App\Models\UsersEarnings;
use App\Models\GuessItems;
use App\Models\DepositsOrdersModel as Deposits;
use App\Models\WithdrawsOrdersModel as Withdraws;

class HomeController extends Controller
{
    public function index()
    {
        return Admin::content(function (Content $content) {

            // $content->header('竞猜');
            // $content->description('Description...');

            // $content->row(Dashboard::title());

            $data['amount'] =(float) Earnings::sum('amount');
            $data['reward'] =(float) Earnings::sum('reward');
            $data['deposits'] =(float) Deposits::sum('amount');
            $data['withdraws'] =(float) Withdraws::where('status', 1)->sum('amount');

            $content->row(function ($row) use($data) {
                $row->column(3, new InfoBox('平台收益', 'users', 'aqua', 'javascript:;', $data['amount']));
                $row->column(3, new InfoBox('奖励', 'shopping-cart', 'green', 'javascript:;', $data['reward']));
                $row->column(3, new InfoBox('充值', 'file', 'green', '/admin/deposits', $data['deposits']));
                $row->column(3, new InfoBox('提现', 'file', 'red', '/admin/withdraw', $data['withdraws']));
            });
        });
    }
}

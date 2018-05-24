<?php

use Illuminate\Routing\Router;

Admin::registerAuthRoutes();

Route::group([
    'prefix'        => config('admin.route.prefix'),
    'namespace'     => config('admin.route.namespace'),
    'middleware'    => config('admin.route.middleware'),
], function (Router $router) {

    $router->get('/', 'HomeController@index');
    $router->resource('user', UserController::class);

    $router->get('currency/wallet', 'CurrencyController@wallet');
    $router->resource('currency', CurrencyController::class);

    // 提现记录
    $router->get('withdraws/currency', 'WithdrawsController@currency');
    $router->put('withdraws/currency', 'WithdrawsController@postCurrency');

    // 用户充值记录
    $router->get('deposits/currency', 'DepositsController@currency');
    $router->put('deposits/currency', 'DepositsController@postCurrency');
    $router->get('deposits/artificial_list', 'DepositsController@artificialRechargeList');
    $router->get('deposits/artificial_list/create', 'DepositsController@artificialRecharge');
    $router->post('deposits/artificial', 'DepositsController@postArtificialRecharge');

    // 补单操作
    $router->resource('deposits', DepositsController::class);

    $router->resource('guess', GuessController::class);
    $router->resource('news', NewsController::class);
});

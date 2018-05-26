<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('layouts.master');
});

Auth::routes();

Route::get('/home', 'HomeController@index')->name('home');


Route::group(['middleware' => 'auth', 'prefix' => 'user'], function () {
    // Route::get('/', 'UserController@index')->name('user');
    // Route::get('/invite/qrcode', 'UserController@qrcode')->name('user:qrcode');
    // Route::get("/notice", 'ChatController@notice')->name('room:notice');
});


Route::get('/register/{invite_code}', 'Auth\RegisterController@showRegist')->name('regist');

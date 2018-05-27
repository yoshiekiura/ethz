<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('/register','Api\RegisterController@register');
Route::post('/login','Api\LoginController@login');
Route::post('/logout','Api\LoginController@logout');
Route::post('/token/refresh','Api\LoginController@refresh');


// Route::middleware('auth:api')->get('/user', function (Request $request) {
//     return $request->user();
// });

Route::group([
	'middleware' => ['auth:api'], 
	'prefix' => 'v1'], 
	function () {
		Route::group(['prefix' => 'user'], function () {
		    Route::get('/','Api\UserController@index');
		    Route::get('/items','Api\UserController@items');
		    Route::get('/friends','Api\UserController@friends');
		    Route::post('/invite/email','Api\UserController@sendInviteEmail');
		});

		Route::group(['prefix' => 'password'], function () {
		    Route::post('/reset','Api\ResetPasswordController@reset');
		});

		Route::group(['prefix' => 'deposits'], function () {
		    Route::get('/address','Api\DepositsController@address');
		});

		Route::group(['prefix' => 'withdraws'], function () {
		    Route::post('/','Api\WithdrawsController@store');
		});
});

Route::group(['prefix' => 'v1'], function () {
    Route::group(['prefix' => 'guess'], function () {
	    Route::get('/','Api\GuessController@index');
	    Route::get('/attendance','Api\GuessController@attendance');
	    Route::get('/{guess}','Api\GuessController@show')->where(['guess' => '[0-9]+']);
	    Route::post('/{guess}','Api\GuessController@guess')->where(['guess' => '[0-9]+']);
	    Route::get('/current','Api\GuessController@showNew');
	});

	Route::group(['prefix' => 'news'], function () {
	    Route::get('/','Api\ArticlesController@index');
	    Route::get('/{id}','Api\ArticlesController@show');
	});

	Route::group(['prefix' => 'deposits'], function () {
	    Route::get('/qrcode','Api\DepositsController@qrcode');
	});

	Route::get('/contact','Api\ContactController@index');
	Route::post('/feedback','Api\FeedbackController@index');
});

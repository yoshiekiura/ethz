<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

use App\Http\Controllers\ApiController as Controller;
use App\Http\Resources\GuessResource;
use App\Models\Guess;
use \Exception;
use Mail;



class UserController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $user->earnings_count = 9998;
        $user->avatar = env('APP_URL') . "/avatars/avatar_".intval($user->avatar).".png";
        $user->wallet = array(['code' => 'eth', 'amount' => 2000]);
        return $this->responseSuccess($user, '查询成功');
    }

    public function items(Request $request)
    {
    	$data['list'] = [
    		[
    			'item_title' => '项目名',
    			'item_rdate' => date('Y-m-d'),
    			'item_price' => rand(1000, 9999),
    			'item_amount' => rand(1, 100),
    			'item_code' => 'eth',
    		],
    		[
    			'item_title' => '项目名2',
    			'item_rdate' => date('Y-m-d'),
    			'item_price' => rand(1000, 9999),
    			'item_amount' => rand(1, 100),
    			'item_code' => 'eth',
    		]
    	];
    	$data['lastId'] = 1;
    	return $this->responseSuccess($data, '查询成功');
    }

    public function friends(Request $request)
    {
        $sinceId = $request->input('sinceId', 0);
        $limit = $request->input('limit', 20);

        $data['list'] = array(
            ['uid' => 1, 'name' => 'Jack', 'createdAt' => date('Y-m-d'),  'avatar' => env('APP_URL') . "/avatars/avatar_".rand(1, 8).".png"],
            ['uid' => 2, 'name' => 'Red', 'createdAt' => date('Y-m-d'),  'avatar' => env('APP_URL') . ("/avatars/avatar_".rand(1, 8).".png")],
            ['uid' => 3, 'name' => 'Ken', 'createdAt' => date('Y-m-d'),  'avatar' => env('APP_URL') . ("/avatars/avatar_".rand(1, 8).".png")],
            ['uid' => 4, 'name' => 'Make', 'createdAt' => date('Y-m-d'),  'avatar' => env('APP_URL') . ("/avatars/avatar_".rand(1, 8).".png")],
        );
        $data['lastId'] = 4;
        return $this->responseSuccess($data, 'success');
    }

    public function sendInviteEmail(Request $request)
    {
        if(empty($this->uid)) {
            return $this->setStatusCode(404)->responseError('请登录');
        }

        $invite_data = $request->all();
        $validator = $this->validator($invite_data);
        if($validator->fails()){
            return $this->setStatusCode(403)->responseError('验证出错', $validator->messages()->toArray());
        }

        $user = $request->user();
        $email = $invite_data['email'];
        $url = env('APP_URL') . '/#/regist?code=' . $user->invite_code;
        $emailContent = __('auth.invite_email', ['url' => $url]);

        try {
            $flag = Mail::send('web.invite_email',['emailContent'=>$emailContent],function($message) use($email){
                $message ->to($email)->subject('竞猜邀请');
            });
        } catch (Exception $e) {
            return $this->setStatusCode(403)
                    ->responseNotFound('邮件发送失败');
        }

        return $this->responseSuccess('邮件发送成功');
    }

    /**
     * Get a validator for an incoming registration request.
     *
     * @param  array  $data
     * @return \Illuminate\Contracts\Validation\Validator
     */
    protected function validator(array $data)
    {
        return Validator::make($data, [
            'email' => 'required|string|email|max:255',
        ]);
    }
}


<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

use App\Http\Controllers\ApiController as Controller;
use App\Http\Resources\GuessResource;
use App\Models\Guess;
use App\Models\GuessOrders;
use App\Models\UserModel;
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

    public function orders(Request $request)
    {
        $user = $this->getUser();
        if (empty($user->id)) {
            return $this->setStatusCode(403)->responseError('请登录');
        }

        $sinceId = $request->input('sinceId', 0);
        $limit = $request->input('limit', 20);

        $builders = with(new GuessOrders())->setHidden([])->newQuery();

        if($sinceId > 0) {
            $builders->where('id', '<', $sinceId);
        }

        $orders = $builders->where('uid', $user->id)->orderBy('id', 'DRSC')->limit($limit)->get();

        if($orders->isEmpty()) {
            $this->setStatusCode(404)->responseError('查无数据');
        }

        $lastId = 0;
        $datas['list'] = $orders->map(function($order) use (&$lastId) {
            $order->load('user');
            $order->load('guess');
            $order->load('currencyTo');

            $lastId = $order->id;
            return [
                'id' => $order->id,
                'item_title' => $order->guess->title,
                'item_rdate' => (string) $order->created_at,
                'item_amount' => $order->amount,
                'item_price' => $order->expect_price,
                'item_code' => $order->currencyTo->code,
                'is_win' => rand(0, 1)
            ];
        });
        
        $datas['lastId'] = $lastId;
    	
    	return $this->responseSuccess($datas, '查询成功');
    }

    public function friends(Request $request)
    {
        if(empty($this->uid)) {
            return $this->setStatusCode(403)->responseError('请登录');
        }

        $sinceId = $request->input('sinceId', 0);
        $limit = $request->input('limit', 20);

        $builders = with(new UserModel())->setHidden([])->newQuery();

        if($sinceId > 0) {
            $builders->where('id', '<', $sinceId);
        }

        $users = $builders->where('invite_uid', $this->uid)->orderBy('id', 'DRSC')->limit($limit)->get();

        if($users->isEmpty()) {
            return $this->setStatusCode(403)->responseError('查无数据');
        }
        
        $data['list'] = [];
        foreach ($users as $key => $user) {
            $data['list'][$key]['uid'] = $user->id;
            $data['list'][$key]['name'] = $user->name;
            $data['list'][$key]['createdAt'] = (string) $user->created_at;
            $data['list'][$key]['avatar'] = env('APP_URL') . "/avatars/avatar_".$user->avatar.".png";
        }
        if(!empty($data['list'])) {
            $last = end($data['list']);
            $data['last'] = $last['uid'];
        }

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


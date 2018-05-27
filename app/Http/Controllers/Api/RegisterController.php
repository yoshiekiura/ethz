<?php

namespace App\Http\Controllers\Api;

use App\User;
use App\Models\UserInvit;
use App\Http\Proxy\TokenProxy;
use App\Http\Controllers\ApiController;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Foundation\Auth\RegistersUsers;
use Illuminate\Support\Facades\Cookie;
use Illuminate\Support\Facades\Session;
use Illuminate\Http\Request;
use Illuminate\Auth\Events\Registered;
use App\Http\Controllers\Controller;
use App\Models\UserAuthorize;


class RegisterController extends  ApiController
{
    /*
    |--------------------------------------------------------------------------
    | Register Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles the registration of new users as well as their
    | validation and creation. By default this controller uses a trait to
    | provide this functionality without requiring any additional code.
    |
    */

    use RegistersUsers;

    /**
     * Where to redirect users after registration.
     *
     * @var string
     */
    protected $redirectTo = '/home';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct(TokenProxy $proxy)
    {
        //dd(111);
        //$this->middleware('guest');
        $this->proxy = $proxy;
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
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6|confirmed',
        ]);
    }



    /**
     * Handle a registration request for the application.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function register(Request $request)
    {
        $postData = $request->all();
        $validator = $this->validator($postData);
        if($validator->fails()){
            return $this->setStatusCode(403)->responseError('验证出错', $validator->messages()->toArray());
        }

        if($this->isUser($postData['email'])){
            return $this->setStatusCode(403)->responseError('验证出错', ['email' => '邮箱已注册']);
        }

        if($postData['password'] != $postData['password_confirmation']) {
            return $this->setStatusCode(403)->responseError('验证出错', ['password' => '两次输入密码不正确']);
        }

        $email = $request->input('email');
        $password = $request->input('password');
        $inviteCode = $request->input('invite');
        $inviteUid = 0;
        $name = explode('@', $email)[0];

        $inviteUser = array();
        if(!empty($inviteCode)) {
            $inviteUser = User::where('invite_code', $inviteCode)->first();
        }

        $user = $this->create([
            'name' => $name,
            'email' => $email,
            'password' => $password,
            'invite_uid' => isset($inviteUser->id) ? $inviteUser->id : 0,
            'invite_code' => strtoupper(uniqid()),
            'ip' => $request->getClientIp(),
        ]);

        if(isset($user) && $user->id > 0) {

            // 邀请人
            if(isset($inviteUser->id)) {
                $this->userInvite($user->id, $inviteUser->id);
                $inviteUser->increment('invite_count');
            }

            $token = $this->proxy->login($postData['email'], $postData['password']);

            $user = User::find($user->id);
            $user->token = $token->original['token'];

            return $this->responseSuccess($user, '注册成功');
        } else {
            return $this->setStatusCode(403)->responseNotFound('注册失败');
        }
    }


    public function userInvite($uid,$inviteUid){
        $user = UserInvit::where('uid', '=', $inviteUid)->first();
        $addData['uid'] = $uid;
        $addData['first_uid'] = $inviteUid;
        $addData['second_uid'] = empty($user) ? 0 : intval($user->first_uid);
        return UserInvit::create($addData);
    }

    public function isUser($email){
        $user = User::where('email', '=', $email)->first();
        return empty($user) ? 0: 1;
    }

    /**
     * Create a new user instance after a valid registration.
     *
     * @param  array  $data
     * @return \App\User
     */
    protected function create(array $data)
    {
        return User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
            'invite_uid' => $data['invite_uid'],
            'invite_code' => $data['invite_code'],
            'avatar' => rand(1, 8),
            'ip' => $data['ip']
        ]);
    }

    public function isUserByPhone($phone){
        $user = User::where('phone', '=', $phone)->first();
        return empty($user) ? 0: 1;
    }
}

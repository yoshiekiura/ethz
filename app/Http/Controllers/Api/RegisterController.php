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
            'name' => 'required|string|max:255',
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
            foreach ($validator->messages()->toArray() as  $value) {
                return $this->setStatusCode(403)
                         ->responseNotFound(__($value[0]));
            }
            exit();
            
        }

        if($this->isUser($postData['email'])){
            return $this->setStatusCode(403)
                        ->responseNotFound(__('auth.register.repeat_email'));
        }

        $userData = $request->all();

        // 查看邀请用户
        //$inviteUid = (int) Cookie::get('inviteUid');
        $inviteUid = (int) $userData['invite'];
        //event(new Registered($user = $this->create($request->all())));
        $user = $this->create([
                    'name' => $postData['name'],
                    'email' => $postData['email'],
                    'password' => $postData['password'],
                    'registere_ip' => $request->getClientIp(),
                ]);
        //Auth::login($user);           //去除了注册自动登录设置
        if(isset($user) && $user->id > 0) {
            if($inviteUid > 0){
                $this->userInvite($user->id,$inviteUid);
            }
            $token = $this->proxy->login($postData['email'], $postData['password']);
            //Cookie::make('refreshToken', $token['refresh_token'], 14400);
            $retData = [
                        'uid'          => $user->id,
                        'token'        => $token->original['token'],
                        'auth_id'      => $token->original['auth_id'],
                        'expires_in'   => $token->original['expires_in'],
                        'my_persimmon' => Session::getId()
                    ];
            return $this->responseSuccess($retData, __('api.public.success'));
        } else {
            return $this->setStatusCode(403)
                        ->responseNotFound(__('auth.register.register_error'));
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


    // public function register(Request $request)
    // {

    //     $this->validator($request->all())->validate();
    //     echo 221;exit();
    //     event(new Registered($user = $this->create($request->all())));

    //     return response()->json(['status' => true,'message' => 'User Created!']);
    // }


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
            'group' => 1,
            'amount' => 0,
            'registere_ip' => $data['registere_ip']
        ]);
    }

    public function inviteRegister(Request $request) 
    {
        $inviteUid = $request->route('inviteUid');
        Cookie::make('inviteUid', $inviteUid, 3600);
        return $this->showRegistrationForm();
    }

    public function isUserByPhone($phone){
        $user = User::where('phone', '=', $phone)->first();
        return empty($user) ? 0: 1;
    }

    /**
     * 快速生成用户
     * @param  Request $request [description]
     * @return [type]           [description]
     */
    public function simple(Request $request) 
    {
        $postData = $request->all();

        if(empty($postData['email']) && empty($postData['phone'])) {
            return $this->setStatusCode(403)
                        ->responseNotFound(__('auth.emptyAccount'));
        }

        if(!empty($postData['email']) && $this->isUser($postData['email'])){
            return $this->setStatusCode(403)
                        ->responseNotFound(__('auth.emailReg'));
        }

        if(!empty($postData['phone']) && $this->isUserByPhone($postData['phone'])){
            return $this->setStatusCode(403)
                        ->responseNotFound(__('auth.phone_repeated'));
        }

        if(empty($postData['password'])) {
            return $this->setStatusCode(403)
                        ->responseNotFound(__('auth.emptyPassword'));
        }

        if(empty($postData['name'])) {
            return $this->setStatusCode(403)
                        ->responseNotFound(__('auth.emptyFirstName'));
        }

        if(empty($postData['user_id'])) {
            return $this->setStatusCode(403)
                        ->responseNotFound('用户ID不能为空');
        }

        $user = new User();
        $user->fillable(['id', 'name', 'email', 'password', 'registere_ip', 'group', 'amount']);
        $user->id = $postData['user_id'];
        $user->name = $postData['name'];
        $user->email = $postData['email'];
        $user->password = Hash::make($postData['password']);
        $user->registere_ip = $request->getClientIp();
        $user->group = 1;
        $user->amount = 0;
        $res = $user->save();

        if($res) {
            $userAuthorize = new UserAuthorize();
            $userAuthorize->createData([
                'uid' => $user->id,
                'open_uid' => $user->id,
                'type' => 'mts_sns',
            ]);

            return $this->responseSuccess($user->toArray(), 'Success');
        }
    }
}

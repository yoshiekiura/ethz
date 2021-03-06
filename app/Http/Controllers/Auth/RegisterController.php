<?php

namespace App\Http\Controllers\Auth;

use App\User;
use App\Models\UserInvit;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Foundation\Auth\RegistersUsers;
use Illuminate\Support\Facades\Cookie;
use Illuminate\Http\Request;

class RegisterController extends Controller
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
    public function __construct()
    {
        $this->middleware('guest');
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
     * Create a new user instance after a valid registration.
     *
     * @param  array  $data
     * @return \App\User
     */
    protected function create(array $data)
    {
        $invite_uid = 0;
        if(!empty($data['invite_code'])) {
            $invite_user = User::where('invite_code', $data['invite_code'])->first();
            if(isset($invite_user->id)) {
                $invite_uid = $invite_user->id;
            }
        }

        $user = User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
            'invite_code' => strtoupper(uniqid()),
            'invite_uid' => $invite_uid,
            'avatar' => rand(1, 8),
        ]);

        if($user && !empty($invite_user)) {
            $this->userInvite($user->id, $invite_user->id);
            $invite_user->increment('invite_count');
        }
        return $user;
    }
    public function showRegist($invite_code)
    {
        return view('auth.register', ['invite_code' => $invite_code]);
    }
    public function userInvite($uid, $inviteUid){
        $user = UserInvit::where('uid', '=', $inviteUid)->first();
        $addData['uid'] = $uid;
        $addData['first_uid'] = $inviteUid;
        $addData['second_uid'] = empty($user) ? 0 : intval($user->first_uid);
        return UserInvit::create($addData);
    }
}

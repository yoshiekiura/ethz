<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\ApiController as Controller;
use App\Http\Proxy\TokenProxy;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Http\Request;
use Auth;
use App\User;

class LoginController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles authenticating users for the application and
    | redirecting them to your home screen. The controller uses a trait
    | to conveniently provide its functionality to your applications.
    |
    */

    use AuthenticatesUsers;

    protected $proxy;

    /**
     * Where to redirect users after login.
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
        $this->middleware('guest')->except('logout');
        $this->proxy = $proxy;
    }

    public function login(Request $request)
    {
        $token = $this->proxy->login(request('account'), request('password'));
        if($token->original['code'] == 200) {
            unset($token->original['code']);

            $client = new \GuzzleHttp\Client(['verify' => false]);
            $response = $client->request('GET', env('APP_URL').'/api/v1/user', [
                'headers' => [
                    'Accept' => 'application/json',
                    'Authorization' => 'Bearer '.$token->original['token'],
                ],
            ]);
            $user = json_decode((string)$response->getBody(), true);
            
            $user['data']['token'] = $token->original['token'];
			$user['data']['avatar'] = env('APP_URL') . "/avatars/avatar_".intval($user['avatar']).".png";
            return $this->responseSuccess($user['data'], '登录成功');
        } else {
            return $this->setStatusCode(404)->responseError($token->original['message']);
        }
    }

    public function logout()
    {
        return $this->proxy->logout();
    }

    public function refresh()
    {
        return $this->proxy->refresh();
    }
}


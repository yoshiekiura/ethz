<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Controllers\ApiController;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Password;
use Illuminate\Foundation\Auth\ResetsPasswords;
use App\Services\Authenticate;

class ResetPasswordController extends ApiController
{

	use ResetsPasswords;
    
	public function reset(Request $request)
	{
		$postData = $request->all();
		$validator = $this->validator($postData);

		if($validator->fails()){
            return $this->setStatusCode(403)->responseError('验证出错', $validator->messages()->toArray());
        }

        $user = $request->user();
        $user = \App\User::find($user->id);
        $passwordOld = $request->input('password_old');
        $password = $request->input('password');

        $authenticate = new Authenticate();
        $authenticate->setUser($user);
        $checkPwd = $authenticate->checkPassword($passwordOld);
        if(empty($checkPwd)) {
        	return $this->setStatusCode(403)->responseError('密码错误');
        }

        $result = $authenticate->resetPassword($password);

        if($result['status'] == 1) {
        	return $this->responseSuccess('密码更新成功');
        } else {
        	return $this->setStatusCode(403)->responseError('密码更新失败');
        }
	}

	public function validator(array $data)
    {
        return Validator::make($data, [
            'password_old' => 'required|min:6',
            'password' => 'required|min:6',
        ]);
    }

}


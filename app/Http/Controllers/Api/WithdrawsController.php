<?php
namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Http\Controllers\ApiController as Controller;
use App\Services\Withdraws;
use App\Models\WithdrawsOrdersModel;
use function App\Lib\my_number_format;

class WithdrawsController extends Controller
{

    /**
     * 创建提款地址.
     *
     * @param StoreCurrencyRecharge $request
     * @return mixed
     * @author BS <414606094@qq.com>
     */
    public function store(Request $request)
    {
        $code = $request->code;
        $address = $request->address;
        $amount = $request->amount;
        $remark = $request->remark;
        $user = $this->getUser();

        if(empty($user)) {
            return $this->setStatusCode(400)->responseError('请登录');
        }

        if(empty($address)) {
            return $this->setStatusCode(400)->responseError('请输入转账地址');
        }

        if(empty($code)) {
            return $this->setStatusCode(400)->responseError('缺少虚拟币编码');
        }

        if(empty($amount)) {
            return $this->setStatusCode(400)->responseError('请输入提现金额');
        }

        $params = [
            'code' => $code,
            'address' => $address,
            'amount' => $amount,
            'remark' => $remark,
        ];

        $result = $this->getWithdraws()->apply($user, $params);

        if ($result['status'] == true) {
            $order = WithdrawsOrdersModel::find($result['order']);
            return $this->setStatusCode(200)->responseSuccess($order);
        }

        return $this->setStatusCode(400)->responseError('操作失败');
    }

    private function getWithdraws()
    {
        return new Withdraws();
    }

}

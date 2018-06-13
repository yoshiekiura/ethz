<?php
namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Http\Controllers\ApiController as Controller;
use App\Services\Withdraws;
use App\Models\WithdrawsOrdersModel;
// use function App\Lib\my_number_format;

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

    public function list(Request $request)
    {
        $limit = $request->input('limit', '10');
        $sinceId = $request->input('sinceId');

        if(is_numeric($sinceId) && $sinceId == 0) {
            $this->setStatusCode(404)->responseError('查无数据');
        }

        $user = $this->getUser();

        $builders = with(new WithdrawsOrdersModel())->setHidden([])->newQuery();

        if($sinceId > 0) {
            $builders->where('id', '<', $sinceId);
        }

        $orders = $builders->where('uid', $user->id)->orderBy('id', 'DESC')->limit($limit)->get();

        if($orders->isEmpty()) {
            return $this->setStatusCode(403)->responseError('查无数据');
        }

        $lastId = 0;
        $datas['list'] = $orders->map(function ($order) use (&$lastId) {
            $order->load('currencyTo');
            $order->code = $order->currencyTo->code;
            $order->amount = my_number_format($order->amount, 4);
            $order->sum_amount = my_number_format($order->sum_amount, 4);
            unset($order->currencyTo);
            $lastId = $order->id;
            return $order;
        });
        $datas['lastId'] = $lastId;

        return $this->responseSuccess($datas, 'success');
    }

    public function show(Request $request, WithdrawsOrdersModel $order)
    {
        return $order->getConnection()->transaction(function () use ($order){
            $order->amount = (float) $order->amount;
            $order->tx_url = 'https://etherscan.io/tx/' . $order->txid;
            $order->address_url = 'https://etherscan.io/address/' . $order->address;
            $order->amount = (string) my_number_format($order->amount, 4);
            $order->sum_amount = (string) my_number_format($order->sum_amount, 4);
            $order->fee = (string) my_number_format($order->fee, 4);

            return $this->responseSuccess($order, 'success');
        });
    }

    private function getWithdraws()
    {
        return new Withdraws();
    }

}

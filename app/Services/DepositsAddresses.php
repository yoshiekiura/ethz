<?php

namespace App\Services;

use App\Services\BaseService;

use App\Models\Erc20TokensModel as MtsErc20Tokens;
use App\Models\DepositsAddressesRelated;
use App\Models\DepositsAddressesModel;
use App\Models\AccountsModel;
use App\Models\CurrencyModel;
use App\Models\UserModel;
// use App\Coin;
use DB;

class DepositsAddresses extends BaseService
{
    /**
     * 获取虚拟货币充值地址
     * @param  [type] $uid      [description]
     * @param  [type] $currency [description]
     * @return [type]           [description]
     */
    public function getUserAddress($uid, $code)
    {
        $currency = $this->getCurrencyModel()->getByCode($code);
        $addressModel = $this->getDepositsAddressesModel()->setCurrency($currency->id);

        $address = $addressModel->getInfoByUid($uid);

        if(is_null($address)) {
            $isErc20 = $this->isErc20($currency->id);
            if($isErc20) {
                $coinId = $this->getCurrencis()->getIdByCode('ETH');
                $address = $addressModel->setCurrency($coinId)->getAddressByUid($uid);
                if(empty($address)) {
                    $address = $this->createAddress($uid, $coinId);
                }
            } else {
                $address = $this->createAddress($uid, $currency->id);
            }
            if(!empty($address)){
                $address->currency = $currency->id;
                $this->saveDepositeRelated($address);
            }
        }

        $this->getAccounts()->setCurrency($address->currency)->getAccount($uid);
        return $address;
    }

    public function createAddress($uid, $currency) 
    {
        $addressModel = $this->getDepositsAddressesModel();

        $type = $this->getCurrencyType($currency);
        if(is_null($type)) {
            return null;
        }

        // $address = $this->getCoin()->getnewaddress($type);
        $address = md5(uniqid());

        if(is_null($address)) {
            return null;
        }

        try {
            $addressModel->uid      = $uid;
            $addressModel->address  = $address;
            $addressModel->currency = $currency;
            $addressModel->createAddress();
            $addressModel->getConnection()->transaction(function () use ($addressModel) {
                $this->saveDepositeRelated($addressModel);
            });
        } catch (\Exception $e) {
            $addressModel->delete();
            throw $e;
        }

        return $addressModel->getInfo($addressModel->id);
    }

    public function getCurrencyType($currency)
    {
        $type = $this->getCurrencyModel()->getInfo($currency);

        if(!is_null($type)) {
            return $type->code;
        } else {
            return null;
        }
    }

    public function isErc20($currency)
    {
        $erc20TokensModel = new MtsErc20Tokens();
        $erc20 = $erc20TokensModel->checkCurrency($currency);
        return isset($erc20->currency) ? true : false;
    }

    public function saveDepositeRelated($address)
    {
        $result = $this->getOwnAddress($address->uid, $address->currency);
        if(!empty($result)) {
            return $result;
        }
        return $this->getAddressesRelated()->createAddress([
                'uid'        => (int) $address->uid, 
                'currency'   => (int) $address->currency, 
                'address_id' => (int) $address->id, 
            ]);
    }

    public function getOwnAddress($uid, $currency)
    {
        return $this->getAddressesRelated()->setCurrency($currency)->getInfoByUid($uid);

    }

    private function getAddressesRelated()
    {
        return new DepositsAddressesRelated();
    }

    private function getDepositsAddressesModel()
    {
        return new DepositsAddressesModel();
    }

    private function getCurrencyModel()
    {
        return new CurrencyModel();
    }

    private function getUserModel()
    {
        return new UserModel();
    }

    private function getAccounts()
    {
        return new AccountsModel();
    }

    private function getCoin()
    {
        return new Coin();
    }
}

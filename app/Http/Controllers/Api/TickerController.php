<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\ApiController as Controller;
use Illuminate\Http\Request;
use App\Services\Coins;

class TickerController extends Controller
{

    public function index(Request $request)
    {
        $this->getNewGuess();
        $this->getWin();
        $coins = new Coins();
        return $this->responseSuccess($coins->ticker('eth_usdt'));
    }

    public function getNewGuess()
    {
        $client = new \GuzzleHttp\Client(['verify' => false]);
        $response = $client->request('POST', env('APP_URL') . '/api/v1/guess/items');
        $guess = json_decode((string)$response->getBody());
        return $guess;
    }

    public function getWin()
    {
        $client = new \GuzzleHttp\Client(['verify' => false]);
        $response = $client->request('GET', env('APP_URL') . '/api/v1/rewards/rose');
        $guess = json_decode((string)$response->getBody());
        return $guess;
    }
}


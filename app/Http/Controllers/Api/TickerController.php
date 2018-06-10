<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\ApiController as Controller;
use Illuminate\Http\Request;

class TickerController extends Controller
{

    public function index(Request $request)
    {
        $client = new \GuzzleHttp\Client(['verify' => false]);
        $response = $client->request('GET', 'https://api.binance.com/api/v1/ticker/24hr', [
            'query' => [
                'symbol' => 'ETHUSDT',
            ],
        ]);

        $ticker = json_decode((string)$response->getBody());
        return $this->responseSuccess([
            'open' => $ticker->openPrice,
            'last' => $ticker->lastPrice,
            'high' => $ticker->highPrice,
            'low' => $ticker->lowPrice,
            'vol' => $ticker->volume,
        ]);
    }
}


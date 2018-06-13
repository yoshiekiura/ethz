<?php

namespace App\Services;

use App\Services\BaseService;
use DB;

class Coins extends BaseService
{

    public function ticker($market = 'eth_usdt') 
    {
        $client = new \GuzzleHttp\Client(['verify' => false]);
        $response = $client->request('GET', 'http://api.bitkk.com/data/v1/ticker', [
            'query' => [
                'market' => $market,
            ],
        ]);

        $ticker = json_decode((string)$response->getBody());
        $ticker = $ticker->ticker;

        return [
            'last' => (float) $ticker->last,
            'high' => (float) $ticker->high,
            'low' => (float) $ticker->low,
            'vol' => (float) $ticker->vol,
        ];
    }

    public function ticker_binance($data) 
    {
        $client = new \GuzzleHttp\Client(['verify' => false]);
        $response = $client->request('GET', 'https://api.binance.com/api/v1/ticker/24hr', [
            'query' => [
                'symbol' => 'ETHUSDT',
            ],
        ]);

        $ticker = json_decode((string)$response->getBody());

        return [
            'open' => (float) $ticker->openPrice,
            'last' => (float) $ticker->lastPrice,
            'high' => (float) $ticker->highPrice,
            'low' => (float) $ticker->lowPrice,
            'vol' => (float) $ticker->volume,
        ];
    }
}

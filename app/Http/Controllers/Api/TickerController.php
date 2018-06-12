<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\ApiController as Controller;
use Illuminate\Http\Request;

class TickerController extends Controller
{

    public function index(Request $request)
    {
        // $client = new \GuzzleHttp\Client(['verify' => false]);
        // $response = $client->request('GET', 'https://api.binance.com/api/v1/ticker/24hr', [
        //     'query' => [
        //         'symbol' => 'ETHUSDT',
        //     ],
        // ]);

        // $ticker = json_decode((string)$response->getBody());
        $ticker = json_decode('{"openPrice":"567.00000000","lastPrice":"522.00000000","highPrice":"568.45000000","lowPrice":"501.13000000","volume":"210881.66080000"}
');
        return $this->responseSuccess([
            'open' => (float) $ticker->openPrice,
            'last' => (float) $ticker->lastPrice,
            'high' => (float) $ticker->highPrice,
            'low' => (float) $ticker->lowPrice,
            'vol' => (float) $ticker->volume,
        ]);
    }
}


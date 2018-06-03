<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\ApiController as Controller;
use Illuminate\Http\Request;

class TickerController extends Controller
{

    public function index(Request $request)
    {
        $client = new \GuzzleHttp\Client(['verify' => false]);
        $response = $client->request('GET', 'https://api.etherscan.io/api', [
            'query' => [
                'module' => 'stats',
                'action' => 'ethprice',
            ],
        ]);
        $ticker = json_decode((string)$response->getBody());
        return $this->responseSuccess($ticker->result);
    }
}


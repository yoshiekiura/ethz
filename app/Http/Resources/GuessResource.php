<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class GuessResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {

        // 未开始
        if(bccomp(strtotime($this->start_time), time()) == 1) {
            $this->state = 'coming_soon';
        }
        // 进行中
        if(bccomp(strtotime($this->start_time), time()) <= 0 && bccomp(strtotime($this->end_time), time()) > 0) {
            $this->state = 'in_progress';
        }
        if(bccomp(strtotime($this->end_time), time()) <= 0 && bccomp(strtotime($this->open_time), time()) > 0) {
            $this->state = 'in_wait';
        }
        // 当前时间大约开奖时间结束
        if(bccomp(strtotime($this->open_time), time()) < 0) {
            $this->state = 'completed';
        }

        return [
            'id' => $this->id,
            'name' => $this->title,
            'price' => (float) bcmul((string)$this->expect_price, '1', 4),
            'minAmount' => (float) bcmul((string)$this->min_amount, '1', 4),
            'maxAmount' => (float) bcmul((string)$this->max_amount, '1', 4),
            'sumAmount' => (float) bcmul((string)$this->sum_amount, '1', 4),
            'startTime' => $this->start_time,
            'endTime' => $this->end_time,
            'openTime' => $this->open_time,
            'period' => $this->period,
            'number' => $this->number,
            'state' => $this->state,
            'createdAt' => (string) $this->created_at,
        ];
        // return parent::toArray($request);
    }
}

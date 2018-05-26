<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class NewsResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toListArray($request)
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'createdAt' => (string) $this->created_at,
        ];
    }
}

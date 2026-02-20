<?php

namespace App\Models;

use App\Models\OrderItem;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Order extends Model
{
    use HasFactory;
    protected $guarded = ['id'];
    protected $table = 'orders';
    protected $fillable = [
        'transaction_time',
        'total_price',
        'total_item',
        'payment_amount',
        'cashier_id',
        'cashier_name',
        'payment_method',
    ];
    
    public function orderItems(){
        return $this->hasMany(OrderItem::class);
    }
}

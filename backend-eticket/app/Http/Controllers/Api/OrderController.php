<?php

namespace App\Http\Controllers\Api;

use App\Models\Order;
use App\Models\OrderItem;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class OrderController extends Controller
{

    public function store(Request $request)
    {
        $request->validate([
            'transaction_time' => 'required',
            'total_price' => 'required|integer',
            'total_item' => 'required|integer',
            'payment_amount' => 'required|integer',
            'cashier_id' => 'required|exist:users,id',
            'cashier_name' => 'required|string',
            'payment_method' => 'required|string',
            'orders_items' => 'required|array'
        ]);

        $order = new Order;
        $order->transaction_time = $request->transaction_time;
        $order->total_price = $request->total_price;
        $order->total_item = $request->total_item;
        $order->payment_amount = $request->payment_amount;
        $order->cashier_id = $request->cashier_id;
        $order->cashier_name = $request->cashier_name;
        $order->payment_method = $request->payment_method;
        $order->orders_items = $request->orders_items;

        $order->save();

        foreach ($request->order_items as $item) {
            $orderItem = OrderItem();
            $orderItem->order_id = $order->id;
            $orderItem->product_id = $item['product_id'];
            $orderItem->quantity = $item['quantity'];
            $orderItem->total_price = $item['total_price'];

            $orderItem->save();
        }

        return response()->json([
            'status' => 'Sukses',
            'data' => $order
        ], 201);
    }


    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}

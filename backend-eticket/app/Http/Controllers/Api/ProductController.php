<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        // Bisa filter by category_id jika ada query param
        $products = Product::when($request->category_id, function ($query) use ($request) {
            return $query->where('category_id', $request->category_id);
        })->get();
        
        // Load relasi kategori agar frontend tahu nama kategorinya
        $products->load('category');

        return response()->json([
            'status' => 'success',
            'data' => $products
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'price' => 'required|integer',
            'stok' => 'required|integer',
            'category_id' => 'required|exists:categories,id',
            'image' => 'nullable|image|mimes:jpeg,png,jpg|max:2048', // Max 2MB
        ]);

        $data = $request->all();

        // Logic Upload Gambar
        if ($request->hasFile('image')) {
            // Simpan ke folder 'products' di storage public
            $path = $request->file('image')->store('products', 'public');
            $data['image'] = $path; // DB menyimpan path: "products/namafile.jpg"
        }

        $product = Product::create($data);

        return response()->json([
            'status' => 'success',
            'data' => $product
        ], 201);
    }
    
    // ... (Show, Update, Destroy mirip Category, tapi perhatikan update image jika ada)
    
    public function destroy(Product $product)
    {
       $product->delete();
       return response()->json(['status' => 'success', 'message' => 'Product deleted']);
    }
}

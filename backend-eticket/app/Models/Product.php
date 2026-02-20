<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute; // Import ini
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $guarded = ['id'];
    
    public function category() {
        return $this->belongsTo(Category::class);
    }

    // Accessor untuk mengubah output 'image' otomatis
    protected function image(): Attribute
    {
        return Attribute::make(
            get: fn ($image) => $image ? url('/storage/' . $image) : null,
        );
    }
}

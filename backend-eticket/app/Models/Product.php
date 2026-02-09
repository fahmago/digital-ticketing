<?php

namespace App\Models;

// use App\Models\Category;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Product extends Model
{
    use HasFactory;

    protected $guarded = ['id'];

    public function category() {
        return $this->belongsTo(Category::class);
    }

    public function image(): Attribute {
        return Attribute::make(
            get: fn ($image) => $image ? url('/storage/' . $image) : null,
        );
    }
}

import 'package:flutter/material.dart';
import 'package:flutter_eshop/features/products/models/brand.dart';
import 'package:flutter_eshop/features/products/models/category.dart';

class Filter {
  final Category? category;
  final Brand? brand;
  final String minPrice;
  final String maxPrice;

  Filter({
    required this.category,
    required this.brand,
    required this.minPrice,
    required this.maxPrice,
  });

  Filter copyWith({
    ValueGetter<Category?>? category,
    ValueGetter<Brand?>? brand,
    String? minPrice,
    String? maxPrice,
  }) =>
      Filter(
        category: category != null ? category() : this.category,
        brand: brand != null ? brand() : this.brand,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_eshop/features/products/models/brand.dart';
import 'package:flutter_eshop/features/products/models/category.dart';

class Filter {
  final Category? category;
  final Brand? brand;
  final String minPrice;
  final String maxPrice;
  final String search;

  Filter({
    required this.category,
    required this.brand,
    required this.minPrice,
    required this.maxPrice,
    required this.search,
  });

  Filter copyWith({
    ValueGetter<Category?>? category,
    ValueGetter<Brand?>? brand,
    String? minPrice,
    String? maxPrice,
    String? search,
  }) =>
      Filter(
        category: category != null ? category() : this.category,
        brand: brand != null ? brand() : this.brand,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        search: search ?? this.search,
      );
}

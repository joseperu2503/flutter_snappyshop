import 'package:flutter/material.dart';

class Filter {
  final int? categoryId;
  final int? brandId;
  final String minPrice;
  final String maxPrice;
  final String search;

  Filter({
    required this.categoryId,
    required this.brandId,
    required this.minPrice,
    required this.maxPrice,
    required this.search,
  });

  Filter copyWith({
    ValueGetter<int?>? categoryId,
    ValueGetter<int?>? brandId,
    String? minPrice,
    String? maxPrice,
    String? search,
  }) =>
      Filter(
        categoryId: categoryId != null ? categoryId() : this.categoryId,
        brandId: brandId != null ? brandId() : this.brandId,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        search: search ?? this.search,
      );
}

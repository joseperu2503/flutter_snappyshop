import 'package:flutter/material.dart';

class Filter {
  final int? categoryId;
  final int? storeId;
  final String minPrice;
  final String maxPrice;
  final String search;

  Filter({
    required this.categoryId,
    required this.storeId,
    required this.minPrice,
    required this.maxPrice,
    required this.search,
  });

  Filter copyWith({
    ValueGetter<int?>? categoryId,
    ValueGetter<int?>? storeId,
    String? minPrice,
    String? maxPrice,
    String? search,
  }) =>
      Filter(
        categoryId: categoryId != null ? categoryId() : this.categoryId,
        storeId: storeId != null ? storeId() : this.storeId,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        search: search ?? this.search,
      );
}

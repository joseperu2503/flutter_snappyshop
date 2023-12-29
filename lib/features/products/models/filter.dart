import 'package:flutter/material.dart';
import 'package:flutter_eshop/features/products/models/category.dart';

class Filter {
  final Category? category;

  Filter({
    required this.category,
  });

  Filter copyWith({
    ValueGetter<Category?>? category,
  }) =>
      Filter(
        category: category != null ? category() : this.category,
      );
}

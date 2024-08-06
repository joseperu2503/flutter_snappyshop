// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/store/models/stores_response.dart';

class ProductDetail {
  final Product product;
  final List<Product> storeRelatedProducts;
  final Store store;

  ProductDetail({
    required this.product,
    required this.storeRelatedProducts,
    required this.store,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        product: Product.fromJson(json["product"]),
        storeRelatedProducts: List<Product>.from(
            json["store_related_products"].map((x) => Product.fromJson(x))),
        store: Store.fromJson(json["store"]),
      );

  ProductDetail copyWith({
    Product? product,
    List<Product>? storeRelatedProducts,
    Store? store,
  }) {
    return ProductDetail(
      product: product ?? this.product,
      storeRelatedProducts: storeRelatedProducts ?? this.storeRelatedProducts,
      store: store ?? this.store,
    );
  }
}

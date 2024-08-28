import 'package:flutter_snappyshop/features/products/models/products_response.dart';

class Cart {
  final double total;
  final double subtotal;
  final double shippingFee;
  final List<ProductCart> products;

  Cart({
    required this.total,
    required this.subtotal,
    required this.shippingFee,
    required this.products,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        total: json["total"]?.toDouble(),
        subtotal: json["subtotal"]?.toDouble(),
        shippingFee: json["shipping_fee"]?.toDouble(),
        products: List<ProductCart>.from(
            json["products"].map((x) => ProductCart.fromJson(x))),
      );

  Cart copyWith({
    double? total,
    double? subtotal,
    double? shippingFee,
    List<ProductCart>? products,
  }) {
    return Cart(
      total: total ?? this.total,
      subtotal: subtotal ?? this.subtotal,
      shippingFee: shippingFee ?? this.shippingFee,
      products: products ?? this.products,
    );
  }
}

class ProductCart {
  final Product productDetail;
  int quantity;

  ProductCart({
    required this.productDetail,
    required this.quantity,
  });

  factory ProductCart.fromJson(Map<String, dynamic> json) => ProductCart(
        productDetail: Product.fromJson(json["product_detail"]),
        quantity: json["quantity"],
      );

  ProductCart copyWith({
    Product? productDetail,
    int? quantity,
  }) {
    return ProductCart(
      productDetail: productDetail ?? this.productDetail,
      quantity: quantity ?? this.quantity,
    );
  }
}

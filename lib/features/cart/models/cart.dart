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

  Cart updateProductQuantity(int index, int newQuantity) {
    products[index].quantity = newQuantity;
    return Cart(
      products: products,
      total: total,
      subtotal: subtotal,
      shippingFee: shippingFee,
    );
  }

  Cart removeProductAtIndex(int index) {
    List<ProductCart> updatedProducts = List.of(products);
    if (index >= 0 && index < updatedProducts.length) {
      updatedProducts.removeAt(index);
    }
    return Cart(
      products: updatedProducts,
      total: total,
      subtotal: subtotal,
      shippingFee: shippingFee,
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
}

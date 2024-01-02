import 'package:flutter_eshop/features/products/models/products_response.dart';

class Cart {
  final double totalAmount;
  final List<ProductCart> products;

  Cart({
    required this.totalAmount,
    required this.products,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        totalAmount: json["total_amount"]?.toDouble(),
        products: List<ProductCart>.from(
            json["products"].map((x) => ProductCart.fromJson(x))),
      );

  Cart updateProductQuantity(int index, int newQuantity) {
    products[index].quantity = newQuantity;
    return Cart(
      products: products,
      totalAmount: totalAmount,
    );
  }

  Cart removeProductAtIndex(int index) {
    List<ProductCart> updatedProducts = List.of(products);
    if (index >= 0 && index < updatedProducts.length) {
      updatedProducts.removeAt(index);
    }
    return Cart(
      products: updatedProducts,
      totalAmount: totalAmount,
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

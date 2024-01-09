import 'package:flutter_snappyshop/features/products/models/cart.dart';

class CreateCartResponse {
  final bool success;
  final String message;
  final Cart data;

  CreateCartResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateCartResponse.fromJson(Map<String, dynamic> json) =>
      CreateCartResponse(
        success: json["success"],
        message: json["message"],
        data: Cart.fromJson(json["data"]),
      );
}

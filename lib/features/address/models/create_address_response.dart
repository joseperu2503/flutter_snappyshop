import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';

class CreateAddressResponse {
  final bool success;
  final String message;
  final Address data;

  CreateAddressResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateAddressResponse.fromJson(Map<String, dynamic> json) =>
      CreateAddressResponse(
        success: json["success"],
        message: json["message"],
        data: Address.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

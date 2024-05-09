class CreateAddressResponse {
  final bool success;
  final String message;

  CreateAddressResponse({
    required this.success,
    required this.message,
  });

  factory CreateAddressResponse.fromJson(Map<String, dynamic> json) =>
      CreateAddressResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}

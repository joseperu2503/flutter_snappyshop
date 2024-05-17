class CreateOrderResponse {
  final bool success;
  final String message;

  CreateOrderResponse({
    required this.success,
    required this.message,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) =>
      CreateOrderResponse(
        success: json["success"],
        message: json["message"],
      );
}

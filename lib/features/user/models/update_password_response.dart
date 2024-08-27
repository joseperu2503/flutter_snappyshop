class UpadatePasswordResponse {
  final bool success;
  final String message;

  UpadatePasswordResponse({
    required this.success,
    required this.message,
  });

  factory UpadatePasswordResponse.fromJson(Map<String, dynamic> json) =>
      UpadatePasswordResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}

class ValidateVerifyCodeResponse {
  final bool success;
  final String message;

  ValidateVerifyCodeResponse({
    required this.success,
    required this.message,
  });

  factory ValidateVerifyCodeResponse.fromJson(Map<String, dynamic> json) =>
      ValidateVerifyCodeResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}

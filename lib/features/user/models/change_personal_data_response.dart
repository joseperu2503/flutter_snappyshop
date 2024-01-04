class ChangePersonalDataResponse {
  final bool success;
  final String message;

  ChangePersonalDataResponse({
    required this.success,
    required this.message,
  });

  factory ChangePersonalDataResponse.fromJson(Map<String, dynamic> json) =>
      ChangePersonalDataResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}

class SaveSnappyTokenResponse {
  final bool success;
  final String message;

  SaveSnappyTokenResponse({
    required this.success,
    required this.message,
  });

  factory SaveSnappyTokenResponse.fromJson(Map<String, dynamic> json) =>
      SaveSnappyTokenResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}

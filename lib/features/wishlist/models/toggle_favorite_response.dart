class ToggleFavoriteResponse {
  final bool success;
  final String message;
  final bool data;

  ToggleFavoriteResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ToggleFavoriteResponse.fromJson(Map<String, dynamic> json) =>
      ToggleFavoriteResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
      };
}

import 'package:flutter_snappyshop/features/auth/models/auth_user.dart';

class UpdateProfileResponse {
  final bool success;
  final String message;
  final User data;

  UpdateProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) =>
      UpdateProfileResponse(
        success: json["success"],
        message: json["message"],
        data: User.fromJson(json["data"]),
      );
}

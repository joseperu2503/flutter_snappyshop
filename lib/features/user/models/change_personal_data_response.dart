import 'package:flutter_eshop/features/auth/models/auth_user.dart';

class ChangePersonalDataResponse {
  final bool success;
  final String message;
  final AuthUser data;

  ChangePersonalDataResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ChangePersonalDataResponse.fromJson(Map<String, dynamic> json) =>
      ChangePersonalDataResponse(
        success: json["success"],
        message: json["message"],
        data: AuthUser.fromJson(json["data"]),
      );
}

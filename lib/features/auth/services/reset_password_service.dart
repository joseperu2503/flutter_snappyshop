import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/config/constants/api_routes.dart';
import 'package:flutter_snappyshop/features/auth/models/send_verify_code_response.dart';
import 'package:flutter_snappyshop/features/auth/models/validate_verify_code_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/user/models/update_password_response.dart';

final api = Api();

class ResetPasswordService {
  static Future<SendVerifyCodeResponse> sendCode({
    required String email,
  }) async {
    try {
      Map<String, dynamic> form = {
        "email": email,
      };

      final response = await api.post(ApiRoutes.sendCode, data: form);

      return SendVerifyCodeResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while sending the verify code.');
    }
  }

  static Future<ValidateVerifyCodeResponse> validateCode({
    required String email,
    required String uuid,
    required String code,
  }) async {
    try {
      Map<String, dynamic> form = {
        "email": email,
        "uuid": uuid,
        "code": code,
      };

      final response = await api.post(ApiRoutes.validateCode, data: form);

      return ValidateVerifyCodeResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while validating the verify code.');
    }
  }

  static Future<UpadatePasswordResponse> resetPassword({
    required String password,
    required String confirmPassword,
    required String email,
    required String uuid,
    required String code,
  }) async {
    try {
      Map<String, dynamic> form = {
        "password": password,
        "password_confirmation": confirmPassword,
        "email": email,
        "uuid": uuid,
        "code": code,
      };

      final response = await api.post(ApiRoutes.resetPassword, data: form);

      return UpadatePasswordResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while changing the password.');
    }
  }
}

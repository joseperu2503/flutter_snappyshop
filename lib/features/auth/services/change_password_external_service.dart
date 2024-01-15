import 'package:dio/dio.dart';
import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/features/auth/models/send_verify_code_response.dart';
import 'package:flutter_snappyshop/features/auth/models/validate_verify_code_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/user/models/change_password_response.dart';

final api = Api();

class ChangePasswordExternalService {
  static Future<SendVerifyCodeResponse> sendVerifyCode({
    required String email,
  }) async {
    try {
      Map<String, dynamic> form = {
        "email": email,
      };

      final response = await api.post('/send-verify-code', data: form);

      return SendVerifyCodeResponse.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage = '';
      if (e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      } else {
        errorMessage = 'An error occurred while sending the verify code.';
      }
      throw ServiceException(errorMessage);
    } catch (e) {
      throw ServiceException(
          'An error occurred while sending the verify code.');
    }
  }

  static Future<ValidateVerifyCodeResponse> validateVerifyCode({
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

      final response = await api.post('/validate-verify-code', data: form);

      return ValidateVerifyCodeResponse.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage = '';
      if (e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      } else {
        errorMessage = 'An error occurred while validating the verify code.';
      }
      throw ServiceException(errorMessage);
    } catch (e) {
      throw ServiceException(
          'An error occurred while validating the verify code.');
    }
  }

  static Future<ChangePasswordResponse> changePassword({
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

      final response = await api.post('/change-password-external', data: form);

      return ChangePasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage = '';
      if (e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      } else {
        errorMessage = 'An error occurred while changing the password.';
      }
      throw ServiceException(errorMessage);
    } catch (e) {
      throw ServiceException('An error occurred while changing the password.');
    }
  }
}

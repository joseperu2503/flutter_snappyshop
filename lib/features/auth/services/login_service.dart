import 'package:dio/dio.dart';
import 'package:flutter_eshop/config/api/api.dart';
import 'package:flutter_eshop/features/auth/models/login_response.dart';
import 'package:flutter_eshop/features/shared/models/service_exception.dart';

final api = Api();

class LoginService {
  static Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> form = {
        "email": email,
        "password": password,
      };

      final response = await api.post('/login', data: form);

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage = '';
      if (e.response?.statusCode == 401) {
        errorMessage = 'Incorrect email or password';
      } else {
        errorMessage = 'An error occurred while trying to log in.';
      }
      throw ServiceException(errorMessage);
    } catch (e) {
      throw ServiceException('An error occurred while trying to log in.');
    }
  }
}

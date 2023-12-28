import 'package:dio/dio.dart';
import 'package:flutter_eshop/config/api/api.dart';
import 'package:flutter_eshop/features/auth/models/login_response.dart';
import 'package:flutter_eshop/features/shared/models/service_exception.dart';
import 'package:flutter_eshop/features/shared/services/key_value_storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final api = Api();

class AuthService {
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

  static Future<bool> verifyToken() async {
    final token = await KeyValueStorageService().getKeyValue<String>('token');

    if(token == null) return false;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    // Obtiene la marca de tiempo de expiración del token
    int expirationTimestamp = decodedToken['exp'];

    // Obtiene la marca de tiempo actual
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    //si el token es invalido
    if (currentTimestamp >= expirationTimestamp) {
      return false;
    }
    return true;
  }
}

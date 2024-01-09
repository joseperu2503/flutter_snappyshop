import 'package:dio/dio.dart';
import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/auth/models/auth_user.dart';
import 'package:flutter_snappyshop/features/auth/models/login_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/services/key_value_storage_service.dart';
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

  static Future<LoginResponse> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      Map<String, dynamic> form = {
        "name": name,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
      };

      final response = await api.post('/register', data: form);

      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while trying to register.');
    }
  }

  static Future<bool> verifyToken() async {
    final token = await KeyValueStorageService().getKeyValue<String>('token');

    if (token == null) return false;

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

  logout() async {
    await KeyValueStorageService().removeKey('token');
    appRouter.go('/');
  }

  static Future<AuthUser> getUser() async {
    try {
      final response = await api.get('/me');

      return AuthUser.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while loading the user.');
    }
  }
}

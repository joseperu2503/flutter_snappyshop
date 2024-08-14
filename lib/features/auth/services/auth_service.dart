import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/config/constants/storage_keys.dart';
import 'package:flutter_snappyshop/config/constants/api_routes.dart';
import 'package:flutter_snappyshop/features/auth/models/auth_user.dart';
import 'package:flutter_snappyshop/features/auth/models/login_response.dart';
import 'package:flutter_snappyshop/features/auth/models/register_response.dart';
import 'package:flutter_snappyshop/features/core/services/storage_service.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
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

      final response = await api.post(ApiRoutes.login, data: form);

      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(e, 'An error occurred while trying to log in.');
    }
  }

  static Future<RegisterResponse> register({
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
        "password_confirmation": confirmPassword,
      };

      final response = await api.post(ApiRoutes.register, data: form);

      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(e, 'An error occurred while trying to register.');
    }
  }

  static Future<(bool, int)> verifyToken() async {
    final token = await StorageService.get<String>(StorageKeys.token);
    if (token == null) return (false, 0);

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    // Obtiene la marca de tiempo de expiración del token
    int expirationTimestamp = decodedToken['exp'];

    // Obtiene la marca de tiempo actual
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    //si el token es invalido

    // Calcula el tiempo restante hasta la expiración en segundos
    int timeRemainingInSeconds = expirationTimestamp - currentTimestamp;

    if (timeRemainingInSeconds <= 0) {
      return (false, 0);
    }
    return (true, timeRemainingInSeconds);
  }

  static Future<User> getUser() async {
    try {
      final response = await api.get(ApiRoutes.me);

      return User.fromJson(response.data);
    } catch (e) {
      throw ServiceException(e, 'An error occurred while loading the user.');
    }
  }

  static Future<LoginResponse> loginGoogle({required String idToken}) async {
    try {
      Map<String, dynamic> form = {
        "id_token": idToken,
      };

      final response = await api.post(ApiRoutes.loginGoogle, data: form);

      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(e, 'An error occurred while trying to log in.');
    }
  }
}

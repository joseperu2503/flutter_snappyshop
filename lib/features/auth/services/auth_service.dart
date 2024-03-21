import 'package:dio/dio.dart';
import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/features/auth/models/auth_user.dart';
import 'package:flutter_snappyshop/features/auth/models/login_response.dart';
import 'package:flutter_snappyshop/features/auth/models/register_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/services/key_value_storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

      final response = await api.post('/register', data: form);

      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage = '';
      if (e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      } else {
        throw ServiceException('An error occurred while trying to register.');
      }
      throw ServiceException(errorMessage);
    } catch (e) {
      throw ServiceException('An error occurred while trying to register.');
    }
  }

  static Future<(bool, int)> verifyToken() async {
    final token = await KeyValueStorageService().getKeyValue<String>('token');
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

  static Future<AuthUser> getUser() async {
    try {
      final response = await api.get('/me');

      return AuthUser.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while loading the user.');
    }
  }

  static void signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      // scopes: [
      //   'https://www.googleapis.com/auth/userinfo.email',
      //   'openid',
      //   'https://www.googleapis.com/auth/userinfo.profile',
      // ],
      clientId:
          '267778652600-bgeqjchi3c9ohm8565eefkafh9kofodm.apps.googleusercontent.com',
    ).signIn();

    print(googleUser?.email);
    print(googleUser?.displayName);

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    print(googleAuth?.accessToken);
    // print(googleAuth?.idToken);
    // print(googleAuth?.idToken.toString());
    printLongString('${googleAuth?.idToken}');
  }
}

void printLongString(String text) {
  final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern
      .allMatches(text)
      .forEach((RegExpMatch match) => print(match.group(0)));
}

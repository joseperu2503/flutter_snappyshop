import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/user/models/change_password_response.dart';
import 'package:flutter_snappyshop/features/user/models/change_personal_data_response.dart';

final api = Api();

class UserService {
  static Future<ChangePasswordResponse> changePasswordInternal({
    required String password,
    required String confirmPassword,
  }) async {
    try {
      Map<String, dynamic> form = {
        "password": password,
        "password_confirmation": confirmPassword,
      };

      final response = await api.post('/change-password-internal', data: form);

      return ChangePasswordResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while changing the password.');
    }
  }

  static Future<ChangePersonalDataResponse> changePersonalData({
    required int? userId,
    required String name,
    required String email,
    required String? photo,
  }) async {
    try {
      Map<String, dynamic> form = {
        "id": userId,
        "email": email,
        "name": name,
        'profile_photo': photo,
      };

      final response = await api.post('/change-personal-data', data: form);

      return ChangePersonalDataResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          'An error occurred while changing the personal data.');
    }
  }
}

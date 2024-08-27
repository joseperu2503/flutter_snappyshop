import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/config/constants/api_routes.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/user/models/update_password_response.dart';

final api = Api();

class PasswordService {
  static Future<UpadatePasswordResponse> updatePassword({
    required String password,
    required String confirmPassword,
  }) async {
    try {
      Map<String, dynamic> form = {
        "password": password,
        "password_confirmation": confirmPassword,
      };

      final response = await api.put(
        ApiRoutes.updatePassword,
        data: form,
      );

      return UpadatePasswordResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while updating the password.');
    }
  }
}

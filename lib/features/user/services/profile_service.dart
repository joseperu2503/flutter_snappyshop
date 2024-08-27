import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/config/constants/api_routes.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/user/models/update_profile_response.dart';

final api = Api();

class ProfileService {
  static Future<UpdateProfileResponse> updateProfile({
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

      final response = await api.put(
        ApiRoutes.updateProfile,
        data: form,
      );

      return UpdateProfileResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while updating your account information.');
    }
  }
}

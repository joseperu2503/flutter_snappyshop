import 'package:dio/dio.dart';
import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/config/api/api_images.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/user/models/upload_photo_response.dart';
import 'package:image_picker/image_picker.dart';

final api = Api();

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> selectPhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return null;
    return image.path;
  }

  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.front,
      maxWidth: 800,
    );

    if (photo == null) return null;
    return photo.path;
  }

  static Future<UploadPhotoResponse> uploadPhoto({
    required String path,
  }) async {
    try {
      final FormData data = FormData.fromMap({
        'image': MultipartFile.fromFileSync(path),
        'folder_name': 'profile_photos',
      });

      final response = await ApiImages().post('/upload_image', data: data);

      return UploadPhotoResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while upload photo.');
    }
  }
}

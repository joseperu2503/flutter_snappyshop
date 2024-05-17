import 'package:flutter_snappyshop/config/constants/storage_keys.dart';
import 'package:flutter_snappyshop/features/core/services/storage_service.dart';

class DarkModeService {
  static setDarkMode(bool status) async {
    await StorageService.set<bool>(StorageKeys.darkMode, status);
  }

  static Future<bool> getDarkMode() async {
    final darkMode = await StorageService.get<bool>(StorageKeys.darkMode);

    return darkMode ?? false;
  }
}

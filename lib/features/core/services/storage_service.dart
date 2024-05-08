import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  static Future<T?> get<T>(String key) async {
    try {
      final prefs = await getSharedPreferences();
      final data = prefs.getString(key);
      if (data == null) return null;
      final value = jsonDecode(data);
      return value['data'] as T;
    } catch (e) {
      return null;
    }
  }

  static Future<void> remove(String key) async {
    final prefs = await getSharedPreferences();
    await prefs.remove(key);
  }

  static Future<void> set<T>(String key, T value) async {
    final prefs = await getSharedPreferences();
    final Map<String, dynamic> data = {'data': value};
    prefs.setString(key, jsonEncode(data));
  }
}

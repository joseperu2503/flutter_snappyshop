import 'package:dio/dio.dart';
import 'package:flutter_snappyshop/config/constants/environment.dart';

class ApiMapbox {
  static final Dio _dioBase = Dio(BaseOptions(baseUrl: Environment.urlMapbox));

  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dioBase.get(path, queryParameters: queryParameters);
  }
}

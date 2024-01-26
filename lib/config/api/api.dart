import 'package:dio/dio.dart';
import 'package:flutter_snappyshop/config/constants/environment.dart';
import 'package:flutter_snappyshop/config/constants/storage_keys.dart';
import 'package:flutter_snappyshop/features/shared/services/key_value_storage_service.dart';

class Api {
  final Dio _dioBase = Dio(BaseOptions(baseUrl: Environment.urlBase));

  final keyValueStorageService = KeyValueStorageService();
  InterceptorsWrapper interceptor = InterceptorsWrapper();

  Api() {
    interceptor = InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token =
            await keyValueStorageService.getKeyValue<String>(StorageKeys.token);
        options.headers['Authorization'] = 'Bearer $token';
        options.headers['Accept'] = 'application/json';

        return handler.next(options);
      },
    );
    _dioBase.interceptors.add(interceptor);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dioBase.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {required Object data}) async {
    return _dioBase.post(path, data: data);
  }
}

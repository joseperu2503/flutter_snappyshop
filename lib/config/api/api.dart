import 'package:dio/dio.dart';
import 'package:flutter_eshop/config/constants/environment.dart';
import 'package:flutter_eshop/features/shared/services/key_value_storage_service.dart';

class Api {
  final Dio _dioBase = Dio(BaseOptions(baseUrl: Environment.urlBase));

  final keyValueStorageService = KeyValueStorageService();
  InterceptorsWrapper interceptor = InterceptorsWrapper();

  Api() {
    interceptor = InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await keyValueStorageService.getKeyValue<String>('token');
        options.headers['Authorization'] = 'Bearer $token';

        return handler.next(options);
      },
    );
    _dioBase.interceptors.add(interceptor);
  }

  Future<Response> get(String path) async {
    return _dioBase.get(path);
  }

  Future<Response> post(String path, {required Object data}) async {
    return _dioBase.post(path, data: data);
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_snappyshop/config/constants/environment.dart';

class ApiImages {
  final Dio _dioBase = Dio(BaseOptions(baseUrl: Environment.urlImages));

  InterceptorsWrapper interceptor = InterceptorsWrapper();

  ApiImages() {
    interceptor = InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Accept'] = 'application/json';

        return handler.next(options);
      },
    );
    _dioBase.interceptors.add(interceptor);
  }

  Future<Response> post(String path, {required Object data}) async {
    return _dioBase.post(path, data: data);
  }
}

import 'package:dio/dio.dart';

class ServiceException implements Exception {
  final dynamic e;
  final String? _errorMessage;

  ServiceException(this.e, this._errorMessage);

  String get message {
    if (e is DioException) {
      try {
        if (e.response?.data['message'] != null &&
            e.response?.data['message'] is String &&
            e.response?.data['message'] != '') {
          return e.response?.data['message'];
        }
      } catch (_) {}
    }

    return _errorMessage ?? '';
  }
}

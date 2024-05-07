import 'package:flutter_snappyshop/config/api/api_mapbox.dart';
import 'package:flutter_snappyshop/config/constants/environment.dart';
import 'package:flutter_snappyshop/features/address/models/mapbox_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';

class MapBoxService {
  static Future<MapboxResponse> searchbox({required String query}) async {
    try {
      Map<String, dynamic> queryParameters = {
        "q": query,
        "access_token": Environment.tokenMapbox,
        "country": "pe",
        "language": "en",
      };

      final response = await ApiMapbox.get(
        '/search/searchbox/v1/forward',
        queryParameters: queryParameters,
      );

      return MapboxResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while searching the address.');
    }
  }

  static Future<MapboxResponse> geocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "access_token": Environment.tokenMapbox,
        // "country": "pe",
        "language": "en",
        "types": "street",
        "longitude": longitude,
        "latitude": latitude,
      };

      final response = await ApiMapbox.get(
        '/search/geocode/v6/reverse',
        queryParameters: queryParameters,
      );

      return MapboxResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while searching the address.');
    }
  }
}

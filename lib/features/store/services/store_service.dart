import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/config/constants/api_routes.dart';
import 'package:flutter_snappyshop/features/store/models/stores_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';

final api = Api();

class StoreService {
  static Future<StoresResponse> getStores({
    int page = 1,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "page": page,
      };

      final response =
          await api.get(ApiRoutes.stores, queryParameters: queryParameters);

      return StoresResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(e, 'An error occurred while loading the stores.');
    }
  }
}

import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/config/constants/api_routes.dart';
import 'package:flutter_snappyshop/features/orders/models/my_orders_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';

final api = Api();

class OrderService {
  static Future<MyOrdersResponse> getOrders({
    int page = 1,
    int? orderStatusId,
  }) async {
    Map<String, dynamic> queryParameters = {
      "page": page,
      "order_status_id": orderStatusId,
    };

    try {
      final response = await api.get(
        ApiRoutes.myOrders,
        queryParameters: queryParameters,
      );

      return MyOrdersResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while loading the orders.');
    }
  }
}

import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/features/cart/models/create_cart.dart';
import 'package:flutter_snappyshop/features/cart/models/create_cart_response.dart';
import 'package:flutter_snappyshop/features/orders/models/my_orders_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';

final api = Api();

class OrderService {
  static Future<MyOrdersResponse> getOrders({
    int page = 1,
  }) async {
    Map<String, dynamic> queryParameters = {
      "page": page,
    };

    try {
      final response =
          await api.get('/v2/my-orders', queryParameters: queryParameters);

      return MyOrdersResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while loading the orders.');
    }
  }

  static Future<CreateCartResponse> updateCart(
      {required List<CreateCart> products}) async {
    try {
      List<Map<String, dynamic>> productsList =
          List<Map<String, dynamic>>.from(products.map((x) => x.toJson()));

      Map<String, dynamic> form = {
        "products": productsList,
      };

      final response = await api.post('/cart', data: form);

      return CreateCartResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while updating the cart.');
    }
  }
}

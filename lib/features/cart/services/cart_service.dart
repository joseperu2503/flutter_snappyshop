import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/config/constants/api_routes.dart';
import 'package:flutter_snappyshop/features/cart/models/cart.dart';
import 'package:flutter_snappyshop/features/cart/models/create_cart.dart';
import 'package:flutter_snappyshop/features/cart/models/create_cart_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';

final api = Api();

class CartService {
  static Future<Cart> getCart() async {
    try {
      final response = await api.get(ApiRoutes.getCart);

      return Cart.fromJson(response.data);
    } catch (e) {
      throw ServiceException(e, 'An error occurred while loading the cart.');
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

      final response = await api.post(ApiRoutes.updateCart, data: form);

      return CreateCartResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(e, 'An error occurred while updating the cart.');
    }
  }
}

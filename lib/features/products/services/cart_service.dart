import 'package:flutter_eshop/config/api/api.dart';
import 'package:flutter_eshop/features/products/models/cart.dart';
import 'package:flutter_eshop/features/products/models/create_cart.dart';
import 'package:flutter_eshop/features/products/models/create_cart_response.dart';
import 'package:flutter_eshop/features/shared/models/service_exception.dart';

final api = Api();

class CartService {
  static Future<Cart> getCart() async {
    try {
      final response = await api.get('/my-cart');

      return Cart.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while loading the cart.');
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

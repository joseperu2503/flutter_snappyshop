import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/features/orders/models/create_order.dart';
import 'package:flutter_snappyshop/features/orders/models/create_order_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';

final api = Api();

class CheckoutService {
  static Future<CreateOrderResponse> createOrder({
    required List<CreateOrder> products,
    required String? cardNumber,
    required int? paymentMethod,
    required String? cardHolderName,
    required int? addresId,
  }) async {
    try {
      List<Map<String, dynamic>> productsList =
          List<Map<String, dynamic>>.from(products.map((x) => x.toJson()));

      Map<String, dynamic> form = {
        "products": productsList,
        "card_number": cardNumber,
        "payment_method_id": paymentMethod,
        "card_holder_name": cardHolderName,
        "address_id": addresId,
      };

      final response = await api.post('/v2/orders', data: form);

      return CreateOrderResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while creating the order.');
    }
  }
}

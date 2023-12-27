import 'package:flutter_eshop/config/api/api.dart';
import 'package:flutter_eshop/features/products/models/products_response.dart';
import 'package:flutter_eshop/features/shared/models/service_exception.dart';

final api = Api();

class ProductsService {
  static Future<ProductsResponse> getProducts({int page = 1}) async {
    Map<String, dynamic> queryParameters = {
      "page": page,
    };

    try {
      final response =
          await api.get('/products', queryParameters: queryParameters);

      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while loading the products.');
    }
  }

  static Future<Product> getProductDetail({required String productId}) async {
    try {
      final response = await api.get('/products/$productId');

      return Product.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while loading the product.');
    }
  }
}

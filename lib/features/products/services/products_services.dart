import 'package:flutter_eshop/config/api/api.dart';
import 'package:flutter_eshop/features/products/models/brand.dart';
import 'package:flutter_eshop/features/products/models/category.dart';
import 'package:flutter_eshop/features/products/models/products_response.dart';
import 'package:flutter_eshop/features/shared/models/service_exception.dart';

final api = Api();

class ProductsService {
  static Future<ProductsResponse> getProducts({
    int page = 1,
    int? categoryId,
  }) async {
    Map<String, dynamic> queryParameters = {
      "page": page,
      "category_id": categoryId,
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

  static Future<List<Brand>> getBrands() async {
    try {
      final response = await api.get('/brands');

      return List<Brand>.from(response.data.map((x) => Brand.fromJson(x)));
    } catch (e) {
      throw ServiceException('An error occurred while loading the brands.');
    }
  }

  static Future<List<Category>> getCategories() async {
    try {
      final response = await api.get('/categories');

      return List<Category>.from(
          response.data.map((x) => Category.fromJson(x)));
    } catch (e) {
      throw ServiceException('An error occurred while loading the brands.');
    }
  }
}

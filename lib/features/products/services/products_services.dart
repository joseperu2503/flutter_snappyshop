import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/config/constants/api_routes.dart';
import 'package:flutter_snappyshop/features/products/models/category.dart';
import 'package:flutter_snappyshop/features/products/models/product_detail.dart';
import 'package:flutter_snappyshop/features/search/models/filter_response.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/wishlist/models/toggle_favorite_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';

final api = Api();

class ProductsService {
  static Future<ProductsResponse> getProducts({
    int page = 1,
    int? categoryId,
    int? storeId,
    String? minPrice,
    String? maxPrice,
    String? search,
  }) async {
    Map<String, dynamic> queryParameters = {
      "page": page,
      "category_id": categoryId,
      "store_id": storeId,
      "min_price": minPrice,
      "max_price": maxPrice,
      "search": search,
    };

    try {
      final response = await api.get(ApiRoutes.getProducts,
          queryParameters: queryParameters);

      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while loading the products.');
    }
  }

  static Future<ProductDetail> getProductDetail(
      {required String productId}) async {
    try {
      final response = await api.get('${ApiRoutes.getProduct}/$productId');

      return ProductDetail.fromJson(response.data);
    } catch (e) {
      throw ServiceException(e, 'An error occurred while loading the product.');
    }
  }

  static Future<List<Category>> getCategories() async {
    try {
      final response = await api.get(ApiRoutes.categories);

      return List<Category>.from(
          response.data.map((x) => Category.fromJson(x)));
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while loading the categories.');
    }
  }

  static Future<FilterResponse> getFilterData() async {
    try {
      final response = await api.get(ApiRoutes.productsFilterData);

      return FilterResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(e, 'An error occurred while loading the filters.');
    }
  }

  static Future<ProductsResponse> getMyFavoriteProducts({
    int page = 1,
  }) async {
    Map<String, dynamic> queryParameters = {
      "page": page,
    };

    try {
      final response = await api.get(ApiRoutes.myFavoriteProducts,
          queryParameters: queryParameters);

      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while loading the products.');
    }
  }

  static Future<ToggleFavoriteResponse> toggleFavoriteProduct({
    required bool isFavorite,
    required int productId,
  }) async {
    Map<String, dynamic> form = {
      "is_favorite": isFavorite,
      "product_id": productId,
    };

    try {
      final response =
          await api.post(ApiRoutes.toggleFavoriteProduct, data: form);

      return ToggleFavoriteResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while setting up the product.');
    }
  }
}

import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/features/products/models/brand.dart';
import 'package:flutter_snappyshop/features/products/models/category.dart';
import 'package:flutter_snappyshop/features/search/models/filter_response.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/wishlist/models/toggle_favorite_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';

final api = Api();

class ProductsService {
  static Future<ProductsResponse> getProducts({
    int page = 1,
    int? categoryId,
    int? brandId,
    String? minPrice,
    String? maxPrice,
    String? search,
  }) async {
    Map<String, dynamic> queryParameters = {
      "page": page,
      "category_id": categoryId,
      "brand_id": brandId,
      "min_price": minPrice,
      "max_price": maxPrice,
      "search": search,
    };

    try {
      final response =
          await api.get('/v2/products', queryParameters: queryParameters);

      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while loading the products.');
    }
  }

  static Future<Product> getProductDetail({required String productId}) async {
    try {
      final response = await api.get('/v2/products/$productId');

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

  static Future<FilterResponse> getFilterData() async {
    try {
      final response = await api.get('/v2/products/filter-data');

      return FilterResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while loading the filters.');
    }
  }

  static Future<ProductsResponse> getMyFavoriteProducts({
    int page = 1,
  }) async {
    Map<String, dynamic> queryParameters = {
      "page": page,
    };

    try {
      final response = await api.get('/v2/my-favorite-products',
          queryParameters: queryParameters);

      return ProductsResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while loading the products.');
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
          await api.post('/v2/toggle-favorite-product', data: form);

      return ToggleFavoriteResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while setting up the product.');
    }
  }
}

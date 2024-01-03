import 'package:flutter_eshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_eshop/features/products/models/brand.dart';
import 'package:flutter_eshop/features/products/models/products_response.dart';
import 'package:flutter_eshop/features/products/models/category.dart';
import 'package:flutter_eshop/features/products/providers/search_provider.dart';
import 'package:flutter_eshop/features/products/services/products_services.dart';
import 'package:flutter_eshop/features/shared/models/service_exception.dart';
import 'package:flutter_eshop/features/shared/providers/loader_provider.dart';
import 'package:flutter_eshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier(ref);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  // final GoRouter router = appRouter;

  ProductsNotifier(this.ref) : super(ProductsState());
  final StateNotifierProviderRef ref;

  getDashboardData() async {
    ref.read(loaderProvider.notifier).showLoader();

    try {
      await Future.wait([
        getProducts(withSpinner: false),
        getBrands(),
        getCategories(),
        ref.read(searchProvider.notifier).getFilterData(),
        ref.read(authProvider.notifier).getUser(),
      ]);
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
    ref.read(loaderProvider.notifier).dismissLoader();
  }

  Future<void> getProducts({bool withSpinner = true}) async {
    if (state.page > state.totalPages || state.loadingProducts) return;

    state = state.copyWith(
      loadingProducts: withSpinner,
    );

    try {
      final ProductsResponse response = await ProductsService.getProducts(
        page: state.page,
      );
      state = state.copyWith(
        products: [...state.products, ...response.data],
        totalPages: response.meta.lastPage,
        page: state.page + 1,
      );
    } on ServiceException catch (e) {
      state = state.copyWith(
        loadingProducts: false,
      );
      if (withSpinner) {
        ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      }
      throw ServiceException(e.message);
    }

    state = state.copyWith(
      loadingProducts: false,
    );
  }

  Future<void> getBrands() async {
    try {
      final response = await ProductsService.getBrands();
      state = state.copyWith(
        brands: response,
      );
    } on ServiceException catch (e) {
      throw ServiceException(e.message);
    }
  }

  Future<void> getCategories() async {
    try {
      final response = await ProductsService.getCategories();
      state = state.copyWith(
        categories: response,
      );
    } on ServiceException catch (e) {
      throw ServiceException(e.message);
    }
  }

  getProduct({required String productId}) async {
    if (state.productDetails[productId] == null) {
      ref.read(loaderProvider.notifier).showLoader();

      try {
        final product =
            await ProductsService.getProductDetail(productId: productId);
        state = state.copyWith(
          productDetails: {...state.productDetails, productId: product},
        );
      } on ServiceException catch (e) {
        ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      }
      ref.read(loaderProvider.notifier).dismissLoader();
    }
  }
}

class ProductsState {
  final List<Product> products;
  final List<Brand> brands;
  final List<Category> categories;
  final Map<String, Product> productDetails;
  final int page;
  final int totalPages;
  final bool loadingProducts;

  ProductsState({
    this.products = const [],
    this.brands = const [],
    this.categories = const [],
    this.productDetails = const {},
    this.page = 1,
    this.totalPages = 1,
    this.loadingProducts = false,
  });

  ProductsState copyWith({
    List<Product>? products,
    List<Brand>? brands,
    List<Category>? categories,
    Map<String, Product>? productDetails,
    int? page,
    int? totalPages,
    bool? loadingProducts,
  }) =>
      ProductsState(
        products: products ?? this.products,
        brands: brands ?? this.brands,
        categories: categories ?? this.categories,
        productDetails: productDetails ?? this.productDetails,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        loadingProducts: loadingProducts ?? this.loadingProducts,
      );
}

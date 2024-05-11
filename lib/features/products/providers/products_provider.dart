import 'package:flutter_snappyshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_snappyshop/features/products/models/brand.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/search/providers/search_provider.dart';
import 'package:flutter_snappyshop/features/products/services/products_services.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier(ref);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  ProductsNotifier(this.ref) : super(ProductsState());
  final StateNotifierProviderRef ref;

  initData() {
    state = state.copyWith(
      brands: [],
      products: [],
      page: 1,
      totalPages: 1,
      productDetails: {},
      loadingProducts: false,
    );
  }

  getDashboardData() async {
    state = state.copyWith(
      dashboardStatus: LoadingStatus.loading,
    );
    ref.read(cartProvider.notifier).initData();
    initData();
    FlutterNativeSplash.remove();

    try {
      ref.read(authProvider.notifier).setuser(null);
      await Future.wait([
        getProducts(),
        getBrands(),
        ref.read(searchProvider.notifier).getFilterData(),
        ref.read(authProvider.notifier).getUser(),
        ref.read(cartProvider.notifier).getCartService(),
      ]);
      state = state.copyWith(
        dashboardStatus: LoadingStatus.success,
      );
    } on ServiceException catch (e) {
      state = state.copyWith(
        dashboardStatus: LoadingStatus.error,
      );
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
  }

  Future<void> getProducts() async {
    if (state.page > state.totalPages || state.loadingProducts) return;

    state = state.copyWith(
      loadingProducts: true,
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
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
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

  setProduct(Product product) {
    if (state.productDetails[product.id.toString()] == null) {
      state = state.copyWith(
        productDetails: {
          ...state.productDetails,
          product.id.toString(): product
        },
      );
    }
  }

  getProduct({required String productId}) async {
    if (state.productDetails[productId] == null) {
      try {
        final product =
            await ProductsService.getProductDetail(productId: productId);
        state = state.copyWith(
          productDetails: {...state.productDetails, productId: product},
        );
      } on ServiceException catch (e) {
        ref.read(snackbarProvider.notifier).showSnackbar(e.message);
        throw ServiceException(e.message);
      }
    }
  }

  setFavoriteProduct(bool isFavorite, int productId) {
    final List<Product> products = state.products.map((product) {
      if (product.id == productId) {
        product = product.copyWith(
          isFavorite: isFavorite,
        );
      }
      return product;
    }).toList();

    if (state.productDetails[productId.toString()] != null) {
      final productDetails = state.productDetails.map((key, product) {
        if (key == productId.toString()) {
          return MapEntry(key, product.copyWith(isFavorite: isFavorite));
        }
        return MapEntry(key, product);
      });

      state = state.copyWith(
        productDetails: productDetails,
      );
    }

    state = state.copyWith(products: products);
  }
}

class ProductsState {
  final List<Product> products;
  final List<Brand> brands;
  final Map<String, Product> productDetails;
  final int page;
  final int totalPages;
  final bool loadingProducts;
  final LoadingStatus dashboardStatus;

  ProductsState({
    this.products = const [],
    this.brands = const [],
    this.productDetails = const {},
    this.page = 1,
    this.totalPages = 1,
    this.loadingProducts = false,
    this.dashboardStatus = LoadingStatus.none,
  });

  ProductsState copyWith({
    List<Product>? products,
    List<Brand>? brands,
    Map<String, Product>? productDetails,
    int? page,
    int? totalPages,
    bool? loadingProducts,
    LoadingStatus? dashboardStatus,
  }) =>
      ProductsState(
        products: products ?? this.products,
        brands: brands ?? this.brands,
        productDetails: productDetails ?? this.productDetails,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        loadingProducts: loadingProducts ?? this.loadingProducts,
        dashboardStatus: dashboardStatus ?? this.dashboardStatus,
      );
}

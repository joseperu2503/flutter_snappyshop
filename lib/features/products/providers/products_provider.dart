import 'package:flutter_snappyshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_snappyshop/features/products/models/product_detail.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/search/providers/search_provider.dart';
import 'package:flutter_snappyshop/features/products/services/products_services.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/store/models/stores_response.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier(ref);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  ProductsNotifier(this.ref) : super(ProductsState());
  final StateNotifierProviderRef ref;

  initData() {
    state = state.copyWith(
      stores: [],
      products: [],
      page: 1,
      totalPages: 1,
      productDetails: {},
      loadingProducts: LoadingStatus.none,
    );
  }

  getDashboardData() async {
    state = state.copyWith(
      dashboardStatus: LoadingStatus.loading,
    );
    ref.read(cartProvider.notifier).initData();
    initData();

    try {
      ref.read(authProvider.notifier).setuser(null);
      await Future.wait([
        getProducts(),
        getStores(),
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
    if (state.page > state.totalPages ||
        state.loadingProducts == LoadingStatus.loading) return;

    state = state.copyWith(
      loadingProducts: LoadingStatus.loading,
    );

    try {
      final ProductsResponse response = await ProductsService.getProducts(
        page: state.page,
      );
      state = state.copyWith(
        products: [...state.products, ...response.results],
        totalPages: response.info.lastPage,
        page: state.page + 1,
        loadingProducts: LoadingStatus.success,
      );
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      state = state.copyWith(
        loadingProducts: LoadingStatus.error,
      );
      throw ServiceException(null, e.message);
    }
  }

  Future<void> getStores() async {
    try {
      final response = await ProductsService.getStores();
      state = state.copyWith(
        stores: response.results,
      );
    } on ServiceException catch (e) {
      throw ServiceException(null, e.message);
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
        throw ServiceException(null, e.message);
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
      final productDetails = state.productDetails.map((key, productDetail) {
        if (key == productId.toString()) {
          return MapEntry(
              key,
              productDetail.copyWith(
                product: productDetail.product.copyWith(
                  isFavorite: isFavorite,
                ),
              ));
        }
        return MapEntry(key, productDetail);
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
  final List<Store> stores;
  final Map<String, ProductDetail> productDetails;
  final int page;
  final int totalPages;
  final LoadingStatus loadingProducts;
  final LoadingStatus dashboardStatus;

  ProductsState({
    this.products = const [],
    this.stores = const [],
    this.productDetails = const {},
    this.page = 1,
    this.totalPages = 1,
    this.loadingProducts = LoadingStatus.none,
    this.dashboardStatus = LoadingStatus.none,
  });

  ProductsState copyWith({
    List<Product>? products,
    List<Store>? stores,
    Map<String, ProductDetail>? productDetails,
    int? page,
    int? totalPages,
    LoadingStatus? loadingProducts,
    LoadingStatus? dashboardStatus,
  }) =>
      ProductsState(
        products: products ?? this.products,
        stores: stores ?? this.stores,
        productDetails: productDetails ?? this.productDetails,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        loadingProducts: loadingProducts ?? this.loadingProducts,
        dashboardStatus: dashboardStatus ?? this.dashboardStatus,
      );
}

import 'package:flutter_eshop/features/products/models/products_response.dart';
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
        getProducts(),
        getBrands(),
      ]);
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
    ref.read(loaderProvider.notifier).dismissLoader();
  }

  Future<void> getProducts() async {
    try {
      final ProductsResponse response =
          await ProductsService.getProducts(page: 1);
      state = state.copyWith(
        products: response.data,
      );
    } on ServiceException catch (e) {
      throw ServiceException(e.message);
    }
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

  final Map<String, Product> productDetails;
  ProductsState({
    this.products = const [],
    this.brands = const [],
    this.productDetails = const {},
  });

  ProductsState copyWith({
    List<Product>? products,
    List<Brand>? brands,
    Map<String, Product>? productDetails,
  }) =>
      ProductsState(
        products: products ?? this.products,
        brands: brands ?? this.brands,
        productDetails: productDetails ?? this.productDetails,
      );
}

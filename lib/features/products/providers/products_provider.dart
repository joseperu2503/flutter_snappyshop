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

  getProducts() async {
    ref.read(loaderProvider.notifier).showLoader();

    try {
      final ProductsResponse response =
          await ProductsService.getProducts(page: 1);
      state = state.copyWith(
        products: response.data,
      );
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    ref.read(loaderProvider.notifier).dismissLoader();
  }
}

class ProductsState {
  final List<Product> products;

  ProductsState({
    this.products = const [],
  });

  ProductsState copyWith({
    List<Product>? products,
  }) =>
      ProductsState(
        products: products ?? this.products,
      );
}

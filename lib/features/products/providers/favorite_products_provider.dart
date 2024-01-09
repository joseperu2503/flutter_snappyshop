import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/products/providers/products_provider.dart';
import 'package:flutter_snappyshop/features/products/providers/search_provider.dart';
import 'package:flutter_snappyshop/features/products/services/products_services.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteProductsProvider =
    StateNotifierProvider<FavoriteProductsNotifier, FavoriteProductsState>(
        (ref) {
  return FavoriteProductsNotifier(ref);
});

class FavoriteProductsNotifier extends StateNotifier<FavoriteProductsState> {
  // final GoRouter router = appRouter;

  FavoriteProductsNotifier(this.ref) : super(FavoriteProductsState());
  final StateNotifierProviderRef ref;

  initState() {
    state = state.copyWith(
      loadingProducts: false,
      page: 1,
      products: [],
      totalPages: 1,
    );
  }

  Future<void> getProducts() async {
    if (state.page > state.totalPages || state.loadingProducts) return;

    state = state.copyWith(
      loadingProducts: true,
    );
    try {
      final ProductsResponse response =
          await ProductsService.getMyFavoriteProducts(
        page: state.page,
      );

      state = state.copyWith(
        products: [...state.products, ...response.data],
        totalPages: response.meta.lastPage,
        page: state.page + 1,
      );
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
    state = state.copyWith(
      loadingProducts: false,
    );
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

    state = state.copyWith(products: products);

    ref
        .read(productsProvider.notifier)
        .setFavoriteProduct(isFavorite, productId);
    ref.read(searchProvider.notifier).setFavoriteProduct(isFavorite, productId);
  }
}

class FavoriteProductsState {
  final List<Product> products;
  final int page;
  final int totalPages;
  final bool loadingProducts;

  FavoriteProductsState({
    this.products = const [],
    this.page = 1,
    this.totalPages = 1,
    this.loadingProducts = false,
  });

  FavoriteProductsState copyWith({
    List<Product>? products,
    int? page,
    int? totalPages,
    bool? loadingProducts,
  }) =>
      FavoriteProductsState(
        products: products ?? this.products,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        loadingProducts: loadingProducts ?? this.loadingProducts,
      );
}

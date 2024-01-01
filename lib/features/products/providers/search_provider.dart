import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_eshop/features/products/models/filter.dart';
import 'package:flutter_eshop/features/products/models/products_response.dart';
import 'package:flutter_eshop/features/products/services/products_services.dart';
import 'package:flutter_eshop/features/shared/models/service_exception.dart';
import 'package:flutter_eshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});

class SearchNotifier extends StateNotifier<SearchState> {
  // final GoRouter router = appRouter;

  SearchNotifier(this.ref) : super(SearchState());
  final StateNotifierProviderRef ref;

  initState() {
    state = state.copyWith(
      filter: () => Filter(
        category: null,
        brand: null,
        minPrice: '',
        maxPrice: '',
        search: '',
      ),
      loadingProducts: false,
      page: 1,
      products: [],
      totalPages: 1,
    );
  }

  Future<void> searchProducts() async {
    state = state.copyWith(
      loadingProducts: true,
    );

    final filter = state.filter;
    try {
      final ProductsResponse response = await ProductsService.getProducts(
        page: state.page,
        categoryId: state.filter?.category?.id,
        brandId: state.filter?.category?.id,
        minPrice: state.filter?.minPrice,
        maxPrice: state.filter?.maxPrice,
        search: state.filter?.search,
      );

      if (filter == state.filter) {
        state = state.copyWith(
          products: [...state.products, ...response.data],
          totalPages: response.meta.lastPage,
          page: state.page + 1,
        );
      }
    } on ServiceException catch (e) {
      if (filter == state.filter) {
        ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      }
    }
    if (filter == state.filter) {
      state = state.copyWith(
        loadingProducts: false,
      );
    }
  }

  loadMoreProducts() {
    if (state.page > state.totalPages || state.loadingProducts) return;
    searchProducts();
  }

  changeFilter(Filter? filter) {
    state = state.copyWith(
      products: [],
      page: 1,
      filter: () => filter,
    );
    searchProducts();
  }

  Timer? _debounceTimer;

  changeSearch(String search) {
    if (search == '') {
      state = state.copyWith(
        loadingProducts: false,
        products: [],
        page: 1,
        filter: () => state.filter?.copyWith(
          search: search,
        ),
      );
      return;
    }

    state = state.copyWith(
      loadingProducts: true,
      products: [],
      page: 1,
      filter: () => state.filter?.copyWith(
        search: search,
      ),
    );

    final filter = state.filter;

    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 1000),
      () {
        if (filter != state.filter) return;
        searchProducts();
      },
    );
  }
}

class SearchState {
  final List<Product> products;
  final Filter? filter;
  final int page;
  final int totalPages;
  final bool loadingProducts;

  SearchState({
    this.products = const [],
    this.filter,
    this.page = 1,
    this.totalPages = 1,
    this.loadingProducts = false,
  });

  SearchState copyWith({
    List<Product>? products,
    ValueGetter<Filter?>? filter,
    int? page,
    int? totalPages,
    bool? loadingProducts,
  }) =>
      SearchState(
        products: products ?? this.products,
        filter: filter != null ? filter() : this.filter,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        loadingProducts: loadingProducts ?? this.loadingProducts,
      );
}

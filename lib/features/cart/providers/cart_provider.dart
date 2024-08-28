import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/features/cart/models/cart.dart';
import 'package:flutter_snappyshop/features/cart/models/create_cart.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/cart/services/cart_service.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref);
});

class CartNotifier extends StateNotifier<CartState> {
  // final GoRouter router = appRouter;

  CartNotifier(this.ref) : super(CartState());
  final StateNotifierProviderRef ref;

  initData() {
    state = state.copyWith(
      cart: () => null,
    );
  }

  Future<void> getCart() async {
    state = state.copyWith(
      loading: true,
    );
    try {
      await getCartService();
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
    state = state.copyWith(
      loading: false,
    );
  }

  Future<void> getCartService() async {
    try {
      final Cart response = await CartService.getCart();

      state = state.copyWith(
        cart: () => response,
      );
    } on ServiceException catch (e) {
      throw ServiceException(null, e.message);
    }
  }

  addUnit({
    required Product product,
    required int quantity,
    bool withDobuncer = true,
  }) async {
    if (state.cart == null) return;

    int index = state.cart!.products
        .map((e) => e.productDetail.id)
        .toList()
        .indexOf(product.id);

    if (index != -1) {
      state = state.copyWith(
        cart: () => state.cart!.copyWith(
          products: state.cart!.products
              .map((pc) {
                if (pc.productDetail.id == product.id) {
                  return pc.copyWith(
                    quantity: pc.quantity + quantity,
                  );
                }

                return pc;
              })
              .where((pc) => pc.quantity != 0)
              .toList(),
        ),
      );
    } else {
      state = state.copyWith(
        cart: () => state.cart!.copyWith(
          products: [
            ...state.cart!.products,
            ProductCart(
              productDetail: product,
              quantity: quantity,
            )
          ],
        ),
      );
    }
    _debounceTimer?.cancel();

    state = state.copyWith(
      loading: true,
    );

    _debounceTimer = Timer(
      Duration(milliseconds: withDobuncer ? 1000 : 0),
      () async {
        try {
          final List<CreateCart> products = state.cart!.products
              .map((product) => CreateCart(
                    id: product.productDetail.id,
                    quantity: product.quantity,
                  ))
              .toList();

          final response = await CartService.updateCart(products: products);

          state = state.copyWith(
            cart: () => response.data,
          );
        } on ServiceException catch (e) {
          ref.read(snackbarProvider.notifier).showSnackbar(e.message);
        }
        state = state.copyWith(
          loading: false,
        );
      },
    );
  }

  Timer? _debounceTimer;
}

class CartState {
  final Cart? cart;
  final bool loading;

  CartState({
    this.cart,
    this.loading = false,
  });

  int get numProducts {
    if (cart != null) {
      if (cart!.products.isNotEmpty) {
        return cart!.products
            .map((product) => product.quantity)
            .reduce((sum, quantity) => sum + quantity);
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  CartState copyWith({
    ValueGetter<Cart?>? cart,
    bool? loading,
  }) =>
      CartState(
        cart: cart != null ? cart() : this.cart,
        loading: loading ?? this.loading,
      );
}

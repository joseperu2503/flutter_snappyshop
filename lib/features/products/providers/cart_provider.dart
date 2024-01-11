import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/features/products/models/cart.dart';
import 'package:flutter_snappyshop/features/products/models/create_cart.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/products/services/cart_service.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/loader_provider.dart';
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
      showUpdateBtn: false,
    );
  }

  Future<void> getCart() async {
    ref.read(loaderProvider.notifier).showLoader();

    try {
      await getCartService();
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
    ref.read(loaderProvider.notifier).dismissLoader();
  }

  Future<void> getCartService() async {
    try {
      final Cart response = await CartService.getCart();

      state = state.copyWith(
        cart: () => response,
        showUpdateBtn: false,
      );
    } on ServiceException catch (e) {
      throw ServiceException(e.message);
    }
  }

  addUnitProduct(int index) async {
    //metodo solo se llamar por el stepper de la vista de cart
    if (state.cart == null) return;
    state = state.copyWith(
      cart: () => state.cart?.updateProductQuantity(
          index, state.cart!.products[index].quantity + 1),
      showUpdateBtn: true,
    );
  }

  removeUnitProduct(int index) async {
    //metodo solo se llamar por el stepper de la vista de cart
    if (state.cart == null) return;
    if (state.cart!.products[index].quantity == 1) return;
    state = state.copyWith(
      cart: () => state.cart?.updateProductQuantity(
          index, state.cart!.products[index].quantity - 1),
      showUpdateBtn: true,
    );
  }

  deleteProduct(int index) async {
    //metodo solo se llamar por el stepper de la vista de cart
    if (state.cart == null) return;
    state = state.copyWith(
      cart: () => state.cart?.removeProductAtIndex(index),
    );
    updateCart();
  }

  updateCart() async {
    if (state.cart == null) return;
    ref.read(loaderProvider.notifier).showLoader();
    try {
      await updateCartService();
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
    ref.read(loaderProvider.notifier).dismissLoader();
  }

  updateCartService() async {
    if (state.cart == null) return;
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
        showUpdateBtn: false,
      );
    } on ServiceException catch (e) {
      throw ServiceException(e.message);
    }
  }

  addToCart(Product product) async {
    ref.read(loaderProvider.notifier).showLoader();
    try {
      await getCartService();
      if (state.cart == null) return;

      int index = state.cart!.products
          .map((e) => e.productDetail.id)
          .toList()
          .indexOf(product.id);
      if (index != -1) {
        addUnitProduct(index);
      } else {
        state.cart!.products.add(ProductCart(
          productDetail: product,
          quantity: 1,
        ));
      }

      await updateCartService();
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    } catch (e) {
      ref
          .read(snackbarProvider.notifier)
          .showSnackbar('An error occurred while updating the cart.');
    }
    ref.read(loaderProvider.notifier).dismissLoader();
  }
}

class CartState {
  final Cart? cart;
  final bool showUpdateBtn;

  CartState({
    this.cart,
    this.showUpdateBtn = false,
  });

  CartState copyWith({
    ValueGetter<Cart?>? cart,
    bool? showUpdateBtn,
  }) =>
      CartState(
        cart: cart != null ? cart() : this.cart,
        showUpdateBtn: showUpdateBtn ?? this.showUpdateBtn,
      );
}

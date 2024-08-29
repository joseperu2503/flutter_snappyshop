import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/cart/models/cart.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/checkout/services/checkout_service.dart';
import 'package:flutter_snappyshop/features/orders/models/create_order.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';

final checkoutProvider =
    StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier(ref);
});

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  CheckoutNotifier(this.ref) : super(CheckoutState());
  final StateNotifierProviderRef ref;

  setAddress(Address address) {
    state = state.copyWith(
      address: () => address,
    );
  }

  initData() async {
    state = state.copyWith(
      address: () => null,
      creatingOrder: LoadingStatus.none,
    );
    await ref.read(addressProvider.notifier).getAddresses();
    final addresses = ref.read(addressProvider).addresses;

    if (addresses.isNotEmpty) {
      setAddress(addresses[0]);
      int primaryIndex =
          addresses.indexWhere((element) => element.adressDefault);
      if (primaryIndex >= 0) {
        setAddress(addresses[primaryIndex]);
      }
    }
  }

  createOrder() async {
    final Cart? cart = ref.read(cartProvider).cart;

    if (cart == null) return;
    state = state.copyWith(
      creatingOrder: LoadingStatus.loading,
    );
    try {
      final List<CreateOrder> products = cart.products
          .map((product) => CreateOrder(
                id: product.productDetail.id,
                quantity: product.quantity,
              ))
          .toList();

      await CheckoutService.createOrder(
        products: products,
        cardNumber: '123456',
        paymentMethod: 1,
        cardHolderName: 'Jose Perez',
        addresId: state.address?.id,
      );
      state = state.copyWith(
        creatingOrder: LoadingStatus.success,
      );
      appRouter.push('/order-confirmed');
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      state = state.copyWith(
        creatingOrder: LoadingStatus.error,
      );
    }
  }
}

class CheckoutState {
  final Address? address;
  final LoadingStatus creatingOrder;

  CheckoutState({
    this.address,
    this.creatingOrder = LoadingStatus.none,
  });

  CheckoutState copyWith({
    ValueGetter<Address?>? address,
    LoadingStatus? creatingOrder,
  }) =>
      CheckoutState(
        address: address != null ? address() : this.address,
        creatingOrder: creatingOrder ?? this.creatingOrder,
      );
}

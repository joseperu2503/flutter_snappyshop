import 'dart:async';
import 'package:flutter_snappyshop/features/orders/models/my_orders_response.dart';
import 'package:flutter_snappyshop/features/orders/services/order_service.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(ref);
});

class OrderNotifier extends StateNotifier<OrderState> {
  OrderNotifier(this.ref) : super(OrderState());
  final StateNotifierProviderRef ref;

  Future<void> getOrders() async {
    if (state.page > state.totalPages || state.loading) return;

    state = state.copyWith(
      loading: true,
    );
    try {
      final MyOrdersResponse response = await OrderService.getOrders(
        page: state.page,
      );

      state = state.copyWith(
        orders: [...state.orders, ...response.results],
        totalPages: response.info.lastPage,
        page: state.page + 1,
      );
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
    state = state.copyWith(
      loading: false,
    );
  }
}

class OrderState {
  final List<Order> orders;
  final int page;
  final int totalPages;
  final bool loading;

  OrderState({
    this.orders = const [],
    this.page = 1,
    this.totalPages = 1,
    this.loading = false,
  });

  OrderState copyWith({
    List<Order>? orders,
    int? page,
    int? totalPages,
    bool? loading,
  }) =>
      OrderState(
        orders: orders ?? this.orders,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        loading: loading ?? this.loading,
      );
}

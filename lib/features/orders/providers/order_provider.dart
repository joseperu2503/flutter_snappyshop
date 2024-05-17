import 'dart:async';
import 'package:flutter/foundation.dart';
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
        orderStatusId: state.orderStatus?.id,
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

  getOrderStatuses() {
    state = state.copyWith(
      orderStatuses: orderStatuses,
    );
  }

  changeOrderStatus(OrderStatusFilter orderStatus) {
    state = state.copyWith(
      orderStatus: () => orderStatus,
      orders: const [],
      page: 1,
      totalPages: 1,
      loading: false,
    );
    getOrders();
  }
}

class OrderState {
  final List<Order> orders;
  final int page;
  final int totalPages;
  final bool loading;
  final List<OrderStatusFilter> orderStatuses;
  final OrderStatusFilter? orderStatus;

  OrderState({
    this.orders = const [],
    this.page = 1,
    this.totalPages = 1,
    this.loading = false,
    this.orderStatuses = const [],
    this.orderStatus,
  });

  OrderState copyWith({
    List<Order>? orders,
    int? page,
    int? totalPages,
    bool? loading,
    List<OrderStatusFilter>? orderStatuses,
    ValueGetter<OrderStatusFilter?>? orderStatus,
  }) =>
      OrderState(
        orders: orders ?? this.orders,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        loading: loading ?? this.loading,
        orderStatuses: orderStatuses ?? this.orderStatuses,
        orderStatus: orderStatus != null ? orderStatus() : this.orderStatus,
      );
}

class OrderStatusFilter {
  final int? id;
  final String name;

  OrderStatusFilter({
    required this.id,
    required this.name,
  });

  factory OrderStatusFilter.fromJson(Map<String, dynamic> json) =>
      OrderStatusFilter(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

List<OrderStatusFilter> orderStatuses = [
  OrderStatusFilter(id: null, name: 'All'),
  OrderStatusFilter(id: 1, name: 'Ordered'),
  OrderStatusFilter(id: 2, name: 'Packed'),
  OrderStatusFilter(id: 3, name: 'In Transit'),
  OrderStatusFilter(id: 4, name: 'Delivered'),
];

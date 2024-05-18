import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/features/orders/providers/order_provider.dart';
import 'package:flutter_snappyshop/features/orders/widgets/order_item.dart';
import 'package:flutter_snappyshop/features/orders/widgets/order_status_filter_button.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  MyOrdersScreenState createState() => MyOrdersScreenState();
}

class MyOrdersScreenState extends ConsumerState<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(orderProvider);
      ref.read(orderProvider.notifier).getOrders();
      ref.read(orderProvider.notifier).getOrderStatuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final orders = orderState.orders;

    return Loader(
      loading: orderState.loading,
      child: Layout1(
        title: 'My Orders',
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 8,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OrderStatusFilterButton(),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverList.separated(
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return OrderItem(order: order);
                      },
                      separatorBuilder: (contomtext, index) {
                        return const SizedBox(
                          height: 14,
                        );
                      },
                      itemCount: orders.length,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

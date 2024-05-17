import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/orders/providers/order_provider.dart';
import 'package:flutter_snappyshop/features/orders/widgets/order_status_filter_button.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';
import 'package:intl/intl.dart';

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

                        return Container(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 18,
                            bottom: 18,
                            right: 23,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryCultured,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order N° ${order.id}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textArsenic,
                                      height: 22 / 14,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    DateFormat('dd-MM-yyyy')
                                        .format(order.createdAt),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textArsenic,
                                      height: 22 / 14,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Quantity: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textArsenic,
                                      height: 22 / 14,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    order.items.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textArsenic,
                                      height: 22 / 14,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '\$${order.totalAmount}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textArsenic,
                                      height: 22 / 16,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    order.orderStatus.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.success,
                                      height: 22 / 14,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
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

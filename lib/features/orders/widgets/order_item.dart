import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/orders/models/my_orders_response.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:intl/intl.dart';

class OrderItem extends ConsumerWidget {
  const OrderItem({
    super.key,
    required this.order,
  });
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        top: 18,
        bottom: 18,
        right: 23,
      ),
      decoration: BoxDecoration(
        color: darkMode
            ? AppColors.primaryCulturedDark
            : AppColors.primaryCultured,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order N° ${order.id}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: darkMode ? AppColors.white : AppColors.textArsenic,
                  height: 22 / 14,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                DateFormat('dd-MM-yyyy').format(order.createdAt),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: darkMode
                      ? AppColors.textArsenicDark
                      : AppColors.textArsenic,
                  height: 22 / 14,
                  leadingDistribution: TextLeadingDistribution.even,
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
              Text(
                'Quantity: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: darkMode
                      ? AppColors.textArsenicDark
                      : AppColors.textArsenic,
                  height: 22 / 14,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                order.items.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: darkMode
                      ? AppColors.textArsenicDark
                      : AppColors.textArsenic,
                  height: 22 / 14,
                  leadingDistribution: TextLeadingDistribution.even,
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkMode
                      ? AppColors.textArsenicDark
                      : AppColors.textArsenic,
                  height: 22 / 16,
                  leadingDistribution: TextLeadingDistribution.even,
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
                  leadingDistribution: TextLeadingDistribution.even,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        ],
      ),
    );
  }
}

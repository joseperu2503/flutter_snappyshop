import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/cart/models/cart.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/cart/widgets/button_stepper.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/utils/utils.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_image.dart';

class ProductCartItem extends ConsumerWidget {
  const ProductCartItem({
    super.key,
    required this.productCart,
    required this.index,
  });

  final ProductCart productCart;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);
    final product = productCart.productDetail;

    return Container(
      height: 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            height: 112,
            child: CustomImage(
              path: product.images[0],
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 24,
                right: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: darkMode
                                ? AppColors.textYankeesBlueDark
                                : AppColors.textYankeesBlue,
                            height: 1.2,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Utils.formatCurrency(product.salePrice),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryPastelRed,
                              height: 22 / 16,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                          if (product.discount != null)
                            Text(
                              Utils.formatCurrency(product.price),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: darkMode
                                    ? AppColors.textArsenicDark.withOpacity(0.5)
                                    : AppColors.textArsenic.withOpacity(0.5),
                                height: 22 / 14,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: darkMode
                                    ? AppColors.textArsenicDark.withOpacity(0.5)
                                    : AppColors.textArsenic.withOpacity(0.5),
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonStepper(
                        value: productCart.quantity,
                        type: ButtonStepperType.cart,
                        onAdd: () {
                          ref
                              .read(cartProvider.notifier)
                              .addUnit(product: product, quantity: 1);
                        },
                        onRemove: () {
                          ref
                              .read(cartProvider.notifier)
                              .addUnit(product: product, quantity: -1);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

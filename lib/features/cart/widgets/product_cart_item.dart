import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/cart/models/cart.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/cart/widgets/button_stepper.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final double price = product.discount == null
        ? product.price
        : (product.price * (1 - product.discount! / 100));

    return Stack(
      children: [
        Container(
          height: 110,
          padding: const EdgeInsets.only(
            left: 12,
            top: 16,
            bottom: 12,
            right: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CustomImage(
                  path: product.images[0],
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: darkMode
                                  ? AppColors.textYankeesBlueDark
                                  : AppColors.textYankeesBlue,
                              height: 16 / 12,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonStepper(
                          value: productCart.quantity,
                          onAdd: () {
                            ref
                                .read(cartProvider.notifier)
                                .addUnitProduct(index);
                          },
                          onRemove: () {
                            ref
                                .read(cartProvider.notifier)
                                .removeUnitProduct(index);
                          },
                        ),
                        Row(
                          children: [
                            Text(
                              '\$${price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryPastelRed,
                                height: 22 / 16,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: SvgPicture.asset(
                'assets/icons/delete.svg',
                colorFilter: ColorFilter.mode(
                  darkMode ? AppColors.textArsenicDark : AppColors.textArsenic,
                  BlendMode.srcIn,
                ),
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

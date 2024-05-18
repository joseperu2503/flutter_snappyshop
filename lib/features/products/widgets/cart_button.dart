import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:badges/badges.dart' as badges;

class CartButton extends ConsumerWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    int numProducts = 0;

    if (cartState.cart != null) {
      if (cartState.cart!.products.isNotEmpty) {
        numProducts = cartState.cart!.products
            .map((product) => product.quantity)
            .reduce((sum, quantity) => sum + quantity);
      } else {
        numProducts = 0;
      }
    } else {
      numProducts = 0;
    }
    final darkMode = ref.watch(darkModeProvider);

    return Container(
      width: 46,
      height: 46,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: TextButton(
        onPressed: () {
          context.push('/cart');
        },
        child: badges.Badge(
          position: badges.BadgePosition.custom(
            end: -12,
            top: -12,
          ),
          badgeContent: SizedBox(
            width: 12,
            child: Center(
              child: Text(
                numProducts.toString(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            ),
          ),
          showBadge: numProducts != 0,
          badgeAnimation: const badges.BadgeAnimation.fade(),
          badgeStyle: badges.BadgeStyle(
            badgeColor: AppColors.primaryPearlAqua.withOpacity(0.8),
          ),
          child: SvgPicture.asset(
            'assets/icons/shopping_cart.svg',
            colorFilter: ColorFilter.mode(
              darkMode
                  ? AppColors.textYankeesBlueDark
                  : AppColors.textYankeesBlue,
              BlendMode.srcIn,
            ),
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}

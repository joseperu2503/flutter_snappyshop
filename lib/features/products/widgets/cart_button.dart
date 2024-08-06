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

    final darkMode = ref.watch(darkModeProvider);

    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: TextButton(
        onPressed: () {
          context.push('/cart');
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: badges.Badge(
          position: badges.BadgePosition.custom(
            end: -12,
            top: -12,
          ),
          badgeContent: SizedBox(
            width: 12,
            child: Center(
              child: Text(
                cartState.numProducts.toString(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            ),
          ),
          showBadge: cartState.numProducts != 0,
          badgeAnimation: const badges.BadgeAnimation.fade(),
          badgeStyle: const badges.BadgeStyle(
            badgeGradient: badges.BadgeGradient.linear(
              colors: [Color(0xff905bd2), Color(0xff8034da)],
              stops: [0, 1],
              begin: Alignment(-0.9, -0.5),
              end: Alignment(0.3, 1.0),
            ),
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

import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/cart/widgets/order_summary.dart';
import 'package:flutter_snappyshop/features/cart/widgets/product_cart_item.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final emptyCart = !(cartState.cart != null &&
        (cartState.cart?.products ?? []).isNotEmpty);
    final darkMode = ref.watch(darkModeProvider);

    return Layout(
      title: 'Cart',
      body: CustomScrollView(
        slivers: [
          if (!emptyCart)
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList.separated(
                itemBuilder: (context, index) {
                  final productCart = cartState.cart!.products[index];
                  return ProductCartItem(
                    productCart: productCart,
                    index: index,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 14,
                  );
                },
                itemCount: cartState.cart?.products.length,
              ),
            ),
          if (!emptyCart)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    Text(
                      'Order summary',
                      style: subtitle(darkMode),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const OrderSummary(),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
          if (emptyCart)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/icons/empty_cart.svg',
                    width: 200,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'your cart is empty',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: darkMode
                          ? AppColors.textYankeesBlueDark
                          : AppColors.textYankeesBlue,
                      height: 32 / 24,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 280,
                    child: Text(
                      'Looks like you haven’t made your choice yet let’s shop!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: darkMode
                            ? AppColors.textArsenicDark
                            : AppColors.textArsenic,
                        height: 22 / 14,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: CustomButton(
                      text: 'Start shopping',
                      onPressed: () {
                        context.go('/dashboard');
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            )
        ],
      ),
      bottomNavigationBar: !emptyCart
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: CustomButton(
                  text: 'Checkout',
                  disabled: cartState.loading,
                  onPressed: () {
                    context.push('/checkout');
                  },
                ),
              ),
            )
          : null,
    );
  }
}

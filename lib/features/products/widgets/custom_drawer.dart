import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_eshop/features/auth/services/auth_service.dart';
import 'package:flutter_eshop/features/products/providers/cart_provider.dart';
import 'package:flutter_eshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    int numProducts = 0;
    final authState = ref.watch(authProvider);

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

    return Drawer(
      elevation: 0,
      backgroundColor: AppColors.white,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: const EdgeInsets.only(
                top: 80,
                bottom: 40,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryCultured,
                          ),
                          child: const Icon(Icons.person),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${authState.user?.name}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textYankeesBlue,
                                  height: 1.1,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                              ),
                              Text(
                                '${authState.user?.email}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textArsenic,
                                  height: 1.1,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 24),
                    title: const Text('Account Information'),
                    leading: const Icon(Icons.person_2_outlined),
                    onTap: () {
                      context.pop();
                      context.push('/account-information');
                    },
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 24),
                    title: const Text('Cart'),
                    leading: const Icon(Icons.shopping_bag_outlined),
                    trailing: numProducts > 0
                        ? Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: AppColors.primaryPearlAqua,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                numProducts.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                              ),
                            ),
                          )
                        : null,
                    onTap: () {
                      context.pop();
                      context.push('/cart');
                    },
                  ),
                  const ListTile(
                    contentPadding:
                        EdgeInsetsDirectional.symmetric(horizontal: 24),
                    title: Text('My Cards'),
                    leading: Icon(Icons.credit_card_outlined),
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 24),
                    title: const Text('Wishlist'),
                    leading: const Icon(Icons.favorite_outline),
                    onTap: () {
                      context.pop();
                      context.push('/whishlist');
                    },
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 24),
                    title: const Text('Change Password'),
                    leading: const Icon(Icons.lock_outline_rounded),
                    onTap: () {
                      context.pop();
                      context.push('/change-password');
                    },
                  ),
                  const ListTile(
                    contentPadding:
                        EdgeInsetsDirectional.symmetric(horizontal: 24),
                    title: Text('Settings'),
                    leading: Icon(Icons.settings_outlined),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: CustomButton(
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: AppColors.primaryCultured,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: AppColors.primaryCultured,
                            ),
                          )
                        ],
                      ),
                      onPressed: () {
                        AuthService().logout();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

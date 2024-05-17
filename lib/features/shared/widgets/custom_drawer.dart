import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_snappyshop/features/cards/providers/card_provider.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/shared/models/form_type.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/image_viewer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final MediaQueryData screen = MediaQuery.of(context);

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

    const textLabelStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textYankeesBlue,
      height: 16 / 16,
      leadingDistribution: TextLeadingDistribution.even,
    );

    return Drawer(
      elevation: 0,
      backgroundColor: AppColors.white,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: EdgeInsets.only(
                top: 40 + screen.padding.top,
                bottom: 40 + screen.padding.bottom,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pop();
                      context.push('/account-information');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          authState.user?.profilePhoto != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: SizedBox(
                                    width: 46,
                                    height: 46,
                                    child: ImageViewer(
                                      images: [authState.user!.profilePhoto!],
                                      radius: 23,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 46,
                                  height: 46,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryCultured,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: AppColors.textArsenic,
                                  ),
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
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 24,
                    ),
                    title: const Text(
                      'Account Information',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/profile.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.textYankeesBlue,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                    onTap: () {
                      context.pop();
                      context.push('/account-information');
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 24,
                    ),
                    title: const Text(
                      'Cart',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/shopping_cart.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.textYankeesBlue,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
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
                  ListTile(
                    contentPadding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 24),
                    title: const Text(
                      'My Cards',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/card.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.textYankeesBlue,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                    onTap: () {
                      context.pop();

                      ref
                          .read(cardProvider.notifier)
                          .changeListType(ListType.list);

                      context.push('/my-cards');
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 24,
                    ),
                    title: const Text(
                      'My Orders',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/order.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.textYankeesBlue,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                    onTap: () {
                      context.pop();
                      context.push('/my-orders');
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 24,
                    ),
                    title: const Text(
                      'Wishlist',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/heart.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.textYankeesBlue,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                    onTap: () {
                      context.pop();
                      context.push('/whishlist');
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 24,
                    ),
                    title: const Text(
                      'My Addresses',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/box.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.textYankeesBlue,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                    onTap: () {
                      context.pop();
                      ref
                          .read(addressProvider.notifier)
                          .changeListType(ListType.list);
                      context.push('/my-addresses');
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 24,
                    ),
                    title: const Text(
                      'Change Password',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/lock.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.textYankeesBlue,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                    onTap: () {
                      context.pop();
                      context.push('/change-password-internal');
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 24,
                    ),
                    title: const Text(
                      'Settings',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/settings.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.textYankeesBlue,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                    onTap: () {
                      context.pop();
                      context.push('/settings');
                    },
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: CustomButton(
                      text: 'Logout',
                      iconLeft: const Icon(
                        Icons.logout,
                        color: AppColors.primaryCultured,
                      ),
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_snappyshop/features/cards/providers/card_provider.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/shared/models/form_type.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
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
    final darkMode = ref.watch(darkModeProvider);

    final authState = ref.watch(authProvider);

    final textLabelStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color:
          darkMode ? AppColors.textYankeesBlueDark : AppColors.textYankeesBlue,
      height: 16 / 16,
      leadingDistribution: TextLeadingDistribution.even,
    );

    return Drawer(
      elevation: 0,
      backgroundColor:
          darkMode ? AppColors.backgroundColorDark : AppColors.backgroundColor,
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
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: darkMode
                                        ? AppColors.primaryCulturedDark
                                        : AppColors.primaryCultured,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/profile.svg',
                                      colorFilter: ColorFilter.mode(
                                        darkMode
                                            ? AppColors.textArsenicDark
                                                .withOpacity(0.5)
                                            : AppColors.textArsenic
                                                .withOpacity(0.5),
                                        BlendMode.srcIn,
                                      ),
                                      width: 24,
                                      height: 24,
                                    ),
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
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: darkMode
                                        ? AppColors.textYankeesBlueDark
                                        : AppColors.textYankeesBlue,
                                    height: 1.1,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                  ),
                                ),
                                Text(
                                  '${authState.user?.email}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: darkMode
                                        ? AppColors.textCultured
                                        : AppColors.textArsenic,
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
                    title: Text(
                      'Account Information',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/profile.svg',
                      colorFilter: ColorFilter.mode(
                        darkMode
                            ? AppColors.textYankeesBlueDark
                            : AppColors.textYankeesBlue,
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
                    title: Text(
                      'Cart',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
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
                    trailing: cartState.numProducts > 0
                        ? Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: primaryGradient,
                            ),
                            child: Center(
                              child: Text(
                                cartState.numProducts.toString(),
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
                    title: Text(
                      'My Cards',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/card.svg',
                      colorFilter: ColorFilter.mode(
                        darkMode
                            ? AppColors.textYankeesBlueDark
                            : AppColors.textYankeesBlue,
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
                    title: Text(
                      'My Orders',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/order.svg',
                      colorFilter: ColorFilter.mode(
                        darkMode
                            ? AppColors.textYankeesBlueDark
                            : AppColors.textYankeesBlue,
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
                    title: Text(
                      'Wishlist',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/heart_outlined.svg',
                      colorFilter: ColorFilter.mode(
                        darkMode
                            ? AppColors.textYankeesBlueDark
                            : AppColors.textYankeesBlue,
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
                    title: Text(
                      'My Addresses',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/box.svg',
                      colorFilter: ColorFilter.mode(
                        darkMode
                            ? AppColors.textYankeesBlueDark
                            : AppColors.textYankeesBlue,
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
                    title: Text(
                      'Change Password',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/lock.svg',
                      colorFilter: ColorFilter.mode(
                        darkMode
                            ? AppColors.textYankeesBlueDark
                            : AppColors.textYankeesBlue,
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
                    title: Text(
                      'Settings',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/settings.svg',
                      colorFilter: ColorFilter.mode(
                        darkMode
                            ? AppColors.textYankeesBlueDark
                            : AppColors.textYankeesBlue,
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
                  ListTile(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 24,
                    ),
                    title: Text(
                      'Dark mode',
                      style: textLabelStyle,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/moon.svg',
                      colorFilter: ColorFilter.mode(
                        darkMode
                            ? AppColors.textYankeesBlueDark
                            : AppColors.textYankeesBlue,
                        BlendMode.srcIn,
                      ),
                      width: 22,
                      height: 22,
                    ),
                    trailing: CupertinoSwitch(
                      value: darkMode,
                      onChanged: (value) {
                        ref.read(darkModeProvider.notifier).changeDarkMode();
                      },
                      activeColor: AppColors.primaryPearlAqua,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: CustomButton(
                      text: 'Logout',
                      iconLeft: SvgPicture.asset(
                        'assets/icons/logout.svg',
                        colorFilter: const ColorFilter.mode(
                          AppColors.textCultured,
                          BlendMode.srcIn,
                        ),
                        width: 22,
                        height: 22,
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

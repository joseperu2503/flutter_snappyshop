import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      elevation: 0,
      backgroundColor: AppColors.white,
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jose Luis Perez',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textYankeesBlue,
                            height: 1.1,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                        Text(
                          'joseperu2503@gmail.com',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textArsenic,
                            height: 1.1,
                            leadingDistribution: TextLeadingDistribution.even,
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
              onTap: () {},
            ),
            const ListTile(
              contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 24),
              title: Text('Password'),
              leading: Icon(Icons.lock_outline_rounded),
            ),
            const ListTile(
              contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 24),
              title: Text('Order'),
              leading: Icon(Icons.shopping_bag_outlined),
            ),
            const ListTile(
              contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 24),
              title: Text('My Cards'),
              leading: Icon(Icons.credit_card_outlined),
            ),
            const ListTile(
              contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 24),
              title: Text('Wishlist'),
              leading: Icon(Icons.favorite_outline),
            ),
            const ListTile(
              contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 24),
              title: Text('Settings'),
              leading: Icon(Icons.settings_outlined),
            ),
            const Spacer(),
            ListTile(
              contentPadding:
                  const EdgeInsetsDirectional.symmetric(horizontal: 24),
              title: const Text(
                'Logout',
                style: TextStyle(color: AppColors.error),
              ),
              leading: const Icon(
                Icons.logout,
                color: AppColors.error,
              ),
              onTap: () {
                ref.read(authProvider.notifier).logout();
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Container(
        padding: const EdgeInsets.only(
          top: 80,
          bottom: 80,
        ),
        child: Column(
          children: [
            const ListTile(
              title: Text('Account Information'),
              leading: Icon(Icons.person_2_outlined),
            ),
            const ListTile(
              title: Text('Password'),
              leading: Icon(Icons.lock_outline_rounded),
            ),
            const ListTile(
              title: Text('Order'),
              leading: Icon(Icons.shopping_bag_outlined),
            ),
            const ListTile(
              title: Text('My Cards'),
              leading: Icon(Icons.credit_card_outlined),
            ),
            const ListTile(
              title: Text('Wishlist'),
              leading: Icon(Icons.favorite_outline),
            ),
            const ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings_outlined),
            ),
            const Spacer(),
            ListTile(
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

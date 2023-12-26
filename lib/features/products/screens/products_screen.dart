import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_eshop/features/products/providers/products_provider.dart';
import 'package:flutter_eshop/features/products/widgets/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ProductsScreenState createState() => ProductsScreenState();
}

class ProductsScreenState extends ConsumerState<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productsProvider.notifier).getProducts();
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
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
                leading: Icon(Icons.info_outline),
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
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        forceMaterialTransparency: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryCultured,
              ),
              child: TextButton(
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
                child: const Icon(
                  Icons.menu,
                  color: AppColors.textYankeesBlue,
                ),
              ),
            ),
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryCultured,
              ),
              child: TextButton(
                onPressed: () {},
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.textYankeesBlue,
                ),
              ),
            )
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(
                top: 4,
                right: 16,
                left: 16,
                bottom: 8,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Hi Jose Luis',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textCoolBlack,
                      height: 32 / 24,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 56,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final product = productsState.products[index];
                  return ProductCard(product: product);
                },
                childCount: productsState.products.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 8,
                mainAxisExtent: 280,
              ),
            ),
          )
        ],
      ),
    );
  }
}

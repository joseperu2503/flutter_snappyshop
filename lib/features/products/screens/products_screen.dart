import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(
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
                onPressed: () {},
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
                mainAxisExtent: 300,
              ),
            ),
          )
        ],
      ),
    );
  }
}

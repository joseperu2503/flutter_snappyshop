import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/wishlist/providers/favorite_products_provider.dart';
import 'package:flutter_snappyshop/features/products/widgets/product_card.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  WishlistScreenState createState() => WishlistScreenState();
}

class WishlistScreenState extends ConsumerState<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels + 400 >=
          scrollController.position.maxScrollExtent) {
        ref.read(favoriteProductsProvider.notifier).getProducts();
      }
    });
    Future.microtask(() {
      ref.read(favoriteProductsProvider.notifier).initState();
      ref.read(favoriteProductsProvider.notifier).getProducts();
    });
  }

  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteState = ref.watch(favoriteProductsProvider);

    return Layout1(
      title: 'Wishslit',
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 24,
                right: 24,
                bottom: 20,
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final product = favoriteState.products[index];
                    return ProductCard(product: product);
                  },
                  childCount: favoriteState.products.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 210,
                ),
              ),
            ),
            if (favoriteState.loadingProducts && favoriteState.products.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            if (favoriteState.loadingProducts &&
                favoriteState.products.isNotEmpty)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 40,
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            if (!favoriteState.loadingProducts &&
                favoriteState.products.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const Spacer(),
                    SvgPicture.asset(
                      'assets/icons/empty-wishlist.svg',
                      width: 200,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'your wishlist is empty!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textYankeesBlue,
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
                        'Explore more and shortlist some items',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textArsenic.withOpacity(0.7),
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
                          context.go('/products');
                        },
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

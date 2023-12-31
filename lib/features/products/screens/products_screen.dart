import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/products/providers/products_provider.dart';
import 'package:flutter_eshop/features/products/widgets/custom_drawer.dart';
import 'package:flutter_eshop/features/products/widgets/filter_bottom_sheet.dart';
import 'package:flutter_eshop/features/products/widgets/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ProductsScreenState createState() => ProductsScreenState();
}

class ProductsScreenState extends ConsumerState<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels + 400 >=
          scrollController.position.maxScrollExtent) {
        ref.read(productsProvider.notifier).getProducts();
      }
    });
    Future.microtask(() {
      ref.read(productsProvider.notifier).getDashboardData();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomDrawer(),
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
                onPressed: () {
                  context.push('/cart');
                },
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
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(
                top: 4,
                right: 24,
                left: 24,
                bottom: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Hi Jose Luis',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textCoolBlack,
                      height: 32 / 24,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.push('/search');
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.primaryCultured,
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: AppColors.textArsenic,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Search...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textCoolBlack,
                                    height: 22 / 14,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primaryPearlAqua,
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            foregroundColor: Colors.white60,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return FilterBottomSheet(
                                  filter: productsState.filter,
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.tune,
                            color: AppColors.textCultured,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Choose Brand',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textCoolBlack,
                      height: 1.1,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final brand = productsState.brands[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryCultured,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(
                        brand.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textCoolBlack,
                          height: 22 / 16,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 10,
                  );
                },
                itemCount: productsState.brands.length,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 24,
              left: 24,
              right: 24,
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
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,
                mainAxisExtent: 210,
              ),
            ),
          ),
          if (productsState.loadingProducts)
            const SliverToBoxAdapter(
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
        ],
      ),
    );
  }
}

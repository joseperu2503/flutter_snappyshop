import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/products/providers/products_provider.dart';
import 'package:flutter_snappyshop/features/products/widgets/cart_button.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_drawer.dart';
import 'package:flutter_snappyshop/features/products/widgets/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/settings/services/notification_service.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';
import 'package:flutter_snappyshop/features/shared/widgets/progress_indicator.dart';
import 'package:flutter_snappyshop/features/shared/widgets/text_field_container.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ProductsScreenState createState() => ProductsScreenState();
}

class ProductsScreenState extends ConsumerState<ProductsScreen> {
  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels + 400 >=
          scrollController.position.maxScrollExtent) {
        ref.read(productsProvider.notifier).getProducts();
      }
    });
    Future.microtask(() {
      loadData();
      NotificationService().initListeners();
    });
    super.initState();
  }

  loadData() {
    ref.read(productsProvider.notifier).getDashboardData();
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
    final darkMode = ref.watch(darkModeProvider);

    return Loader(
      loading: productsState.dashboardStatus == LoadingStatus.loading,
      child: Scaffold(
        key: scaffoldKey,
        drawer: const CustomDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.white,
          forceMaterialTransparency: true,
          titleSpacing: 0,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: TextButton(
                    onPressed: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: SvgPicture.asset(
                      'assets/icons/menu.svg',
                      colorFilter: ColorFilter.mode(
                        darkMode ? AppColors.white : AppColors.textYankeesBlue,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  'SnappyShop',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: darkMode
                        ? AppColors.textCultured
                        : AppColors.primaryPearlAqua,
                    height: 22 / 22,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
                const Spacer(),
                const CartButton(),
              ],
            ),
          ),
        ),
        body: (productsState.dashboardStatus == LoadingStatus.success)
            ? SafeArea(
                bottom: false,
                child: CustomScrollView(
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
                            const SizedBox(
                              height: 20,
                            ),
                            Hero(
                              tag: 'searchTag',
                              child: Material(
                                color: Colors.transparent,
                                child: GestureDetector(
                                  onTap: () {
                                    context.push('/search');
                                  },
                                  child: TextFieldContainer(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.search,
                                            color: darkMode
                                                ? AppColors.textCultured
                                                    .withOpacity(0.5)
                                                : AppColors.textArsenic
                                                    .withOpacity(0.5),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Search...',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: darkMode
                                                  ? AppColors.textCultured
                                                      .withOpacity(0.5)
                                                  : AppColors.textArsenic
                                                      .withOpacity(0.5),
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
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Choose Brand',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: darkMode
                                    ? AppColors.white
                                    : AppColors.textCoolBlack,
                                height: 1.1,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 40,
                            child: ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final brand = productsState.brands[index];
                                return GestureDetector(
                                  onTap: () {
                                    context.push('/brand/${brand.id}');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: darkMode
                                          ? AppColors.backgroundColorDark2
                                          : AppColors.primaryCultured,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Center(
                                      child: Text(
                                        brand.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: darkMode
                                              ? AppColors.textCultured
                                              : AppColors.textCoolBlack,
                                          height: 22 / 16,
                                          leadingDistribution:
                                              TextLeadingDistribution.even,
                                        ),
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
                          Container(
                            padding: const EdgeInsets.only(
                              top: 24,
                              right: 24,
                              left: 24,
                              bottom: 0,
                            ),
                            child: Text(
                              'Popular',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: darkMode
                                    ? AppColors.white
                                    : AppColors.textCoolBlack,
                                height: 1.1,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                            final product = productsState.products[index];
                            return ProductCard(product: product);
                          },
                          childCount: productsState.products.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 210,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 40,
                        ),
                        child: Center(
                          child: productsState.loadingProducts
                              ? const CustomProgressIndicator()
                              : null,
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Center(
                  child: CustomButton(
                    text: 'Retry',
                    onPressed: () {
                      loadData();
                    },
                  ),
                ),
              ),
      ),
    );
  }
}

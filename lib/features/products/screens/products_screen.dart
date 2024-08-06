import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/products/providers/products_provider.dart';
import 'package:flutter_snappyshop/features/products/widgets/cart_button.dart';
import 'package:flutter_snappyshop/features/products/widgets/input_search.dart';
import 'package:flutter_snappyshop/features/products/widgets/product_skeleton.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_drawer.dart';
import 'package:flutter_snappyshop/features/products/widgets/product_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/settings/services/notification_service.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
    final MediaQueryData screen = MediaQuery.of(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: darkMode
            ? AppColors.backgroundColorDark
            : AppColors.backgroundColor,
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
                      darkMode
                          ? AppColors.textYankeesBlueDark
                          : AppColors.textYankeesBlue,
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
      body: (productsState.dashboardStatus != LoadingStatus.error)
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
                          const InputSearch(),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Choose Store',
                            style: subtitle(darkMode),
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
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final store = productsState.stores[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push('/store/${store.id}');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: darkMode
                                        ? AppColors.primaryCulturedDark
                                        : AppColors.primaryCultured,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Center(
                                    child: Text(
                                      store.name,
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
                            itemCount: productsState.stores.length,
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
                            style: subtitle(darkMode),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (productsState.loadingProducts == LoadingStatus.success)
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: horizontalPaddingMobile,
                        right: horizontalPaddingMobile,
                        bottom: 20,
                      ),
                      sliver: SliverGrid.builder(
                        itemBuilder: (context, index) {
                          final product = productsState.products[index];
                          return ProductItem(product: product);
                        },
                        gridDelegate:
                            productSliverGridDelegate(screen.size.width),
                        itemCount: productsState.products.length,
                      ),
                    ),
                  if (productsState.loadingProducts == LoadingStatus.loading)
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: horizontalPaddingMobile,
                        right: horizontalPaddingMobile,
                        bottom: 20,
                      ),
                      sliver: SliverGrid.builder(
                        itemBuilder: (context, index) {
                          return const ProductSkeleton();
                        },
                        gridDelegate:
                            productSliverGridDelegate(screen.size.width),
                        itemCount: 4,
                      ),
                    ),
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
    );
  }
}

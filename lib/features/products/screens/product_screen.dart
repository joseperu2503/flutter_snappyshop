import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/progress_indicator.dart';
import 'package:flutter_snappyshop/features/wishlist/providers/favorite_products_provider.dart';
import 'package:flutter_snappyshop/features/products/providers/products_provider.dart';
import 'package:flutter_snappyshop/features/products/services/products_services.dart';
import 'package:flutter_snappyshop/features/products/widgets/cart_button.dart';
import 'package:flutter_snappyshop/features/products/widgets/product_card.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/back_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/image_viewer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  void initState() {
    super.initState();

    loadProduct();
    FlutterNativeSplash.remove();
  }

  loadProduct() async {
    setState(() {
      loadingProduct = LoadingStatus.loading;
    });
    try {
      await ref
          .read(productsProvider.notifier)
          .getProduct(productId: widget.productId);
      setState(() {
        loadingProduct = LoadingStatus.success;
      });
    } on ServiceException catch (_) {
      setState(() {
        loadingProduct = LoadingStatus.error;
      });
    }
  }

  bool loadingFavorite = false;
  LoadingStatus loadingProduct = LoadingStatus.none;

  toggleFavorite(Product? product) async {
    if (loadingFavorite || product == null) return;
    setState(() {
      loadingFavorite = true;
    });
    try {
      final response = await ProductsService.toggleFavoriteProduct(
        isFavorite: !product.isFavorite,
        productId: product.id,
      );

      ref
          .read(favoriteProductsProvider.notifier)
          .setFavoriteProduct(response.data, product.id);
      ref.read(snackbarProvider.notifier).showSnackbar(response.message);
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    setState(() {
      loadingFavorite = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);

    final Product? product = productsState.productDetails[widget.productId];
    final size = MediaQuery.of(context).size;
    final double price = product?.discount == null
        ? product?.price ?? 1
        : ((product?.price ?? 1) * (1 - (product?.discount ?? 1) / 100));
    double safeAreaHeight = MediaQuery.of(context).padding.top;
    final darkMode = ref.watch(darkModeProvider);

    return loadingProduct == LoadingStatus.success && product != null
        ? Scaffold(
            bottomNavigationBar: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(radiusButton),
                        border: Border.all(
                          color: AppColors.secondaryPastelRed,
                        ),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(radiusButton),
                          ),
                        ),
                        onPressed: loadingFavorite
                            ? null
                            : () {
                                toggleFavorite(product);
                              },
                        child: loadingFavorite
                            ? const Center(
                                child: CustomProgressIndicator(
                                  size: 20,
                                  strokeWidth: 2,
                                  color: AppColors.secondaryPastelRed,
                                ),
                              )
                            : SvgPicture.asset(
                                product.isFavorite
                                    ? 'assets/icons/heart_solid.svg'
                                    : 'assets/icons/heart_outlined.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColors.secondaryPastelRed,
                                  BlendMode.srcIn,
                                ),
                                width: 24,
                                height: 24,
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomButton(
                        text: 'Add to cart',
                        onPressed: () {
                          ref.read(cartProvider.notifier).addToCart(product);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  titleSpacing: 0,
                  title: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: const Row(
                      children: [
                        CustomBackButton(),
                        Spacer(),
                        CartButton(),
                      ],
                    ),
                  ),
                  scrolledUnderElevation: 0,
                  automaticallyImplyLeading: false,
                  pinned: true,
                  backgroundColor: darkMode
                      ? AppColors.backgroundColorDark
                      : AppColors.backgroundColor,
                  expandedHeight: size.height * 0.4,
                  foregroundColor: darkMode
                      ? AppColors.backgroundColorDark
                      : AppColors.backgroundColor,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: EdgeInsets.only(
                        top: safeAreaHeight,
                      ),
                      width: double.maxFinite,
                      color: darkMode
                          ? AppColors.primaryCulturedDark
                          : AppColors.primaryCultured,
                      child: Center(
                        child: ImageViewer(
                          radius: 0,
                          images: product.images,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 20,
                      bottom: 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: darkMode
                                ? AppColors.textYankeesBlueDark
                                : AppColors.textYankeesBlue,
                            height: 1.1,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '\$${price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryPastelRed,
                                height: 1.6,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (product.discount != null)
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: darkMode
                                      ? AppColors.textCultured
                                      : AppColors.gray,
                                  height: 1.6,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: darkMode
                                      ? AppColors.textCultured
                                      : AppColors.gray,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                              ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: darkMode
                                    ? AppColors.primaryCulturedDark
                                    : AppColors.primaryCultured,
                                borderRadius:
                                    BorderRadiusDirectional.circular(50),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: AppColors.star,
                                  ),
                                  Text(
                                    '4,2',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: darkMode
                                          ? AppColors.textArsenicDark
                                          : AppColors.textArsenic,
                                      height: 22 / 14,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 26,
                        ),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: darkMode
                                ? AppColors.textYankeesBlueDark
                                : AppColors.textYankeesBlue,
                            height: 1.1,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: darkMode
                                ? AppColors.textArsenicDark
                                : AppColors.textArsenic,
                            height: 22 / 14,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'You might also like',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: darkMode
                                ? AppColors.textYankeesBlueDark
                                : AppColors.textYankeesBlue,
                            height: 1.1,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 230,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 150,
                          child: ProductCard(
                            product: productsState.products[index],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 14,
                        );
                      },
                      itemCount: productsState.products.length,
                    ),
                  ),
                )
              ],
            ),
          )
        : Layout1(
            body: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Center(
                child: loadingProduct == LoadingStatus.loading
                    ? const CustomProgressIndicator()
                    : CustomButton(
                        text: 'Retry',
                        onPressed: () {
                          loadProduct();
                        },
                      ),
              ),
            ),
          );
  }
}

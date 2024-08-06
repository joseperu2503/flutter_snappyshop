import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/cart/widgets/button_stepper.dart';
import 'package:flutter_snappyshop/features/products/models/product_detail.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_image.dart';
import 'package:flutter_snappyshop/features/shared/widgets/progress_indicator.dart';
import 'package:flutter_snappyshop/features/wishlist/providers/favorite_products_provider.dart';
import 'package:flutter_snappyshop/features/products/providers/products_provider.dart';
import 'package:flutter_snappyshop/features/products/services/products_services.dart';
import 'package:flutter_snappyshop/features/products/widgets/cart_button.dart';
import 'package:flutter_snappyshop/features/products/widgets/product_item.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/back_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    final ProductDetail? productDetail =
        productsState.productDetails[widget.productId];
    final Product? product = productDetail?.product;

    final double price = product?.discount == null
        ? product?.price ?? 1
        : ((product?.price ?? 1) * (1 - (product?.discount ?? 1) / 100));
    final darkMode = ref.watch(darkModeProvider);

    final screen = MediaQuery.of(context);
    final width = screen.size.width;

    final widthImage = width - 2 * horizontalPaddingMobile;

    return loadingProduct == LoadingStatus.success && product != null
        ? Scaffold(
            appBar: AppBar(
              toolbarHeight: toolbarHeight,
              automaticallyImplyLeading: false,
              backgroundColor: darkMode
                  ? AppColors.backgroundColorDark
                  : AppColors.backgroundColor,
              scrolledUnderElevation: 0,
              flexibleSpace: SafeArea(
                child: Container(
                  height: toolbarHeight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPaddinAppBargMobile,
                  ),
                  child: Row(
                    children: [
                      const CustomBackButton(),
                      const SizedBox(
                        width: 4,
                      ),
                      CustomImage(
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                        path: productDetail?.store.isotype,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        productDetail?.store.name ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: darkMode
                              ? AppColors.textYankeesBlueDark
                              : AppColors.textYankeesBlue,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const Spacer(),
                      const CartButton(),
                    ],
                  ),
                ),
              ),
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: widthImage,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        final image = product.images[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: CustomImage(
                            borderRadius: BorderRadius.circular(15),
                            fit: BoxFit.contain,
                            path: image,
                          ),
                        );
                      },
                      scale: 1,
                      viewportFraction: widthImage / width,
                      scrollDirection: Axis.horizontal,
                      itemCount: product.images.length,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: horizontalPaddingMobile,
                      right: horizontalPaddingMobile,
                      top: 20,
                      bottom: 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  product.name,
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
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                color: product.isFavorite
                                    ? AppColors.primaryPearlAqua
                                    : Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(radiusButton),
                                border: Border.all(
                                  color: product.isFavorite
                                      ? Colors.transparent
                                      : AppColors.textYankeesBlue
                                          .withOpacity(0.3),
                                ),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(radiusButton),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: loadingFavorite
                                    ? null
                                    : () {
                                        toggleFavorite(product);
                                      },
                                child: loadingFavorite
                                    ? Center(
                                        child: CustomProgressIndicator(
                                          size: 20,
                                          strokeWidth: 2,
                                          color: product.isFavorite
                                              ? AppColors.white
                                              : AppColors.textYankeesBlue,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        product.isFavorite
                                            ? 'assets/icons/heart_solid.svg'
                                            : 'assets/icons/heart_outlined.svg',
                                        colorFilter: ColorFilter.mode(
                                          product.isFavorite
                                              ? AppColors.white
                                              : AppColors.textYankeesBlue,
                                          BlendMode.srcIn,
                                        ),
                                        width: 18,
                                        height: 18,
                                      ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(radiusButton),
                                border: Border.all(
                                  color: AppColors.textYankeesBlue
                                      .withOpacity(0.3),
                                ),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(radiusButton),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {},
                                child: SvgPicture.asset(
                                  'assets/icons/share.svg',
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.textYankeesBlue,
                                    BlendMode.srcIn,
                                  ),
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                            ),
                          ],
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
                                      ? AppColors.textArsenicDark
                                          .withOpacity(0.5)
                                      : AppColors.textArsenic.withOpacity(0.5),
                                  height: 1.6,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: darkMode
                                      ? AppColors.textArsenicDark
                                          .withOpacity(0.5)
                                      : AppColors.textArsenic.withOpacity(0.5),
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                              ),
                            const Spacer(),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 10,
                            //     vertical: 6,
                            //   ),
                            //   decoration: BoxDecoration(
                            //     color: darkMode
                            //         ? AppColors.primaryCulturedDark
                            //         : AppColors.primaryCultured,
                            //     borderRadius:
                            //         BorderRadiusDirectional.circular(50),
                            //   ),
                            //   child: Row(
                            //     children: [
                            //       const Icon(
                            //         Icons.star_rounded,
                            //         color: AppColors.star,
                            //       ),
                            //       Text(
                            //         '4,2',
                            //         style: TextStyle(
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.w400,
                            //           color: darkMode
                            //               ? AppColors.textArsenicDark
                            //               : AppColors.textArsenic,
                            //           height: 22 / 14,
                            //           leadingDistribution:
                            //               TextLeadingDistribution.even,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: AppColors.textCoolBlackDark
                                    .withOpacity(0.9),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Quantity',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: darkMode
                                        ? AppColors.textYankeesBlueDark
                                        : AppColors.textYankeesBlue,
                                    height: 1.1,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                  ),
                                ),
                              ),
                              ButtonStepper(
                                value: 2,
                                onAdd: () {},
                                onRemove: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 26,
                        ),
                        CustomButton(
                          text: 'Add to cart',
                          onPressed: () {
                            ref.read(cartProvider.notifier).addToCart(product);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                          text: 'Buy now',
                          type: ButtonType.secondary,
                          onPressed: () {},
                        ),
                        const SizedBox(
                          height: 32,
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
                          'More from ${productDetail!.store.name}',
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
                          height: 12,
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
                        final product =
                            productDetail.storeRelatedProducts[index];
                        return SizedBox(
                          width: 150,
                          child: ProductItem(
                            product: product,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 14,
                        );
                      },
                      itemCount: productDetail.storeRelatedProducts.length,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: screen.padding.bottom,
                  ),
                )
              ],
            ),
            // bottomNavigationBar: SafeArea(
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 16,
            //       vertical: 16,
            //     ),
            //     child: Row(
            //       children: [
            //         Container(
            //           height: 52,
            //           width: 52,
            //           decoration: BoxDecoration(
            //             color: Colors.transparent,
            //             borderRadius: BorderRadius.circular(radiusButton),
            //             border: Border.all(
            //               color: AppColors.secondaryPastelRed,
            //             ),
            //           ),
            //           child: TextButton(
            //             style: TextButton.styleFrom(
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(radiusButton),
            //               ),
            //             ),
            //             onPressed: loadingFavorite
            //                 ? null
            //                 : () {
            //                     toggleFavorite(product);
            //                   },
            //             child: loadingFavorite
            //                 ? const Center(
            //                     child: CustomProgressIndicator(
            //                       size: 20,
            //                       strokeWidth: 2,
            //                       color: AppColors.secondaryPastelRed,
            //                     ),
            //                   )
            //                 : SvgPicture.asset(
            //                     product.isFavorite
            //                         ? 'assets/icons/heart_solid.svg'
            //                         : 'assets/icons/heart_outlined.svg',
            //                     colorFilter: const ColorFilter.mode(
            //                       AppColors.secondaryPastelRed,
            //                       BlendMode.srcIn,
            //                     ),
            //                     width: 24,
            //                     height: 24,
            //                   ),
            //           ),
            //         ),
            //         const SizedBox(
            //           width: 10,
            //         ),
            //         Expanded(
            //           child: CustomButton(
            //             text: 'Add to cart',
            //             onPressed: () {
            //               ref.read(cartProvider.notifier).addToCart(product);
            //             },
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
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

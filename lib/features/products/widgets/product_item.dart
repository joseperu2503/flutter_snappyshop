import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/utils/utils.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_image.dart';
import 'package:flutter_snappyshop/features/shared/widgets/progress_indicator.dart';
import 'package:flutter_snappyshop/features/wishlist/providers/favorite_products_provider.dart';
import 'package:flutter_snappyshop/features/products/services/products_services.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ProductItem extends ConsumerStatefulWidget {
  const ProductItem({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends ConsumerState<ProductItem> {
  @override
  void initState() {
    super.initState();
  }

  bool loadingFavorite = false;

  toggleFavorite() async {
    if (loadingFavorite) return;
    setState(() {
      loadingFavorite = true;
    });
    try {
      final response = await ProductsService.toggleFavoriteProduct(
        isFavorite: !widget.product.isFavorite,
        productId: widget.product.id,
      );

      ref
          .read(favoriteProductsProvider.notifier)
          .setFavoriteProduct(response.data, widget.product.id);
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
    final darkMode = ref.watch(darkModeProvider);

    return GestureDetector(
      onTap: () {
        context.push('/product/${widget.product.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusDirectional.circular(15),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CustomImage(
                    path: widget.product.images.isEmpty
                        ? null
                        : widget.product.images[0],
                  ),
                ),
              ),
              if (widget.product.discount != null)
                Positioned(
                  top: 10,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryMangoTango,
                      borderRadius: BorderRadiusDirectional.circular(50),
                    ),
                    child: Text(
                      '${widget.product.discount}% Off',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                        height: 1,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 8,
                bottom: 8,
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: TextButton(
                    onPressed: loadingFavorite
                        ? null
                        : () {
                            toggleFavorite();
                          },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: widget.product.isFavorite
                          ? AppColors.primaryPearlAqua
                          : AppColors.textArsenic.withOpacity(0.3),
                    ),
                    child: Center(
                      child: loadingFavorite
                          ? const CustomProgressIndicator(
                              size: 18,
                              color: AppColors.white,
                              strokeWidth: 2,
                            )
                          : SvgPicture.asset(
                              widget.product.isFavorite
                                  ? 'assets/icons/heart_solid.svg'
                                  : 'assets/icons/heart_outlined.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColors.white,
                                BlendMode.srcIn,
                              ),
                              width: 18,
                              height: 18,
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
            ),
            height: productItemInfoHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: darkMode ? AppColors.white : AppColors.textCoolBlack,
                    height: 14 / 12,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text(
                      Utils.formatCurrency(widget.product.salePrice),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryPastelRed,
                        height: 14 / 12,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (widget.product.discount != null)
                      Text(
                        Utils.formatCurrency(widget.product.price),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: darkMode
                              ? AppColors.textArsenicDark.withOpacity(0.5)
                              : AppColors.textArsenic.withOpacity(0.5),
                          height: 14 / 12,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: darkMode
                              ? AppColors.textArsenicDark.withOpacity(0.5)
                              : AppColors.textArsenic.withOpacity(0.5),
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

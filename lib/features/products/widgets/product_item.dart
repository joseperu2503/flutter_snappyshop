import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_image.dart';
import 'package:flutter_snappyshop/features/shared/widgets/progress_indicator.dart';
import 'package:flutter_snappyshop/features/wishlist/providers/favorite_products_provider.dart';
import 'package:flutter_snappyshop/features/products/providers/products_provider.dart';
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
    final double price = widget.product.discount == null
        ? widget.product.price
        : (widget.product.price * (1 - widget.product.discount! / 100));
    final darkMode = ref.watch(darkModeProvider);

    return GestureDetector(
      onTap: () {
        ref.read(productsProvider.notifier).setProduct(widget.product);
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
                right: 0,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: loadingFavorite
                      ? const Center(
                          child: CustomProgressIndicator(
                            size: 20,
                            color: AppColors.secondaryPastelRed,
                            strokeWidth: 2,
                          ),
                        )
                      : TextButton(
                          onPressed: loadingFavorite
                              ? null
                              : () {
                                  toggleFavorite();
                                },
                          child: SvgPicture.asset(
                            widget.product.isFavorite
                                ? 'assets/icons/heart_solid.svg'
                                : 'assets/icons/heart_outlined.svg',
                            colorFilter: ColorFilter.mode(
                              AppColors.secondaryPastelRed.withOpacity(0.8),
                              BlendMode.srcIn,
                            ),
                            width: 24,
                            height: 24,
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
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: darkMode ? AppColors.white : AppColors.textCoolBlack,
                    height: 1.4,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryPastelRed,
                        height: 1.1,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (widget.product.discount != null)
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: darkMode
                              ? AppColors.textArsenicDark.withOpacity(0.5)
                              : AppColors.textArsenic.withOpacity(0.5),
                          height: 1.1,
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

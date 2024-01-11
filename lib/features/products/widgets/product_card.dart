import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/products/models/products_response.dart';
import 'package:flutter_snappyshop/features/products/providers/favorite_products_provider.dart';
import 'package:flutter_snappyshop/features/products/providers/products_provider.dart';
import 'package:flutter_snappyshop/features/products/services/products_services.dart';
import 'package:flutter_snappyshop/features/products/widgets/image_viewer.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends ConsumerStatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends ConsumerState<ProductCard> {
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
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.primaryCultured,
                  borderRadius: BorderRadiusDirectional.circular(15),
                ),
                child: Center(
                  child: SizedBox(
                    width: 120,
                    child: ImageViewer(
                      images: widget.product.images,
                      radius: 0,
                    ),
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
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color:
                                AppColors.secondaryPastelRed.withOpacity(0.8),
                          ),
                        )
                      : IconButton(
                          onPressed: loadingFavorite
                              ? null
                              : () {
                                  toggleFavorite();
                                },
                          icon: Icon(
                            widget.product.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline_rounded,
                            color:
                                AppColors.secondaryPastelRed.withOpacity(0.8),
                          ),
                        ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.product.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textCoolBlack,
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
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.gray,
                    height: 1.1,
                    decoration: TextDecoration.lineThrough,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

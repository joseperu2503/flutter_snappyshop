import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/products/models/products_response.dart';
import 'package:flutter_eshop/features/products/widgets/image_viewer.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final double price = product.discount == null
        ? product.price
        : (product.price * (1 - product.discount! / 100));

    return GestureDetector(
      onTap: () {
        context.push('/product/${product.id}');
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
                      images: product.images,
                      radius: 0,
                    ),
                  ),
                ),
              ),
              if (product.discount != null)
                Positioned(
                  top: 10,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryMangoTango,
                      borderRadius: BorderRadiusDirectional.circular(50),
                    ),
                    child: Text(
                      '${product.discount}% Off',
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
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            product.name,
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
              if (product.discount != null)
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
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

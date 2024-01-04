import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/products/models/products_response.dart';
import 'package:flutter_eshop/features/products/providers/cart_provider.dart';
import 'package:flutter_eshop/features/products/providers/products_provider.dart';
import 'package:flutter_eshop/features/products/widgets/cart_button.dart';
import 'package:flutter_eshop/features/products/widgets/image_viewer.dart';
import 'package:flutter_eshop/features/products/widgets/product_card.dart';
import 'package:flutter_eshop/features/shared/widgets/back_button.dart';
import 'package:flutter_eshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  Product? product;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(productsProvider.notifier)
          .getProduct(productId: widget.productId);
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

    if (product == null) {
      return Container(
        color: AppColors.white,
      );
    }

    return Scaffold(
      bottomNavigationBar: Container(
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
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primaryPearlAqua,
                ),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: AppColors.primaryPearlAqua,
                ),
                onPressed: () {},
                child: const Icon(
                  Icons.favorite_outline_rounded,
                  color: AppColors.primaryPearlAqua,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: CustomButton(
                child: const Text(
                  'Add to cart',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textCultured,
                    height: 22 / 16,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
                onPressed: () {
                  ref.read(cartProvider.notifier).addToCart(product);
                },
              ),
            ),
          ],
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
            backgroundColor: Colors.white,
            expandedHeight: size.height * 0.4,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: EdgeInsets.only(
                  top: safeAreaHeight,
                ),
                width: double.maxFinite,
                color: AppColors.primaryCultured,
                child: Center(
                  child: ImageViewer(
                    radius: 0,
                    images: product.images,
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textYankeesBlue,
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
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: AppColors.gray,
                            height: 1.6,
                            decoration: TextDecoration.lineThrough,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCultured,
                          borderRadius: BorderRadiusDirectional.circular(50),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.star,
                            ),
                            Text(
                              '4,2',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textArsenic,
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
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textYankeesBlue,
                      height: 1.1,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textArsenic,
                      height: 22 / 14,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'You might also like',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textYankeesBlue,
                      height: 1.1,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 230,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

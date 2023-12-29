import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/products/models/products_response.dart';
import 'package:flutter_eshop/features/products/providers/products_provider.dart';
import 'package:flutter_eshop/features/products/widgets/product_card_2.dart';
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

    if (product == null) return Container();

    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: const Row(
          children: [
            CustomButton(
              width: 52,
              child: Icon(
                Icons.add_shopping_cart_rounded,
                color: AppColors.textCultured,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: CustomButton(
                child: Text(
                  'Buy Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textCultured,
                    height: 22 / 16,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: size.height * 0.4,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Center(
                      child: Image.network(
                        product.images[0],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress != null) return const SizedBox();

                          return child;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
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
                        fontWeight: FontWeight.w700,
                        color: AppColors.textYankeesBlue,
                        height: 1.2,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryPastelRed,
                            height: 1.6,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                        const Row(
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
                        )
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
                      height: 10,
                    ),
                    SizedBox(
                      height: 230,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return ProductCard2(
                            product: productsState.products[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 14,
                          );
                        },
                        itemCount: productsState.products.length,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
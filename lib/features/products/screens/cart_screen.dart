import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/products/providers/cart_provider.dart';
import 'package:flutter_eshop/features/products/widgets/button_stepper.dart';
import 'package:flutter_eshop/features/products/widgets/image_viewer.dart';
import 'package:flutter_eshop/features/shared/layout/layout_1.dart';
import 'package:flutter_eshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(cartProvider.notifier).initState();
      ref.read(cartProvider.notifier).getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Layout1(
      title: 'Cart',
      bottomNavigationBar: (cartState.cart != null)
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textArsenic,
                          height: 22 / 14,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${cartState.cart?.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textYankeesBlue,
                          height: 32 / 20,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomButton(
                    child: Text(
                      cartState.showUpdateBtn ? 'Update cart' : 'Checkout',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textCultured,
                        height: 22 / 16,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    onPressed: () {
                      if (cartState.showUpdateBtn) {
                        ref.read(cartProvider.notifier).updateCart();
                        return;
                      }
                      context.push('/order-confirmed');
                    },
                  )
                ],
              ),
            )
          : null,
      child: CustomScrollView(
        slivers: [
          if (cartState.cart != null)
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList.separated(
                itemBuilder: (context, index) {
                  final productCart = cartState.cart!.products[index];
                  final product = productCart.productDetail;
                  final double price = product.discount == null
                      ? product.price
                      : (product.price * (1 - product.discount! / 100));

                  return Container(
                    height: 136,
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 18,
                      bottom: 18,
                      right: 23,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryCultured,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ImageViewer(
                            images: product.images,
                            radius: 13,
                          ),
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textArsenic,
                                  height: 22 / 14,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '\$${price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondaryPastelRed,
                                      height: 22 / 16,
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
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.gray,
                                        height: 22 / 16,
                                        decoration: TextDecoration.lineThrough,
                                        leadingDistribution:
                                            TextLeadingDistribution.even,
                                      ),
                                    ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ButtonStepper(
                                    value: productCart.quantity,
                                    onAdd: () {
                                      ref
                                          .read(cartProvider.notifier)
                                          .addUnitProduct(index);
                                    },
                                    onRemove: () {
                                      ref
                                          .read(cartProvider.notifier)
                                          .removeUnitProduct(index);
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(cartProvider.notifier)
                                          .deleteProduct(index);
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: AppColors.textArsenic,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 14,
                  );
                },
                itemCount: cartState.cart?.products.length,
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/products/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/products/widgets/button_stepper.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/image_viewer.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final emptyCart = !(cartState.cart != null &&
        (cartState.cart?.products ?? []).isNotEmpty);

    return Loader(
      loading: cartState.loading,
      child: Layout1(
        title: 'Cart',
        bottomNavigationBar: !emptyCart
            ? SafeArea(
                child: Container(
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
                ),
              )
            : null,
        child: CustomScrollView(
          slivers: [
            if (!emptyCart)
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
                                          decoration:
                                              TextDecoration.lineThrough,
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
            if (emptyCart)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const Spacer(),
                    SvgPicture.asset(
                      'assets/icons/empty_cart.svg',
                      width: 200,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'your cart is empty',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textYankeesBlue,
                        height: 32 / 24,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 280,
                      child: Text(
                        'Looks like you haven’t made your choice yet let’s shop!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textArsenic.withOpacity(0.7),
                          height: 22 / 14,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CustomButton(
                        child: const Text(
                          'Start shopping',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textCultured,
                            height: 22 / 16,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                        onPressed: () {
                          context.go('/products');
                        },
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

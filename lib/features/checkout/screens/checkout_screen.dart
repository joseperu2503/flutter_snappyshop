import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/address/widgets/address_item.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_snappyshop/features/checkout/screens/payment_config.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/image_viewer.dart';
import 'package:pay/pay.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(checkoutProvider.notifier).initData();
    });
    super.initState();

    _paymentItems = [
      const PaymentItem(
        label: 'Total',
        amount: '99.99',
        status: PaymentItemStatus.final_price,
      )
    ];

    applePayButton = ApplePayButton(
      paymentConfiguration:
          PaymentConfiguration.fromJsonString(defaultApplePay),
      paymentItems: _paymentItems,
      style: ApplePayButtonStyle.black,
      type: ApplePayButtonType.buy,
      onPaymentResult: (result) {
        print('result $result');
      },
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
      height: 48,
      cornerRadius: 12,
      onError: (error) {},
    );

    googlePayButton = GooglePayButton(
      paymentConfiguration:
          PaymentConfiguration.fromJsonString(defaultGooglePay),
      paymentItems: _paymentItems,
      type: GooglePayButtonType.pay,
      onPaymentResult: (result) {
        print('result $result');
      },
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
      height: 48,
      cornerRadius: 12,
      theme: GooglePayButtonTheme.dark,
    );
  }

  List<PaymentItem> _paymentItems = [];
  late ApplePayButton applePayButton;
  late GooglePayButton googlePayButton;

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final addressState = ref.watch(addressProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final Address? address = checkoutState.address;

    final emptyCart = !(cartState.cart != null &&
        (cartState.cart?.products ?? []).isNotEmpty);
    final darkMode = ref.watch(darkModeProvider);

    return Layout(
      loading: addressState.loadingAddresses == LoadingStatus.loading ||
          checkoutState.creatingOrder == LoadingStatus.loading,
      title: 'Checkout',
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        'Ship to',
                        style: subtitle(darkMode),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (address != null) AddressItem(address: address),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Order summary',
                    style: subtitle(darkMode),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
          if (!emptyCart)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList.builder(
                itemBuilder: (context, index) {
                  final productCart = cartState.cart!.products[index];
                  final product = productCart.productDetail;

                  return Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 68,
                          height: 68,
                          child: ImageViewer(
                            images: product.images,
                            radius: 13,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: darkMode
                                            ? AppColors.textArsenicDark
                                            : AppColors.textArsenic,
                                        height: 22 / 14,
                                        leadingDistribution:
                                            TextLeadingDistribution.even,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    Utils.formatCurrency(product.salePrice),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondaryPastelRed,
                                      height: 22 / 16,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Quantity: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: darkMode
                                          ? AppColors.textArsenicDark
                                          : AppColors.textArsenic,
                                      height: 1.2,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                  ),
                                  Text(
                                    '2',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: darkMode
                                          ? AppColors.textArsenicDark
                                          : AppColors.textArsenic,
                                      height: 1.2,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
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
                },
                itemCount: cartState.cart?.products.length,
              ),
            ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                children: [
                  const Spacer(),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: darkMode
                          ? AppColors.primaryCulturedDark
                          : AppColors.primaryCultured,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Subtotal',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: darkMode
                                    ? AppColors.textYankeesBlueDark
                                    : AppColors.textYankeesBlue,
                                height: 22 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              Utils.formatCurrency(cartState.cart!.subtotal),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: darkMode
                                    ? AppColors.textYankeesBlueDark
                                    : AppColors.textYankeesBlue,
                                height: 22 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Text(
                              'Shipping Fee',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: darkMode
                                    ? AppColors.textYankeesBlueDark
                                    : AppColors.textYankeesBlue,
                                height: 22 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              Utils.formatCurrency(cartState.cart!.shippingFee),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: darkMode
                                    ? AppColors.textYankeesBlueDark
                                    : AppColors.textYankeesBlue,
                                height: 22 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Text(
                              ' Total',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: darkMode
                                    ? AppColors.textYankeesBlueDark
                                    : AppColors.textYankeesBlue,
                                height: 22 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              Utils.formatCurrency(cartState.cart!.total),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: darkMode
                                    ? AppColors.textYankeesBlueDark
                                    : AppColors.textYankeesBlue,
                                height: 22 / 16,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          child: Platform.isIOS ? applePayButton : googlePayButton,
        ),
      ),
    );
  }
}

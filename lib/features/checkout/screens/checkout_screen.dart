import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/address/widgets/select_address.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/cart/widgets/order_summary.dart';
import 'package:flutter_snappyshop/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_snappyshop/features/checkout/screens/payment_config.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/image_viewer.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      onError: (error) {
        print('error $error');
      },
      childOnError: CustomButton(
        text: 'Pay',
        onPressed: () {},
      ),
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
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      final Address? newSelectedAddress = await Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return SelectAddress(
                              selectedAddress: address!,
                            ); // Tu widget de destino
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset(0.0, 0.0);
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var opacityTween =
                                Tween<double>(begin: 0.0, end: 1.0)
                                    .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: FadeTransition(
                                opacity: animation.drive(opacityTween),
                                child: child,
                              ),
                            );
                          },
                        ),
                      );

                      if (newSelectedAddress != null) {
                        ref
                            .read(checkoutProvider.notifier)
                            .setAddress(newSelectedAddress);
                      }
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ship to',
                              style: subtitle(darkMode),
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              'assets/icons/arrow_down.svg',
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                darkMode
                                    ? AppColors.secondaryPastelRed
                                    : AppColors.secondaryPastelRed,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (address != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            address.address,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: darkMode
                                                  ? AppColors
                                                      .textYankeesBlueDark
                                                  : AppColors.textYankeesBlue,
                                              height: 1.2,
                                              leadingDistribution:
                                                  TextLeadingDistribution.even,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${address.country}, ${address.locality}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: darkMode
                                            ? AppColors.textArsenicDark
                                            : AppColors.textArsenic,
                                        height: 16 / 12,
                                        leadingDistribution:
                                            TextLeadingDistribution.even,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  if (address == null)
                    CustomButton(
                      text: 'Add address',
                      iconLeft: SvgPicture.asset(
                        'assets/icons/plus.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          darkMode
                              ? AppColors.textArsenicDark
                              : AppColors.textArsenic,
                          BlendMode.srcIn,
                        ),
                      ),
                      disabled: cartState.loading,
                      onPressed: () {},
                      type: ButtonType.outlined,
                    ),
                  const SizedBox(
                    height: 18,
                  ),
                  Divider(
                    color: AppColors.textArsenicDark.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 18,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        height: 1.2,
                                        leadingDistribution:
                                            TextLeadingDistribution.even,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
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
                                      fontSize: 12,
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
              child: const Column(
                children: [
                  Spacer(),
                  SizedBox(
                    height: 16,
                  ),
                  OrderSummary(),
                  SizedBox(
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

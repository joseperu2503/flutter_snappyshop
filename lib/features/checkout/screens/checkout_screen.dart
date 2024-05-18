import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/cards/providers/card_provider.dart';
import 'package:flutter_snappyshop/features/cart/providers/cart_provider.dart';
import 'package:flutter_snappyshop/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/models/form_type.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/image_viewer.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(checkoutProvider.notifier).initData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final addressState = ref.watch(addressProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final Address? address = checkoutState.address;

    final emptyCart = !(cartState.cart != null &&
        (cartState.cart?.products ?? []).isNotEmpty);
    final MediaQueryData screen = MediaQuery.of(context);
    final darkMode = ref.watch(darkModeProvider);

    return Layout1(
      loading: addressState.loadingAddresses == LoadingStatus.loading ||
          checkoutState.creatingOrder == LoadingStatus.loading,
      title: 'Checkout',
      body: CustomScrollView(
        slivers: [
          if (!emptyCart)
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList.builder(
                itemBuilder: (context, index) {
                  final productCart = cartState.cart!.products[index];
                  final product = productCart.productDetail;
                  final double price = product.discount == null
                      ? product.price
                      : (product.price * (1 - product.discount! / 100));
                  BorderRadius borderRadius =
                      const BorderRadius.all(Radius.circular(0));
                  borderRadius = BorderRadius.only(
                    topLeft: Radius.circular(index == 0 ? 14 : 0),
                    topRight: Radius.circular(index == 0 ? 14 : 0),
                    bottomLeft: Radius.circular(
                        index == cartState.cart!.products.length - 1 ? 14 : 0),
                    bottomRight: Radius.circular(
                        index == cartState.cart!.products.length - 1 ? 14 : 0),
                  );

                  return Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 16,
                      bottom: 16,
                      right: 16,
                    ),
                    decoration: BoxDecoration(
                      color: darkMode
                          ? AppColors.primaryCulturedDark
                          : AppColors.primaryCultured,
                      borderRadius: borderRadius,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
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
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
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
                                      height: 16 / 12,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                  ),
                                  Text(
                                    '2',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: darkMode
                                          ? AppColors.textArsenicDark
                                          : AppColors.textArsenic,
                                      height: 22 / 16,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '\$${price.toStringAsFixed(2)}',
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
                        )
                      ],
                    ),
                  );
                },
                itemCount: cartState.cart?.products.length,
              ),
            ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                        Text(
                          'Order Info',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: darkMode
                                ? AppColors.textYankeesBlueDark
                                : AppColors.textYankeesBlue,
                            height: 22 / 18,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Text(
                              'Subtotal',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: darkMode
                                    ? AppColors.textArsenicDark
                                    : AppColors.textArsenic,
                                height: 22 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\$2744.00',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: darkMode
                                    ? AppColors.textArsenicDark
                                    : AppColors.textArsenic,
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
                                    ? AppColors.textArsenicDark
                                    : AppColors.textArsenic,
                                height: 22 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\$10.00',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: darkMode
                                    ? AppColors.textArsenicDark
                                    : AppColors.textArsenic,
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
                              'Order Total',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: darkMode
                                    ? AppColors.textArsenicDark
                                    : AppColors.textArsenic,
                                height: 22 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\$2754.00',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: darkMode
                                    ? AppColors.textYankeesBlueDark
                                    : AppColors.textYankeesBlue,
                                height: 32 / 20,
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
                  Row(
                    children: [
                      Text(
                        'Shipping Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: darkMode
                              ? AppColors.textYankeesBlueDark
                              : AppColors.textYankeesBlue,
                          height: 22 / 18,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(addressProvider.notifier)
                              .changeListType(ListType.select);
                          context.push('/my-addresses');
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Change',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryPastelRed,
                                height: 22 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppColors.secondaryPastelRed,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
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
                              'Address',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: darkMode
                                    ? AppColors.textArsenicDark
                                    : AppColors.textArsenic,
                                height: 22 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Text(
                                address?.address ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: darkMode
                                      ? AppColors.textArsenicDark
                                      : AppColors.textArsenic,
                                  height: 22 / 14,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        if (address?.detail != null)
                          const SizedBox(
                            height: 4,
                          ),
                        if (address?.detail != null)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  address?.detail ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: darkMode
                                        ? AppColors.textArsenicDark
                                        : AppColors.textArsenic,
                                    height: 22 / 14,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        if (address?.references != null)
                          const SizedBox(
                            height: 4,
                          ),
                        if (address?.references != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'References',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: darkMode
                                      ? AppColors.textArsenicDark
                                      : AppColors.textArsenic,
                                  height: 22 / 14,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Text(
                                  address?.references ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: darkMode
                                        ? AppColors.textArsenicDark
                                        : AppColors.textArsenic,
                                    height: 22 / 14,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                  ),
                                  textAlign: TextAlign.end,
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
                              'Recipient',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: darkMode
                                    ? AppColors.textArsenicDark
                                    : AppColors.textArsenic,
                                height: 22 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Text(
                                address?.recipientName ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: darkMode
                                      ? AppColors.textArsenicDark
                                      : AppColors.textArsenic,
                                  height: 22 / 14,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                                textAlign: TextAlign.end,
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
                              'Phone',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: darkMode
                                    ? AppColors.textArsenicDark
                                    : AppColors.textArsenic,
                                height: 22 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Text(
                                address?.phone ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: darkMode
                                      ? AppColors.textArsenicDark
                                      : AppColors.textArsenic,
                                  height: 22 / 14,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: darkMode
                              ? AppColors.textYankeesBlueDark
                              : AppColors.textYankeesBlue,
                          height: 22 / 18,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(cardProvider.notifier)
                              .changeListType(ListType.select);
                          context.push('/my-cards');
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Change',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryPastelRed,
                                height: 22 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppColors.secondaryPastelRed,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(cardProvider.notifier)
                          .changeListType(ListType.select);
                      context.push('/my-cards');
                    },
                    child: SizedBox(
                      height: screen.size.width * 0.5,
                      child: CreditCardWidget(
                        height: screen.size.width * 0.5,
                        padding: 0,
                        cardNumber: checkoutState.card?.cardNumber ?? '',
                        expiryDate: checkoutState.card?.expired ?? '',
                        cardHolderName:
                            checkoutState.card?.cardHolderName ?? '',
                        cvvCode: '',
                        showBackView: false,
                        isHolderNameVisible: true,
                        isSwipeGestureEnabled: false,
                        onCreditCardWidgetChange: (CreditCardBrand brand) {},
                        cardBgColor: AppColors.textCoolBlack,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                text: 'Confirm',
                onPressed: () {
                  ref.read(checkoutProvider.notifier).createOrder();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

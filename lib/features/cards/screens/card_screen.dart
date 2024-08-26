import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/cards/providers/card_provider.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_text_field.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_input_formatter/mask_input_formatter.dart';

class CardScreen extends ConsumerStatefulWidget {
  const CardScreen({super.key});

  @override
  CardScreenState createState() => CardScreenState();
}

class CardScreenState extends ConsumerState<CardScreen> {
  final FocusNode _focusNodeCcv = FocusNode();
  bool showBackView = false;

  @override
  void initState() {
    _focusNodeCcv.addListener(() {
      setState(() {
        showBackView = _focusNodeCcv.hasFocus;
      });
    });
    super.initState();
  }

  MaskInputFormatter cardNumberFormatter = MaskInputFormatter(
    mask: '#### #### #### ####',
  );

  MaskInputFormatter ccvFormatter = MaskInputFormatter(
    mask: '###',
  );

  @override
  Widget build(BuildContext context) {
    final MediaQueryData screen = MediaQuery.of(context);
    final cardState = ref.watch(cardProvider);

    return Loader(
      loading: false,
      child: Layout(
        title: 'Card',
        action: cardState.selectedCard != null
            ? Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: TextButton(
                  onPressed: () {
                    ref.read(cardProvider.notifier).deleteCard();
                  },
                  child: SvgPicture.asset(
                    'assets/icons/delete.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.secondaryPastelRed,
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  ),
                ),
              )
            : null,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
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
                    CreditCardWidget(
                      height: screen.size.width * 0.5,
                      cardNumber: cardState.cardNumber.value,
                      expiryDate: cardState.expired.value,
                      cardHolderName: cardState.cardHolderName.value,
                      cvvCode: cardState.ccv.value,
                      showBackView: showBackView,
                      isHolderNameVisible: true,
                      onCreditCardWidgetChange: (CreditCardBrand brand) {
                        if (brand.brandName == CardType.visa ||
                            brand.brandName == CardType.mastercard) {
                          cardNumberFormatter = MaskInputFormatter(
                            mask: '#### #### #### ####',
                          );
                          ccvFormatter = MaskInputFormatter(
                            mask: '###',
                          );
                        }
                        if (brand.brandName == CardType.americanExpress) {
                          cardNumberFormatter =
                              MaskInputFormatter(mask: '#### ###### #####');
                          ccvFormatter = MaskInputFormatter(
                            mask: '####',
                          );
                        }
                      },
                      padding: 0,
                      cardBgColor: AppColors.textCoolBlack,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomTextField(
                      label: 'Card Number',
                      hintText: 'XXXX XXXX XXXX XXXX',
                      value: cardState.cardNumber,
                      onChanged: (value) {
                        ref.read(cardProvider.notifier).changeCardNumber(value);
                      },
                      inputFormatters: [
                        cardNumberFormatter,
                      ],
                      textInputAction: TextInputAction.next,
                      autofocus: cardState.selectedCard == null,
                      keyboardType: TextInputType.number,
                      readOnly: cardState.selectedCard != null,
                    ),
                    const SizedBox(
                      height: formInputSpacing,
                    ),
                    CustomTextField(
                      label: 'Card Holder Name',
                      hintText: 'Enter Holder Name',
                      value: cardState.cardHolderName,
                      onChanged: (value) {
                        ref
                            .read(cardProvider.notifier)
                            .changeCardHolderName(value);
                      },
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      readOnly: cardState.selectedCard != null,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(40),
                      ],
                    ),
                    const SizedBox(
                      height: formInputSpacing,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomTextField(
                                label: 'Expired',
                                hintText: 'MM/YY',
                                value: cardState.expired,
                                onChanged: (value) {
                                  ref
                                      .read(cardProvider.notifier)
                                      .changeExpired(value);
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  expiredFormatter,
                                ],
                                readOnly: cardState.selectedCard != null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomTextField(
                                label: 'CVC/CCV',
                                hintText: 'XXX',
                                value: cardState.ccv,
                                onChanged: (value) {
                                  ref
                                      .read(cardProvider.notifier)
                                      .changeCcv(value);
                                },
                                focusNode: _focusNodeCcv,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) {},
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  ccvFormatter,
                                ],
                                readOnly: cardState.selectedCard != null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    if (cardState.selectedCard == null)
                      CustomButton(
                        onPressed: () {
                          ref.read(cardProvider.notifier).saveCard();
                        },
                        disabled: !cardState.isFormValue,
                        text: 'Save Card',
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

MaskInputFormatter expiredFormatter = MaskInputFormatter(
  mask: '##/##',
);

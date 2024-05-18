import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/cards/providers/card_provider.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/models/form_type.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_input.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_label.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';
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
    final changeForm = ref.read(cardProvider.notifier).changeForm;

    return Loader(
      loading: false,
      child: Layout1(
        title: 'Card',
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
                      cardNumber: cardState.cardNumber.value ?? '',
                      expiryDate: cardState.expired.value ?? '',
                      cardHolderName: cardState.cardHolderName.value ?? '',
                      cvvCode: cardState.ccv.value ?? '',
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
                    const CustomLabel('Card Number'),
                    const SizedBox(
                      height: labelInputSpacing,
                    ),
                    CustomInput(
                      value: cardState.cardNumber,
                      onChanged: (value) {
                        changeForm(CardForm.cardNumber, value);
                      },
                      hintText: 'XXXX XXXX XXXX XXXX',
                      inputFormatters: [
                        cardNumberFormatter,
                      ],
                      textInputAction: TextInputAction.next,
                      autofocus: cardState.formType == FormType.create,
                      validationMessages: {
                        'required': (error) => 'We need this information.',
                        'minLength': (error) => 'Incomplete card number.',
                        'invalidCard': (error) => 'Invalid card number.'
                      },
                      keyboardType: TextInputType.number,
                      readOnly: cardState.formType == FormType.edit,
                    ),
                    const SizedBox(
                      height: formInputSpacing,
                    ),
                    const CustomLabel('Card Holder Name'),
                    const SizedBox(
                      height: labelInputSpacing,
                    ),
                    CustomInput(
                      value: cardState.cardHolderName,
                      onChanged: (value) {
                        changeForm(CardForm.cardHolderName, value);
                      },
                      hintText: 'Enter Holder Name',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validationMessages: {
                        'required': (error) => 'We need this information.'
                      },
                      readOnly: cardState.formType == FormType.edit,
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
                              const CustomLabel('Expired'),
                              const SizedBox(
                                height: labelInputSpacing,
                              ),
                              CustomInput(
                                value: cardState.expired,
                                onChanged: (value) {
                                  changeForm(CardForm.expired, value);
                                },
                                hintText: 'MM/YY',
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  expiredFormatter,
                                ],
                                readOnly: cardState.formType == FormType.edit,
                                validationMessages: {
                                  'required': (error) =>
                                      'We need this information.',
                                  'minLength': (error) => 'Incomplete date.',
                                  'invalid': (error) => 'Invalid date.'
                                },
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
                              const CustomLabel('CVC/CCV'),
                              const SizedBox(
                                height: labelInputSpacing,
                              ),
                              CustomInput(
                                value: cardState.ccv,
                                onChanged: (value) {
                                  changeForm(CardForm.ccv, value);
                                },
                                hintText: 'XXX',
                                focusNode: _focusNodeCcv,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) {},
                                validationMessages: {
                                  'required': (error) =>
                                      'We need this information.',
                                  'minLength': (error) => 'Incomplete CVC/CCV. '
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  ccvFormatter,
                                ],
                                readOnly: cardState.formType == FormType.edit,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    cardState.formType == FormType.edit
                        ? CustomButton(
                            onPressed: () {
                              ref.read(cardProvider.notifier).deleteCard();
                            },
                            text: 'Delete Card',
                            type: ButtonType.delete,
                            iconLeft: const Icon(
                              Icons.delete,
                              color: AppColors.error,
                            ),
                          )
                        : CustomButton(
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

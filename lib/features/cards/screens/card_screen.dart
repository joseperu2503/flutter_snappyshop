import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/cards/providers/card_provider.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_input.dart';
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
                      onCreditCardWidgetChange: (CreditCardBrand brand) {},
                      padding: 0,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Card Number',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textYankeesBlue,
                        height: 22 / 14,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    const SizedBox(
                      height: labelInputSpacing,
                    ),
                    CustomInput(
                      value: cardState.cardNumber,
                      onChanged: (value) {
                        changeForm(FormCard.cardNumber, value);
                      },
                      valueProcess: (value) {
                        return addSpaces(value);
                      },
                      onChangeProcess: (value) {
                        return removeSpaces(value);
                      },
                      hintText: 'XXXX XXXX XXXX XXXX',
                      inputFormatters: [
                        cardNumberFormatter,
                      ],
                      textInputAction: TextInputAction.next,
                      autofocus:
                          cardState.form.control(FormCard.cardNumber).value ==
                              '',
                      validationMessages: {
                        'required': (error) => 'We need this information.',
                        'minLength': (error) =>
                            'Please enter the 16 digits of your card correctly.'
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: formInputSpacing,
                    ),
                    const Text(
                      'Card Holder Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textYankeesBlue,
                        height: 22 / 14,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    const SizedBox(
                      height: labelInputSpacing,
                    ),
                    CustomInput(
                      value: cardState.cardHolderName,
                      onChanged: (value) {
                        changeForm(FormCard.cardHolderName, value);
                      },
                      hintText: 'Enter Holder Name',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validationMessages: {
                        'required': (error) => 'We need this information.'
                      },
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
                              const Text(
                                'Expired',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textYankeesBlue,
                                  height: 22 / 14,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                              ),
                              const SizedBox(
                                height: labelInputSpacing,
                              ),
                              CustomInput(
                                value: cardState.expired,
                                onChanged: (value) {
                                  changeForm(FormCard.expired, value);
                                },
                                hintText: 'MM/YY',
                                textInputAction: TextInputAction.next,
                                validationMessages: {
                                  'required': (error) =>
                                      'We need this information.'
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  expiredFormatter,
                                ],
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
                              const Text(
                                'CVC/CCV',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textYankeesBlue,
                                  height: 22 / 14,
                                  leadingDistribution:
                                      TextLeadingDistribution.even,
                                ),
                              ),
                              const SizedBox(
                                height: labelInputSpacing,
                              ),
                              CustomInput(
                                value: cardState.ccv,
                                onChanged: (value) {
                                  changeForm(FormCard.ccv, value);
                                },
                                hintText: 'XXX',
                                focusNode: _focusNodeCcv,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) {},
                                validationMessages: {
                                  'required': (error) =>
                                      'We need this information.'
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  ccvFormatter,
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    CustomButton(
                      onPressed: () {
                        ref.read(cardProvider.notifier).saveCard();
                      },
                      disabled: !cardState.isFormValue,
                      child: const Text(
                        'Save Card',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textCultured,
                          height: 22 / 16,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
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

String addSpaces(String value) {
  final StringBuffer result = StringBuffer();
  int groupLength = 0;
  String stringWithoutSpaces = removeSpaces(value);

  for (int i = 0; i < stringWithoutSpaces.length; i++) {
    result.write(stringWithoutSpaces[i]);
    if ([3, 7, 11].contains(groupLength)) {
      // Agrega un espacio después de cada grupo de 4 dígitos, al final se obtiene 4 grupos de 4 dígitos
      result.write(' ');
    }
    groupLength++;
  }

  return result.toString();
}

String removeSpaces(String value) {
  return value.replaceAll(' ', '');
}

MaskInputFormatter expiredFormatter = MaskInputFormatter(
  mask: '##/##',
);

MaskInputFormatter cardNumberFormatter = MaskInputFormatter(
  mask: '#### #### #### ####',
);

MaskInputFormatter ccvFormatter = MaskInputFormatter(
  mask: '###',
);

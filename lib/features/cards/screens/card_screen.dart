import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/cards/providers/card_provider.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_input.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';
import 'package:go_router/go_router.dart';

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
                        ref.read(cardProvider.notifier).changeCardNumber(value);
                      },
                      valueProcess: (value) {
                        return addSpaces(value);
                      },
                      onChangeProcess: (value) {
                        return removeSpaces(value);
                      },
                      hintText: 'XXXX XXXX XXXX XXXX',
                      inputFormatters: [
                        CardFormatter(),
                        LengthLimitingTextInputFormatter(19)
                      ],
                      textInputAction: TextInputAction.next,
                      autofocus: true,
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
                        ref
                            .read(cardProvider.notifier)
                            .changeCardHolderName(value);
                      },
                      hintText: 'Enter Holder Name',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: formInputSpacing,
                    ),
                    Row(
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
                                  ref
                                      .read(cardProvider.notifier)
                                      .changeExpired(value);
                                },
                                hintText: 'MM/YY',
                                textInputAction: TextInputAction.next,
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
                                  ref
                                      .read(cardProvider.notifier)
                                      .changeCcv(value);
                                },
                                hintText: 'XXX',
                                focusNode: _focusNodeCcv,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) {},
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
                      onPressed: () {
                        context.pop();
                      },
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

int offset(int selectionEnd) {
  if (selectionEnd >= 0 && selectionEnd <= 3) {
    return 0;
  }
  if (selectionEnd >= 4 && selectionEnd <= 8) {
    return 1;
  }
  if (selectionEnd >= 9 && selectionEnd <= 13) {
    return 2;
  }
  return 3;
}

class CardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Rechazar la entrada si ingresan espacio
    if (removeSpaces(oldValue.text) == removeSpaces(newValue.text) &&
        (newValue.text.length > oldValue.text.length)) {
      return oldValue;
    }

    final regex = RegExp(r'^[0-9]*$');
    if (!regex.hasMatch(removeSpaces(newValue.text))) {
      return oldValue; // Rechazar la entrada si no contiene solo números
    }

    var newText = addSpaces(newValue.text);

    //limitar a 19 caracteres, esto es porque al pegar de la papelera
    //el LengthLimitingTextInputFormatter(19) no funcionaba
    if (newText.length > 19) {
      newText = newText.substring(0, 19);
    }

    //variable para saber cuanto hay que aumentarle o disminuirle al puntero
    var addSelection = 0;

    // al agregar caracteres, funciona para cuando se pega del portapapeles
    if (newValue.text.length > oldValue.text.length) {
      addSelection =
          offset(newValue.selection.end) - offset(oldValue.selection.end);
      //al agregar caracter, cuando el puntero esté en las posiciones indicadas se le aumentará una posicion
      if ([4, 9, 14].contains(oldValue.selection.end)) {
        addSelection = addSelection + 1;
      }
    }
    //al remover caracter, cuando el puntero esté en las posiciones indicadas se le restara una posicion
    if (newValue.text.length < oldValue.text.length) {
      if ([5, 10, 15].contains(newValue.selection.end)) {
        addSelection = -1;
      }
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newValue.selection.end + addSelection > 19
            ? 19
            : newValue.selection.end + addSelection,
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
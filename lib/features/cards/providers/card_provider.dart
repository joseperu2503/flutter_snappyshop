import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/cards/models/bank_card.dart';
import 'package:flutter_snappyshop/features/cards/services/card_service.dart';
import 'package:flutter_snappyshop/features/cards/validators/card_validator.dart';
import 'package:flutter_snappyshop/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_snappyshop/features/shared/models/form_type.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/plugins/formx/formx.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';

final cardProvider = StateNotifierProvider<CardNotifier, CardState>((ref) {
  return CardNotifier(ref);
});

class CardNotifier extends StateNotifier<CardState> {
  CardNotifier(this.ref) : super(CardState());
  final StateNotifierProviderRef ref;

  resetForm() {
    state = state.copyWith(
      cardNumber: FormxInput(value: '', validators: [
        Validators.required(),
        Validators.composeOR([
          const VisaValidator(),
          const MasterCardValidator(),
          const AmexValidator(),
        ])
      ]),
      cardHolderName: FormxInput(
        value: '',
        validators: [
          Validators.required(),
        ],
      ),
      expired: FormxInput(
        value: '',
        validators: [
          Validators.required(),
          const ExpiredValidator(),
        ],
      ),
      ccv: FormxInput(
        value: '',
        validators: [
          Validators.required(),
          Validators.minLenth(3, errorMessage: 'Incomplete CVC/CCV.'),
        ],
      ),
    );
  }

  getCards() async {
    try {
      final cards = await CardService.getCards();
      state = state.copyWith(
        cards: cards,
      );
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
  }

  saveCard() async {
    try {
      if (state.cardExist) {
        ref
            .read(snackbarProvider.notifier)
            .showSnackbar('Credit card already registered. Try another one');
        return;
      }

      await CardService.saveCard(BankCard(
        cardNumber: removeSpaces(state.cardNumber.value),
        cardHolderName: state.cardHolderName.value,
        expired: state.expired.value,
        ccv: state.ccv.value,
        paymenthMethod: state.paymentMethod,
      ));

      if (state.listType == ListType.list) {
        appRouter.pop();
      } else {
        appRouter.pop();
        appRouter.pop();
      }
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    getCards();
  }

  deleteCard() async {
    try {
      await CardService.deleteCard(state.cardNumber.value);
      appRouter.pop();
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    getCards();
  }

  selectCard(BankCard? card) {
    if (state.listType == ListType.list) {
      resetForm();
      state = state.copyWith(
        selectedCard: () => card,
      );

      if (card != null) {
        state = state.copyWith(
          cardHolderName: state.cardHolderName.updateValue(card.cardHolderName),
          cardNumber: state.cardNumber.updateValue(card.cardNumber),
          expired: state.expired.updateValue(card.expired),
          ccv: state.ccv.updateValue(card.ccv),
        );
      }

      appRouter.push('/card');
    } else {
      if (card == null) return;
      ref.read(checkoutProvider.notifier).setCard(card);
      appRouter.pop();
    }
  }

  changeListType(listType) {
    state = state.copyWith(
      listType: listType,
    );
  }

  void changeCardNumber(FormxInput<String> cardNumber) {
    state = state.copyWith(
      cardNumber: cardNumber,
    );
  }

  void changeCardHolderName(FormxInput<String> cardHolderName) {
    state = state.copyWith(
      cardHolderName: cardHolderName,
    );
  }

  void changeExpired(FormxInput<String> expired) {
    state = state.copyWith(
      expired: expired,
    );
  }

  void changeCcv(FormxInput<String> ccv) {
    state = state.copyWith(
      ccv: ccv,
    );
  }
}

class CardState {
  final List<BankCard> cards;
  final BankCard? selectedCard;
  final ListType listType;
  final FormxInput<String> cardNumber;
  final FormxInput<String> cardHolderName;
  final FormxInput<String> expired;
  final FormxInput<String> ccv;

  CardState({
    this.cards = const [],
    this.selectedCard,
    this.listType = ListType.list,
    this.cardNumber = const FormxInput(value: ''),
    this.cardHolderName = const FormxInput(value: ''),
    this.expired = const FormxInput(value: ''),
    this.ccv = const FormxInput(value: ''),
  });

  bool get isFormValue =>
      cardNumber.isValid &&
      cardHolderName.isValid &&
      expired.isValid &&
      ccv.isValid;

  bool get cardExist {
    final int index =
        cards.indexWhere((element) => cardNumber.value == element.cardNumber);

    return index >= 0;
  }

  int? get paymentMethod {
    final isVisa = const VisaValidator().validate(cardNumber.value) == null;
    if (isVisa) {
      return 1;
    }

    final isMasterCard =
        const MasterCardValidator().validate(cardNumber.value) == null;
    if (isMasterCard) {
      return 2;
    }

    final isAmex = const AmexValidator().validate(cardNumber.value) == null;
    if (isAmex) {
      return 3;
    }

    return null;
  }

  CardState copyWith({
    List<BankCard>? cards,
    ListType? listType,
    FormxInput<String>? cardNumber,
    FormxInput<String>? cardHolderName,
    FormxInput<String>? expired,
    FormxInput<String>? ccv,
    ValueGetter<BankCard?>? selectedCard,
  }) =>
      CardState(
        cards: cards ?? this.cards,
        selectedCard: selectedCard != null ? selectedCard() : this.selectedCard,
        listType: listType ?? this.listType,
        cardNumber: cardNumber ?? this.cardNumber,
        cardHolderName: cardHolderName ?? this.cardHolderName,
        expired: expired ?? this.expired,
        ccv: ccv ?? this.ccv,
      );
}

String removeSpaces(String value) {
  return value.replaceAll(' ', '');
}

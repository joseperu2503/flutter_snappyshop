import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/cards/models/bank_card.dart';
import 'package:flutter_snappyshop/features/cards/services/card_service.dart';
import 'package:flutter_snappyshop/features/cards/validators/card_validator.dart';
import 'package:flutter_snappyshop/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_snappyshop/features/shared/models/form_type.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

final cardProvider = StateNotifierProvider<CardNotifier, CardState>((ref) {
  return CardNotifier(ref);
});

class CardNotifier extends StateNotifier<CardState> {
  CardNotifier(this.ref)
      : super(CardState(
          form: FormGroup({}),
        ));
  final StateNotifierProviderRef ref;

  void changeForm(String key, FormControl<String> formControl) {
    state = state.copyWith(
      form: FormGroup({
        ...state.form.controls,
        key: formControl,
      }),
    );
  }

  resetForm() {
    state = state.copyWith(
      formType: FormType.create,
      form: CardForm.resetForm(),
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
        cardNumber: removeSpaces(state.cardNumber.value ?? ''),
        cardHolderName: state.cardHolderName.value ?? '',
        expired: state.expired.value ?? '',
        ccv: state.ccv.value ?? '',
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

  selectCard(BankCard card) {
    if (state.listType == ListType.list) {
      resetForm();
      state = state.copyWith(
        formType: FormType.edit,
      );
      state.form.patchValue(card.toJson());
      appRouter.push('/card');
    } else {
      ref.read(checkoutProvider.notifier).setCard(card);
      appRouter.pop();
    }
  }

  changeListType(listType) {
    state = state.copyWith(
      listType: listType,
    );
  }
}

class CardState {
  final FormGroup form;
  final List<BankCard> cards;
  final FormType formType;
  final ListType listType;

  CardState({
    required this.form,
    this.cards = const [],
    this.formType = FormType.create,
    this.listType = ListType.list,
  });

  FormControl<String> get cardNumber =>
      form.control(CardForm.cardNumber) as FormControl<String>;
  FormControl<String> get cardHolderName =>
      form.control(CardForm.cardHolderName) as FormControl<String>;
  FormControl<String> get expired =>
      form.control(CardForm.expired) as FormControl<String>;
  FormControl<String> get ccv =>
      form.control(CardForm.ccv) as FormControl<String>;

  bool get isFormValue => form.valid;

  bool get cardExist {
    final int index =
        cards.indexWhere((element) => cardNumber.value == element.cardNumber);

    return index >= 0;
  }

  int? get paymentMethod {
    final isVisa =
        const VisaValidator().validate(form.control(CardForm.cardNumber)) ==
            null;
    if (isVisa) {
      return 1;
    }

    final isMasterCard = const MasterCardValidator()
            .validate(form.control(CardForm.cardNumber)) ==
        null;
    if (isMasterCard) {
      return 2;
    }

    final isAmex =
        const AmexValidator().validate(form.control(CardForm.cardNumber)) ==
            null;
    if (isAmex) {
      return 3;
    }

    return null;
  }

  CardState copyWith({
    FormGroup? form,
    List<BankCard>? cards,
    FormType? formType,
    ListType? listType,
  }) =>
      CardState(
        form: form ?? this.form,
        cards: cards ?? this.cards,
        formType: formType ?? this.formType,
        listType: listType ?? this.listType,
      );
}

class CardForm {
  static String cardNumber = 'cardNumber';
  static String cardHolderName = 'cardHolderName';
  static String expired = 'expired';
  static String ccv = 'ccv';

  static FormGroup resetForm() {
    return FormGroup({
      cardNumber: FormControl<String>(
        value: '',
        validators: [
          Validators.required,
          Validators.composeOR([
            const VisaValidator(),
            const MasterCardValidator(),
            const AmexValidator(),
          ])
        ],
      ),
      cardHolderName: FormControl<String>(
        value: '',
        validators: [Validators.required],
      ),
      expired: FormControl<String>(
        value: '',
        validators: [
          Validators.required,
          Validators.minLength(5),
          Validators.maxLength(5),
          const ExpiredValidator(),
        ],
      ),
      ccv: FormControl<String>(
        value: '',
        validators: [
          Validators.required,
          Validators.number(),
          Validators.minLength(3),
          Validators.maxLength(4),
        ],
      ),
    });
  }
}

String removeSpaces(String value) {
  return value.replaceAll(' ', '');
}

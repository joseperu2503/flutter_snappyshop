import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/cards/models/bank_card.dart';
import 'package:flutter_snappyshop/features/cards/services/card_service.dart';
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
      form: FormCard.resetForm(),
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
      await CardService.saveCard(BankCard(
        cardNumber: state.cardNumber.value ?? '',
        cardHolderName: state.cardHolderName.value ?? '',
        expired: state.expired.value ?? '',
        ccv: state.ccv.value ?? '',
      ));
      appRouter.pop();
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    getCards();
  }

  selectCard(BankCard card) {
    resetForm();
    state.form.patchValue(card.toJson());
  }
}

class CardState {
  final FormGroup form;
  final List<BankCard> cards;

  CardState({
    required this.form,
    this.cards = const [],
  });

  FormControl<String> get cardNumber =>
      form.control(FormCard.cardNumber) as FormControl<String>;
  FormControl<String> get cardHolderName =>
      form.control(FormCard.cardHolderName) as FormControl<String>;
  FormControl<String> get expired =>
      form.control(FormCard.expired) as FormControl<String>;
  FormControl<String> get ccv =>
      form.control(FormCard.ccv) as FormControl<String>;

  bool get isFormValue => form.valid;

  CardState copyWith({
    FormGroup? form,
    List<BankCard>? cards,
  }) =>
      CardState(
        form: form ?? this.form,
        cards: cards ?? this.cards,
      );
}

class FormCard {
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
          Validators.minLength(16),
          Validators.minLength(16)
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
        ],
      ),
      ccv: FormControl<String>(
        value: '',
        validators: [
          Validators.required,
          Validators.number(),
        ],
      ),
    });
  }
}

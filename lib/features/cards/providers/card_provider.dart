import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FormAddress {
  static String cardNumber = 'cardNumber';
  static String cardHolderName = 'cardHolderName';
  static String expired = 'expired';
  static String ccv = 'ccv';
}

final cardProvider = StateNotifierProvider<CardNotifier, CardState>((ref) {
  return CardNotifier(ref);
});

class CardNotifier extends StateNotifier<CardState> {
  CardNotifier(this.ref)
      : super(CardState(
          form: FormGroup({
            FormAddress.cardNumber: FormControl<String>(
              value: '',
              validators: [
                Validators.required,
                Validators.minLength(16),
                Validators.minLength(16)
              ],
            ),
            FormAddress.cardHolderName: FormControl<String>(
              value: '',
              validators: [Validators.required],
            ),
            FormAddress.expired: FormControl<String>(
              value: '',
              validators: [
                Validators.required,
              ],
            ),
            FormAddress.ccv: FormControl<String>(
              value: '',
              validators: [
                Validators.required,
                Validators.number(),
              ],
            ),
          }),
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
}

class CardState {
  final FormGroup form;

  CardState({
    required this.form,
  });

  FormControl<String> get cardNumber =>
      form.control(FormAddress.cardNumber) as FormControl<String>;
  FormControl<String> get cardHolderName =>
      form.control(FormAddress.cardHolderName) as FormControl<String>;
  FormControl<String> get expired =>
      form.control(FormAddress.expired) as FormControl<String>;
  FormControl<String> get ccv =>
      form.control(FormAddress.ccv) as FormControl<String>;

  bool get isFormValue => form.valid;

  CardState copyWith({
    FormGroup? form,
  }) =>
      CardState(
        form: form ?? this.form,
      );
}

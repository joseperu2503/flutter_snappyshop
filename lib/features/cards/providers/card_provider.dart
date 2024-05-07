import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

final cardProvider = StateNotifierProvider<CardNotifier, CardState>((ref) {
  return CardNotifier(ref);
});

class CardNotifier extends StateNotifier<CardState> {
  CardNotifier(this.ref)
      : super(CardState(
          cardNumber: FormControl<String>(value: ''),
          cardHolderName: FormControl<String>(value: ''),
          expired: FormControl<String>(value: ''),
          ccv: FormControl<String>(value: ''),
        ));
  final StateNotifierProviderRef ref;

  void changeCardNumber(FormControl<String> cardNumber) {
    state = state.copyWith(
      cardNumber: cardNumber,
    );
  }

  void changeCardHolderName(FormControl<String> cardHolderName) {
    state = state.copyWith(
      cardHolderName: cardHolderName,
    );
  }

  void changeExpired(FormControl<String> expired) {
    state = state.copyWith(
      expired: expired,
    );
  }

  void changeCcv(FormControl<String> ccv) {
    state = state.copyWith(
      ccv: ccv,
    );
  }
}

class CardState {
  final FormControl<String> cardNumber;
  final FormControl<String> cardHolderName;
  final FormControl<String> expired;
  final FormControl<String> ccv;

  CardState({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expired,
    required this.ccv,
  });

  CardState copyWith({
    FormControl<String>? cardNumber,
    FormControl<String>? cardHolderName,
    FormControl<String>? expired,
    FormControl<String>? ccv,
  }) =>
      CardState(
        cardNumber: cardNumber ?? this.cardNumber,
        cardHolderName: cardHolderName ?? this.cardHolderName,
        expired: expired ?? this.expired,
        ccv: ccv ?? this.ccv,
      );
}

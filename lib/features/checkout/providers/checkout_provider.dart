import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/cards/models/bank_card.dart';
import 'package:flutter_snappyshop/features/cards/providers/card_provider.dart';

final checkoutProvider =
    StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier(ref);
});

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  CheckoutNotifier(this.ref) : super(CheckoutState());
  final StateNotifierProviderRef ref;

  setCard(BankCard card) {
    state = state.copyWith(
      card: () => card,
    );
  }

  setAddress(Address address) {
    state = state.copyWith(
      address: () => address,
    );
  }

  initData() async {
    state = state.copyWith(
      card: () => null,
      address: () => null,
    );
    await ref.read(cardProvider.notifier).getCards();
    await ref.read(addressProvider.notifier).getMyAddresses();
    final cards = ref.read(cardProvider).cards;
    final addresses = ref.read(addressProvider).addresses;

    if (cards.isNotEmpty) {
      setCard(cards[0]);
    }

    if (addresses.isNotEmpty) {
      setAddress(addresses[0]);
      int primaryIndex = addresses.indexWhere((element) => element.primary);
      if (primaryIndex >= 0) {
        setAddress(addresses[primaryIndex]);
      }
    }
  }
}

class CheckoutState {
  final Address? address;
  final BankCard? card;

  CheckoutState({
    this.address,
    this.card,
  });

  CheckoutState copyWith({
    ValueGetter<Address?>? address,
    ValueGetter<BankCard?>? card,
  }) =>
      CheckoutState(
        address: address != null ? address() : this.address,
        card: card != null ? card() : this.card,
      );
}

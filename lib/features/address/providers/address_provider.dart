import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

final addressProvider =
    StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier(ref);
});

class AddressNotifier extends StateNotifier<AddressState> {
  AddressNotifier(this.ref)
      : super(AddressState(
          name: FormControl<String>(value: ''),
          country: FormControl<String>(value: ''),
          city: FormControl<String>(value: ''),
          phone: FormControl<String>(value: ''),
          address: FormControl<String>(value: ''),
          zipCode: FormControl<String>(value: ''),
        ));

  final StateNotifierProviderRef ref;

  void changeName(FormControl<String> name) {
    state = state.copyWith(
      name: name,
    );
  }

  void changeCountry(FormControl<String> country) {
    state = state.copyWith(
      country: country,
    );
  }

  void changeCity(FormControl<String> city) {
    state = state.copyWith(
      city: city,
    );
  }

  void changePhone(FormControl<String> phone) {
    state = state.copyWith(
      phone: phone,
    );
  }

  void changeAddress(FormControl<String> address) {
    state = state.copyWith(
      address: address,
    );
  }

  void changeZipCode(FormControl<String> zipCode) {
    state = state.copyWith(
      zipCode: zipCode,
    );
  }
}

class AddressState {
  final FormControl<String> name;
  final FormControl<String> country;
  final FormControl<String> city;
  final FormControl<String> phone;
  final FormControl<String> address;
  final FormControl<String> zipCode;

  AddressState({
    required this.name,
    required this.country,
    required this.city,
    required this.phone,
    required this.address,
    required this.zipCode,
  });

  AddressState copyWith({
    FormControl<String>? name,
    FormControl<String>? country,
    FormControl<String>? city,
    FormControl<String>? phone,
    FormControl<String>? address,
    FormControl<String>? zipCode,
  }) =>
      AddressState(
        name: name ?? this.name,
        country: country ?? this.country,
        city: city ?? this.city,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        zipCode: zipCode ?? this.zipCode,
      );
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/models/autocomplete_response.dart';
import 'package:flutter_snappyshop/features/address/models/geocode_response.dart';
import 'package:flutter_snappyshop/features/address/services/address_services.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/plugins/formx/formx.dart';
import 'package:flutter_snappyshop/features/shared/providers/map_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/shared/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final addressProvider =
    StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier(ref);
});

class AddressNotifier extends StateNotifier<AddressState> {
  AddressNotifier(this.ref) : super(AddressState());

  final StateNotifierProviderRef ref;

  resetForm() {
    state = state.copyWith(
      recipientName: FormxInput(
        value: '',
        validators: [Validators.required()],
      ),
      detail: FormxInput(
        value: '',
        validators: [
          Validators.required(errorMessage: 'We need this information.')
        ],
      ),
      references: const FormxInput(
        value: '',
      ),
      phone: FormxInput(
        value: '',
        validators: [
          Validators.required(errorMessage: 'We need this information.')
        ],
      ),
      address: FormxInput(
        value: '',
        validators: [
          Validators.required(errorMessage: 'We need this information.')
        ],
      ),
      country: FormxInput(
        value: '',
        validators: [Validators.required()],
      ),
      locality: FormxInput(
        value: '',
        validators: [Validators.required()],
      ),
      plusCode: FormxInput(
        value: '',
        validators: [Validators.required()],
      ),
      postalCode: FormxInput(
        value: '',
        validators: [Validators.required()],
      ),
    );
  }

  //** Metodo que se ejecuta cuando se desplaza el mapa */
  Future<void> onCameraPositionChange() async {
    LatLng? cameraPosition = ref.read(mapProvider).cameraPosition;
    if (cameraPosition == null) return;

    state = state.copyWith(
      geocodeStatus: LoadingStatus.loading,
      address: state.address.updateValue(''),
      country: state.country.updateValue(''),
      locality: state.locality.updateValue(''),
      plusCode: state.plusCode.updateValue(''),
      postalCode: state.postalCode.updateValue(''),
    );

    try {
      final GeocodeResponse response = await AddressService.geocode(
        latitude: cameraPosition.latitude,
        longitude: cameraPosition.longitude,
      );

      if (cameraPosition == ref.read(mapProvider).cameraPosition) {
        state = state.copyWith(
          address: state.address.updateValue(response.address),
          country: state.country.updateValue(response.country),
          locality: state.locality.updateValue(response.locality),
          plusCode: state.plusCode.updateValue(response.plusCode),
          postalCode: state.postalCode.updateValue(response.postalCode),
          geocodeStatus: LoadingStatus.success,
        );
      }
    } on ServiceException catch (_) {
      if (cameraPosition == ref.read(mapProvider).cameraPosition) {
        state = state.copyWith(
          geocodeStatus: LoadingStatus.error,
        );
      }
    }
  }

  Timer? _debounceTimer;

  //** Metodo que se ejecuta cuando se escribe el input de busqueda */
  changeSearch(String newSearch) {
    state = state.copyWith(
      addressResults: [],
      search: newSearch,
      searchingAddresses:
          newSearch != '' ? LoadingStatus.loading : LoadingStatus.none,
    );
    if (newSearch == '') return;

    final search = state.search;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 1000),
      () {
        if (search != state.search) return;
        searchAddress();
      },
    );
  }

  //** Metodo para buscar resultados de direcciones */
  Future<void> searchAddress() async {
    state = state.copyWith(
      searchingAddresses: LoadingStatus.loading,
    );

    final search = state.search;
    try {
      final response = await AddressService.autocomplete(
        input: state.search,
      );

      if (search == state.search) {
        state = state.copyWith(
          addressResults: response,
          searchingAddresses: LoadingStatus.success,
        );
      }
    } on ServiceException catch (e) {
      if (search == state.search) {
        ref.read(snackbarProvider.notifier).showSnackbar(e.message);
        state = state.copyWith(
          searchingAddresses: LoadingStatus.error,
        );
      }
    }
  }

  Future<void> getAddresses() async {
    if (state.loadingAddresses == LoadingStatus.loading) return;

    state = state.copyWith(
      loadingAddresses: LoadingStatus.loading,
      addresses: [],
    );

    try {
      final response = await AddressService.getAddresses();
      state = state.copyWith(
        addresses: response,
        loadingAddresses: LoadingStatus.success,
      );
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      state = state.copyWith(
        loadingAddresses: LoadingStatus.error,
      );
    }
  }

  createAddress() async {
    LatLng? cameraPosition = ref.read(mapProvider).cameraPosition;
    if (cameraPosition == null) return;

    try {
      state = state.copyWith(
        savingAddress: LoadingStatus.loading,
      );
      final response = await AddressService.createAddress(
        address: state.address.value,
        detail: state.detail.value,
        recipientName: state.recipientName.value,
        phone: state.phone.value,
        latitude: cameraPosition.latitude,
        longitude: cameraPosition.longitude,
        references: state.references.value,
        country: state.country.value,
        locality: state.locality.value,
        plusCode: state.plusCode.value,
        postalCode: state.postalCode.value,
      );
      state = state.copyWith(
        savingAddress: LoadingStatus.success,
      );
      await getAddresses();

      appRouter.pop(response.data);
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      state = state.copyWith(
        savingAddress: LoadingStatus.error,
      );
    }
  }

  deleteAddress() async {
    if (state.selectedAddress == null) return;

    try {
      state = state.copyWith(
        savingAddress: LoadingStatus.loading,
      );
      await AddressService.deleteAddress(
        addressId: state.selectedAddress!.id,
      );
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
    state = state.copyWith(
      savingAddress: LoadingStatus.none,
    );
    appRouter.pop();
    await getAddresses();
  }

  goSearchAddress({void Function(Address address)? onSubmit}) async {
    changeSearch('');
    state = state.copyWith(
      selectedAddress: () => null,
      savingAddress: LoadingStatus.none,
    );
    resetForm();
    final Address? address = await appRouter.push<Address>('/search-address');
    if (address != null && onSubmit != null) {
      onSubmit(address);
    }
  }

  //** Metodo para seleccionar un resultado y buscar sus coordenadas */
  Future<void> goMap(AddressResult? addressResult) async {
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      if (addressResult != null) {
        final addressResultDetails = await AddressService.addressResultDetail(
          placeId: addressResult.placeId,
        );

        ref.read(mapProvider.notifier).changeCameraPosition(LatLng(
              addressResultDetails.location.lat,
              addressResultDetails.location.lng,
            ));
      } else {
        Position? location = await LocationService.getCurrentPosition();

        if (location == null) {
          return;
        }

        ref.read(mapProvider.notifier).changeCameraPosition(LatLng(
              location.latitude,
              location.longitude,
            ));
      }

      final Address? address = await appRouter.push<Address>('/address-map');
      if (address != null) {
        appRouter.pop(address);
      }
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
  }

  goConfirm() async {
    state = state.copyWith(
      savingAddress: LoadingStatus.none,
    );

    final Address? address = await appRouter.push<Address>('/confirm-address');
    if (address != null) {
      appRouter.pop(address);
    }
  }

  editAddress({required Address address}) {
    state = state.copyWith(
      selectedAddress: () => address,
      savingAddress: LoadingStatus.none,
      recipientName: state.recipientName.updateValue(address.recipientName),
      detail: state.detail.updateValue(address.detail),
      references: state.references.updateValue(address.references ?? ''),
      phone: state.phone.updateValue(address.phone),
      address: state.address.updateValue(address.address),
      country: state.country.updateValue(address.country),
      locality: state.locality.updateValue(address.locality),
      plusCode: state.plusCode.updateValue(address.plusCode),
      postalCode: state.postalCode.updateValue(address.postalCode),
    );

    appRouter.push('/confirm-address');
  }

  void changeRecipientName(FormxInput<String> recipientName) {
    state = state.copyWith(
      recipientName: recipientName,
    );
  }

  void changeDetail(FormxInput<String> detail) {
    state = state.copyWith(
      detail: detail,
    );
  }

  void changeReferences(FormxInput<String> references) {
    state = state.copyWith(
      references: references,
    );
  }

  void changePhone(FormxInput<String> phone) {
    state = state.copyWith(
      phone: phone,
    );
  }

  void changeAddress(FormxInput<String> address) {
    state = state.copyWith(
      address: address,
    );
  }
}

class AddressState {
  final List<AddressResult> addressResults;
  final String search;
  final LoadingStatus searchingAddresses;
  final LoadingStatus geocodeStatus;
  final List<Address> addresses;
  final Address? selectedAddress;
  final LoadingStatus loadingAddresses;
  final LoadingStatus savingAddress;
  final FormxInput<String> recipientName;
  final FormxInput<String> detail;
  final FormxInput<String> references;
  final FormxInput<String> phone;
  final FormxInput<String> address;
  final FormxInput<String> country;
  final FormxInput<String> locality;
  final FormxInput<String> postalCode;
  final FormxInput<String> plusCode;

  AddressState({
    this.addressResults = const [],
    this.search = '',
    this.searchingAddresses = LoadingStatus.none,
    this.geocodeStatus = LoadingStatus.none,
    this.addresses = const [],
    this.loadingAddresses = LoadingStatus.none,
    this.savingAddress = LoadingStatus.none,
    this.selectedAddress,
    this.recipientName = const FormxInput(value: ''),
    this.detail = const FormxInput(value: ''),
    this.references = const FormxInput(value: ''),
    this.phone = const FormxInput(value: ''),
    this.address = const FormxInput(value: ''),
    this.country = const FormxInput(value: ''),
    this.locality = const FormxInput(value: ''),
    this.postalCode = const FormxInput(value: ''),
    this.plusCode = const FormxInput(value: ''),
  });

  bool get isFormValid =>
      recipientName.isValid &&
      detail.isValid &&
      references.isValid &&
      phone.isValid &&
      address.isValid &&
      country.isValid &&
      locality.isValid &&
      postalCode.isValid &&
      plusCode.isValid;

  AddressState copyWith({
    List<AddressResult>? addressResults,
    String? search,
    LoadingStatus? searchingAddresses,
    List<Address>? addresses,
    LoadingStatus? loadingAddresses,
    LoadingStatus? geocodeStatus,
    LoadingStatus? savingAddress,
    ValueGetter<Address?>? selectedAddress,
    FormxInput<String>? recipientName,
    FormxInput<String>? detail,
    FormxInput<String>? references,
    FormxInput<String>? phone,
    FormxInput<String>? address,
    FormxInput<String>? country,
    FormxInput<String>? locality,
    FormxInput<String>? postalCode,
    FormxInput<String>? plusCode,
  }) =>
      AddressState(
        addressResults: addressResults ?? this.addressResults,
        search: search ?? this.search,
        searchingAddresses: searchingAddresses ?? this.searchingAddresses,
        geocodeStatus: geocodeStatus ?? this.geocodeStatus,
        addresses: addresses ?? this.addresses,
        loadingAddresses: loadingAddresses ?? this.loadingAddresses,
        savingAddress: savingAddress ?? this.savingAddress,
        selectedAddress:
            selectedAddress != null ? selectedAddress() : this.selectedAddress,
        recipientName: recipientName ?? this.recipientName,
        detail: detail ?? this.detail,
        references: references ?? this.references,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        country: country ?? this.country,
        locality: locality ?? this.locality,
        postalCode: postalCode ?? this.postalCode,
        plusCode: plusCode ?? this.plusCode,
      );
}

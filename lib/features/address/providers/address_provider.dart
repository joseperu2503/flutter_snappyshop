import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/models/autocomplete_response.dart';
import 'package:flutter_snappyshop/features/address/models/geocode_response.dart';
import 'package:flutter_snappyshop/features/address/services/address_services.dart';
import 'package:flutter_snappyshop/features/shared/models/form_type.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/plugins/formx/formx.dart';
import 'package:flutter_snappyshop/features/shared/providers/map_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
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
    );
  }

  goSearchAddress() {
    changeSearch('');
    appRouter.push('/search-address');
  }

  Future<void> onCameraPositionChange() async {
    LatLng? cameraPosition = ref.read(mapProvider).cameraPosition;
    if (cameraPosition == null) return;
    try {
      final GeocodeResponse response = await AddressService.geocode(
        latitude: cameraPosition.latitude,
        longitude: cameraPosition.longitude,
      );

      if (cameraPosition == ref.read(mapProvider).cameraPosition) {
        state = state.copyWith(
          address: state.address.updateValue(response.address),
        );
      }
    } on ServiceException catch (_) {
      if (cameraPosition == ref.read(mapProvider).cameraPosition) {
        state = state.copyWith(
          address: state.address.updateValue(''),
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

    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
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
      final AutocompleteResponse response = await AddressService.autocomplete(
        query: state.search,
      );

      if (search == state.search) {
        state = state.copyWith(
          addressResults: response.predictions,
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

  //** Metodo para seleccionar un resultado y buscar sus coordenadas */
  Future<void> selectAddressResult(AddressResult addressResult) async {
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      final addressResultDetails = await AddressService.addressResultDetail(
        placeId: addressResult.placeId,
      );

      ref.read(mapProvider.notifier).changeCameraPosition(LatLng(
            addressResultDetails.result.geometry.location.lat,
            addressResultDetails.result.geometry.location.lng,
          ));

      appRouter.push('/address-map');
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
  }

  resetMyAddresses() {
    state = state.copyWith(
      addresses: [],
      page: 1,
      totalPages: 1,
      loadingAddresses: LoadingStatus.none,
    );
  }

  Future<void> getMyAddresses() async {
    if (state.page > state.totalPages ||
        state.loadingAddresses == LoadingStatus.loading) return;

    state = state.copyWith(
      loadingAddresses: LoadingStatus.loading,
    );

    try {
      final AddressesResponse response = await AddressService.getMyAddresses(
        page: state.page,
      );
      state = state.copyWith(
        addresses: [...state.addresses, ...response.results],
        totalPages: response.info.lastPage,
        page: state.page + 1,
        loadingAddresses: LoadingStatus.success,
      );
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      state = state.copyWith(
        loadingAddresses: LoadingStatus.error,
      );
    }
  }

  saveAddress() async {
    LatLng? cameraPosition = ref.read(mapProvider).cameraPosition;
    if (cameraPosition == null) return;

    try {
      state = state.copyWith(
        savingAddress: LoadingStatus.loading,
      );
      await AddressService.createAddress(
        address: state.address.value,
        detail: state.detail.value,
        recipientName: state.recipientName.value,
        phone: state.phone.value,
        latitude: cameraPosition.latitude,
        longitude: cameraPosition.longitude,
        references: state.references.value,
      );
      state = state.copyWith(
        savingAddress: LoadingStatus.success,
      );

      appRouter.pop();
      appRouter.pop();
      appRouter.pop();

      resetMyAddresses();
      await getMyAddresses();
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      state = state.copyWith(
        savingAddress: LoadingStatus.error,
      );
    }
  }

  deleteAddress() async {
    if (state.selectedAddress == null) return;

    resetMyAddresses();
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
    await getMyAddresses();
  }

  markAsPrimary() async {
    if (state.selectedAddress == null) return;

    resetMyAddresses();
    try {
      state = state.copyWith(
        savingAddress: LoadingStatus.loading,
      );
      await AddressService.markAsPrimary(
        addressId: state.selectedAddress!.id,
      );
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
    state = state.copyWith(
      savingAddress: LoadingStatus.none,
    );
    appRouter.pop();
    await getMyAddresses();
  }

  goConfirm() {
    state = state.copyWith(
      savingAddress: LoadingStatus.none,
    );

    appRouter.push('/confirm-address');
  }

  viewAddress({required Address address}) {
    state = state.copyWith(
      selectedAddress: () => address,
      savingAddress: LoadingStatus.none,
    );

    resetForm();

    state = state.copyWith(
      recipientName: state.recipientName.updateValue(address.recipientName),
      detail: state.detail.updateValue(address.detail),
      references: state.references.updateValue(address.references ?? ''),
      phone: state.phone.updateValue(address.phone),
      address: state.address.updateValue(address.address),
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
  final List<Address> addresses;
  final Address? selectedAddress;
  final int page;
  final int totalPages;
  final LoadingStatus loadingAddresses;
  final LoadingStatus savingAddress;
  final FormxInput<String> recipientName;
  final FormxInput<String> detail;
  final FormxInput<String> references;
  final FormxInput<String> phone;
  final FormxInput<String> address;

  AddressState({
    this.addressResults = const [],
    this.search = '',
    this.searchingAddresses = LoadingStatus.none,
    this.addresses = const [],
    this.page = 1,
    this.totalPages = 1,
    this.loadingAddresses = LoadingStatus.none,
    this.savingAddress = LoadingStatus.none,
    this.selectedAddress,
    this.recipientName = const FormxInput(value: ''),
    this.detail = const FormxInput(value: ''),
    this.references = const FormxInput(value: ''),
    this.phone = const FormxInput(value: ''),
    this.address = const FormxInput(value: ''),
  });

  bool get isFormValid =>
      recipientName.isValid &&
      detail.isValid &&
      references.isValid &&
      phone.isValid &&
      address.isValid;

  bool get firstLoad => loadingAddresses == LoadingStatus.loading && page == 1;

  AddressState copyWith({
    List<AddressResult>? addressResults,
    String? search,
    LoadingStatus? searchingAddresses,
    List<Address>? addresses,
    int? page,
    int? totalPages,
    LoadingStatus? loadingAddresses,
    FormType? formType,
    LoadingStatus? savingAddress,
    ValueGetter<Address?>? selectedAddress,
    FormxInput<String>? recipientName,
    FormxInput<String>? detail,
    FormxInput<String>? references,
    FormxInput<String>? phone,
    FormxInput<String>? address,
  }) =>
      AddressState(
        addressResults: addressResults ?? this.addressResults,
        search: search ?? this.search,
        searchingAddresses: searchingAddresses ?? this.searchingAddresses,
        addresses: addresses ?? this.addresses,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        loadingAddresses: loadingAddresses ?? this.loadingAddresses,
        savingAddress: savingAddress ?? this.savingAddress,
        selectedAddress:
            selectedAddress != null ? selectedAddress() : this.selectedAddress,
        recipientName: recipientName ?? this.recipientName,
        detail: detail ?? this.detail,
        references: references ?? this.references,
        phone: phone ?? this.phone,
        address: address ?? this.address,
      );
}

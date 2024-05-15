import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/models/mapbox_response.dart';
import 'package:flutter_snappyshop/features/address/services/address_services.dart';
import 'package:flutter_snappyshop/features/address/services/mapbox_service.dart';
import 'package:flutter_snappyshop/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_snappyshop/features/shared/models/form_type.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/map_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FormAddress {
  static String name = 'name';
  static String detail = 'detail';
  static String phone = 'phone';
  static String address = 'address';
  static String references = 'references';
}

final addressProvider =
    StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier(ref);
});

class AddressNotifier extends StateNotifier<AddressState> {
  AddressNotifier(this.ref)
      : super(
          AddressState(
            form: AddressForm.resetForm(),
          ),
        );

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
      savingAddress: LoadingStatus.none,
      form: AddressForm.resetForm(),
    );
    changeSearch('');
  }

  Future<void> searchLocality() async {
    LatLng? cameraPosition = ref.read(mapProvider).cameraPosition;
    if (cameraPosition == null) return;
    try {
      final MapboxResponse response = await MapBoxService.geocode(
        latitude: cameraPosition.latitude,
        longitude: cameraPosition.longitude,
      );

      if (cameraPosition == ref.read(mapProvider).cameraPosition) {
        if (response.features.isNotEmpty &&
            response.features[0].properties.namePreferred != null &&
            response.features[0].properties.context.country?.name != null) {
          changeForm(FormAddress.address,
              FormControl(value: response.features[0].properties.name));
        } else {
          changeForm(FormAddress.address, FormControl(value: ''));
        }
      }
    } on ServiceException catch (_) {
      if (cameraPosition == ref.read(mapProvider).cameraPosition) {
        changeForm(FormAddress.address, FormControl(value: ''));
      }
    }
  }

  Timer? _debounceTimer;

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

  Future<void> searchAddress() async {
    state = state.copyWith(
      searchingAddresses: LoadingStatus.loading,
    );

    final search = state.search;
    try {
      final MapboxResponse response = await MapBoxService.searchbox(
        query: state.search,
      );

      if (search == state.search) {
        state = state.copyWith(
          addressResults: response.features,
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
        address: state.form.control(AddressForm.address).value,
        detail: state.form.control(AddressForm.detail).value,
        name: state.form.control(AddressForm.name).value,
        phone: state.form.control(AddressForm.phone).value,
        latitude: cameraPosition.latitude,
        longitude: cameraPosition.longitude,
        references: state.form.control(AddressForm.references).value,
      );
      state = state.copyWith(
        savingAddress: LoadingStatus.success,
      );

      appRouter.pop();
      appRouter.pop();
      appRouter.pop();

      resetMyAddresses();
      await getMyAddresses();

      if (state.listType == ListType.select) {
        appRouter.pop();
        int selectedIndex = state.addresses.indexWhere((element) =>
            element.latitude == cameraPosition.latitude &&
            element.longitude == cameraPosition.longitude);
        if (selectedIndex >= 0) {
          ref
              .read(checkoutProvider.notifier)
              .setAddress(state.addresses[selectedIndex]);
        }
      }
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

  selectAddress(Address address) {
    if (state.listType == ListType.list) {
      state = state.copyWith(
        formType: FormType.edit,
        selectedAddress: () => address,
        savingAddress: LoadingStatus.none,
        form: AddressForm.resetForm(),
      );
      state.form.patchValue(address.toJson());
      appRouter.push('/confirm-address');
    } else {
      ref.read(checkoutProvider.notifier).setAddress(address);
      appRouter.pop();
    }
  }

  changeListType(listType) {
    state = state.copyWith(
      listType: listType,
    );
  }
}

class AddressState {
  final List<Feature> addressResults;
  final String search;
  final LoadingStatus searchingAddresses;
  final FormGroup form;
  final List<Address> addresses;
  final Address? selectedAddress;
  final int page;
  final int totalPages;
  final LoadingStatus loadingAddresses;
  final LoadingStatus savingAddress;
  final FormType formType;
  final ListType listType;

  AddressState({
    this.addressResults = const [],
    this.search = '',
    this.searchingAddresses = LoadingStatus.none,
    required this.form,
    this.addresses = const [],
    this.page = 1,
    this.totalPages = 1,
    this.loadingAddresses = LoadingStatus.none,
    this.formType = FormType.create,
    this.savingAddress = LoadingStatus.none,
    this.selectedAddress,
    this.listType = ListType.list,
  });

  FormControl<String> get name =>
      form.control(FormAddress.name) as FormControl<String>;
  FormControl<String> get detail =>
      form.control(FormAddress.detail) as FormControl<String>;
  FormControl<String> get references =>
      form.control(FormAddress.references) as FormControl<String>;
  FormControl<String> get phone =>
      form.control(FormAddress.phone) as FormControl<String>;
  FormControl<String> get address =>
      form.control(FormAddress.address) as FormControl<String>;

  bool get isFormValue => form.valid;
  bool get firstLoad => loadingAddresses == LoadingStatus.loading && page == 1;

  AddressState copyWith({
    List<Feature>? addressResults,
    String? search,
    LoadingStatus? searchingAddresses,
    FormGroup? form,
    List<Address>? addresses,
    int? page,
    int? totalPages,
    LoadingStatus? loadingAddresses,
    FormType? formType,
    LoadingStatus? savingAddress,
    ValueGetter<Address?>? selectedAddress,
    ListType? listType,
  }) =>
      AddressState(
        addressResults: addressResults ?? this.addressResults,
        search: search ?? this.search,
        searchingAddresses: searchingAddresses ?? this.searchingAddresses,
        form: form ?? this.form,
        addresses: addresses ?? this.addresses,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        loadingAddresses: loadingAddresses ?? this.loadingAddresses,
        formType: formType ?? this.formType,
        savingAddress: savingAddress ?? this.savingAddress,
        selectedAddress:
            selectedAddress != null ? selectedAddress() : this.selectedAddress,
        listType: listType ?? this.listType,
      );
}

class AddressForm {
  static String address = 'address';
  static String detail = 'detail';
  static String name = 'name';
  static String phone = 'phone';
  static String references = 'references';

  static FormGroup resetForm() {
    return FormGroup({
      FormAddress.address:
          FormControl<String>(value: '', validators: [Validators.required]),
      FormAddress.detail:
          FormControl<String>(value: '', validators: [Validators.required]),
      FormAddress.name: FormControl<String>(
        value: '',
        validators: [Validators.required],
      ),
      FormAddress.phone: FormControl<String>(value: '', validators: [
        Validators.required,
        Validators.number(),
      ]),
      FormAddress.references: FormControl<String>(value: ''),
    });
  }
}

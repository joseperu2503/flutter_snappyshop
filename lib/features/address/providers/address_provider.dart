import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/address/models/mapbox_response.dart';
import 'package:flutter_snappyshop/features/address/services/mapbox_service.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
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
            form: FormGroup({
              FormAddress.name: FormControl<String>(
                value: '',
                validators: [Validators.required],
              ),
              FormAddress.detail: FormControl<String>(
                  value: '', validators: [Validators.required]),
              FormAddress.phone: FormControl<String>(
                  value: '', validators: [Validators.required]),
              FormAddress.address: FormControl<String>(
                  value: '', validators: [Validators.required]),
              FormAddress.references: FormControl<String>(value: ''),
            }),
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

  void changeCameraPosition(LatLng newCameraPosition) {
    state = state.copyWith(
      cameraPosition: () => newCameraPosition,
    );
  }

  Future<void> searchLocality() async {
    LatLng? cameraPosition = state.cameraPosition;
    if (cameraPosition == null) return;
    try {
      final MapboxResponse response = await MapBoxService.geocode(
        latitude: cameraPosition.latitude,
        longitude: cameraPosition.longitude,
      );

      if (cameraPosition == state.cameraPosition) {
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
      if (cameraPosition == state.cameraPosition) {
        changeForm(FormAddress.address, FormControl(value: ''));
      }
    }
  }

  Timer? _debounceTimer;

  changeSearch(String newSearch) {
    state = state.copyWith(
      addressResults: [],
      search: newSearch,
      loadingAddresses: newSearch != '',
    );
    if (newSearch == '') return;

    final search = state.search;

    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 1000),
      () {
        if (search != state.search) return;
        searchProducts();
      },
    );
  }

  Future<void> searchProducts() async {
    state = state.copyWith(
      loadingAddresses: true,
    );

    final search = state.search;
    try {
      final MapboxResponse response = await MapBoxService.searchbox(
        query: state.search,
      );

      if (search == state.search) {
        state = state.copyWith(
          addressResults: response.features,
        );
      }
    } on ServiceException catch (e) {
      if (search == state.search) {
        ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      }
    }
    if (search == state.search) {
      state = state.copyWith(
        loadingAddresses: false,
      );
    }
  }
}

class AddressState {
  final LatLng? cameraPosition;
  final List<Feature> addressResults;
  final String search;
  final bool loadingAddresses;
  final FormGroup form;

  AddressState({
    this.cameraPosition,
    this.addressResults = const [],
    this.search = '',
    this.loadingAddresses = false,
    required this.form,
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

  AddressState copyWith({
    ValueGetter<LatLng?>? cameraPosition,
    List<Feature>? addressResults,
    String? search,
    bool? loadingAddresses,
    FormGroup? form,
  }) =>
      AddressState(
        cameraPosition:
            cameraPosition != null ? cameraPosition() : this.cameraPosition,
        addressResults: addressResults ?? this.addressResults,
        search: search ?? this.search,
        loadingAddresses: loadingAddresses ?? this.loadingAddresses,
        form: form ?? this.form,
      );
}

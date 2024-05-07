import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/address/models/mapbox_response.dart';
import 'package:flutter_snappyshop/features/address/services/mapbox_service.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final addressProvider =
    StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier(ref);
});

class AddressNotifier extends StateNotifier<AddressState> {
  AddressNotifier(this.ref)
      : super(
          AddressState(
            name: FormControl<String>(
              value: '',
              validators: [Validators.required],
            ),
            detail: FormControl<String>(
                value: '', validators: [Validators.required]),
            phone: FormControl<String>(
                value: '', validators: [Validators.required]),
            address: FormControl<String>(
                value: '', validators: [Validators.required]),
            references: FormControl<String>(value: ''),
          ),
        );

  final StateNotifierProviderRef ref;

  void changeName(FormControl<String> name) {
    state = state.copyWith(
      name: name,
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

  void changeReferences(FormControl<String> references) {
    state = state.copyWith(
      references: references,
    );
  }

  void changeCameraPosition(LatLng newCameraPosition) {
    state = state.copyWith(
      cameraPosition: () => newCameraPosition,
    );
  }

  void changeDetail(FormControl<String> detail) {
    state = state.copyWith(
      detail: detail,
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
          state = state.copyWith(
            address: FormControl(value: response.features[0].properties.name),
          );
        } else {
          state = state.copyWith(address: FormControl(value: ''));
        }
      }
    } on ServiceException catch (_) {
      if (cameraPosition == state.cameraPosition) {
        state = state.copyWith(address: FormControl(value: null));
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
  final FormControl<String> name;
  final FormControl<String> detail;
  final FormControl<String> references;
  final FormControl<String> phone;
  final FormControl<String> address;
  final LatLng? cameraPosition;
  final List<Feature> addressResults;
  final String search;
  final bool loadingAddresses;

  AddressState({
    required this.name,
    required this.detail,
    required this.phone,
    required this.address,
    required this.references,
    this.cameraPosition,
    this.addressResults = const [],
    this.search = '',
    this.loadingAddresses = false,
  });

  AddressState copyWith({
    FormControl<String>? name,
    FormControl<String>? detail,
    FormControl<String>? phone,
    FormControl<String>? address,
    FormControl<String>? references,
    ValueGetter<LatLng?>? cameraPosition,
    List<Feature>? addressResults,
    String? search,
    bool? loadingAddresses,
  }) =>
      AddressState(
        name: name ?? this.name,
        detail: detail ?? this.detail,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        references: references ?? this.references,
        cameraPosition:
            cameraPosition != null ? cameraPosition() : this.cameraPosition,
        addressResults: addressResults ?? this.addressResults,
        search: search ?? this.search,
        loadingAddresses: loadingAddresses ?? this.loadingAddresses,
      );
}

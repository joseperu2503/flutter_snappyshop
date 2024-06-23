import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  return MapNotifier();
});

class MapNotifier extends StateNotifier<MapState> {
  MapNotifier() : super(MapState());

  void setMapController(GoogleMapController controller) {
    state = state.copyWith(
      controller: controller,
    );
  }

  Future<void> goToLocation(double latitude, double longitude) async {
    final newPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 18,
    );

    await state.controller
        ?.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  void changeCameraPosition(LatLng newCameraPosition) {
    state = state.copyWith(
      cameraPosition: () => newCameraPosition,
    );
  }
}

class MapState {
  final GoogleMapController? controller;
  final LatLng? cameraPosition;

  MapState({
    this.controller,
    this.cameraPosition,
  });

  MapState copyWith({
    GoogleMapController? controller,
    ValueGetter<LatLng?>? cameraPosition,
  }) {
    return MapState(
      controller: controller ?? this.controller,
      cameraPosition:
          cameraPosition != null ? cameraPosition() : this.cameraPosition,
    );
  }
}

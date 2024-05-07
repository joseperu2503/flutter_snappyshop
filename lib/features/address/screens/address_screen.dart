import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/address/constants/constants.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/address/widgets/bottom_modal.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/providers/map_controller_provider.dart';
import 'package:flutter_snappyshop/features/shared/services/location_service.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const double sizeMarker = 60;

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  AddressScreenState createState() => AddressScreenState();
}

class AddressScreenState extends ConsumerState<AddressScreen> {
  @override
  void initState() {
    Future.microtask(() async {
      ref.invalidate(addressProvider);
      Position location = await LocationService.getCurrentPosition();
      ref.read(addressProvider.notifier).changeCameraPosition(LatLng(
            location.latitude,
            location.longitude,
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData screen = MediaQuery.of(context);

    return Loader(
      loading: false,
      child: Layout1(
        title: 'Address',
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(
            right: 24,
            left: 24,
            bottom: screen.padding.bottom,
          ),
          height: heightBottomSheet,
          color: AppColors.white,
          child: Center(
            child: CustomButton(
              child: const Text(
                'Save Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textCultured,
                  height: 22 / 16,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
              onPressed: () {
                context.pop();
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      const MapView(),
                      Center(
                        child: SizedBox(
                          width: 0,
                          height: 0,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -sizeMarker,
                                left: -sizeMarker / 2,
                                child: SvgPicture.asset(
                                  'assets/icons/map_pin_solid.svg',
                                  height: sizeMarker,
                                  width: sizeMarker,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.primaryPearlAqua,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: (minHeightBottomSheet - radiusBottomSheet),
                ),
              ],
            ),
            BottomModal(screen: screen),
          ],
        ),
      ),
    );
  }
}

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends ConsumerState<MapView> {
  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressProvider);
    if (addressState.cameraPosition == null) return Container();
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: addressState.cameraPosition!,
        zoom: 18,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onCameraMove: (position) {
        ref.read(addressProvider.notifier).changeCameraPosition(LatLng(
              position.target.latitude,
              position.target.longitude,
            ));
      },
      onCameraIdle: () {
        ref.read(addressProvider.notifier).searchLocality();
      },
      onMapCreated: (GoogleMapController controller) {
        ref.read(mapControllerProvider.notifier).setMapController(controller);
      },
    );
  }
}

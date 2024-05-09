import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/search/widgets/input_search.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/providers/map_provider.dart';
import 'package:flutter_snappyshop/features/shared/services/location_service.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchAddressScreen extends ConsumerStatefulWidget {
  const SearchAddressScreen({super.key});

  @override
  SearchAddressScreenState createState() => SearchAddressScreenState();
}

class SearchAddressScreenState extends ConsumerState<SearchAddressScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressProvider);
    final showResults = addressState.addressResults.isNotEmpty;
    final noResults =
        addressState.searchingAddresses == LoadingStatus.success &&
            addressState.addressResults.isEmpty;

    return Layout1(
      title: 'Search address',
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.white,
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            titleSpacing: 0,
            toolbarHeight: 60,
            title: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 24,
                    right: 24,
                    bottom: 10,
                  ),
                  child: Hero(
                    tag: 'searchAddressTag',
                    child: Material(
                      child: InputSearch(
                        focusNode: _focusNode,
                        value: addressState.search,
                        onChanged: (value) {
                          ref
                              .read(addressProvider.notifier)
                              .changeSearch(value);
                        },
                        hintText: 'Enter address...',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            pinned: true,
          ),
          if (addressState.searchingAddresses == LoadingStatus.loading)
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: AppColors.primaryPearlAqua,
                    ),
                  ),
                ),
              ),
            ),
          if (showResults)
            SliverPadding(
              padding: const EdgeInsets.only(),
              sliver: SliverList.separated(
                itemBuilder: (context, index) {
                  final result = addressState.addressResults[index];
                  return SizedBox(
                    height: 80,
                    child: TextButton(
                      onPressed: () {
                        if (result.properties.coordinates?.latitude != null &&
                            result.properties.coordinates?.longitude != null) {
                          ref
                              .read(mapProvider.notifier)
                              .changeCameraPosition(LatLng(
                                result.properties.coordinates!.latitude!,
                                result.properties.coordinates!.longitude!,
                              ));
                          context.push('/address-map');
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  result.properties.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textCoolBlack,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                  ),
                                ),
                                Text(
                                  result.properties.placeFormatted ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textArsenic,
                                    height: 1,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    color: AppColors.textArsenic.withOpacity(0.1),
                  );
                },
                itemCount: addressState.addressResults.length,
              ),
            ),
          if (noResults)
            const SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Icon(
                    Icons.search,
                    size: 80,
                    color: AppColors.textArsenic,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'No Results',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textArsenic,
                      height: 1.1,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: 40,
              ),
              child: CustomButton(
                onPressed: () async {
                  try {
                    Position location =
                        await LocationService.getCurrentPosition();

                    ref.read(mapProvider.notifier).changeCameraPosition(LatLng(
                          location.latitude,
                          location.longitude,
                        ));
                    if (!context.mounted) return;
                    context.push('/address-map');
                  } catch (_) {}
                },
                text: 'Search address over the map',
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/address/widgets/no_results.dart';
import 'package:flutter_snappyshop/features/search/widgets/input_search.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/map_provider.dart';
import 'package:flutter_snappyshop/features/shared/services/location_service.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/progress_indicator.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  final FocusNode _focusNode = FocusNode();
  bool loadingPosition = false;

  searchAddressOverMap() async {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      loadingPosition = true;
    });
    Position? location = await LocationService.getCurrentPosition();
    setState(() {
      loadingPosition = false;
    });
    if (location == null) return;

    ref.read(mapProvider.notifier).changeCameraPosition(LatLng(
          location.latitude,
          location.longitude,
        ));
    if (!context.mounted) return;
    context.push('/address-map');
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressProvider);
    final showResults = addressState.addressResults.isNotEmpty;
    final noResults =
        addressState.searchingAddresses == LoadingStatus.success &&
            addressState.addressResults.isEmpty;
    final darkMode = ref.watch(darkModeProvider);

    return Layout1(
      loading: loadingPosition,
      title: 'Search address',
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: darkMode
                ? AppColors.backgroundColorDark
                : AppColors.backgroundColor,
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
                      color: Colors.transparent,
                      child: InputSearch(
                        focusNode: _focusNode,
                        value: addressState.search,
                        onChanged: (value) {
                          ref
                              .read(addressProvider.notifier)
                              .changeSearch(value);
                        },
                        hintText: 'Search address...',
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
                  child: CustomProgressIndicator(),
                ),
              ),
            ),
          if (showResults)
            SliverPadding(
              padding: const EdgeInsets.only(),
              sliver: SliverList.separated(
                itemBuilder: (context, index) {
                  final addressResult = addressState.addressResults[index];
                  return SizedBox(
                    height: 80,
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          loadingPosition = true;
                        });
                        await ref
                            .read(addressProvider.notifier)
                            .selectAddressResult(addressResult);
                        setState(() {
                          loadingPosition = false;
                        });
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
                                  addressResult.structuredFormatting.mainText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: darkMode
                                        ? AppColors.textCoolBlackDark
                                        : AppColors.textCoolBlack,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                  ),
                                ),
                                Text(
                                  addressResult
                                      .structuredFormatting.secondaryText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: darkMode
                                        ? AppColors.textArsenicDark
                                        : AppColors.textArsenic,
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
                    color: darkMode
                        ? AppColors.textArsenicDark.withOpacity(0.1)
                        : AppColors.textArsenic.withOpacity(0.1),
                  );
                },
                itemCount: addressState.addressResults.length,
              ),
            ),
          if (noResults) const NoResults(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: 40,
              ),
              child: CustomButton(
                onPressed: () {
                  searchAddressOverMap();
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

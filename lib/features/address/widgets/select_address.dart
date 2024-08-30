import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/address/widgets/address_option.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/progress_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SelectAddress extends ConsumerStatefulWidget {
  const SelectAddress({
    super.key,
    required this.selectedAddress,
  });

  final Address selectedAddress;

  @override
  SelectAddressState createState() => SelectAddressState();
}

class SelectAddressState extends ConsumerState<SelectAddress> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.invalidate(addressProvider);
      ref.read(addressProvider.notifier).getAddresses();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(darkModeProvider);

    final addressState = ref.watch(addressProvider);
    return Layout(
      loading: addressState.loadingAddresses == LoadingStatus.loading,
      title: 'Select address',
      leading: SizedBox(
        height: 42,
        width: 42,
        child: TextButton(
          onPressed: () {
            context.pop();
          },
          style: TextButton.styleFrom(
            padding: EdgeInsetsDirectional.zero,
          ),
          child: SvgPicture.asset(
            'assets/icons/close.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              darkMode
                  ? AppColors.textYankeesBlueDark
                  : AppColors.textYankeesBlue,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList.separated(
              itemBuilder: (context, index) {
                final address = addressState.addresses[index];
                return AddressOption(
                  address: address,
                  isSelected: widget.selectedAddress.id == address.id,
                  onPressed: () {
                    context.pop(address);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 14,
                );
              },
              itemCount: addressState.addresses.length,
            ),
          ),
          if (addressState.loadingAddresses == LoadingStatus.loading &&
              addressState.addresses.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 40,
                ),
                child: const Center(
                  child: CustomProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: CustomButton(
            text: 'Add address',
            onPressed: () {
              ref.read(addressProvider.notifier).goSearchAddress(
                onSubmit: (address) {
                  context.pop(address);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

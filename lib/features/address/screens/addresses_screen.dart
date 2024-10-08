import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/address/widgets/address_item.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/progress_indicator.dart';

class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  AddressesScreenState createState() => AddressesScreenState();
}

class AddressesScreenState extends ConsumerState<AddressesScreen> {
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
    final addressState = ref.watch(addressProvider);
    return Layout(
      loading: addressState.loadingAddresses == LoadingStatus.loading,
      title: 'My Addresses',
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList.separated(
              itemBuilder: (context, index) {
                final address = addressState.addresses[index];
                return AddressItem(address: address);
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
              ref.read(addressProvider.notifier).goSearchAddress();
            },
          ),
        ),
      ),
    );
  }
}

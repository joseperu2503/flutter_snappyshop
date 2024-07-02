import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/address/widgets/address_item.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/widgets/progress_indicator.dart';
import 'package:go_router/go_router.dart';

class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  AddressesScreenState createState() => AddressesScreenState();
}

class AddressesScreenState extends ConsumerState<AddressesScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(addressProvider.notifier).resetMyAddresses();
      ref.read(addressProvider.notifier).getMyAddresses();

      scrollController.addListener(() {
        if (scrollController.position.pixels + 400 >=
            scrollController.position.maxScrollExtent) {
          ref.read(addressProvider.notifier).getMyAddresses();
        }
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressProvider);
    return Layout1(
      loading: addressState.firstLoad,
      title: 'My Addresses',
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primaryPearlAqua,
          ),
          icon: const Icon(
            Icons.add,
            color: AppColors.white,
          ),
          onPressed: () {
            ref.read(addressProvider.notifier).resetForm();
            context.push('/search-address');
          },
        ),
      ),
      body: CustomScrollView(
        controller: scrollController,
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
    );
  }
}

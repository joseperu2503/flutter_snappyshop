import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/checkbox.dart';
import 'package:go_router/go_router.dart';

class AddressItem extends StatelessWidget {
  const AddressItem({
    super.key,
    required this.address,
  });

  final Address address;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryCultured,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.only(
            left: 16,
            top: 18,
            bottom: 18,
            right: 23,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: AppColors.white,
            elevation: 0,
            showDragHandle: true,
            context: context,
            builder: (context) {
              return _AddressBottomSheet(
                address: address,
              );
            },
          );
        },
        child: Column(
          children: [
            Row(
              children: [
                CustomCheckbox(
                  value: address.primary,
                  onChanged: (value) {},
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  address.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textYankeesBlue,
                    height: 2,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(
              height: 19,
            ),
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.white,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.phone_outlined,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  address.phone,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textArsenic,
                    height: 22 / 14,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(
              height: 11,
            ),
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.white,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.pin_drop,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  address.address,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textArsenic,
                    height: 22 / 14,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressBottomSheet extends ConsumerWidget {
  const _AddressBottomSheet({
    required this.address,
  });
  final Address address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.only(top: 0),
          width: double.infinity,
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: const Text(
                  'Save as primary address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textYankeesBlue,
                    height: 1,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
                contentPadding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 24,
                ),
                leading: const Icon(
                  Icons.check,
                  color: AppColors.textArsenic,
                ),
                onTap: () {
                  context.pop();
                  ref.read(addressProvider.notifier).markAsPrimary(address);
                },
              ),
              ListTile(
                title: const Text(
                  'View address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textYankeesBlue,
                    height: 1,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
                contentPadding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 24,
                ),
                leading: const Icon(
                  Icons.visibility,
                  color: AppColors.textArsenic,
                ),
                onTap: () {
                  context.pop();
                },
              ),
              ListTile(
                title: const Text(
                  'Delete address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.error,
                    height: 1,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
                contentPadding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 24,
                ),
                leading: const Icon(
                  Icons.delete,
                  color: AppColors.error,
                ),
                onTap: () {
                  context.pop();
                  ref.read(addressProvider.notifier).deleteAddress(address);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';

class AddressItem extends ConsumerWidget {
  const AddressItem({
    super.key,
    required this.address,
  });

  final Address address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return Container(
      decoration: BoxDecoration(
        color: darkMode
            ? AppColors.primaryCulturedDark
            : AppColors.primaryCultured,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.only(
            left: 16,
            top: 16,
            bottom: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          ref.read(addressProvider.notifier).selectAddress(address);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (address.primary)
              const Text(
                'Primary address',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryMangoTango,
                  height: 16 / 12,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Row(
              children: [
                Icon(
                  Icons.location_pin,
                  size: 14,
                  color: darkMode
                      ? AppColors.textCoolBlackDark
                      : AppColors.textCoolBlack,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  address.address,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: darkMode
                        ? AppColors.textYankeesBlueDark
                        : AppColors.textYankeesBlue,
                    height: 2,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Text(
              address.detail,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: darkMode
                    ? AppColors.textArsenicDark
                    : AppColors.textArsenic,
                height: 22 / 14,
                leadingDistribution: TextLeadingDistribution.even,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 19,
            ),
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: darkMode
                        ? AppColors.backgroundColorDark
                        : AppColors.backgroundColor,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.phone_outlined,
                      size: 14,
                      color:
                          darkMode ? AppColors.white : AppColors.textCoolBlack,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  address.phone,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: darkMode
                        ? AppColors.textArsenicDark
                        : AppColors.textArsenic,
                    height: 22 / 14,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: darkMode
                        ? AppColors.backgroundColorDark
                        : AppColors.backgroundColor,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 14,
                      color:
                          darkMode ? AppColors.white : AppColors.textCoolBlack,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  address.recipientName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: darkMode
                        ? AppColors.textArsenicDark
                        : AppColors.textArsenic,
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

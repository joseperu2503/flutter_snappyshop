import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/providers/address_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_svg/svg.dart';

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
          ref.read(addressProvider.notifier).viewAddress(address: address);
        },
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  'assets/icons/map_pin.svg',
                  colorFilter: ColorFilter.mode(
                    darkMode
                        ? AppColors.textCoolBlackDark
                        : AppColors.textCoolBlack,
                    BlendMode.srcIn,
                  ),
                  width: 18,
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          address.address,
                          style: TextStyle(
                            fontSize: 14,
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
                      ),
                      if (address.primary)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color:
                                AppColors.secondaryMangoTango.withOpacity(0.1),
                          ),
                          child: const Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryMangoTango,
                              height: 1.2,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  Text(
                    address.detail,
                    style: TextStyle(
                      fontSize: 12,
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
            ),
            const SizedBox(
              width: 12,
            ),
            SvgPicture.asset(
              'assets/icons/arrow_forward.svg',
              colorFilter: ColorFilter.mode(
                darkMode
                    ? AppColors.textCoolBlackDark
                    : AppColors.textCoolBlack,
                BlendMode.srcIn,
              ),
              width: 16,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}

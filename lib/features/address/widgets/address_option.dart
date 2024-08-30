import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_svg/svg.dart';

class AddressOption extends ConsumerWidget {
  const AddressOption({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onPressed,
  });

  final Address address;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return Container(
      height: 70,
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
        onPressed: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/icons/map_pin_outlined.svg',
              colorFilter: ColorFilter.mode(
                darkMode
                    ? AppColors.textYankeesBlueDark
                    : AppColors.textYankeesBlue,
                BlendMode.srcIn,
              ),
              width: 16,
              height: 16,
            ),
            const SizedBox(
              width: 8,
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
                            height: 1.2,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (address.adressDefault)
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
                              height: 1,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    '${address.country}, ${address.locality}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: darkMode
                          ? AppColors.textArsenicDark
                          : AppColors.textArsenic,
                      height: 16 / 12,
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
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: isSelected
                      ? AppColors.primaryPearlAqua
                      : darkMode
                          ? AppColors.textYankeesBlueDark
                          : AppColors.textYankeesBlue,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryPearlAqua
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

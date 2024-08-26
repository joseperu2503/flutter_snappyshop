import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/address/models/autocomplete_response.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';

class AddressResultItem extends ConsumerWidget {
  const AddressResultItem({
    super.key,
    this.onPressed,
    required this.addressResult,
  });

  final Function()? onPressed;
  final AddressResult addressResult;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return SizedBox(
      height: 80,
      child: TextButton(
        onPressed: onPressed,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: darkMode
                          ? AppColors.textCoolBlackDark
                          : AppColors.textCoolBlack,
                      height: 22 / 14,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  Text(
                    addressResult.structuredFormatting.secondaryText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: darkMode
                          ? AppColors.textArsenicDark
                          : AppColors.textArsenic,
                      height: 16 / 12,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

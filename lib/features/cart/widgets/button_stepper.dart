import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ButtonStepperType { productDetail, cart }

class ButtonStepper extends ConsumerWidget {
  const ButtonStepper({
    super.key,
    required this.value,
    required this.onAdd,
    required this.onRemove,
    required this.type,
  });

  final int value;
  final void Function() onAdd;
  final void Function() onRemove;
  final ButtonStepperType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return Container(
      width: 96,
      height: 36,
      decoration: BoxDecoration(
        color: darkMode
            ? AppColors.primaryCulturedDark
            : AppColors.primaryCultured,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: TextButton(
              onPressed:
                  (value == 1 && type == ButtonStepperType.productDetail) ||
                          value == 0
                      ? null
                      : () {
                          onRemove();
                        },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: SvgPicture.asset(
                value == 1 && type == ButtonStepperType.cart
                    ? 'assets/icons/delete.svg'
                    : 'assets/icons/minus.svg',
                height: 20,
                colorFilter: ColorFilter.mode(
                  value == 1 && type == ButtonStepperType.productDetail
                      ? darkMode
                          ? AppColors.textYankeesBlueDark.withOpacity(0.25)
                          : AppColors.textYankeesBlue.withOpacity(0.25)
                      : darkMode
                          ? AppColors.textYankeesBlueDark
                          : AppColors.textYankeesBlue,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkMode
                  ? AppColors.textYankeesBlueDark
                  : AppColors.textYankeesBlue,
              height: 22 / 14,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: TextButton(
              onPressed: () {
                onAdd();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: SvgPicture.asset(
                'assets/icons/plus.svg',
                height: 20,
                colorFilter: ColorFilter.mode(
                  darkMode
                      ? AppColors.textYankeesBlueDark
                      : AppColors.textYankeesBlue,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

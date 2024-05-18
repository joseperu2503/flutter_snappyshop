import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';

class ButtonStepper extends ConsumerWidget {
  const ButtonStepper({
    super.key,
    required this.value,
    required this.onAdd,
    required this.onRemove,
  });

  final int value;
  final void Function() onAdd;
  final void Function() onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return Container(
      width: 110,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: darkMode
            ? AppColors.backgroundColorDark
            : AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                onRemove();
              },
              child: const Text(
                '-',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryMangoTango,
                  height: 1,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            ),
          ),
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
          Expanded(
            child: GestureDetector(
              onTap: () {
                onAdd();
              },
              child: const Text(
                '+',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryMangoTango,
                  height: 1,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

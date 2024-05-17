import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';

class TextFieldContainer extends ConsumerWidget {
  const TextFieldContainer({
    super.key,
    required this.child,
    this.errorMessage,
    this.height = 52,
  });
  final Widget child;
  final String? errorMessage;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: darkMode
                ? AppColors.backgroundColorDark2
                : AppColors.primaryCultured,
            borderRadius: BorderRadius.circular(10),
          ),
          height: height,
          child: child,
        ),
        if (errorMessage != null)
          Container(
            padding: const EdgeInsets.only(top: 6, left: 6),
            child: Text(
              '$errorMessage',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: AppColors.error,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
          ),
      ],
    );
  }
}

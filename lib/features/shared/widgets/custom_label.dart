import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';

class CustomLabel extends ConsumerWidget {
  const CustomLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: darkMode ? AppColors.textArsenicDark : AppColors.textArsenic,
          height: 22 / 14,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      ),
    );
  }
}

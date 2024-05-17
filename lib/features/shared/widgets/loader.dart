import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/progress_indicator.dart';

class Loader extends ConsumerWidget {
  const Loader({
    super.key,
    required this.loading,
    required this.child,
  });

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);
    return PopScope(
      canPop: !loading,
      child: Stack(
        children: [
          child,
          if (loading)
            Scaffold(
              backgroundColor:
                  darkMode ? AppColors.backgroundColorDark : AppColors.white,
              body: const Center(
                child: CustomProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

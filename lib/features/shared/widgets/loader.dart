import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/widgets/progress_indicator.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
    required this.loading,
    required this.child,
  });

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !loading,
      child: Stack(
        children: [
          child,
          if (loading)
            const Scaffold(
              backgroundColor: AppColors.white,
              body: Center(
                child: CustomProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

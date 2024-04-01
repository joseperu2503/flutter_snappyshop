import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';

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
            Scaffold(
              backgroundColor: AppColors.textArsenic.withOpacity(0.4),
              body: const Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

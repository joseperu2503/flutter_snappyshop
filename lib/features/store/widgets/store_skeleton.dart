import 'dart:math';
import 'package:animated_shimmer/animated_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';

class StoreSkeleton extends StatelessWidget {
  const StoreSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: AnimatedShimmer(
            width: 40.0 + Random().nextInt(80),
            height: 32,
            borderRadius: BorderRadius.circular(8),
            startColor: AppColors.primaryCultured,
            endColor: AppColors.primaryCultured.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

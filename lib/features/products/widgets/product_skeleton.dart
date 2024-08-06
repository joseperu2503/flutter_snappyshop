import 'dart:math';

import 'package:animated_shimmer/animated_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: AnimatedShimmer(
            height: double.infinity,
            width: double.infinity,
            borderRadius: BorderRadius.circular(12),
            startColor: AppColors.primaryCultured,
            endColor: AppColors.primaryCultured.withOpacity(0.5),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
          ),
          height: productItemInfoHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: AnimatedShimmer(
                  height: 12,
                  width: 80.0 + Random().nextInt(41),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: AnimatedShimmer(
                  height: 12,
                  width: 80.0,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

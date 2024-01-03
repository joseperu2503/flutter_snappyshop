import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';

class BrandFilter extends StatelessWidget {
  const BrandFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.textCoolBlack.withOpacity(0.3),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      child: Text(
        'All brands',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textCoolBlack.withOpacity(0.7),
          height: 1.1,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      ),
    );
  }
}

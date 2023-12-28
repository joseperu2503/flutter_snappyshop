import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';

class ButtonStepper extends StatelessWidget {
  const ButtonStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          GestureDetector(
            child: const Text(
              '-',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: AppColors.secondaryMangoTango,
                height: 1,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            '1',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textYankeesBlue,
              height: 22 / 12,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
          const Spacer(),
          GestureDetector(
            child: const Text(
              '+',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: AppColors.secondaryMangoTango,
                height: 1,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

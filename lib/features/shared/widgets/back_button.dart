import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryCultured,
      ),
      child: TextButton(
        onPressed: () {
          context.pop();
        },
        child: SvgPicture.asset(
          'assets/icons/arrow-back.svg',
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}

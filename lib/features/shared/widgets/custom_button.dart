import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    required this.child,
    this.width = double.infinity,
    this.height = 52,
  });

  final void Function()? onPressed;
  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.primaryPearlAqua,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: child,
      ),
    );
  }
}

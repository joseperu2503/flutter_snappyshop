import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    required this.child,
    this.width = double.infinity,
    this.height = 52,
    this.disabled = false,
  });

  final void Function()? onPressed;
  final Widget child;
  final double width;
  final double height;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: disabled
            ? AppColors.textArsenic.withOpacity(0.2)
            : AppColors.primaryPearlAqua,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: Colors.white60,
        ),
        onPressed: disabled
            ? null
            : () {
                if (onPressed != null) {
                  onPressed!();
                }
              },
        child: child,
      ),
    );
  }
}

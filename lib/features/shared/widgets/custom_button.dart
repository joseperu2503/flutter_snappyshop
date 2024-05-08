import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    this.text,
    this.width = double.infinity,
    this.height = 52,
    this.disabled = false,
    this.iconLeft,
  });

  final void Function()? onPressed;
  final String? text;
  final double width;
  final double height;
  final bool disabled;
  final Widget? iconLeft;

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconLeft != null) iconLeft!,
            if (text != null && iconLeft != null)
              const SizedBox(
                width: 10,
              ),
            if (text != null)
              Text(
                text!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textCultured,
                  height: 22 / 16,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              )
          ],
        ),
      ),
    );
  }
}

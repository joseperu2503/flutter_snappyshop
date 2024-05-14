import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';

enum ButtonType { primary, delete, text, outlined }

enum ButtonColor { primary, secondary, terti, outlined }

List<ButtonTypeStyle> buttonTypes = [
  ButtonTypeStyle(
    buttonType: ButtonType.primary,
    color: AppColors.primaryPearlAqua,
    colorDisabled: AppColors.textArsenic.withOpacity(0.2),
    textColor: AppColors.textCultured,
    textColorDisabled: AppColors.textCultured,
    foregroundColor: Colors.white60,
    borderColor: Colors.transparent,
  ),
  ButtonTypeStyle(
    buttonType: ButtonType.outlined,
    color: Colors.transparent,
    colorDisabled: AppColors.textArsenic.withOpacity(0.2),
    textColor: AppColors.primaryPearlAqua,
    textColorDisabled: AppColors.textCultured,
    foregroundColor: AppColors.primaryPearlAqua,
    borderColor: AppColors.primaryPearlAqua,
  ),
  ButtonTypeStyle(
    buttonType: ButtonType.text,
    color: AppColors.textCultured.withOpacity(0.6),
    colorDisabled: AppColors.textArsenic.withOpacity(0.2),
    textColor: AppColors.secondaryPastelRed,
    textColorDisabled: AppColors.primaryPearlAqua,
    foregroundColor: AppColors.textArsenic,
    borderColor: Colors.transparent,
  ),
  ButtonTypeStyle(
    buttonType: ButtonType.delete,
    color: Colors.transparent,
    colorDisabled: AppColors.textArsenic.withOpacity(0.2),
    textColor: AppColors.error,
    textColorDisabled: AppColors.error,
    foregroundColor: AppColors.error,
    borderColor: Colors.transparent,
  ),
];

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    this.text,
    this.width = double.infinity,
    this.height = 52,
    this.disabled = false,
    this.iconLeft,
    this.type = ButtonType.primary,
  });

  final void Function()? onPressed;
  final String? text;
  final double width;
  final double height;
  final bool disabled;
  final Widget? iconLeft;
  final ButtonType type;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = buttonTypes.firstWhere((b) => b.buttonType == type);

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: disabled ? buttonStyle.colorDisabled : buttonStyle.color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: buttonStyle.borderColor,
          )),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: buttonStyle.foregroundColor,
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: disabled
                      ? buttonStyle.textColorDisabled
                      : buttonStyle.textColor,
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

class ButtonTypeStyle {
  final ButtonType buttonType;
  final Color color;
  final Color colorDisabled;
  final Color textColor;
  final Color textColorDisabled;
  final Color foregroundColor;
  final Color borderColor;

  ButtonTypeStyle({
    required this.buttonType,
    required this.color,
    required this.colorDisabled,
    required this.textColor,
    required this.textColorDisabled,
    required this.foregroundColor,
    required this.borderColor,
  });
}

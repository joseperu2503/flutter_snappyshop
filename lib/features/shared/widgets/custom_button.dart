import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';

enum ButtonType { primary, delete, text, outlined }

enum ButtonColor { primary, secondary, terti, outlined }

List<ButtonTypeStyle> buttonTypes = [
  ButtonTypeStyle(
    buttonType: ButtonType.primary,
    color: AppColors.primaryPearlAqua,
    textColorDisabled: AppColors.textArsenicDark,
    foregroundColor: Colors.white60,
    borderColor: Colors.transparent,
    gradient: const LinearGradient(
      colors: [Color(0xff905bd2), Color(0xff8034da)],
      stops: [0, 1],
      begin: Alignment(-0.9, -0.5),
      end: Alignment(0.3, 1.0),
    ),
    colorDisabled: AppColors.textArsenicDark.withOpacity(0.5),
    textColor: AppColors.textCultured,
    colorDisabledDark: AppColors.textArsenic.withOpacity(0.5),
    textColorDisabledDark: AppColors.textArsenic,
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

class CustomButton extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle = buttonTypes.firstWhere((b) => b.buttonType == type);
    final darkMode = ref.watch(darkModeProvider);

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: disabled
            ? darkMode
                ? buttonStyle.colorDisabledDark
                : buttonStyle.colorDisabled
            : darkMode
                ? buttonStyle.colorDark
                : buttonStyle.color,
        borderRadius: BorderRadius.circular(radiusButton),
        border: Border.all(
          color: buttonStyle.borderColor,
        ),
        gradient:
            disabled ? buttonStyle.gradientDisabled : buttonStyle.gradient,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
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
                      ? darkMode
                          ? buttonStyle.textColorDisabledDark
                          : buttonStyle.textColorDisabled
                      : darkMode
                          ? buttonStyle.textColorDark
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
  final Color colorDark;
  final Color colorDisabled;
  final Color colorDisabledDark;
  final Color textColor;
  final Color textColorDark;
  final Color textColorDisabled;
  final Color textColorDisabledDark;
  final Color foregroundColor;
  final Color borderColor;
  final Gradient? gradient;
  final Gradient? gradientDisabled;

  ButtonTypeStyle({
    required this.buttonType,
    required this.color,
    required this.colorDisabled,
    required this.textColor,
    required this.textColorDisabled,
    required this.foregroundColor,
    required this.borderColor,
    this.gradient,
    this.gradientDisabled,
    Color? colorDark,
    Color? colorDisabledDark,
    Color? textColorDark,
    Color? textColorDisabledDark,
  })  : colorDark = colorDark ?? color,
        colorDisabledDark = colorDisabledDark ?? colorDisabled,
        textColorDark = textColorDark ?? textColor,
        textColorDisabledDark = textColorDisabledDark ?? textColorDisabled;
}

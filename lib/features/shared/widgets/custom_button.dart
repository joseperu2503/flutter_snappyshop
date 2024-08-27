import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';

enum ButtonType { primary, secondary, text }

List<ButtonTypeStyle> buttonTypes = [
  ButtonTypeStyle(
    buttonType: ButtonType.primary,
    color: AppColors.primaryPearlAqua,
    textColorDisabled: AppColors.textArsenicDark,
    foregroundColor: Colors.white60,
    borderColor: Colors.transparent,
    gradient: primaryGradient,
    colorDisabled: AppColors.textArsenicDark.withOpacity(0.5),
    textColor: AppColors.textCultured,
    colorDisabledDark: AppColors.textArsenic.withOpacity(0.5),
    textColorDisabledDark: AppColors.textArsenic,
  ),
  ButtonTypeStyle(
    buttonType: ButtonType.secondary,
    color: AppColors.textYankeesBlue,
    colorDark: AppColors.textYankeesBlueDark,
    textColorDisabled: AppColors.textArsenicDark,
    foregroundColor: Colors.white60,
    borderColor: Colors.transparent,
    gradient: null,
    colorDisabled: AppColors.textArsenicDark.withOpacity(0.5),
    textColor: AppColors.textYankeesBlueDark,
    textColorDark: AppColors.textYankeesBlue,
    colorDisabledDark: AppColors.textArsenic.withOpacity(0.5),
    textColorDisabledDark: AppColors.textArsenic,
  ),
  ButtonTypeStyle(
    buttonType: ButtonType.text,
    color: Colors.transparent,
    colorDisabled: AppColors.textArsenic.withOpacity(0.2),
    textColor: AppColors.secondaryPastelRed,
    textColorDisabled: AppColors.primaryPearlAqua,
    borderColor: Colors.transparent,
  ),
];

class CustomButton extends ConsumerWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    this.text,
    this.width = double.infinity,
    this.disabled = false,
    this.iconLeft,
    this.type = ButtonType.primary,
  });

  final void Function()? onPressed;
  final String? text;
  final double width;
  final bool disabled;
  final Widget? iconLeft;
  final ButtonType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle = buttonTypes.firstWhere((b) => b.buttonType == type);
    final darkMode = ref.watch(darkModeProvider);

    return Container(
      height: buttonHeight,
      width: width,
      decoration: BoxDecoration(
        color: disabled
            ? darkMode
                ? buttonStyle.colorDisabledDark
                : buttonStyle.colorDisabled
            : darkMode
                ? buttonStyle.colorDark
                : buttonStyle.color,
        borderRadius: BorderRadius.circular(buttonBorderRadius),
        border: Border.all(
          color: buttonStyle.borderColor,
        ),
        gradient:
            disabled ? buttonStyle.gradientDisabled : buttonStyle.gradient,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
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
  final Color? foregroundColor;
  final Color borderColor;
  final Gradient? gradient;
  final Gradient? gradientDisabled;

  ButtonTypeStyle({
    required this.buttonType,
    required this.color,
    required this.colorDisabled,
    required this.textColor,
    required this.textColorDisabled,
    this.foregroundColor,
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

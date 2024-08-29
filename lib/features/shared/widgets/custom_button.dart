import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';

enum ButtonType { primary, secondary, text, outlined }

class CustomButton extends ConsumerStatefulWidget {
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
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends ConsumerState<CustomButton> {
  List<ButtonTypeStyle> get buttonTypes {
    return [
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
        buttonType: ButtonType.outlined,
        color: Colors.transparent,
        foregroundColor: AppColors.textArsenicDark,
        borderColor: AppColors.textArsenicDark,
        borderColorDark: AppColors.textArsenic,
        colorDisabled: AppColors.textArsenicDark.withOpacity(0.5),
        textColor: AppColors.textArsenic,
        textColorDark: AppColors.textArsenicDark,
        textColorDisabled: AppColors.textArsenicDark,
        textColorDisabledDark: AppColors.textArsenic,
        colorDisabledDark: AppColors.textArsenic.withOpacity(0.5),
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
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle =
        buttonTypes.firstWhere((b) => b.buttonType == widget.type);
    final darkMode = ref.watch(darkModeProvider);

    return Container(
      height: buttonHeight,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.disabled
            ? darkMode
                ? buttonStyle.colorDisabledDark
                : buttonStyle.colorDisabled
            : darkMode
                ? buttonStyle.colorDark
                : buttonStyle.color,
        borderRadius: BorderRadius.circular(buttonBorderRadius),
        border: Border.all(
          color:
              darkMode ? buttonStyle.borderColorDark : buttonStyle.borderColor,
        ),
        gradient: widget.disabled
            ? buttonStyle.gradientDisabled
            : buttonStyle.gradient,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          ),
          foregroundColor: buttonStyle.foregroundColor,
        ),
        onPressed: widget.disabled
            ? null
            : () {
                if (widget.onPressed != null) {
                  widget.onPressed!();
                }
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.iconLeft != null) widget.iconLeft!,
            if (widget.text != null && widget.iconLeft != null)
              const SizedBox(
                width: 10,
              ),
            if (widget.text != null)
              Text(
                widget.text!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: widget.disabled
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
  final Color borderColorDark;
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
    Color? borderColorDark,
  })  : colorDark = colorDark ?? color,
        colorDisabledDark = colorDisabledDark ?? colorDisabled,
        textColorDark = textColorDark ?? textColor,
        textColorDisabledDark = textColorDisabledDark ?? textColorDisabled,
        borderColorDark = borderColorDark ?? borderColor;
}

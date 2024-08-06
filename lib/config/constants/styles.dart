import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';

const double formInputSpacing = 28;
const double labelInputSpacing = 4;
const double toolbarHeight = 58;

const double radiusButton = 32;

const LinearGradient primaryGradient = LinearGradient(
  colors: [Color(0xff905bd2), Color(0xff8034da)],
  stops: [0, 1],
  begin: Alignment(-0.9, -0.5),
  end: Alignment(0.3, 1.0),
);

const double horizontalPaddingMobile = 24;
const double horizontalPaddinAppBargMobile = 24;

TextStyle subtitle(bool darkMode) {
  return TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: darkMode ? AppColors.textYankeesBlueDark : AppColors.textYankeesBlue,
    height: 1.1,
    leadingDistribution: TextLeadingDistribution.even,
  );
}

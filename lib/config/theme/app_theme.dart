import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';

class AppTheme {
  static ThemeData getTheme(bool darkMode) => ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor:
            darkMode ? AppColors.backgroundColorDark : AppColors.white,
        useMaterial3: true,
        bottomSheetTheme: const BottomSheetThemeData(
          modalBackgroundColor: Colors.white,
          showDragHandle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      );
}

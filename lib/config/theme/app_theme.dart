import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';

class AppTheme {
  static ThemeData getTheme(bool darkMode) => ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: darkMode
            ? AppColors.backgroundColorDark
            : AppColors.backgroundColor,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.black12,
          backgroundColor: Colors.white,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          modalBackgroundColor: Colors.white,
          showDragHandle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textArsenic,
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.primaryPearlAqua,
        ),
      );
}

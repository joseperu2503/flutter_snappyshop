import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        bottomSheetTheme: const BottomSheetThemeData(
          modalBackgroundColor: Colors.white,
          showDragHandle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      );
}

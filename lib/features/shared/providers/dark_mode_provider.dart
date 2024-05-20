import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/services/dark_mode_service.dart';

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  return DarkModeNotifier(ref);
});

class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier(this.ref) : super(true);
  final StateNotifierProviderRef ref;

  getDarkMode() async {
    final darkMode = await DarkModeService.getDarkMode();
    changeDarkMode(darkMode: darkMode);
  }

  changeDarkMode({bool? darkMode}) async {
    state = darkMode ?? !state;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            state ? AppColors.backgroundColorDark : AppColors.backgroundColor,
      ),
    );
    await DarkModeService.setDarkMode(state);
  }
}

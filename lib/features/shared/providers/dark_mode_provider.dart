import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/services/dark_mode_service.dart';

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  return DarkModeNotifier(ref);
});

class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier(this.ref) : super(true);
  final StateNotifierProviderRef ref;

  getThemeState() async {
    final darkMode = await DarkModeService.getDarkMode();
    changeDarkMode(darkMode: darkMode);
  }

  changeDarkMode({bool? darkMode}) async {
    state = darkMode ?? !state;
    await DarkModeService.setDarkMode(state);
  }
}

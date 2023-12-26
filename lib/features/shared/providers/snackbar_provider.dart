import 'package:flutter_riverpod/flutter_riverpod.dart';

final snackbarProvider =
    StateNotifierProvider<SnackbarNotifier, SnackbarState>((ref) {
  return SnackbarNotifier();
});

class SnackbarNotifier extends StateNotifier<SnackbarState> {
  SnackbarNotifier() : super(SnackbarState());

  showSnackbar(String message) {
    state = state.copyWith(showSnackbar: true, message: message);
    state = state.copyWith(showSnackbar: false);
  }
}

class SnackbarState {
  final bool showSnackbar;
  final String message;

  SnackbarState({
    this.showSnackbar = false,
    this.message = '',
  });

  SnackbarState copyWith({
    bool? showSnackbar,
    String? message,
  }) =>
      SnackbarState(
        showSnackbar: showSnackbar ?? this.showSnackbar,
        message: message ?? this.message,
      );
}

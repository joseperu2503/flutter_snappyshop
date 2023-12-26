import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loaderProvider =
    StateNotifierProvider<LoaderNotifier, LoaderState>((ref) {
  return LoaderNotifier();
});

class LoaderNotifier extends StateNotifier<LoaderState> {
  LoaderNotifier() : super(LoaderState());

  showLoader() {
    if (state.loading) return;
    FocusManager.instance.primaryFocus?.unfocus();

    state = state.copyWith(
      loading: true,
    );
  }

  dismissLoader() {
    if (!state.loading) return;

    state = state.copyWith(
      loading: false,
    );
  }
}

class LoaderState {
  final bool loading;

  LoaderState({
    this.loading = false,
  });

  LoaderState copyWith({
    bool? loading,
  }) =>
      LoaderState(
        loading: loading ?? this.loading,
      );
}

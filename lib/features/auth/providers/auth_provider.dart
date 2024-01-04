import 'package:flutter/material.dart';
import 'package:flutter_eshop/features/auth/models/auth_user.dart';
import 'package:flutter_eshop/features/auth/services/auth_service.dart';
import 'package:flutter_eshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_eshop/features/shared/models/service_exception.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.ref) : super(AuthState());
  final StateNotifierProviderRef ref;

  Future<void> getUser() async {
    try {
      final AuthUser user = await AuthService.getUser();

      setuser(user);
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }
  }

  setuser(AuthUser user) {
    state = state.copyWith(
      user: () => user,
    );
  }
}

class AuthState {
  final AuthUser? user;

  AuthState({
    this.user,
  });

  AuthState copyWith({
    ValueGetter<AuthUser?>? user,
  }) =>
      AuthState(
        user: user != null ? user() : this.user,
      );
}

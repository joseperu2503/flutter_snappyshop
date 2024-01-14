import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/shared/inputs/email.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>((ref) {
  return ForgotPasswordNotifier(ref);
});

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordNotifier(this.ref) : super(ForgotPasswordState());
  final StateNotifierProviderRef ref;

  initData() {
    state = state.copyWith(
      email: const Email.pure('joseperu2503@gmail.com'),
    );
  }

  getCode() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final email = Email.dirty(state.email.value);
    state = state.copyWith(
      email: email,
    );
    if (!Formz.validate([email])) return;

    state = state.copyWith(
      loading: true,
    );

    appRouter.push('/verify-code');

    state = state.copyWith(
      loading: false,
    );
  }

  verifyCode() async {
    FocusManager.instance.primaryFocus?.unfocus();

    //TODO: validar el codigo de verificacion

    state = state.copyWith(
      loading: true,
    );

    appRouter.push('/change-password');

    state = state.copyWith(
      loading: false,
    );
  }

  changeEmail(Email email) {
    state = state.copyWith(
      email: email,
    );
  }
}

class ForgotPasswordState {
  final Email email;

  final bool loading;

  ForgotPasswordState({
    this.email = const Email.pure(''),
    this.loading = false,
  });

  ForgotPasswordState copyWith({
    Email? email,
    bool? loading,
  }) =>
      ForgotPasswordState(
        email: email ?? this.email,
        loading: loading ?? this.loading,
      );
}

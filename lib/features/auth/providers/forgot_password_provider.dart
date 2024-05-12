import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/auth/services/change_password_external_service.dart';
import 'package:flutter_snappyshop/features/shared/inputs/email.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/inputs/password.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/timer_provider.dart';
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
      email: const Email.pure(''),
      confirmPassword: const Password.pure(''),
      loading: false,
      password: const Password.pure(''),
      uuid: '',
      verifyCode: '',
      expirationDate: () => null,
    );
  }

  sendVerifyCode({bool withPushRoute = true}) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final email = Email.dirty(state.email.value);
    state = state.copyWith(
      email: email,
    );
    if (!Formz.validate([email])) return;

    state = state.copyWith(
      loading: true,
    );

    try {
      final response = await ChangePasswordExternalService.sendVerifyCode(
        email: state.email.value,
      );

      state = state.copyWith(
        uuid: response.data.uuid,
        expirationDate: () => response.data.expirationDate,
        verifyCode: '',
      );

      ref.read(timerProvider.notifier).initDateTimer(
            date: state.expirationDate,
          );
      if (withPushRoute) {
        appRouter.push('/verify-code');
      }
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    state = state.copyWith(
      loading: false,
    );
  }

  validateVerifyCode() async {
    FocusManager.instance.primaryFocus?.unfocus();

    ref.read(timerProvider.notifier).cancelTimer();

    state = state.copyWith(
      loading: true,
    );

    try {
      await ChangePasswordExternalService.validateVerifyCode(
        email: state.email.value,
        code: state.verifyCode,
        uuid: state.uuid,
      );

      appRouter.pushReplacement('/change-password-external');
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    state = state.copyWith(
      loading: false,
    );
  }

  submitChangePassword() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final password = Password.dirty(state.password.value);
    final confirmPassword = Password.dirty(state.confirmPassword.value);

    state = state.copyWith(
      password: password,
      confirmPassword: confirmPassword,
    );
    if (!Formz.validate([password, confirmPassword])) return;

    state = state.copyWith(
      loading: true,
    );

    try {
      final response = await ChangePasswordExternalService.changePassword(
        email: state.email.value,
        code: state.verifyCode,
        uuid: state.uuid,
        password: state.password.value,
        confirmPassword: state.confirmPassword.value,
      );

      ref.read(snackbarProvider.notifier).showSnackbar(response.message);

      appRouter.go('/');
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    state = state.copyWith(
      loading: false,
    );
  }

  changeEmail(Email email) {
    state = state.copyWith(
      email: email,
    );
  }

  changeVerifyCode(String verifyCode) {
    state = state.copyWith(
      verifyCode: verifyCode,
    );
  }

  changePassword(Password password) {
    state = state.copyWith(
      password: password,
    );
  }

  changeConfirmPassword(Password confirmPassword) {
    state = state.copyWith(
      confirmPassword: confirmPassword,
    );
  }
}

class ForgotPasswordState {
  final Email email;
  final bool loading;
  final String verifyCode;
  final String uuid;
  final Password password;
  final Password confirmPassword;
  final DateTime? expirationDate;

  ForgotPasswordState({
    this.email = const Email.pure(''),
    this.loading = false,
    this.verifyCode = '',
    this.uuid = '',
    this.password = const Password.pure(''),
    this.confirmPassword = const Password.pure(''),
    this.expirationDate,
  });

  ForgotPasswordState copyWith({
    Email? email,
    bool? loading,
    String? verifyCode,
    String? uuid,
    Password? password,
    Password? confirmPassword,
    ValueGetter<DateTime?>? expirationDate,
  }) =>
      ForgotPasswordState(
        email: email ?? this.email,
        loading: loading ?? this.loading,
        verifyCode: verifyCode ?? this.verifyCode,
        uuid: uuid ?? this.uuid,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        expirationDate:
            expirationDate != null ? expirationDate() : this.expirationDate,
      );
}

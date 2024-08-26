import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/auth/services/reset_password_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/plugins/formx/formx.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/timer_provider.dart';

final resetPasswordProvider =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>((ref) {
  return ResetPasswordNotifier(ref);
});

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  ResetPasswordNotifier(this.ref) : super(ResetPasswordState());
  final StateNotifierProviderRef ref;

  initData() {
    state = state.copyWith(
      email: FormxInput<String>(
        value: '',
        validators: [Validators.required<String>(), Validators.email()],
      ),
      password: FormxInput(
        value: '',
        validators: [Validators.required()],
      ),
      confirmPassword: FormxInput(
        value: '',
        validators: [Validators.required()],
      ),
      loading: false,
      uuid: '',
      verifyCode: '',
      expirationDate: () => null,
    );
  }

  sendCode({bool withPushRoute = true}) async {
    FocusManager.instance.primaryFocus?.unfocus();

    state = state.copyWith(
      email: state.email.touch(),
    );
    if (!Formx.validate([state.email])) return;

    state = state.copyWith(
      loading: true,
    );

    try {
      final response = await ResetPasswordService.sendCode(
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

  validateCode() async {
    FocusManager.instance.primaryFocus?.unfocus();

    ref.read(timerProvider.notifier).cancelTimer();

    state = state.copyWith(
      loading: true,
    );

    try {
      await ResetPasswordService.validateCode(
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

  resetPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (state.password.value != state.confirmPassword.value) {
      ref.read(snackbarProvider.notifier).showSnackbar(
          'The passwords do not match. Please make sure to enter the same password in both fields.');
      return;
    }

    state = state.copyWith(
      password: state.password.touch(),
      confirmPassword: state.confirmPassword.touch(),
    );
    if (!Formx.validate([state.password, state.confirmPassword])) return;

    state = state.copyWith(
      loading: true,
    );

    try {
      final response = await ResetPasswordService.resetPassword(
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

  changeEmail(FormxInput<String> email) {
    state = state.copyWith(
      email: email,
    );
  }

  changeVerifyCode(String verifyCode) {
    state = state.copyWith(
      verifyCode: verifyCode,
    );
  }

  changePassword(FormxInput<String> password) {
    state = state.copyWith(
      password: password,
    );
  }

  changeConfirmPassword(FormxInput<String> confirmPassword) {
    state = state.copyWith(
      confirmPassword: confirmPassword,
    );
  }
}

class ResetPasswordState {
  final FormxInput<String> email;
  final FormxInput<String> password;
  final FormxInput<String> confirmPassword;
  final bool loading;
  final String verifyCode;
  final String uuid;

  final DateTime? expirationDate;

  ResetPasswordState({
    this.email = const FormxInput(value: ''),
    this.password = const FormxInput(value: ''),
    this.confirmPassword = const FormxInput(value: ''),
    this.loading = false,
    this.verifyCode = '',
    this.uuid = '',
    this.expirationDate,
  });

  ResetPasswordState copyWith({
    FormxInput<String>? email,
    bool? loading,
    String? verifyCode,
    String? uuid,
    FormxInput<String>? password,
    FormxInput<String>? confirmPassword,
    ValueGetter<DateTime?>? expirationDate,
  }) =>
      ResetPasswordState(
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

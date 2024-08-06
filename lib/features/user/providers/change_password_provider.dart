import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/plugins/formx/formx.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/user/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final changePasswordProvider =
    StateNotifierProvider<ChangePasswordNotifier, ChangePasswordState>((ref) {
  return ChangePasswordNotifier(ref);
});

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  ChangePasswordNotifier(this.ref) : super(ChangePasswordState());
  final StateNotifierProviderRef ref;

  initData() {
    state = state.copyWith(
      loading: LoadingStatus.none,
      password: FormxInput(
        value: '',
        validators: [Validators.required()],
      ),
      confirmPassword: FormxInput(
        value: '',
        validators: [Validators.required()],
      ),
    );
  }

  submit() async {
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
      loading: LoadingStatus.loading,
    );

    try {
      final response = await UserService.changePasswordInternal(
        password: state.password.value,
        confirmPassword: state.confirmPassword.value,
      );
      state = state.copyWith(
        loading: LoadingStatus.success,
      );
      ref.read(snackbarProvider.notifier).showSnackbar(response.message);

      appRouter.go('/dashboard');
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      state = state.copyWith(
        loading: LoadingStatus.error,
      );
    }
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

class ChangePasswordState {
  final FormxInput<String> password;
  final FormxInput<String> confirmPassword;
  final LoadingStatus loading;

  ChangePasswordState({
    this.password = const FormxInput(value: ''),
    this.confirmPassword = const FormxInput(value: ''),
    this.loading = LoadingStatus.none,
  });

  ChangePasswordState copyWith({
    FormxInput<String>? password,
    FormxInput<String>? confirmPassword,
    LoadingStatus? loading,
  }) =>
      ChangePasswordState(
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        loading: loading ?? this.loading,
      );
}

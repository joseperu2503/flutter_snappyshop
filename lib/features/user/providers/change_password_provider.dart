import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/shared/inputs/password.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/user/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final changePasswordProvider =
    StateNotifierProvider<ChangePasswordNotifier, ChangePasswordState>((ref) {
  return ChangePasswordNotifier(ref);
});

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  ChangePasswordNotifier(this.ref) : super(ChangePasswordState());
  final StateNotifierProviderRef ref;

  initData() {
    state = state.copyWith(
      password: const Password.pure(''),
      confirmPassword: const Password.pure(''),
    );
  }

  submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final password = Password.dirty(state.password.value);
    final confirmPassword = Password.dirty(state.confirmPassword.value);

    if (password.value != confirmPassword.value) {
      ref.read(snackbarProvider.notifier).showSnackbar(
          'The passwords do not match. Please make sure to enter the same password in both fields.');
      return;
    }
    state = state.copyWith(
      password: password,
      confirmPassword: confirmPassword,
    );
    if (!Formz.validate([password, confirmPassword])) return;

    state = state.copyWith(
      loading: true,
    );

    try {
      final response = await UserService.changePasswordInternal(
        password: state.password.value,
        confirmPassword: state.confirmPassword.value,
      );

      ref.read(snackbarProvider.notifier).showSnackbar(response.message);

      appRouter.go('/products');
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    state = state.copyWith(
      loading: false,
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

class ChangePasswordState {
  final Password password;
  final Password confirmPassword;
  final bool loading;

  ChangePasswordState({
    this.password = const Password.pure(''),
    this.confirmPassword = const Password.pure(''),
    this.loading = false,
  });

  ChangePasswordState copyWith({
    Password? password,
    Password? confirmPassword,
    bool? loading,
  }) =>
      ChangePasswordState(
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        loading: loading ?? this.loading,
      );
}

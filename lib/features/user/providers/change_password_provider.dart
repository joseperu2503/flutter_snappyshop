import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/shared/inputs/password.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/loader_provider.dart';
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

    state = state.copyWith(
      password: password,
      confirmPassword: confirmPassword,
    );
    if (!Formz.validate([password, confirmPassword])) return;

    ref.read(loaderProvider.notifier).showLoader();

    try {
      final response = await UserService.changePassword(
          password: state.password.value,
          confirmPassword: state.confirmPassword.value);

      ref.read(snackbarProvider.notifier).showSnackbar(response.message);

      appRouter.go('/products');
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    ref.read(loaderProvider.notifier).dismissLoader();
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

  ChangePasswordState({
    this.password = const Password.pure(''),
    this.confirmPassword = const Password.pure(''),
  });

  ChangePasswordState copyWith({
    Password? password,
    Password? confirmPassword,
  }) =>
      ChangePasswordState(
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
      );
}

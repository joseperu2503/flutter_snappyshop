import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/auth/services/auth_service.dart';
import 'package:flutter_snappyshop/features/shared/inputs/email.dart';
import 'package:flutter_snappyshop/features/shared/inputs/name.dart';
import 'package:flutter_snappyshop/features/shared/inputs/password.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/shared/services/key_value_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final registerProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier(ref);
});

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier(this.ref) : super(RegisterState());
  final StateNotifierProviderRef ref;
  final keyValueStorageService = KeyValueStorageService();

  initData() {
    state = state.copyWith(
      name: const Name.pure(''),
      email: const Email.pure(''),
      password: const Password.pure(''),
      confirmPassword: const Password.pure(''),
    );
  }

  register() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final name = Name.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = Password.dirty(state.confirmPassword.value);

    state = state.copyWith(
      email: email,
      password: password,
      name: name,
      confirmPassword: confirmPassword,
    );
    if (!Formz.validate([email, password, name, confirmPassword])) return;

    state = state.copyWith(
      loading: true,
    );
    try {
      await AuthService.register(
        name: state.name.value,
        email: state.email.value,
        password: state.password.value,
        confirmPassword: state.confirmPassword.value,
      );

      appRouter.go('/');
      ref
          .read(snackbarProvider.notifier)
          .showSnackbar('User registered successfully');
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    state = state.copyWith(
      loading: false,
    );
  }

  changeName(Name name) {
    state = state.copyWith(
      name: name,
    );
  }

  changeEmail(Email email) {
    state = state.copyWith(
      email: email,
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

class RegisterState {
  final Name name;
  final Email email;
  final Password password;
  final Password confirmPassword;
  final bool loading;

  RegisterState({
    this.name = const Name.pure(''),
    this.email = const Email.pure(''),
    this.password = const Password.pure(''),
    this.confirmPassword = const Password.pure(''),
    this.loading = false,
  });

  RegisterState copyWith({
    Name? name,
    Email? email,
    Password? password,
    Password? confirmPassword,
    bool? loading,
  }) =>
      RegisterState(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        loading: loading ?? this.loading,
      );
}

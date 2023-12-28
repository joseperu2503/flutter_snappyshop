import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/router/app_router.dart';
import 'package:flutter_eshop/features/auth/services/auth_service.dart';
import 'package:flutter_eshop/features/shared/inputs/email.dart';
import 'package:flutter_eshop/features/shared/inputs/name.dart';
import 'package:flutter_eshop/features/shared/inputs/password.dart';
import 'package:flutter_eshop/features/shared/models/service_exception.dart';
import 'package:flutter_eshop/features/shared/providers/loader_provider.dart';
import 'package:flutter_eshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_eshop/features/shared/services/key_value_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final registerProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier(ref);
});

class RegisterNotifier extends StateNotifier<RegisterState> {
  // final GoRouter router = appRouter;

  RegisterNotifier(this.ref) : super(RegisterState());
  final StateNotifierProviderRef ref;
  final keyValueStorageService = KeyValueStorageService();

  register() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final name = Name.dirty(state.email.value);
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

    ref.read(loaderProvider.notifier).showLoader();

    try {
      await AuthService.register(
        name: state.name.value,
        email: state.email.value,
        password: state.password.value,
        confirmPassword: state.confirmPassword.value,
      );

      ref.read(goRouterProvider).go('/');
      ref
          .read(snackbarProvider.notifier)
          .showSnackbar('User registered successfully');
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    ref.read(loaderProvider.notifier).dismissLoader();
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

  RegisterState({
    this.name = const Name.pure(''),
    this.email = const Email.pure(''),
    this.password = const Password.pure(''),
    this.confirmPassword = const Password.pure(''),
  });

  RegisterState copyWith({
    Name? name,
    Email? email,
    Password? password,
    Password? confirmPassword,
  }) =>
      RegisterState(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
      );
}

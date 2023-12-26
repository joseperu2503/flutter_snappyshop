import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/router/app_router.dart';
import 'package:flutter_eshop/features/auth/models/login_response.dart';
import 'package:flutter_eshop/features/auth/services/login_service.dart';
import 'package:flutter_eshop/features/shared/inputs/email.dart';
import 'package:flutter_eshop/features/shared/inputs/password.dart';
import 'package:flutter_eshop/features/shared/models/service_exception.dart';
import 'package:flutter_eshop/features/shared/providers/loader_provider.dart';
import 'package:flutter_eshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_eshop/features/shared/services/key_value_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref);
});

class LoginNotifier extends StateNotifier<LoginState> {
  final GoRouter router = appRouter;

  LoginNotifier(this.ref) : super(LoginState());
  final StateNotifierProviderRef ref;
  final keyValueStorageService = KeyValueStorageService();

  login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
      email: email,
      password: password,
    );
    if (!Formz.validate([email, password])) return;

    ref.read(loaderProvider.notifier).showLoader();

    try {
      final LoginResponse loginResponse = await LoginService.login(
        email: state.email.value,
        password: state.password.value,
      );

      await keyValueStorageService.setKeyValue<String>(
          'token', loginResponse.accessToken);

      print('login correcto');
      appRouter.go('/inicio-sesion/portafolio');
    } on ServiceException catch (e) {
      print(e.message);
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    ref.read(loaderProvider.notifier).dismissLoader();
  }

  goRecuperarContrasena() {
    //TODO
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
}

class LoginState {
  final Email email;
  final Password password;

  LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  LoginState copyWith({
    Email? email,
    Password? password,
  }) =>
      LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
      );
}

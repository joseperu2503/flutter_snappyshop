import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/auth/models/login_response.dart';
import 'package:flutter_snappyshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_snappyshop/features/auth/services/auth_service.dart';
import 'package:flutter_snappyshop/features/shared/inputs/email.dart';
import 'package:flutter_snappyshop/features/shared/inputs/password.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/settings/providers/notification_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/shared/services/key_value_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref);
});

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this.ref) : super(LoginState());
  final StateNotifierProviderRef ref;
  final keyValueStorageService = KeyValueStorageService();

  initData() {
    state = state.copyWith(
        email: const Email.pure('joseperu2503@gmail.com'),
        password: const Password.pure('12345678'));
  }

  login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
      email: email,
      password: password,
    );
    if (!Formz.validate([email, password])) return;

    state = state.copyWith(
      loading: true,
    );

    try {
      final LoginResponse loginResponse = await AuthService.login(
        email: state.email.value,
        password: state.password.value,
      );

      await keyValueStorageService.setKeyValue<String>(
          'token', loginResponse.accessToken);

      //cada vez que inicia sesion habilita las notificaciones
      ref.read(notificationProvider.notifier).enableNotifications();
      ref.read(authProvider.notifier).initAutoLogout();

      appRouter.go('/products');
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

  changePassword(Password password) {
    state = state.copyWith(
      password: password,
    );
  }
}

class LoginState {
  final Email email;
  final Password password;
  final bool loading;

  LoginState({
    this.email = const Email.pure(''),
    this.password = const Password.pure(''),
    this.loading = false,
  });

  LoginState copyWith({
    Email? email,
    Password? password,
    bool? loading,
  }) =>
      LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        loading: loading ?? this.loading,
      );
}

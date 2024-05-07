import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/storage_keys.dart';
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
import 'package:flutter_snappyshop/config/constants/environment.dart';
import 'package:google_sign_in/google_sign_in.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref);
});

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this.ref) : super(LoginState());
  final StateNotifierProviderRef ref;
  final keyValueStorageService = KeyValueStorageService();

  initData() async {
    final email =
        await keyValueStorageService.getKeyValue<String>(StorageKeys.email) ??
            '';
    final rememberMe = await keyValueStorageService
            .getKeyValue<bool>(StorageKeys.rememberMe) ??
        false;

    state = state.copyWith(
      email: rememberMe ? Email.pure(email) : const Email.pure(''),
      password: const Password.pure(''),
      rememberMe: rememberMe,
    );
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
          StorageKeys.token, loginResponse.accessToken);

      setRemember();
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

  loginGoogle() async {
    FocusManager.instance.primaryFocus?.unfocus();

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      clientId: Platform.isIOS
          ? Environment.googleClientIdOAuthIos
          : Environment.googleClientIdOAuthAndroid,
      serverClientId: Environment.googleClientIdOAuthServer,
    ).signIn();

    if (googleUser == null) {
      return;
    }

    state = state.copyWith(
      loading: true,
    );

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final String? idToken = googleAuth.idToken;

    if (idToken == null) {
      ref.read(snackbarProvider.notifier).showSnackbar('no idToken');
      state = state.copyWith(
        loading: false,
      );
      return;
    }

    try {
      final LoginResponse loginResponse = await AuthService.loginGoogle(
        idToken: idToken,
      );

      await keyValueStorageService.setKeyValue<String>(
          StorageKeys.token, loginResponse.accessToken);

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

  setRemember() async {
    if (state.rememberMe) {
      await keyValueStorageService.setKeyValue<String>(
          StorageKeys.email, state.email.value);
    }
    await keyValueStorageService.setKeyValue<bool>(
        StorageKeys.rememberMe, state.rememberMe);
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

  toggleRememberMe() {
    state = state.copyWith(
      rememberMe: !state.rememberMe,
    );
  }
}

class LoginState {
  final Email email;
  final Password password;
  final bool loading;
  final bool rememberMe;

  LoginState({
    this.email = const Email.pure(''),
    this.password = const Password.pure(''),
    this.loading = false,
    this.rememberMe = false,
  });

  LoginState copyWith({
    Email? email,
    Password? password,
    bool? loading,
    bool? rememberMe,
  }) =>
      LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        loading: loading ?? this.loading,
        rememberMe: rememberMe ?? this.rememberMe,
      );
}

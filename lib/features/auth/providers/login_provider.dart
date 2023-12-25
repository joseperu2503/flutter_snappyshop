import 'package:flutter_eshop/config/router/app_router.dart';
import 'package:flutter_eshop/features/auth/models/login_response.dart';
import 'package:flutter_eshop/features/auth/services/login_service.dart';
import 'package:flutter_eshop/features/shared/inputs/email.dart';
import 'package:flutter_eshop/features/shared/inputs/password.dart';
import 'package:flutter_eshop/features/shared/models/service_exception.dart';
import 'package:flutter_eshop/features/shared/services/key_value_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref);
});

class LoginNotifier extends StateNotifier<LoginState> {
  final GoRouter router = appRouter;

  LoginNotifier(this.ref) : super(LoginState());
  final StateNotifierProviderRef ref;
  final keyValueStorageService = KeyValueStorageService();

  iniciarSesion() async {
    //TODO: MOSTRAR LOADER

    try {
      final LoginResponse loginResponse = await LoginService.iniciarSesion(
        email: state.email.value,
        password: state.password.value,
      );

      await keyValueStorageService.setKeyValue<String>(
          'token', loginResponse.accessToken);

      appRouter.go('/inicio-sesion/portafolio');
    } on ServiceException catch (e) {
      //TODO:MOSTRAR ALGUN SNACKBAR SI EL LOGIN FALLA
    }

    //TODO: OCULTAR LOADER
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

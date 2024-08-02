import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/auth/services/auth_service.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/plugins/formx/formx.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier(ref);
});

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier(this.ref) : super(RegisterState());
  final StateNotifierProviderRef ref;

  initData() {
    state = state.copyWith(
      name: FormxInput(
        value: '',
        validators: [Validators.required()],
      ),
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
    );
  }

  register() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (state.password.value != state.confirmPassword.value) {
      ref.read(snackbarProvider.notifier).showSnackbar(
          'The passwords do not match. Please make sure to enter the same password in both fields.');
      return;
    }

    state = state.copyWith(
      email: state.email.touch(),
      password: state.password.touch(),
      name: state.name.touch(),
      confirmPassword: state.confirmPassword.touch(),
    );
    if (!Formx.validate(
        [state.email, state.password, state.name, state.confirmPassword])) {
      return;
    }

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

  changeName(FormxInput<String> name) {
    state = state.copyWith(
      name: name,
    );
  }

  changeEmail(FormxInput<String> email) {
    state = state.copyWith(
      email: email,
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

class RegisterState {
  final FormxInput<String> name;
  final FormxInput<String> email;
  final FormxInput<String> password;
  final FormxInput<String> confirmPassword;
  final bool loading;

  RegisterState({
    this.name = const FormxInput(value: ''),
    this.email = const FormxInput(value: ''),
    this.password = const FormxInput(value: ''),
    this.confirmPassword = const FormxInput(value: ''),
    this.loading = false,
  });

  RegisterState copyWith({
    FormxInput<String>? name,
    FormxInput<String>? email,
    FormxInput<String>? password,
    FormxInput<String>? confirmPassword,
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

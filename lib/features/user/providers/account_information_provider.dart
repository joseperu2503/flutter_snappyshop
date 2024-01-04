import 'package:flutter/material.dart';
import 'package:flutter_eshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_eshop/features/shared/inputs/email.dart';
import 'package:flutter_eshop/features/shared/inputs/name.dart';
import 'package:flutter_eshop/features/shared/models/service_exception.dart';
import 'package:flutter_eshop/features/shared/providers/loader_provider.dart';
import 'package:flutter_eshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_eshop/features/user/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final accountInformationProvider =
    StateNotifierProvider<AccountInformationNotifier, AccountInformationState>(
        (ref) {
  return AccountInformationNotifier(ref);
});

class AccountInformationNotifier
    extends StateNotifier<AccountInformationState> {
  AccountInformationNotifier(this.ref) : super(AccountInformationState());
  final StateNotifierProviderRef ref;

  initData() async {
    state = state.copyWith(
      name: Name.pure(ref.read(authProvider).user?.name ?? ''),
      email: Email.pure(ref.read(authProvider).user?.email ?? ''),
      showButton: false,
    );
  }

  submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final name = Name.dirty(state.name.value);
    final email = Email.dirty(state.email.value);

    state = state.copyWith(
      email: email,
      name: name,
    );
    if (!Formz.validate([email, name])) return;

    ref.read(loaderProvider.notifier).showLoader();

    try {
      final response = await UserService.changePersonalData(
        email: state.email.value,
        name: state.name.value,
        userId: ref.read(authProvider).user?.id,
      );
      ref.read(authProvider.notifier).setuser(response.data);
      initData();
      ref.read(snackbarProvider.notifier).showSnackbar(response.message);
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    ref.read(loaderProvider.notifier).dismissLoader();
  }

  changeName(Name name) {
    state = state.copyWith(
      name: name,
      showButton: true,
    );
  }

  changeEmail(Email email) {
    state = state.copyWith(
      email: email,
      showButton: true,
    );
  }
}

class AccountInformationState {
  final Name name;
  final Email email;
  final bool showButton;

  AccountInformationState({
    this.name = const Name.pure(''),
    this.email = const Email.pure(''),
    this.showButton = false,
  });

  AccountInformationState copyWith({
    Name? name,
    Email? email,
    bool? showButton,
  }) =>
      AccountInformationState(
        name: name ?? this.name,
        email: email ?? this.email,
        showButton: showButton ?? this.showButton,
      );
}

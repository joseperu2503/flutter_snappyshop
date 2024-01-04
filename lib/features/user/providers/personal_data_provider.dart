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

final personalDataProvider =
    StateNotifierProvider<PersonalDataNotifier, PersonalDataState>((ref) {
  return PersonalDataNotifier(ref);
});

class PersonalDataNotifier extends StateNotifier<PersonalDataState> {
  PersonalDataNotifier(this.ref) : super(PersonalDataState());
  final StateNotifierProviderRef ref;

  initData() async {
    ref.read(loaderProvider.notifier).showLoader();
    try {
      await ref.read(authProvider.notifier).getUser();
      state = state.copyWith(
        name: Name.pure(ref.read(authProvider).user?.name ?? ''),
        email: Email.pure(ref.read(authProvider).user?.email ?? ''),
      );
      ref.read(loaderProvider.notifier).dismissLoader();
    } on ServiceException catch (e) {
      ref.read(loaderProvider.notifier).dismissLoader();
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
      throw ServiceException(e.message);
    }
  }

  submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final name = Name.dirty(state.email.value);
    final email = Email.dirty(state.email.value);

    state = state.copyWith(
      email: email,
      name: name,
    );
    if (!Formz.validate([email, name])) return;

    ref.read(loaderProvider.notifier).showLoader();

    try {
      await UserService.changePersonalData(
        email: state.email.value,
        name: state.name.value,
        userId: ref.read(authProvider).user?.id,
      );

      await initData();
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
}

class PersonalDataState {
  final Name name;
  final Email email;

  PersonalDataState({
    this.name = const Name.pure(''),
    this.email = const Email.pure(''),
  });

  PersonalDataState copyWith({
    Name? name,
    Email? email,
  }) =>
      PersonalDataState(
        name: name ?? this.name,
        email: email ?? this.email,
      );
}

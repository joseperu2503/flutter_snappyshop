import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_snappyshop/features/shared/inputs/email.dart';
import 'package:flutter_snappyshop/features/shared/inputs/name.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/providers/loader_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/user/services/camera_service.dart';
import 'package:flutter_snappyshop/features/user/services/user_service.dart';
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
      image: () => ref.read(authProvider).user?.profilePhoto,
      temporalImage: () => null,
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
      if (state.temporalImage != null) {
        //cuando sube nueva foto asi haya tenido o no foto antes
        final response = await CameraService.uploadPhoto(
          path: state.temporalImage!,
        );
        state = state.copyWith(
          image: () => response.image.fullUrlImage,
        );
      }

      if (state.image == null && state.temporalImage == null) {
        //cuando eliminó foto de perfil
        state = state.copyWith(
          image: () => null,
        );
      }

      final response = await UserService.changePersonalData(
        email: state.email.value,
        name: state.name.value,
        userId: ref.read(authProvider).user?.id,
        photo: state.image,
      );
      ref.read(authProvider.notifier).setuser(response.data);
      ref.read(snackbarProvider.notifier).showSnackbar(response.message);
    } on ServiceException catch (e) {
      ref.read(snackbarProvider.notifier).showSnackbar(e.message);
    }

    initData();
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

  takePhoto() async {
    final String? image = await CameraService().takePhoto();
    state = state.copyWith(
      temporalImage: () => image,
      image: () => null,
      showButton: true,
    );
  }

  selectPhoto() async {
    final String? image = await CameraService().selectPhoto();
    state = state.copyWith(
      temporalImage: () => image,
      image: () => null,
      showButton: true,
    );
  }

  deletePhoto() {
    if (state.image == null && state.temporalImage == null) return;
    state = state.copyWith(
      temporalImage: () => null,
      image: () => null,
      showButton: true,
    );
  }
}

class AccountInformationState {
  final Name name;
  final Email email;
  final String? image;
  final String? temporalImage;
  final bool showButton;

  AccountInformationState({
    this.name = const Name.pure(''),
    this.email = const Email.pure(''),
    this.image,
    this.temporalImage,
    this.showButton = false,
  });

  AccountInformationState copyWith({
    Name? name,
    Email? email,
    bool? showButton,
    ValueGetter<String?>? image,
    ValueGetter<String?>? temporalImage,
  }) =>
      AccountInformationState(
        name: name ?? this.name,
        email: email ?? this.email,
        showButton: showButton ?? this.showButton,
        image: image != null ? image() : this.image,
        temporalImage:
            temporalImage != null ? temporalImage() : this.temporalImage,
      );
}

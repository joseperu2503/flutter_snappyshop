import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_snappyshop/features/shared/plugins/formx/formx.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/user/services/camera_service.dart';
import 'package:flutter_snappyshop/features/user/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      name: FormxInput<String>(
        value: ref.read(authProvider).user?.name ?? '',
        validators: [Validators.required<String>()],
      ),
      email: FormxInput<String>(
        value: ref.read(authProvider).user?.email ?? '',
        validators: [Validators.required<String>(), Validators.email()],
      ),
      image: () => ref.read(authProvider).user?.profilePhoto,
      temporalImage: () => null,
      showButton: false,
    );
  }

  submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    state = state.copyWith(
      email: state.email.touch(),
      name: state.name.touch(),
    );
    if (!Formx.validate([state.email, state.name])) return;

    state = state.copyWith(
      loading: true,
    );
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
    state = state.copyWith(
      loading: false,
    );
  }

  changeName(FormxInput<String> name) {
    state = state.copyWith(
      name: name,
      showButton: true,
    );
  }

  changeEmail(FormxInput<String> email) {
    state = state.copyWith(
      email: email,
      showButton: true,
    );
  }

  takePhoto() async {
    final String? image = await CameraService().takePhoto();
    if (image == null) return;
    state = state.copyWith(
      temporalImage: () => image,
      image: () => null,
      showButton: true,
    );
  }

  selectPhoto() async {
    final String? image = await CameraService().selectPhoto();
    if (image == null) return;
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
  final FormxInput<String> name;
  final FormxInput<String> email;
  final String? image;
  final String? temporalImage;
  final bool showButton;
  final bool loading;

  AccountInformationState({
    this.name = const FormxInput(value: ''),
    this.email = const FormxInput(value: ''),
    this.image,
    this.temporalImage,
    this.showButton = false,
    this.loading = false,
  });

  AccountInformationState copyWith({
    FormxInput<String>? name,
    FormxInput<String>? email,
    bool? showButton,
    ValueGetter<String?>? image,
    ValueGetter<String?>? temporalImage,
    bool? loading,
  }) =>
      AccountInformationState(
        name: name ?? this.name,
        email: email ?? this.email,
        showButton: showButton ?? this.showButton,
        image: image != null ? image() : this.image,
        temporalImage:
            temporalImage != null ? temporalImage() : this.temporalImage,
        loading: loading ?? this.loading,
      );
}

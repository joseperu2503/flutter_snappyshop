import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/auth/widgets/input_email.dart';
import 'package:flutter_snappyshop/features/auth/widgets/input_name.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_label.dart';
import 'package:flutter_snappyshop/features/shared/widgets/image_viewer.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';
import 'package:flutter_snappyshop/features/user/providers/account_information_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AccountInformationScreen extends ConsumerStatefulWidget {
  const AccountInformationScreen({super.key});

  @override
  AccountInformationScreenState createState() =>
      AccountInformationScreenState();
}

class AccountInformationScreenState
    extends ConsumerState<AccountInformationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(accountInformationProvider.notifier).initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountInformationProvider);
    final darkMode = ref.watch(darkModeProvider);

    return Loader(
      loading: accountState.loading,
      child: Layout1(
        title: 'Account Information',
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 4,
                  right: 24,
                  left: 24,
                  bottom: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          showModalBottomSheet(
                            backgroundColor: darkMode
                                ? AppColors.backgroundColorDark
                                : AppColors.backgroundColor,
                            elevation: 0,
                            showDragHandle: false,
                            context: context,
                            builder: (context) {
                              return const _PhotoBottomSheet();
                            },
                          );
                        },
                        child: accountState.temporalImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: Image(
                                  width: 180,
                                  height: 180,
                                  image: FileImage(
                                    File(accountState.temporalImage!),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : accountState.image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: SizedBox(
                                      width: 180,
                                      height: 180,
                                      child: ImageViewer(
                                        images: [accountState.image!],
                                        radius: 90,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 180,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: darkMode
                                          ? AppColors.primaryCulturedDark
                                          : AppColors.primaryCultured,
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/profile.svg',
                                        colorFilter: ColorFilter.mode(
                                          darkMode
                                              ? AppColors.textArsenicDark
                                                  .withOpacity(0.5)
                                              : AppColors.textArsenic
                                                  .withOpacity(0.5),
                                          BlendMode.srcIn,
                                        ),
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const CustomLabel(
                      'Name',
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    InputName(
                      value: accountState.name,
                      onChanged: (value) {
                        ref
                            .read(accountInformationProvider.notifier)
                            .changeName(value);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const CustomLabel(
                      'Email',
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    InputEmail(
                      value: accountState.email,
                      onChanged: (value) {
                        ref
                            .read(accountInformationProvider.notifier)
                            .changeEmail(value);
                      },
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    FadeIn(
                      animate: accountState.showButton,
                      duration: const Duration(milliseconds: 150),
                      child: CustomButton(
                        onPressed: () {
                          ref
                              .read(accountInformationProvider.notifier)
                              .submit();
                        },
                        text: 'Save Changes',
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PhotoBottomSheet extends ConsumerWidget {
  const _PhotoBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 24, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'Update profile photo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: darkMode
                            ? AppColors.textYankeesBlueDark
                            : AppColors.textYankeesBlue,
                        height: 1,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(Icons.close),
                    color: darkMode
                        ? AppColors.textYankeesBlueDark
                        : AppColors.textYankeesBlue,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListTile(
              title: Text(
                'Take photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: darkMode
                      ? AppColors.textArsenicDark
                      : AppColors.textArsenic,
                  height: 1,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
              contentPadding: const EdgeInsetsDirectional.symmetric(
                horizontal: 24,
              ),
              leading: SvgPicture.asset(
                'assets/icons/camera.svg',
                colorFilter: ColorFilter.mode(
                  darkMode ? AppColors.textArsenicDark : AppColors.textArsenic,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
              onTap: () {
                context.pop();
                ref.read(accountInformationProvider.notifier).takePhoto();
              },
            ),
            ListTile(
              title: Text(
                'Choose from gallery',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: darkMode
                      ? AppColors.textArsenicDark
                      : AppColors.textArsenic,
                  height: 1,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
              contentPadding: const EdgeInsetsDirectional.symmetric(
                horizontal: 24,
              ),
              leading: SvgPicture.asset(
                'assets/icons/gallery.svg',
                colorFilter: ColorFilter.mode(
                  darkMode ? AppColors.textArsenicDark : AppColors.textArsenic,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
              onTap: () {
                context.pop();
                ref.read(accountInformationProvider.notifier).selectPhoto();
              },
            ),
            ListTile(
              title: const Text(
                'Delete photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.error,
                  height: 1,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
              contentPadding: const EdgeInsetsDirectional.symmetric(
                horizontal: 24,
              ),
              leading: SvgPicture.asset(
                'assets/icons/delete.svg',
                colorFilter: ColorFilter.mode(
                  darkMode ? AppColors.error : AppColors.error,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
              onTap: () {
                context.pop();
                ref.read(accountInformationProvider.notifier).deletePhoto();
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/auth/widgets/input_email.dart';
import 'package:flutter_snappyshop/features/auth/widgets/input_name.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/widgets/image_viewer.dart';
import 'package:flutter_snappyshop/features/user/providers/account_information_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
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

    return Layout1(
      title: 'Account Information',
      child: CustomScrollView(
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
                          backgroundColor: AppColors.white,
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
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryCultured,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: AppColors.textArsenic,
                                    size: 60,
                                  ),
                                ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textYankeesBlue,
                      height: 22 / 14,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
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
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textYankeesBlue,
                      height: 22 / 14,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
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
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPearlAqua,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          ref
                              .read(accountInformationProvider.notifier)
                              .submit();
                        },
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textCultured,
                            height: 22 / 16,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PhotoBottomSheet extends ConsumerWidget {
  const _PhotoBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
                  child: const Text(
                    'Update profile photo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textYankeesBlue,
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
                  color: AppColors.textYankeesBlue,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ListTile(
            title: const Text(
              'Take photo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textYankeesBlue,
                height: 1,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            contentPadding: const EdgeInsetsDirectional.symmetric(
              horizontal: 24,
            ),
            leading: const Icon(
              Icons.camera_alt_rounded,
              color: AppColors.textArsenic,
            ),
            onTap: () {
              context.pop();
              ref.read(accountInformationProvider.notifier).takePhoto();
            },
          ),
          ListTile(
            title: const Text(
              'Choose from gallery',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textYankeesBlue,
                height: 1,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            contentPadding: const EdgeInsetsDirectional.symmetric(
              horizontal: 24,
            ),
            leading: const Icon(
              Icons.add_photo_alternate_rounded,
              color: AppColors.textArsenic,
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
            leading: const Icon(
              Icons.delete,
              color: AppColors.error,
            ),
            onTap: () {
              context.pop();
              ref.read(accountInformationProvider.notifier).deletePhoto();
            },
          )
        ],
      ),
    );
  }
}

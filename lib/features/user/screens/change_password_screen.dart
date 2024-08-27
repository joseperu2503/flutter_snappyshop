import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_text_field.dart';
import 'package:flutter_snappyshop/features/user/providers/password_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(passwordProvider.notifier).initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final passwordState = ref.watch(passwordProvider);
    final darkMode = ref.watch(darkModeProvider);

    return Layout(
      loading: passwordState.loading == LoadingStatus.loading,
      title: 'Change password',
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
                    height: 16,
                  ),
                  Center(
                    child: Text(
                      'Please change your old password, \n and put new password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: darkMode
                            ? AppColors.textArsenicDark
                            : AppColors.textArsenic,
                        height: 1.5,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomTextField(
                    label: 'New password',
                    hintText: 'Password',
                    value: passwordState.password,
                    onChanged: (value) {
                      ref.read(passwordProvider.notifier).changePassword(value);
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: formInputSpacing,
                  ),
                  CustomTextField(
                    label: 'Confirm new Password',
                    hintText: 'Password',
                    value: passwordState.confirmPassword,
                    onChanged: (value) {
                      ref
                          .read(passwordProvider.notifier)
                          .changeConfirmPassword(value);
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    onFieldSubmitted: (value) {
                      ref.read(passwordProvider.notifier).submit();
                    },
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  CustomButton(
                    text: 'Change password',
                    onPressed: () {
                      ref.read(passwordProvider.notifier).submit();
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

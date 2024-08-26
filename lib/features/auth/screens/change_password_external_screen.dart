import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/auth/providers/forgot_password_provider.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_text_field.dart';

class ChangePasswordExternalScreen extends ConsumerStatefulWidget {
  const ChangePasswordExternalScreen({super.key});

  @override
  ChangePasswordExternalScreenState createState() =>
      ChangePasswordExternalScreenState();
}

class ChangePasswordExternalScreenState
    extends ConsumerState<ChangePasswordExternalScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPasswordProvider);
    final darkMode = ref.watch(darkModeProvider);

    return Layout(
      loading: forgotState.loading,
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
                  Center(
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: darkMode
                            ? AppColors.textYankeesBlueDark
                            : AppColors.textYankeesBlue,
                        height: 32 / 24,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ),
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
                    label: 'New Password',
                    hintText: 'Password',
                    value: forgotState.password,
                    onChanged: (value) {
                      ref
                          .read(forgotPasswordProvider.notifier)
                          .changePassword(value);
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
                    value: forgotState.confirmPassword,
                    onChanged: (value) {
                      ref
                          .read(forgotPasswordProvider.notifier)
                          .changeConfirmPassword(value);
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    onFieldSubmitted: (value) {
                      ref
                          .read(forgotPasswordProvider.notifier)
                          .submitChangePassword();
                    },
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  CustomButton(
                    onPressed: () {
                      ref
                          .read(forgotPasswordProvider.notifier)
                          .submitChangePassword();
                    },
                    text: 'Change password',
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

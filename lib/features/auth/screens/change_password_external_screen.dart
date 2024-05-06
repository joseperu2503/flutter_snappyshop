import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/auth/providers/forgot_password_provider.dart';
import 'package:flutter_snappyshop/features/auth/widgets/input_password.dart';
import 'package:flutter_snappyshop/features/shared/inputs/password.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    Future.microtask(() {
      ref
          .read(forgotPasswordProvider.notifier)
          .changePassword(const Password.pure(''));
      ref
          .read(forgotPasswordProvider.notifier)
          .changeConfirmPassword(const Password.pure(''));
    });
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPasswordProvider);

    return Layout1(
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
                  const Center(
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textYankeesBlue,
                        height: 32 / 24,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Center(
                    child: Text(
                      'Please change your old password, \n and put new password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textArsenic,
                        height: 1.5,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'New Password',
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
                  InputPassword(
                    value: forgotState.password,
                    onChanged: (value) {
                      ref
                          .read(forgotPasswordProvider.notifier)
                          .changePassword(value);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Confirm new password',
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
                  InputPassword(
                    value: forgotState.confirmPassword,
                    onChanged: (value) {
                      ref
                          .read(forgotPasswordProvider.notifier)
                          .changeConfirmPassword(value);
                    },
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Container(
                    height: 52,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPearlAqua,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        ref
                            .read(forgotPasswordProvider.notifier)
                            .submitChangePassword();
                      },
                      child: !forgotState.loading
                          ? const Text(
                              'Change password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textCultured,
                                height: 22 / 16,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            )
                          : const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.primaryCultured,
                                strokeWidth: 2,
                              ),
                            ),
                    ),
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

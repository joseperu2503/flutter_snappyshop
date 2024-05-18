import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/auth/widgets/input_password.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_label.dart';
import 'package:flutter_snappyshop/features/user/providers/change_password_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordInternalScreen extends ConsumerStatefulWidget {
  const ChangePasswordInternalScreen({super.key});

  @override
  ChangePasswordInternalScreenState createState() =>
      ChangePasswordInternalScreenState();
}

class ChangePasswordInternalScreenState
    extends ConsumerState<ChangePasswordInternalScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(changePasswordProvider.notifier).initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final passwordState = ref.watch(changePasswordProvider);
    final darkMode = ref.watch(darkModeProvider);

    return Layout1(
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
                  const CustomLabel('New Password'),
                  const SizedBox(
                    height: 4,
                  ),
                  InputPassword(
                    value: passwordState.password,
                    onChanged: (value) {
                      ref
                          .read(changePasswordProvider.notifier)
                          .changePassword(value);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const CustomLabel('Confirm new Password'),
                  const SizedBox(
                    height: 4,
                  ),
                  InputPassword(
                    value: passwordState.confirmPassword,
                    onChanged: (value) {
                      ref
                          .read(changePasswordProvider.notifier)
                          .changeConfirmPassword(value);
                    },
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  CustomButton(
                    text: 'Change password',
                    onPressed: () {
                      ref.read(changePasswordProvider.notifier).submit();
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

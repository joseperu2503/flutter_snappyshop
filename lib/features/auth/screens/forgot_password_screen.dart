import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/auth/providers/forgot_password_provider.dart';
import 'package:flutter_snappyshop/features/auth/widgets/input_email.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_label.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(forgotPasswordProvider.notifier).initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPasswordProvider);
    final darkMode = ref.watch(darkModeProvider);

    return Layout1(
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
                      'Forgot Password',
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
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Text(
                        'Please enter your email, we send an verify code',
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
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  const CustomLabel('Email'),
                  const SizedBox(
                    height: 4,
                  ),
                  InputEmail(
                    value: forgotState.email,
                    onChanged: (value) {
                      ref
                          .read(forgotPasswordProvider.notifier)
                          .changeEmail(value);
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomButton(
                    onPressed: () {
                      ref
                          .read(forgotPasswordProvider.notifier)
                          .sendVerifyCode();
                    },
                    text: 'Get code',
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

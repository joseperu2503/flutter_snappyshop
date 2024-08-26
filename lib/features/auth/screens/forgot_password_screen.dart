import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/auth/providers/reset_password_provider.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(resetPasswordProvider.notifier).initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final resetPasswordState = ref.watch(resetPasswordProvider);
    final darkMode = ref.watch(darkModeProvider);

    return Layout(
      loading: resetPasswordState.loading,
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
                  CustomTextField(
                    label: 'Email',
                    hintText: 'Your email',
                    value: resetPasswordState.email,
                    onChanged: (value) {
                      ref
                          .read(resetPasswordProvider.notifier)
                          .changeEmail(value);
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (value) {
                      ref.read(resetPasswordProvider.notifier).sendCode();
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomButton(
                    onPressed: () {
                      ref.read(resetPasswordProvider.notifier).sendCode();
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

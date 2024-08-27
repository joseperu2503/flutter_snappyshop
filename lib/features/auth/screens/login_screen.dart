import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/auth/providers/login_provider.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/checkbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_text_field.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';
import 'package:flutter_snappyshop/features/shared/widgets/social_button.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(loginProvider.notifier).initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final darkMode = ref.watch(darkModeProvider);

    return Loader(
      loading: loginState.loading,
      child: Layout(
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
                        'Log in',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: darkMode
                              ? AppColors.white
                              : AppColors.primaryPearlAqua,
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
                          'Please enter your data to continue',
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
                      value: loginState.email,
                      onChanged: (value) {
                        ref.read(loginProvider.notifier).changeEmail(value);
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: formInputSpacing,
                    ),
                    CustomTextField(
                      label: 'Password',
                      hintText: 'Password',
                      value: loginState.password,
                      onChanged: (value) {
                        ref.read(loginProvider.notifier).changePassword(value);
                      },
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                      onFieldSubmitted: (value) {
                        ref.read(loginProvider.notifier).login();
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomCheckbox(
                          value: loginState.rememberMe,
                          onChanged: (value) {
                            ref.read(loginProvider.notifier).toggleRememberMe();
                          },
                          label: 'Remember Me',
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push('/forgot-password');
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: darkMode
                                  ? AppColors.textArsenicDark
                                  : AppColors.textArsenic,
                              height: 22 / 14,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    CustomButton(
                      text: 'Log In',
                      onPressed: () {
                        ref.read(loginProvider.notifier).login();
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Or using other method',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: darkMode
                            ? AppColors.textArsenicDark
                            : AppColors.textArsenic,
                        height: 22 / 14,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SocialButton(
                      onPressed: () {
                        ref.read(loginProvider.notifier).loginGoogle();
                      },
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

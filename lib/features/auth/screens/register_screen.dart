import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/auth/providers/register_provider.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/checkbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends ConsumerState<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(registerProvider.notifier).initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerProvider);
    final darkMode = ref.watch(darkModeProvider);

    return Layout1(
      loading: registerState.loading,
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
                      'Register',
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
                    height: 60,
                  ),
                  CustomTextField(
                    label: 'Name',
                    hintText: 'Your name',
                    value: registerState.name,
                    onChanged: (value) {
                      ref.read(registerProvider.notifier).changeName(value);
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: formInputSpacing,
                  ),
                  CustomTextField(
                    label: 'Email',
                    hintText: 'Your email',
                    value: registerState.email,
                    onChanged: (value) {
                      ref.read(registerProvider.notifier).changeEmail(value);
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
                    value: registerState.password,
                    onChanged: (value) {
                      ref.read(registerProvider.notifier).changePassword(value);
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: formInputSpacing,
                  ),
                  CustomTextField(
                    label: 'Confirm new Password',
                    hintText: 'Password',
                    value: registerState.confirmPassword,
                    onChanged: (value) {
                      ref
                          .read(registerProvider.notifier)
                          .changeConfirmPassword(value);
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: formInputSpacing,
                  ),
                  CustomCheckbox(
                    value: true,
                    onChanged: (value) {},
                    label: 'I accepted Terms & Privacy Policy',
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  CustomButton(
                    text: 'Register',
                    onPressed: () {
                      ref.read(registerProvider.notifier).register();
                    },
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

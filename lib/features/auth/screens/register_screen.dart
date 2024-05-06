import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/auth/providers/register_provider.dart';
import 'package:flutter_snappyshop/features/auth/widgets/input_email.dart';
import 'package:flutter_snappyshop/features/auth/widgets/input_name.dart';
import 'package:flutter_snappyshop/features/auth/widgets/input_password.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_snappyshop/features/shared/widgets/checkbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends ConsumerState<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(registerProvider.notifier).initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerProvider);

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
                      'Register',
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
                    height: 60,
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
                    height: 8,
                  ),
                  InputName(
                    value: registerState.name,
                    onChanged: (value) {
                      ref.read(registerProvider.notifier).changeName(value);
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
                    value: registerState.email,
                    onChanged: (value) {
                      ref.read(registerProvider.notifier).changeEmail(value);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Password',
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
                    value: registerState.password,
                    onChanged: (value) {
                      ref.read(registerProvider.notifier).changePassword(value);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Confirm password',
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
                    value: registerState.confirmPassword,
                    onChanged: (value) {
                      ref
                          .read(registerProvider.notifier)
                          .changeConfirmPassword(value);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomCheckbox(
                    value: true,
                    onChanged: (value) {},
                    label: 'I accepted Terms & Privacy Policy',
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
                        ref.read(registerProvider.notifier).register();
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textCultured,
                          height: 22 / 16,
                          leadingDistribution: TextLeadingDistribution.even,
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

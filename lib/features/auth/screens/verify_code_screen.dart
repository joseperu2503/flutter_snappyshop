import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/auth/providers/forgot_password_provider.dart';
import 'package:flutter_snappyshop/features/auth/widgets/otp.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/timer_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';

class VerifyCodeScreen extends ConsumerStatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  VerifyCodeScreenState createState() => VerifyCodeScreenState();
}

class VerifyCodeScreenState extends ConsumerState<VerifyCodeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPasswordProvider);
    final timerState = ref.watch(timerProvider);
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
                      'Verify Code',
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
                      'Please enter verify code that we\'ve \n sent to your email',
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
                    height: 60,
                  ),
                  Otp(
                    onChanged: (value) {
                      ref
                          .read(forgotPasswordProvider.notifier)
                          .changeVerifyCode(value);
                    },
                    value: forgotState.verifyCode,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  if (timerState.timerOn)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: darkMode
                              ? AppColors.textArsenicDark
                              : AppColors.textArsenic,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          timerState.timerText,
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
                      ],
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    onPressed: () {
                      if (timerState.timerOn) {
                        ref
                            .read(forgotPasswordProvider.notifier)
                            .validateVerifyCode();
                      } else {
                        ref
                            .read(forgotPasswordProvider.notifier)
                            .sendVerifyCode(withPushRoute: false);
                      }
                    },
                    text: timerState.timerOn ? 'Verify' : 'Resend verify code',
                    disabled: timerState.timerOn &&
                        forgotState.verifyCode.length != 4,
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

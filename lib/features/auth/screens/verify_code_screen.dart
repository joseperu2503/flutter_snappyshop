import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/auth/providers/reset_password_provider.dart';
import 'package:flutter_snappyshop/features/auth/widgets/otp.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/timer_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final resetPasswordState = ref.watch(resetPasswordProvider);
    final timerState = ref.watch(timerProvider);
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
                          .read(resetPasswordProvider.notifier)
                          .changeVerifyCode(value);
                    },
                    value: resetPasswordState.verifyCode,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  if (timerState.timerOn)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/clock.svg',
                          colorFilter: ColorFilter.mode(
                            darkMode
                                ? AppColors.textArsenicDark
                                : AppColors.textArsenic,
                            BlendMode.srcIn,
                          ),
                          width: 16,
                          height: 16,
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
                        ref.read(resetPasswordProvider.notifier).validateCode();
                      } else {
                        ref
                            .read(resetPasswordProvider.notifier)
                            .sendCode(withPushRoute: false);
                      }
                    },
                    text: timerState.timerOn ? 'Verify' : 'Resend verify code',
                    disabled: timerState.timerOn &&
                        resetPasswordState.verifyCode.length != 4,
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

import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/auth/providers/forgot_password_provider.dart';
import 'package:flutter_snappyshop/features/auth/widgets/otp.dart';
import 'package:flutter_snappyshop/features/shared/layout/layout_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/shared/providers/timer_provider.dart';

class VerifyCodeScreen extends ConsumerStatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  VerifyCodeScreenState createState() => VerifyCodeScreenState();
}

class VerifyCodeScreenState extends ConsumerState<VerifyCodeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(forgotPasswordProvider.notifier).changeVerifyCode('');
    });
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPasswordProvider);
    final timerState = ref.watch(timerProvider);

    return Layout1(
      child: CustomScrollView(
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
                      'Verify Code',
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
                      'Please enter verify code that we\'ve \n sent to your email',
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
                        const Icon(
                          Icons.schedule_rounded,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          timerState.timerText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textArsenic,
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
                  Container(
                    height: 52,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPearlAqua,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
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
                      child: forgotState.loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.primaryCultured,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              timerState.timerOn
                                  ? 'Verify'
                                  : 'Resend verify code',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textCultured,
                                height: 22 / 16,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
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

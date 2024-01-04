import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/auth/widgets/input_email.dart';
import 'package:flutter_eshop/features/auth/widgets/input_name.dart';
import 'package:flutter_eshop/features/shared/layout/layout_1.dart';
import 'package:flutter_eshop/features/user/providers/account_information_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

class AccountInformationScreen extends ConsumerStatefulWidget {
  const AccountInformationScreen({super.key});

  @override
  AccountInformationScreenState createState() =>
      AccountInformationScreenState();
}

class AccountInformationScreenState
    extends ConsumerState<AccountInformationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(accountInformationProvider.notifier).initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountInformationProvider);

    return Layout1(
      title: 'Account Information',
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
                  const SizedBox(
                    height: 40,
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
                    height: 4,
                  ),
                  InputName(
                    value: accountState.name,
                    onChanged: (value) {
                      ref
                          .read(accountInformationProvider.notifier)
                          .changeName(value);
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
                    value: accountState.email,
                    onChanged: (value) {
                      ref
                          .read(accountInformationProvider.notifier)
                          .changeEmail(value);
                    },
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  FadeIn(
                    animate: accountState.showButton,
                    duration: const Duration(milliseconds: 150),
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPearlAqua,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          ref
                              .read(accountInformationProvider.notifier)
                              .submit();
                        },
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textCultured,
                            height: 22 / 16,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                      ),
                    ),
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

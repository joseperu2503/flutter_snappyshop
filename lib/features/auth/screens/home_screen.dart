import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/settings/providers/notification_provider.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    Future.microtask(() {
      ref.read(notificationProvider.notifier).disableNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 60,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Icon(
                      Icons.shopping_bag,
                      color: AppColors.primaryPearlAqua,
                      size: 88,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'SnappyShop',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textYankeesBlue,
                        height: 1.1,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'Explore the latest trends and discover \nexclusive deals all in one place',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textArsenic,
                        height: 1.3,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 64,
                    ),
                    CustomButton(
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textCultured,
                          height: 22 / 16,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      onPressed: () {
                        context.push('/register');
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          context.push('/login');
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 22 / 16,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                            children: [
                              TextSpan(
                                text: 'I already have an account? ',
                                style: TextStyle(color: AppColors.textArsenic),
                              ),
                              TextSpan(
                                text: 'Log in',
                                style:
                                    TextStyle(color: AppColors.primaryPearlAqua),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Powered by',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textCoolBlack,
                            height: 1.4,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/icons/joseperez-logo.svg',
                          width: 100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/shared/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            Container(
              constraints: const BoxConstraints(
                maxWidth: 300,
              ),
              child: const Text(
                'Explore the latest trends and discover exclusive deals all in one place',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textArsenic,
                  height: 1.3,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
                textAlign: TextAlign.center,
              ),
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
                        style: TextStyle(color: AppColors.primaryPearlAqua),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

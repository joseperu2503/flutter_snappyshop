import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class OrderConfirmedScreen extends StatelessWidget {
  const OrderConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            right: 24,
            left: 24,
            bottom: 56,
          ),
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(
                'assets/icons/order-confirmed.svg',
                width: 100,
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Order Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textYankeesBlue,
                  height: 32 / 24,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: 280,
                child: Text(
                  'Your order has been confirmed, we will send you confirmation email shortly.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textArsenic.withOpacity(0.7),
                    height: 22 / 14,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Continue Shopping',
                onPressed: () {
                  context.go('/');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

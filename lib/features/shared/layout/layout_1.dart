import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Layout1 extends StatelessWidget {
  const Layout1({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 58,
        title: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryCultured,
              ),
              child: TextButton(
                onPressed: () {},
                child: SvgPicture.asset(
                  'assets/icons/arrow-back.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            )
          ],
        ),
      ),
      body: child,
    );
  }
}

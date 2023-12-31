import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class Layout1 extends StatelessWidget {
  const Layout1({
    super.key,
    required this.child,
    this.bottomNavigationBar,
    this.title,
  });

  final Widget child;
  final Widget? bottomNavigationBar;
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      appBar: AppBar(
        toolbarHeight: 58,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        forceMaterialTransparency: true,
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
                onPressed: () {
                  context.pop();
                },
                child: SvgPicture.asset(
                  'assets/icons/arrow-back.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            const Spacer(),
            if (title != null)
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textYankeesBlue,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            const Spacer(),
            const SizedBox(
              width: 46,
              height: 46,
            )
          ],
        ),
      ),
      body: child,
    );
  }
}

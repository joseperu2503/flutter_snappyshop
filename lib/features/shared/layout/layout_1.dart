import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/app_colors.dart';
import 'package:flutter_eshop/features/shared/widgets/back_button.dart';

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
        titleSpacing: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const CustomBackButton(),
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
      ),
      body: child,
    );
  }
}

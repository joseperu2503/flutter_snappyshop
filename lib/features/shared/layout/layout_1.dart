import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/config/constants/styles.dart';
import 'package:flutter_snappyshop/features/shared/widgets/back_button.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';

class Layout1 extends StatelessWidget {
  const Layout1({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.title,
    this.bottomSheet,
    this.loading = false,
  });

  final Widget body;
  final Widget? bottomNavigationBar;
  final String? title;
  final Widget? floatingActionButton;
  final Widget? bottomSheet;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Loader(
      loading: loading,
      child: Scaffold(
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
        floatingActionButton: floatingActionButton,
        appBar: AppBar(
          toolbarHeight: toolbarHeight,
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
        body: body,
      ),
    );
  }
}

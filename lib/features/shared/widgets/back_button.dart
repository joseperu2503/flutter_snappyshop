import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends ConsumerWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // color: darkMode
        //     ? AppColors.primaryCulturedDark
        //     : AppColors.primaryCultured,
        color: Colors.transparent,
      ),
      child: TextButton(
        onPressed: () {
          context.pop();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: SvgPicture.asset(
            kIsWeb || Platform.isAndroid
                ? 'assets/icons/arrow_back_material.svg'
                : 'assets/icons/arrow_back_ios.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              darkMode
                  ? AppColors.textYankeesBlueDark
                  : AppColors.textYankeesBlue,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

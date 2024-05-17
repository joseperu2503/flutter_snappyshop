import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';

class CustomProgressIndicator extends ConsumerWidget {
  const CustomProgressIndicator({
    super.key,
    this.size = 32,
    this.color = AppColors.primaryPearlAqua,
    this.strokeWidth = 4,
  });

  final double size;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);
    return SizedBox(
      width: size,
      height: size,
      child: kIsWeb || Platform.isAndroid
          ? CircularProgressIndicator(
              color: darkMode ? AppColors.white : color,
              strokeWidth: strokeWidth,
            )
          : CupertinoActivityIndicator(
              radius: size / 2,
              color: darkMode ? AppColors.white : color,
            ),
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';

class CustomProgressIndicator extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: kIsWeb || Platform.isAndroid
          ? CircularProgressIndicator(
              color: color,
              strokeWidth: strokeWidth,
            )
          : CupertinoActivityIndicator(
              radius: size / 2,
              color: color,
            ),
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/constants/app_colors.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
    required this.loading,
    required this.child,
  });

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !loading,
      child: Stack(
        children: [
          child,
          if (loading)
            Scaffold(
              backgroundColor: AppColors.white,
              body: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: kIsWeb || Platform.isAndroid
                      ? const CircularProgressIndicator(
                          color: AppColors.primaryPearlAqua,
                        )
                      : const CupertinoActivityIndicator(
                          radius: 16,
                          color: AppColors.primaryPearlAqua,
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

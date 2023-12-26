import 'package:flutter/material.dart';

enum SnackbarType { info, success, error, floating }

class SnackbarService {
  void showSnackbar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(milliseconds: 3000),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: Colors.black54,
      duration: duration,
    ));
  }
}

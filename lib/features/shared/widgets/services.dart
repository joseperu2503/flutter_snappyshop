import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/features/auth/providers/auth_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/dark_mode_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/shared/services/snackbar_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Services extends ConsumerStatefulWidget {
  const Services({super.key, required this.child});
  final Widget child;

  @override
  ServicesState createState() => ServicesState();
}

class ServicesState extends ConsumerState<Services> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      ref.read(authProvider.notifier).initAutoLogout();
      ref.read(darkModeProvider.notifier).getDarkMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(snackbarProvider, (previous, next) {
      if (next.showSnackbar) {
        SnackbarService().showSnackbar(
          context: context,
          message: next.message,
        );
      }
    });

    return Stack(
      children: [
        widget.child,
      ],
    );
  }
}

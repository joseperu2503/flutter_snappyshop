import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/features/shared/providers/loader_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_snappyshop/features/settings/services/notification_service.dart';
import 'package:flutter_snappyshop/features/shared/services/snackbar_service.dart';
import 'package:flutter_snappyshop/features/shared/widgets/loader.dart';
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
    NotificationService().initListeners();
  }

  @override
  Widget build(BuildContext context) {
    final loader = ref.watch(loaderProvider);

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
        if (loader.loading) const Loader(),
      ],
    );
  }
}

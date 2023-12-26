import 'package:flutter/material.dart';
import 'package:flutter_eshop/features/shared/providers/loader_provider.dart';
import 'package:flutter_eshop/features/shared/providers/snackbar_provider.dart';
import 'package:flutter_eshop/features/shared/services/snackbar_service.dart';
import 'package:flutter_eshop/features/shared/widgets/loader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Services extends ConsumerWidget {
  const Services({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, ref) {
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
        child,
        if (loader.loading) const Loader(),
      ],
    );
  }
}

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/config/router/app_router.dart';
import 'package:flutter_snappyshop/features/shared/providers/loader_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/notifications_provider.dart';
import 'package:flutter_snappyshop/features/shared/providers/snackbar_provider.dart';
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
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'product' &&
        message.data['productId'] != null) {
      appRouter.push('/product/${message.data['productId']}');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationsProvider.notifier).initialStatusCheck();
    });
    setupInteractedMessage();
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

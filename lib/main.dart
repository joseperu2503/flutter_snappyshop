import 'package:flutter/material.dart';
import 'package:flutter_eshop/config/constants/environment.dart';
import 'package:flutter_eshop/config/router/app_router.dart';
import 'package:flutter_eshop/config/theme/app_theme.dart';
import 'package:flutter_eshop/features/shared/widgets/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await Environment.initEnvironment();
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Services(
          child: child!,
        );
      },
      theme: AppTheme().getTheme(),
    );
  }
}

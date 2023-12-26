import 'package:flutter_eshop/features/auth/screens/login_screen.dart';
import 'package:flutter_eshop/features/auth/screens/register_screen.dart';
import 'package:flutter_eshop/features/auth/services/auth_service.dart';
import 'package:flutter_eshop/features/products/screens/products_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider((ref) {
  externalRedirect() async {
    final token = await AuthService.verifyToken();
    if (token) {
      return '/products';
    }
    return null;
  }

  return GoRouter(
    initialLocation: '/login',
    routes: [
      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
        redirect: (context, state) async {
          return externalRedirect();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),
    ],

    ///! TODO: Bloquear si no se está autenticado de alguna manera
  );
});

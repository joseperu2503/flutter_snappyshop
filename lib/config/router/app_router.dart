import 'package:flutter_eshop/features/auth/screens/home_screen.dart';
import 'package:flutter_eshop/features/auth/screens/login_screen.dart';
import 'package:flutter_eshop/features/auth/screens/register_screen.dart';
import 'package:flutter_eshop/features/auth/services/auth_service.dart';
import 'package:flutter_eshop/features/products/screens/cart_screen.dart';
import 'package:flutter_eshop/features/products/screens/product_screen.dart';
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
    initialLocation: '/',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        redirect: (context, state) async {
          return externalRedirect();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Product Routes
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductScreen(
          productId: state.pathParameters['id'] ?? 'no-id',
        ),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
    ],
  );
});

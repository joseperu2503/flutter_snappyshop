import 'package:flutter_eshop/features/auth/screens/home_screen.dart';
import 'package:flutter_eshop/features/auth/screens/login_screen.dart';
import 'package:flutter_eshop/features/auth/screens/register_screen.dart';
import 'package:flutter_eshop/features/auth/services/auth_service.dart';
import 'package:flutter_eshop/features/products/screens/brand_screen.dart';
import 'package:flutter_eshop/features/products/screens/cart_screen.dart';
import 'package:flutter_eshop/features/products/screens/order_confirmed_screen.dart';
import 'package:flutter_eshop/features/products/screens/product_screen.dart';
import 'package:flutter_eshop/features/products/screens/products_screen.dart';
import 'package:flutter_eshop/features/products/screens/search_screen.dart';
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

  internalRedirect() async {
    final token = await AuthService.verifyToken();
    if (token) {
      return null;
    }
    return '/';
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
        redirect: (context, state) async {
          return externalRedirect();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
        redirect: (context, state) async {
          return externalRedirect();
        },
      ),

      // Product Routes
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
        redirect: (context, state) async {
          return internalRedirect();
        },
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductScreen(
          productId: state.pathParameters['id'] ?? 'no-id',
        ),
        redirect: (context, state) async {
          return internalRedirect();
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
        redirect: (context, state) async {
          return internalRedirect();
        },
      ),
      GoRoute(
        path: '/order-confirmed',
        builder: (context, state) => const OrderConfirmedScreen(),
        redirect: (context, state) async {
          return internalRedirect();
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
        redirect: (context, state) async {
          return internalRedirect();
        },
      ),
      GoRoute(
        path: '/brand/:id',
        builder: (context, state) => BrandScreen(
          brandId: state.pathParameters['id'] ?? 'no-id',
        ),
        redirect: (context, state) async {
          return internalRedirect();
        },
      ),
    ],
  );
});

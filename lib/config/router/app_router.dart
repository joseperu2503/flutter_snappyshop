import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/features/products/screens/wishlist_screen.dart';
import 'package:flutter_snappyshop/features/user/screens/account_information_screen.dart';
import 'package:flutter_snappyshop/features/user/screens/change_password_screen.dart';
import 'package:flutter_snappyshop/features/auth/screens/home_screen.dart';
import 'package:flutter_snappyshop/features/auth/screens/login_screen.dart';
import 'package:flutter_snappyshop/features/auth/screens/register_screen.dart';
import 'package:flutter_snappyshop/features/auth/services/auth_service.dart';
import 'package:flutter_snappyshop/features/products/screens/brand_screen.dart';
import 'package:flutter_snappyshop/features/products/screens/cart_screen.dart';
import 'package:flutter_snappyshop/features/products/screens/order_confirmed_screen.dart';
import 'package:flutter_snappyshop/features/products/screens/product_screen.dart';
import 'package:flutter_snappyshop/features/products/screens/products_screen.dart';
import 'package:flutter_snappyshop/features/products/screens/search_screen.dart';
import 'package:go_router/go_router.dart';

Future<String?> externalRedirect() async {
  final token = await AuthService.verifyToken();
  if (token) {
    return '/products';
  }
  return null;
}

Future<String?> internalRedirect() async {
  final token = await AuthService.verifyToken();
  if (token) {
    return null;
  }
  return '/';
}

Widget transition({
  required BuildContext context,
  required Animation animation,
  required Widget child,
}) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  var fadeTween = Tween(begin: 0.7, end: 1.0);
  var fadeAnimation = animation.drive(fadeTween);

  return FadeTransition(
    opacity: fadeAnimation,
    child: SlideTransition(position: offsetAnimation, child: child),
  );
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Auth Routes
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
      redirect: (context, state) async {
        return externalRedirect();
      },
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
      redirect: (context, state) async {
        return externalRedirect();
      },
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
      redirect: (context, state) async {
        return externalRedirect();
      },
    ),

    // Product Routes
    GoRoute(
      path: '/products',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const ProductsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
      redirect: (context, state) async {
        return internalRedirect();
      },
    ),
    GoRoute(
      path: '/product/:id',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ProductScreen(
            productId: state.pathParameters['id'] ?? 'no-id',
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
      redirect: (context, state) async {
        return internalRedirect();
      },
    ),
    GoRoute(
      path: '/cart',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const CartScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
      redirect: (context, state) async {
        return internalRedirect();
      },
    ),
    GoRoute(
      path: '/order-confirmed',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const OrderConfirmedScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
      redirect: (context, state) async {
        return internalRedirect();
      },
    ),
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const SearchScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
      redirect: (context, state) async {
        return internalRedirect();
      },
    ),
    GoRoute(
      path: '/whishlist',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const WishlistScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
      redirect: (context, state) async {
        return internalRedirect();
      },
    ),
    GoRoute(
      path: '/brand/:id',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: BrandScreen(
            brandId: state.pathParameters['id'] ?? 'no-id',
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
      redirect: (context, state) async {
        return internalRedirect();
      },
    ),
    GoRoute(
      path: '/change-password',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const ChangePasswordScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
      redirect: (context, state) async {
        return internalRedirect();
      },
    ),
    GoRoute(
      path: '/account-information',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const AccountInformationScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
      redirect: (context, state) async {
        return internalRedirect();
      },
    ),
  ],
);

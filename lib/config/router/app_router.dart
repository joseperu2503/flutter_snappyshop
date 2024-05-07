import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/features/address/screens/address_screen.dart';
import 'package:flutter_snappyshop/features/address/screens/addresses_screen.dart';
import 'package:flutter_snappyshop/features/auth/screens/change_password_external_screen.dart';
import 'package:flutter_snappyshop/features/auth/screens/forgot_password_screen.dart';
import 'package:flutter_snappyshop/features/auth/screens/verify_code_screen.dart';
import 'package:flutter_snappyshop/features/cards/screens/card_screen.dart';
import 'package:flutter_snappyshop/features/cards/screens/cards_screen.dart';
import 'package:flutter_snappyshop/features/orders/screens/my_orders_screen.dart';
import 'package:flutter_snappyshop/features/wishlist/screens/wishlist_screen.dart';
import 'package:flutter_snappyshop/features/settings/screens/settings_screen.dart';
import 'package:flutter_snappyshop/features/user/screens/account_information_screen.dart';
import 'package:flutter_snappyshop/features/user/screens/change_password_internal_screen.dart';
import 'package:flutter_snappyshop/features/auth/screens/home_screen.dart';
import 'package:flutter_snappyshop/features/auth/screens/login_screen.dart';
import 'package:flutter_snappyshop/features/auth/screens/register_screen.dart';
import 'package:flutter_snappyshop/features/auth/services/auth_service.dart';
import 'package:flutter_snappyshop/features/brand/screens/brand_screen.dart';
import 'package:flutter_snappyshop/features/cart/screens/cart_screen.dart';
import 'package:flutter_snappyshop/features/checkout/screens/order_confirmed_screen.dart';
import 'package:flutter_snappyshop/features/products/screens/product_screen.dart';
import 'package:flutter_snappyshop/features/products/screens/products_screen.dart';
import 'package:flutter_snappyshop/features/search/screens/search_screen.dart';
import 'package:go_router/go_router.dart';

Future<String?> externalRedirect(
    BuildContext context, GoRouterState state) async {
  final (token, _) = await AuthService.verifyToken();
  if (token) {
    return '/products';
  }
  return null;
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
      redirect: externalRedirect,
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
    ),
    GoRoute(
      path: '/forgot-password',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/verify-code',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const VerifyCodeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/change-password-external',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const ChangePasswordExternalScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
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
    ),
    GoRoute(
      path: '/change-password-internal',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const ChangePasswordInternalScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
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
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/my-orders',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const MyOrdersScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/my-addresses',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const AddressesScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/address',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const AddressScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/my-cards',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const CardsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/card',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const CardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return transition(
                animation: animation, context: context, child: child);
          },
        );
      },
    ),
  ],
);

import 'package:flutter/material.dart';
import 'package:flutter_snappyshop/features/address/screens/address_map_screen.dart';
import 'package:flutter_snappyshop/features/address/screens/address_screen.dart';
import 'package:flutter_snappyshop/features/address/screens/addresses_screen.dart';
import 'package:flutter_snappyshop/features/address/screens/search_address_screen.dart';
import 'package:flutter_snappyshop/features/auth/screens/change_password_external_screen.dart';
import 'package:flutter_snappyshop/features/auth/screens/forgot_password_screen.dart';
import 'package:flutter_snappyshop/features/auth/screens/verify_code_screen.dart';
import 'package:flutter_snappyshop/features/cards/screens/card_screen.dart';
import 'package:flutter_snappyshop/features/cards/screens/cards_screen.dart';
import 'package:flutter_snappyshop/features/checkout/screens/checkout_screen.dart';
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
      builder: (context, state) {
        return const HomeScreen();
      },
      redirect: externalRedirect,
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) {
        return const ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: '/verify-code',
      builder: (context, state) {
        return const VerifyCodeScreen();
      },
    ),
    GoRoute(
      path: '/change-password-external',
      builder: (context, state) {
        return const ChangePasswordExternalScreen();
      },
    ),
    // Product Routes
    GoRoute(
      path: '/products',
      builder: (context, state) {
        return const ProductsScreen();
      },
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        return ProductScreen(
          productId: state.pathParameters['id'] ?? 'no-id',
        );
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) {
        return const CartScreen();
      },
    ),
    GoRoute(
      path: '/order-confirmed',
      builder: (context, state) {
        return const OrderConfirmedScreen();
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) {
        return const SearchScreen();
      },
    ),
    GoRoute(
      path: '/whishlist',
      builder: (context, state) {
        return const WishlistScreen();
      },
    ),
    GoRoute(
      path: '/brand/:id',
      builder: (context, state) {
        return BrandScreen(
          brandId: state.pathParameters['id'] ?? 'no-id',
        );
      },
    ),
    GoRoute(
      path: '/change-password-internal',
      builder: (context, state) {
        return const ChangePasswordInternalScreen();
      },
    ),
    GoRoute(
      path: '/account-information',
      builder: (context, state) {
        return const AccountInformationScreen();
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) {
        return const SettingsScreen();
      },
    ),
    GoRoute(
      path: '/my-orders',
      builder: (context, state) {
        return const MyOrdersScreen();
      },
    ),
    GoRoute(
      path: '/my-addresses',
      builder: (context, state) {
        return const AddressesScreen();
      },
    ),
    GoRoute(
      path: '/search-address',
      builder: (context, state) {
        return const SearchAddressScreen();
      },
    ),
    GoRoute(
      path: '/address-map',
      builder: (context, state) {
        return const AddressMapScreen();
      },
    ),
    GoRoute(
      path: '/confirm-address',
      builder: (context, state) {
        return const AddressScreen();
      },
    ),
    GoRoute(
      path: '/my-cards',
      builder: (context, state) {
        return const CardsScreen();
      },
    ),
    GoRoute(
      path: '/card',
      builder: (context, state) {
        return const CardScreen();
      },
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        return const CheckoutScreen();
      },
    ),
  ],
);

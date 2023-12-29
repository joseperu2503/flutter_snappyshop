import 'package:flutter_eshop/config/router/app_router.dart';
import 'package:flutter_eshop/features/shared/services/key_value_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.ref) : super(AuthState());
  final StateNotifierProviderRef ref;
  final keyValueStorageService = KeyValueStorageService();

  logout() async {
    await keyValueStorageService.removeKey('token');

    ref.read(goRouterProvider).go('/');
  }
}

class AuthState {
  final bool authenticated;

  AuthState({
    this.authenticated = false,
  });

  AuthState copyWith({
    bool? authenticated,
  }) =>
      AuthState(
        authenticated: authenticated ?? this.authenticated,
      );
}

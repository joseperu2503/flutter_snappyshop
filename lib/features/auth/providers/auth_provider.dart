import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.ref) : super(AuthState());
  final StateNotifierProviderRef ref;
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

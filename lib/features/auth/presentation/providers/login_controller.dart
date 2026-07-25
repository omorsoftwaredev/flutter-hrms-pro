import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

final loginLoadingProvider = StateProvider<bool>((ref) => false);

final loginControllerProvider = Provider<LoginController>((ref) {
  return LoginController(ref);
});

class LoginController {
  final Ref ref;

  LoginController(this.ref);

  Future<void> login({
    required String email,
    required String password,
  }) async {
    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      await ref.read(authRepositoryProvider).signIn(
        email: email,
        password: password,
      );
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/auth/current_user.dart';
import '../../../../core/auth/current_user_provider.dart';

final loginLoadingProvider =
StateProvider<bool>((ref) => false);

final loginControllerProvider =
Provider<LoginController>((ref) {
  return LoginController(ref);
});

class LoginController {
  final Ref ref;

  LoginController(this.ref);

  Future<CurrentUser> login({
    required String email,
    required String password,
  }) async {
    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      final user = await ref
          .read(authRepositoryProvider)
          .login(
        email: email,
        password: password,
      );

      if (user == null) {
        throw Exception('Login failed.');
      }

      ref
          .read(currentUserProvider.notifier)
          .login(user);

      return user;
    } finally {
      ref.read(loginLoadingProvider.notifier).state =
      false;
    }
  }
}
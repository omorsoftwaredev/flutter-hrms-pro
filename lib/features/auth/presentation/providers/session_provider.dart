import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';
import 'auth_provider.dart';

final sessionProvider = Provider<UserSession>((ref) {
  return UserSession(ref);
});

class UserSession {
  final Ref ref;

  UserSession(this.ref);

  bool isLoggedIn() {
    return ref.read(authRepositoryProvider).currentUser != null;
  }
}

/// ===============================================================
/// Flutter HRMS Pro
/// Role Redirect
///
/// Version : 0.7.0
/// ===============================================================

import 'current_user.dart';
import 'roles.dart';

class RoleRedirect {
  const RoleRedirect._();

  /// ===========================================================
  /// Default Home Route
  /// ===========================================================

  static String home(CurrentUser? user) {
    if (user == null || !user.isLoggedIn) {
      return '/login';
    }

    switch (user.role) {
      case UserRole.developer:
        return '/developer';

      case UserRole.companyOwner:
        return '/dashboard';

        case UserRole.hr:
        return '/hr';

      case UserRole.supervisor:
        return '/supervisor';

      case UserRole.employee:
        return '/employee';
    }
  }

  /// ===========================================================
  /// Login Redirect
  /// ===========================================================

  static String afterLogin(CurrentUser user) {
    return home(user);
  }

  /// ===========================================================
  /// Logout Redirect
  /// ===========================================================

  static String afterLogout() {
    return '/login';
  }
}
/// ===============================================================
/// Flutter HRMS Pro
/// Redirect Helper
///
/// Version : 0.8.0
/// ===============================================================

import '../auth/current_user.dart';
import 'dashboard_redirect.dart';
import 'route_paths.dart';

class RedirectHelper {
  const RedirectHelper._();

  // =============================================================
  // Initial Redirect
  // =============================================================

  static String initial(CurrentUser? user) {
    if (user == null || !user.isLoggedIn) {
      return RoutePaths.login;
    }

    return DashboardRedirect.home(user);
  }

  // =============================================================
  // Login Redirect
  // =============================================================

  static String login(CurrentUser? user) {
    if (user == null || !user.isLoggedIn) {
      return RoutePaths.login;
    }

    return DashboardRedirect.home(user);
  }

  // =============================================================
  // Logout Redirect
  // =============================================================

  static String logout() {
    return RoutePaths.login;
  }

  // =============================================================
  // Unauthorized Redirect
  // =============================================================

  static String unauthorized() {
    return RoutePaths.unauthorized;
  }

  // =============================================================
  // Not Found Redirect
  // =============================================================

  static String notFound() {
    return RoutePaths.notFound;
  }
}
/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Redirect
///
/// Version : 0.8.1
/// ===============================================================

import '../auth/current_user.dart';
import 'route_paths.dart';

class DashboardRedirect {
  const DashboardRedirect._();

  /// =============================================================
  /// Dashboard Route
  /// =============================================================

  static String home(CurrentUser? user) {
    if (user == null || !user.isLoggedIn) {
      return RoutePaths.login;
    }

    // -------------------------------------------------------------
    // All authenticated users go to one dashboard route.
    // DashboardHomePage will decide which dashboard to show
    // based on the user's role.
    // -------------------------------------------------------------
    return RoutePaths.dashboard;
  }

  /// =============================================================
  /// Dashboard Check
  /// =============================================================

  static bool isDashboard(String location) {
    return location == RoutePaths.dashboard;
  }
}
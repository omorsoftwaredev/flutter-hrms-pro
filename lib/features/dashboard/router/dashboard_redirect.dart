/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Redirect
///
/// Version : 0.7.0
/// ===============================================================

import '../../../core/auth/current_user.dart';
import '../../../core/auth/roles.dart';

class DashboardRedirect {
  DashboardRedirect._();

  /// ------------------------------------------------------------
  /// Dashboard Route By Role
  /// ------------------------------------------------------------

  static String home(CurrentUser user) {
    switch (user.role) {
      case UserRole.developer:
        return developer;

      case UserRole.companyOwner:
        return companyOwner;

        case UserRole.hr:
        return companyOwner;

      case UserRole.supervisor:
        return supervisor;

      case UserRole.employee:
        return employee;
    }
  }

  // ============================================================
  // Dashboard Routes
  // ============================================================

  static const String developer =
      '/dashboard/developer';

  static const String superAdmin =
      '/dashboard/super-admin';

  static const String companyOwner =
      '/dashboard/company-owner';

  static const String hr =
      '/dashboard/hr';

  static const String supervisor =
      '/dashboard/supervisor';

  static const String employee =
      '/dashboard/employee';

  // ============================================================
  // Common
  // ============================================================

  static const String login =
      '/login';

  static const String dashboard =
      '/dashboard';

  // ============================================================
  // Helper
  // ============================================================

  static bool isDashboard(String location) {
    return location.startsWith('/dashboard');
  }

  static bool isLogin(String location) {
    return location == login;
  }
}
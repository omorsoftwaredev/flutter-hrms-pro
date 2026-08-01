/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Redirect
///
/// Version : 0.7.0
/// ===============================================================

import '../auth/current_user.dart';
import '../auth/roles.dart';

class DashboardRedirect {
  const DashboardRedirect._();

  static String home(CurrentUser user) {
    switch (user.role) {
      case UserRole.developer:
        return "/dashboard";

      case UserRole.superAdmin:
        return "/dashboard";

      case UserRole.companyOwner:
        return "/dashboard";

      case UserRole.supervisor:
        return "/dashboard";

      case UserRole.employee:
        return "/dashboard/mobile-attendance";
    }
  }
}
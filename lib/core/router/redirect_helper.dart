/// ===============================================================
/// Flutter HRMS Pro
/// Redirect Helper
///
/// Version : 1.0.0
/// ===============================================================

import '../auth/current_user.dart';
import '../auth/user_type.dart';
import 'route_paths.dart';

class RedirectHelper {
  const RedirectHelper._();

  static String initial(CurrentUser? user) {
    if (user == null) {
      return RoutePaths.login;
    }

    switch (user.userType) {
      case UserType.developer:
        return RoutePaths.developerDashboard;

      case UserType.company:
        return RoutePaths.companyDashboard;

      case UserType.hr:
        return RoutePaths.hrDashboard;

      case UserType.supervisor:
        return RoutePaths.supervisorDashboard;

      case UserType.employee:
        return RoutePaths.employeeDashboard;
    }
  }
}
/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Redirect
///
/// Version : 1.0.0
/// ===============================================================

import '../router/route_paths.dart';
import 'current_user.dart';
import 'user_type.dart';

class DashboardRedirect {
  const DashboardRedirect._();

  static String home(CurrentUser user) {
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
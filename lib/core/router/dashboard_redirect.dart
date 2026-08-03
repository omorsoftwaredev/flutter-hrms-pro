import '../auth/current_user.dart';
import '../auth/user_type.dart';
import '../router/route_paths.dart';

class DashboardRedirect {
  DashboardRedirect._();

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
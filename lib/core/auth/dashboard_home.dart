/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Home
///
/// Version : 0.7.0
/// ===============================================================

import '../auth/current_user.dart';
import 'dashboard_redirect.dart';

class DashboardHome {
  const DashboardHome._();

  static String route(CurrentUser user) {
    return DashboardRedirect.home(user);
  }
}
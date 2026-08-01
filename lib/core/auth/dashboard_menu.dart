/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Menu
///
/// Version : 0.7.0
/// ===============================================================

import 'permissions.dart';

class DashboardMenu {
  const DashboardMenu({
    required this.title,
    required this.route,
    required this.permission,
  });

  final String title;
  final String route;
  final Permission permission;
}
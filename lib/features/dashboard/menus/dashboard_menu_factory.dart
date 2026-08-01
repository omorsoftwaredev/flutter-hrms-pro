/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Menu Factory
///
/// Version : 0.7.0
/// ===============================================================


import '../../../core/auth/current_user.dart';
import '../../../core/auth/roles.dart';
import '../widgets/dashboard_menu_item.dart';

import 'dashboard_developer_menu.dart';
import 'dashboard_super_admin_menu.dart';
import 'dashboard_owner_menu.dart';
import 'dashboard_supervisor_menu.dart';
import 'dashboard_employee_menu.dart';

class DashboardMenuFactory {
  DashboardMenuFactory._();

  static List<DashboardMenuItem> getMenus(
      CurrentUser user,
      ) {
    switch (user.role) {
      case UserRole.developer:
        return DashboardDeveloperMenu.menus;

      case UserRole.superAdmin:
        return DashboardSuperAdminMenu.menus;

      case UserRole.companyOwner:
        return DashboardOwnerMenu.menus;

      case UserRole.supervisor:
        return DashboardSupervisorMenu.menus;

      case UserRole.employee:
        return DashboardEmployeeMenu.menus;
    }
  }
}
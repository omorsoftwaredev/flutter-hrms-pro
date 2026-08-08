/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Router
///
/// Version : 0.7.0
/// ===============================================================

import 'package:go_router/go_router.dart';

import '../../developer/pages/developer_dashboard_page.dart';
import '../../employee_dashboard/pages/employee_dashboard_page.dart';
import '../pages/company_owner_dashboard_page.dart';
import '../pages/dashboard_home_page.dart';
import '../pages/super_admin_dashboard_page.dart';
import '../pages/supervisor_dashboard_page.dart';

import 'dashboard_redirect.dart';

class DashboardRouter {
  DashboardRouter._();

  static List<RouteBase> routes = [

    /// ===========================================================
    /// Developer
    /// ===========================================================

    GoRoute(
      path: DashboardRedirect.developer,
      builder: (context, state) =>
      const DeveloperDashboardPage(),
    ),

    /// ===========================================================
    /// Super Admin
    /// ===========================================================

    GoRoute(
      path: DashboardRedirect.superAdmin,
      builder: (context, state) =>
      const SuperAdminDashboardPage(),
    ),

    /// ===========================================================
    /// Company Owner
    /// ===========================================================

    GoRoute(
      path: DashboardRedirect.companyOwner,
      builder: (context, state) =>
      const CompanyOwnerDashboardPage(),
    ),

    /// ===========================================================
    /// Supervisor
    /// ===========================================================

    GoRoute(
      path: DashboardRedirect.supervisor,
      builder: (context, state) =>
      const SupervisorDashboardPage(),
    ),

    /// ===========================================================
    /// Employee
    /// ===========================================================

    GoRoute(
      path: DashboardRedirect.employee,
      builder: (context, state) =>
      const EmployeeDashboardPage(),
    ),

    GoRoute(
      path: DashboardRedirect.dashboard,
      builder: (context, state) =>
      const DashboardHomePage(),
    ),
  ];
}
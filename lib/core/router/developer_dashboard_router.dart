/// ===============================================================
/// Flutter HRMS Pro
/// Developer Router
///
/// Version : 1.0.0
/// ===============================================================

import 'package:go_router/go_router.dart';

import '../../features/company/domain/entities/company_entity.dart';
import '../../features/company/presentation/pages/company_form_page.dart';
import '../../features/company/presentation/pages/company_list_page.dart';

import '../../features/company_account/domain/entities/company_account_entity.dart';
import '../../features/company_account/presentation/pages/company_account_form_page.dart';
import '../../features/company_account/presentation/pages/company_account_list_page.dart';

import '../../features/dashboard/pages/developer_dashboard_page.dart';
import 'route_names.dart';
import 'route_paths.dart';

class DeveloperDashboardRouter {
  const DeveloperDashboardRouter._();

  static List<RouteBase> get routes => [

    // =========================================================
    // Developer Dashboard
    // =========================================================

    GoRoute(
      path: RoutePaths.developerDashboard,
      name: RouteNames.developerDashboard,
      builder: (context, state) =>
      const DeveloperDashboardPage(),
    ),

    // =========================================================
    // Company
    // =========================================================

    GoRoute(
      path: RoutePaths.companies,
      name: RouteNames.companies,
      builder: (context, state) =>
      const CompanyListPage(),
    ),

    GoRoute(
      path: RoutePaths.companyCreate,
      name: RouteNames.companyCreate,
      builder: (context, state) =>
      const CompanyFormPage(),
    ),

    GoRoute(
      path: RoutePaths.companyEdit,
      name: RouteNames.companyEdit,
      builder: (context, state) {
        final company =
        state.extra as CompanyEntity;

        return CompanyFormPage(
          company: company,
        );
      },
    ),

    // =========================================================
    // Company Accounts
    // =========================================================

    GoRoute(
      path: RoutePaths.companyAccounts,
      name: RouteNames.companyAccounts,
      builder: (context, state) =>
      const CompanyAccountListPage(),
    ),

    GoRoute(
      path: RoutePaths.companyAccountCreate,
      name: RouteNames.companyAccountCreate,
      builder: (context, state) =>
      const CompanyAccountFormPage(),
    ),

    GoRoute(
      path: RoutePaths.companyAccountEdit,
      name: RouteNames.companyAccountEdit,
      builder: (context, state) {
        print(state.extra);

        final account = state.extra as CompanyAccountEntity?;

        print(account);
        print(account?.username);
        print(account?.passwordHash);

        return CompanyAccountFormPage(
          account: account,
        );
      },
    ),
  ];
}
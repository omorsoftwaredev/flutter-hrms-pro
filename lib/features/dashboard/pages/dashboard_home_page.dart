/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Home Page
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/roles.dart';
import '../../../core/auth/current_user_provider.dart';

import '../../developer/pages/developer_dashboard_page.dart';
import '../../employee_dashboard/pages/employee_dashboard_page.dart';
import '../../supervisor_dashboard/pages/supervisor_dashboard_page.dart';
import 'company_owner_dashboard_page.dart';
import 'super_admin_dashboard_page.dart';

class DashboardHomePage extends ConsumerWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    switch (user.role) {
      case UserRole.developer:
        return const DeveloperDashboardPage();

      case UserRole.companyOwner:
        return const CompanyOwnerDashboardPage();

      case UserRole.supervisor:
        return const SupervisorDashboardPage();

      case UserRole.hr:
        return const SupervisorDashboardPage();

      case UserRole.employee:
        return const EmployeeDashboardPage();
    }
  }
}
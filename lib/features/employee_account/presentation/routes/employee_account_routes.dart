//===============================================================
// Employee Account Routes
//===============================================================

import 'package:go_router/go_router.dart';

import '../../domain/entities/employee_account_entity.dart';

import '../pages/employee_account_list_page.dart';
import '../pages/employee_account_form_page.dart';
import '../pages/employee_account_view_page.dart';

class EmployeeAccountRoutes {
  const EmployeeAccountRoutes._();

  static List<RouteBase> get routes => [

    //-------------------------------------------------------
    // Employee Account List
    //-------------------------------------------------------

    GoRoute(
      path: '/dashboard/employee-accounts',
      name: 'employee-accounts',
      builder: (context, state) =>
      const EmployeeAccountListPage(),
    ),

    //-------------------------------------------------------
    // Create Employee Account
    //-------------------------------------------------------

    GoRoute(
      path: '/dashboard/employee-accounts/create',
      name: 'employee-account-create',
      builder: (context, state) =>
      const EmployeeAccountFormPage(),
    ),

    //-------------------------------------------------------
    // Edit Employee Account
    //-------------------------------------------------------

    GoRoute(
      path: '/dashboard/employee-accounts/edit',
      name: 'employee-account-edit',
      builder: (context, state) {

        final account =
        state.extra as EmployeeAccountEntity;

        return EmployeeAccountFormPage(
          account: account,
        );
      },
    ),

    //-------------------------------------------------------
    // View Employee Account
    //-------------------------------------------------------

    GoRoute(
      path: '/dashboard/employee-accounts/view',
      name: 'employee-account-view',
      builder: (context, state) {

        final account =
        state.extra as EmployeeAccountEntity;

        return EmployeeAccountViewPage(
          account: account,
        );
      },
    ),
  ];
}
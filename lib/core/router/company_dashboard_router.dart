/// ===============================================================
/// Flutter HRMS Pro
/// Company Dashboard Router
///
/// Version : 1.0.0
/// ===============================================================

import 'package:go_router/go_router.dart';

import '../../features/company_dashboard/pages/company_dashboard_page.dart';

import '../../features/department/domain/entities/department_entity.dart';
import '../../features/department/presentation/pages/department_form_page.dart';
import '../../features/department/presentation/pages/department_list_page.dart';

import '../../features/designation/domain/entities/designation_entity.dart';
import '../../features/designation/presentation/pages/designation_form_page.dart';
import '../../features/designation/presentation/pages/designation_list_page.dart';

import '../../features/shift/domain/entities/shift_entity.dart';
import '../../features/shift/presentation/pages/shift_form_page.dart';
import '../../features/shift/presentation/pages/shift_list_page.dart';

//
// import '../../features/role_permission/domain/entities/role_permission_entity.dart';
// import '../../features/role_permission/presentation/pages/role_permission_form_page.dart';
// import '../../features/role_permission/presentation/pages/role_permission_list_page.dart';

import '../../features/employee/domain/entities/employee_entity.dart';
import '../../features/employee/presentation/pages/employee_form_page.dart';
import '../../features/employee/presentation/pages/employee_list_page.dart';

import 'route_names.dart';
import 'route_paths.dart';

class CompanyDashboardRouter {
  const CompanyDashboardRouter._();

  static List<RouteBase> get routes => [

    // ===========================================================
    // Company Dashboard
    // ===========================================================

    // GoRoute(
    //   path: RoutePaths.companyDashboard,
    //   name: RouteNames.companyDashboard,
    //   builder: (context, state) =>
    //   const CompanyDashboardPage(),
    // ),

    // ===========================================================
    // Department
    // ===========================================================
    GoRoute(
      path: RoutePaths.companyDashboard,
      name: RouteNames.companyDashboard,
      builder: (context, state) =>
      const CompanyDashboardPage(),
    ),

    GoRoute(
      path: RoutePaths.departments,
      name: RouteNames.departments,
      builder: (_, __) =>
      const DepartmentListPage(),
    ),

    GoRoute(
      path: RoutePaths.departmentCreate,
      name: RouteNames.departmentCreate,
      builder: (_, __) =>
      const DepartmentFormPage(),
    ),

    GoRoute(
      path: RoutePaths.departmentEdit,
      name: RouteNames.departmentEdit,
      builder: (_, state) {
        final department = state.extra as DepartmentEntity;

        return DepartmentFormPage(
          department: department,
        );
      },
    ),

    // ===========================================================
    // Designation
    // ===========================================================

    GoRoute(
      path: RoutePaths.designations,
      name: RouteNames.designations,
      builder: (_, __) =>
      const DesignationListPage(),
    ),

    GoRoute(
      path: RoutePaths.designationCreate,
      name: RouteNames.designationCreate,
      builder: (_, __) =>
      const DesignationFormPage(),
    ),

    GoRoute(
      path: RoutePaths.designationEdit,
      name: RouteNames.designationEdit,
      builder: (_, state) {
        final designation =
        state.extra as DesignationEntity;

        return DesignationFormPage(
          designation: designation,
        );
      },
    ),

    // ===========================================================
    // Shift
    // ===========================================================

    GoRoute(
      path: RoutePaths.shifts,
      name: RouteNames.shifts,
      builder: (_, __) =>
      const ShiftListPage(),
    ),

    GoRoute(
      path: RoutePaths.shiftCreate,
      name: RouteNames.shiftCreate,
      builder: (_, __) =>
      const ShiftFormPage(),
    ),

    GoRoute(
      path: RoutePaths.shiftEdit,
      name: RouteNames.shiftEdit,
      builder: (_, state) {
        final shift = state.extra as ShiftEntity;

        return ShiftFormPage(
          shift: shift,
        );
      },
    ),

    // ===========================================================
// HR Dashboard
// ===========================================================

//     GoRoute(
//       path: RoutePaths.hrDashboard,
//       name: RouteNames.hrDashboard,
//       builder: (context, state) =>
//       const HrDashboardPage(),
//     ),
//
// // ===========================================================
// // Supervisor Dashboard
// // ===========================================================
//
//     GoRoute(
//       path: RoutePaths.supervisorDashboard,
//       name: RouteNames.supervisorDashboard,
//       builder: (context, state) =>
//       const SupervisorDashboardPage(),
//     ),
//
// // ===========================================================
// // Employee Dashboard
// // ===========================================================
//
//     GoRoute(
//       path: RoutePaths.employeeDashboard,
//       name: RouteNames.employeeDashboard,
//       builder: (context, state) =>
//       const EmployeeDashboardPage(),
//     ),

    // ===========================================================
    // Role
    // ===========================================================

    // GoRoute(
    //   path: RoutePaths.roles,
    //   name: RouteNames.roles,
    //   builder: (_, __) =>
    //   const RoleListPage(),
    // ),
    //
    // GoRoute(
    //   path: RoutePaths.roleCreate,
    //   name: RouteNames.roleCreate,
    //   builder: (_, __) =>
    //   const RoleFormPage(),
    // ),
    //
    // GoRoute(
    //   path: RoutePaths.roleEdit,
    //   name: RouteNames.roleEdit,
    //   builder: (_, state) {
    //     final role = state.extra as RoleEntity;
    //
    //     return RoleFormPage(
    //       role: role,
    //     );
    //   },
    // ),

    // ===========================================================
    // Role Permission
    // ===========================================================

    // GoRoute(
    //   path: RoutePaths.rolePermissions,
    //   name: RouteNames.rolePermissions,
    //   builder: (_, __) =>
    //   const RolePermissionListPage(),
    // ),
    //
    // GoRoute(
    //   path: RoutePaths.rolePermissionCreate,
    //   name: RouteNames.rolePermissionCreate,
    //   builder: (_, __) =>
    //   const RolePermissionFormPage(),
    // ),

    // GoRoute(
    //   path: RoutePaths.rolePermissionEdit,
    //   name: RouteNames.rolePermissionEdit,
    //   builder: (_, state) {
    //     final permission =
    //     state.extra as RolePermissionEntity;
    //
    //     return RolePermissionFormPage(
    //       permission: permission,
    //     );
    //   },
    // ),

    // ===========================================================
    // Employee
    // ===========================================================

    GoRoute(
      path: RoutePaths.employees,
      name: RouteNames.employees,
      builder: (_, __) =>
      const EmployeeListPage(),
    ),

    GoRoute(
      path: RoutePaths.employeeCreate,
      name: RouteNames.employeeCreate,
      builder: (_, __) =>
      const EmployeeFormPage(),
    ),

    GoRoute(
      path: RoutePaths.employeeEdit,
      name: RouteNames.employeeEdit,
      builder: (_, state) {
        final employee =
        state.extra as EmployeeEntity;

        return EmployeeFormPage(
          employee: employee,
        );
      },
    ),
  ];
}
/// ===============================================================
/// Flutter HRMS Pro
/// Company Dashboard Router
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_hrms_pro/features/supervisor/presentation/pages/supervisor_department_assignment_management_page.dart';
import 'package:go_router/go_router.dart';

import '../../features/attendance/mobile_attendance/presentation/pages/company_supervisor_mobile_attendance_report_page.dart';
import '../../features/dashboard/pages/company_dashboard_page.dart';

import '../../features/department/domain/entities/department_entity.dart';
import '../../features/department/presentation/pages/department_form_page.dart';
import '../../features/department/presentation/pages/department_list_page.dart';

import '../../features/department/presentation/pages/department_view_page.dart';
import '../../features/designation/domain/entities/designation_entity.dart';
import '../../features/designation/presentation/pages/designation_form_page.dart';
import '../../features/designation/presentation/pages/designation_list_page.dart';

import '../../features/designation/presentation/pages/designation_view_page.dart';
import '../../features/employee/presentation/pages/employee_view_page.dart';

import '../../features/role/domain/entities/role_entity.dart';
import '../../features/role/presentation/pages/role_form_page.dart';
import '../../features/role/presentation/pages/role_list_page.dart';
import '../../features/role/presentation/pages/role_view_page.dart';
import '../../features/role_permissions/domain/entities/role_permissions_entity.dart';
import '../../features/role_permissions/domain/entities/role_permissions_view_entity.dart';
import '../../features/role_permissions/presentation/pages/role_permissions_form_page.dart';
import '../../features/role_permissions/presentation/pages/role_permissions_list_page.dart';
import '../../features/role_permissions/presentation/pages/role_permissions_view_page.dart';
import '../../features/shift/domain/entities/shift_entity.dart';
import '../../features/shift/presentation/pages/shift_form_page.dart';
import '../../features/shift/presentation/pages/shift_list_page.dart';

import '../../features/employee/domain/entities/employee_entity.dart';
import '../../features/employee/presentation/pages/employee_form_page.dart';
import '../../features/employee/presentation/pages/employee_list_page.dart';

import '../../features/shift/presentation/pages/shift_view_page.dart';
import '../../features/supervisor/presentation/pages/supervisor_assignment_page.dart';
import '../../features/supervisor/presentation/pages/supervisor_department_assignment_page.dart';
import '../../features/supervisor/presentation/pages/supervisor_department_status_page.dart';
import '../../features/supervisor/presentation/pages/supervisor_page.dart';
import 'route_names.dart';
import 'route_paths.dart';
import '../../features/employee_account/presentation/routes/employee_account_routes.dart';

class CompanyDashboardRouter {
  const CompanyDashboardRouter._();

  static List<RouteBase> get routes => [
    // ===========================================================
    // Company Dashboard
    // ===========================================================
    GoRoute(
      path: RoutePaths.companyDashboard,
      name: RouteNames.companyDashboard,
      builder: (context, state) => const CompanyDashboardPage(),
    ),
    GoRoute(
      path: RoutePaths.departmentView,
      builder: (context, state) {
        final department = state.extra as DepartmentEntity;
        return DepartmentViewPage(department: department);
      },
    ),
    GoRoute(
      path: RoutePaths.departments,
      name: RouteNames.departments,
      builder: (_, __) => const DepartmentListPage(),
    ),

    GoRoute(
      path: RoutePaths.departmentCreate,
      name: RouteNames.departmentCreate,
      builder: (_, __) => const DepartmentFormPage(),
    ),

    GoRoute(
      path: RoutePaths.departmentEdit,
      name: RouteNames.departmentEdit,
      builder: (_, state) {
        final department = state.extra as DepartmentEntity;

        return DepartmentFormPage(department: department);
      },
    ),

    // ===========================================================
    // Designation
    // ===========================================================
    GoRoute(
      path: RoutePaths.designationView,
      builder: (context, state) {
        final designation = state.extra as DesignationEntity;

        return DesignationViewPage(designation: designation);
      },
    ),
    GoRoute(
      path: RoutePaths.designations,
      name: RouteNames.designations,
      builder: (_, __) => const DesignationListPage(),
    ),

    GoRoute(
      path: RoutePaths.designationCreate,
      name: RouteNames.designationCreate,
      builder: (_, __) => const DesignationFormPage(),
    ),

    GoRoute(
      path: RoutePaths.designationEdit,
      name: RouteNames.designationEdit,
      builder: (_, state) {
        final designation = state.extra as DesignationEntity;

        return DesignationFormPage(designation: designation);
      },
    ),

    // ===========================================================
    // Shift
    // ===========================================================
    GoRoute(
      path: RoutePaths.shiftView,
      name: RouteNames.shiftView,
      builder: (context, state) {
        final shift = state.extra as ShiftEntity;

        return ShiftViewPage(shift: shift);
      },
    ),
    GoRoute(
      path: RoutePaths.shifts,
      name: RouteNames.shifts,
      builder: (_, __) => const ShiftListPage(),
    ),

    GoRoute(
      path: RoutePaths.shiftCreate,
      name: RouteNames.shiftCreate,
      builder: (_, __) => const ShiftFormPage(),
    ),

    GoRoute(
      path: RoutePaths.shiftEdit,
      name: RouteNames.shiftEdit,
      builder: (_, state) {
        final shift = state.extra as ShiftEntity;

        return ShiftFormPage(shift: shift);
      },
    ),

    // Role
    // ===========================================================
    GoRoute(
      path: RoutePaths.roleView,
      name: RouteNames.roleView,
      builder: (context, state) {
        final role = state.extra as RoleEntity;

        return RoleViewPage(role: role);
      },
    ),
    GoRoute(
      path: RoutePaths.roles,
      name: RouteNames.roles,
      builder: (_, __) => const RoleListPage(),
    ),

    GoRoute(
      path: RoutePaths.roleCreate,
      name: RouteNames.roleCreate,
      builder: (_, __) => const RoleFormPage(),
    ),

    GoRoute(
      path: RoutePaths.roleEdit,
      name: RouteNames.roleEdit,
      builder: (_, state) {
        final role = state.extra as RoleEntity;

        return RoleFormPage(role: role);
      },
    ),

    // RolePermissions
    // ===========================================================
    GoRoute(
      path: RoutePaths.rolePermissionsView,
      name: RouteNames.rolePermissionsView,
      builder: (context, state) {
        final data = state.extra as RolePermissionsViewEntity;

        return RolePermissionsViewPage(data: data);
      },
    ),
    GoRoute(
      path: RoutePaths.rolePermissions,
      name: RouteNames.rolePermissions,
      builder: (_, __) => const RolePermissionsListPage(),
    ),

    GoRoute(
      path: RoutePaths.rolePermissionsCreate,
      name: RouteNames.rolePermissionsCreate,
      builder: (_, __) => const RolePermissionsFormPage(),
    ),

    GoRoute(
      path: RoutePaths.rolePermissionsEdit,
      name: RouteNames.rolePermissionsEdit,
      builder: (_, state) {
        final role = state.extra as RolePermissionsEntity;

        return RolePermissionsFormPage(permission: role);
      },
    ),

    // Employee
    GoRoute(
      path: RoutePaths.employees,
      name: RouteNames.employees,
      builder: (context, state) => const EmployeeListPage(),
    ),

    GoRoute(
      path: RoutePaths.employeeCreate,
      name: RouteNames.employeeCreate,
      builder: (context, state) => const EmployeeFormPage(),
    ),

    GoRoute(
      path: RoutePaths.employeeEdit,
      name: RouteNames.employeeEdit,
      builder: (context, state) {
        final employee = state.extra as EmployeeEntity;

        return EmployeeFormPage(employee: employee);
      },
    ),

    GoRoute(
      path: RoutePaths.employeeView,
      name: RouteNames.employeeView,
      builder: (context, state) {
        final employee = state.extra as EmployeeEntity;

        return EmployeeViewPage(employee: employee);
      },
    ),
    // GoRoute(
    //   path: RoutePaths.supervisors,
    //   builder: (context, state) =>
    //   const SupervisorPage(),
    // ),
    GoRoute(
      path: RoutePaths.supervisors,
      name: RouteNames.supervisors,
      builder: (context, state) => const SupervisorPage(),
    ),

    GoRoute(
      path: RoutePaths.supervisorAssignment,
      builder: (context, state) => const SupervisorAssignmentPage(),
    ),

    GoRoute(
      path: RoutePaths.supervisorDepartmentAssignments,
      builder: (context, state) => const SupervisorDepartmentAssignmentPage(),
    ),
    GoRoute(
      path: RoutePaths.supervisorDepartmentManage,
      builder: (context, state) =>
          const SupervisorDepartmentAssignmentManagementPage(),
    ),
    GoRoute(
      path: RoutePaths.supervisorDepartmentStatus,
      builder: (context, state) => const SupervisorDepartmentStatusPage(),
    ),
    GoRoute(
      path: RoutePaths.CompanysupervisorEmployeeAttendanceReport,
      name: 'companySupervisorEmployeeAttendanceReport',
      builder: (context, state) {
        final companyId = state.uri.queryParameters['companyId'];

        if (companyId == null || companyId.trim().isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Company ID not found.',
              ),
            ),
          );
        }

        return CompanySupervisorMobileAttendanceReportPage(
          companyId: companyId,
        );
      },
    ),
    // GoRoute(
    //   path: RoutePaths.CompanysupervisorEmployeeAttendanceReport,
    //   name: 'companySupervisorEmployeeAttendanceReport',
    //   builder: (context, state) {
    //     final companyId =
    //     state.uri.queryParameters['companyId'];
    //
    //     if (companyId == null ||
    //         companyId.trim().isEmpty) {
    //       return const Scaffold(
    //         body: Center(
    //           child: Text(
    //             'Company ID not found.',
    //           ),
    //         ),
    //       );
    //     }
    //
    //     return SupervisorMobileAttendanceReportSelectionPage(
    //       companyId: companyId,
    //     );
    //   },
    // ),

    //-------------------------------------------------------
    // Employee Account List
    //-------------------------------------------------------
    ...EmployeeAccountRoutes.routes,
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
  ];
}

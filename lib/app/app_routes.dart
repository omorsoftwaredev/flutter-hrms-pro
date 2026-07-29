import 'package:go_router/go_router.dart';

import '../core/services/supabase_service.dart';

import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/update_password_page.dart';

import '../features/dashboard/presentation/pages/dashboard_page.dart';

import '../features/company/domain/entities/company_entity.dart';
import '../features/company/presentation/pages/company_form_page.dart';
import '../features/company/presentation/pages/company_list_page.dart';

import '../features/department/domain/entities/department_entity.dart';
import '../features/department/presentation/pages/department_form_page.dart';
import '../features/department/presentation/pages/department_list_page.dart';
import '../features/designation/domain/entities/designation_entity.dart';
import '../features/designation/presentation/pages/designation_form_page.dart';
import '../features/designation/presentation/pages/designation_list_page.dart';
import '../features/shift/domain/entities/shift_entity.dart';
import '../features/shift/presentation/pages/shift_form_page.dart';
import '../features/shift/presentation/pages/shift_list_page.dart';
import '../features/employee/domain/entities/employee_entity.dart';
import '../features/employee/presentation/pages/employee_form_page.dart';
import '../features/employee/presentation/pages/employee_list_page.dart';
final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  redirect: (context, state) {
    final loggedIn =
        SupabaseService.client.auth.currentUser != null;

    final location = state.matchedLocation;

    final isLoginRoute = location == '/login';
    final isForgotPasswordRoute =
        location == '/forgot-password';
    final isUpdatePasswordRoute =
        location == '/update-password';

    if (isUpdatePasswordRoute) {
      return null;
    }

    if (!loggedIn) {
      if (isLoginRoute || isForgotPasswordRoute) {
        return null;
      }

      return '/login';
    }

    if (loggedIn &&
        (isLoginRoute || isForgotPasswordRoute)) {
      return '/dashboard';
    }

    return null;
  },

  routes: [
    /// Root
    GoRoute(
      path: '/',
      redirect: (context, state) {
        final loggedIn =
            SupabaseService.client.auth.currentUser !=
                null;

        return loggedIn
            ? '/dashboard'
            : '/login';
      },
    ),

    /// Login
    GoRoute(
      path: '/login',
      builder: (context, state) =>
      const LoginPage(),
    ),

    /// Forgot Password
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) =>
      const ForgotPasswordPage(),
    ),

    /// Update Password
    GoRoute(
      path: '/update-password',
      builder: (context, state) =>
      const UpdatePasswordPage(),
    ),

    /// Dashboard
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) =>
      const DashboardPage(),

      routes: [
        //=====================================
        // COMPANY
        //=====================================

        GoRoute(
          path: 'companies',
          name: 'companies',
          builder: (context, state) =>
          const CompanyListPage(),
        ),

        GoRoute(
          path: 'companies/add',
          name: 'add-company',
          builder: (context, state) =>
          const CompanyFormPage(),
        ),

        GoRoute(
          path: 'companies/edit',
          name: 'edit-company',
          builder: (context, state) {
            final company =
            state.extra as CompanyEntity;

            return CompanyFormPage(
              company: company,
            );
          },
        ),

        //=====================================
        // DEPARTMENT
        //=====================================

        GoRoute(
          path: 'departments',
          name: 'departments',
          builder: (context, state) =>
          const DepartmentListPage(),
        ),

        GoRoute(
          path: 'departments/add',
          name: 'add-department',
          builder: (context, state) =>
          const DepartmentFormPage(),
        ),

        GoRoute(
          path: 'departments/edit',
          name: 'edit-department',
          builder: (context, state) {
            final department =
            state.extra as DepartmentEntity;

            return DepartmentFormPage(
              department: department,
            );
          },
        ),

        /// ==========================
        /// DESIGNATION
        /// ==========================

        GoRoute(
          path: 'designations',
          name: 'designations',
          builder: (context, state) =>
          const DesignationListPage(),
        ),

        GoRoute(
          path: 'designations/add',
          name: 'add-designation',
          builder: (context, state) =>
          const DesignationFormPage(),
        ),

        GoRoute(
          path: 'designations/edit',
          name: 'edit-designation',
          builder: (context, state) {
            final designation =
            state.extra as DesignationEntity;

            return DesignationFormPage(
              designation: designation,
            );
          },
        ),

        GoRoute(
          path: 'shifts',
          name: 'shifts',
          builder: (context, state) =>
          const ShiftListPage(),
        ),

        GoRoute(
          path: 'shifts/add',
          name: 'add-shift',
          builder: (context, state) =>
          const ShiftFormPage(),
        ),

        GoRoute(
          path: 'shifts/edit',
          name: 'edit-shift',
          builder: (context, state) {
            final shift = state.extra as ShiftEntity;

            return ShiftFormPage(
              shift: shift,
            );
          },
        ),



        //=====================================
// EMPLOYEE
//=====================================

        GoRoute(
          path: 'employees',
          name: 'employees',
          builder: (context, state) =>
          const EmployeeListPage(),
        ),

        GoRoute(
          path: 'employees/add',
          name: 'add-employee',
          builder: (context, state) =>
          const EmployeeFormPage(),
        ),

        GoRoute(
          path: 'employees/edit',
          name: 'edit-employee',
          builder: (context, state) {
            final employee =
            state.extra as EmployeeEntity;

            return EmployeeFormPage(
              employee: employee,
            );
          },
        ),
        //=====================================
        // ATTENDANCE
        //=====================================

        GoRoute(
          path: 'attendance',
          name: 'attendance',
          builder: (context, state) =>
          const DashboardPage(),
        ),

        //=====================================
        // LEAVE
        //=====================================

        GoRoute(
          path: 'leave',
          name: 'leave',
          builder: (context, state) =>
          const DashboardPage(),
        ),
      ],
    ),
  ],
);
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

        //=====================================
        // EMPLOYEE
        //=====================================

        GoRoute(
          path: 'employees',
          name: 'employees',
          builder: (context, state) =>
          const DashboardPage(),
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
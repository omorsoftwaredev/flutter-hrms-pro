import 'package:go_router/go_router.dart';

import '../core/services/supabase_service.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/update_password_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';

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

    /// Always allow Update Password page.
    /// This is required for Supabase Password Recovery.
    if (isUpdatePasswordRoute) {
      return null;
    }

    /// User is NOT logged in
    if (!loggedIn) {
      if (isLoginRoute || isForgotPasswordRoute) {
        return null;
      }

      return '/login';
    }

    /// User IS logged in
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
            SupabaseService.client.auth.currentUser != null;

        return loggedIn
            ? '/dashboard'
            : '/login';
      },
    ),

    /// Login
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
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

    /// Dashboard (Protected)
    GoRoute(
      path: '/dashboard',
      builder: (context, state) =>
      const DashboardPage(),

      routes: [
        /// Employees
        GoRoute(
          path: 'employees',
          builder: (context, state) =>
          const DashboardPage(),
        ),

        /// Attendance
        GoRoute(
          path: 'attendance',
          builder: (context, state) =>
          const DashboardPage(),
        ),

        /// Leave
        GoRoute(
          path: 'leave',
          builder: (context, state) =>
          const DashboardPage(),
        ),
      ],
    ),
  ],
);
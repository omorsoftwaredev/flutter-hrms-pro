import 'package:go_router/go_router.dart';

import '../core/services/supabase_service.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  redirect: (context, state) {
    final loggedIn = SupabaseService.client.auth.currentUser != null;

    final isLoginRoute = state.matchedLocation == '/login';
    final isForgotPasswordRoute =
        state.matchedLocation == '/forgot-password';

    // Allow login & forgot password when logged out
    if (!loggedIn) {
      if (isLoginRoute || isForgotPasswordRoute) {
        return null;
      }

      return '/login';
    }

    // Prevent logged-in users from visiting auth pages
    if (loggedIn &&
        (isLoginRoute || isForgotPasswordRoute)) {
      return '/dashboard';
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        final loggedIn =
            SupabaseService.client.auth.currentUser != null;

        return loggedIn ? '/dashboard' : '/login';
      },
    ),

    // Login
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    // forgot
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),

    // Dashboard (Protected)
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),

      routes: [
        // Employee Module
        GoRoute(
          path: 'employees',
          builder: (context, state) => const DashboardPage(),
        ),

        // Attendance Module
        GoRoute(
          path: 'attendance',
          builder: (context, state) => const DashboardPage(),
        ),

        // Leave Module
        GoRoute(
          path: 'leave',
          builder: (context, state) => const DashboardPage(),
        ),
      ],
    ),
  ],
);
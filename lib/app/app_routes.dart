import 'package:go_router/go_router.dart';

import '../core/services/supabase_service.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  redirect: (context, state) {
    final loggedIn =
        SupabaseService.client.auth.currentUser != null;

    final isLoginRoute = state.matchedLocation == '/login';

    // Not logged in → only login page is allowed
    if (!loggedIn) {
      return isLoginRoute ? null : '/login';
    }

    // Already logged in → prevent going back to login
    if (loggedIn && isLoginRoute) {
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
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

    // User is NOT logged in
    if (!loggedIn) {
      return isLoginRoute ? null : '/login';
    }

    // User IS logged in
    if (loggedIn && isLoginRoute) {
      return '/dashboard';
    }

    // Allow access
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

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
  ],
);
import 'package:go_router/go_router.dart';

import '../core/services/supabase_service.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final loggedIn = SupabaseService.client.auth.currentUser != null;

    if (loggedIn) {
      return '/dashboard';
    }

    return '/login';
  },
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) {
        final loggedIn =
            SupabaseService.client.auth.currentUser != null;

        return loggedIn ? '/dashboard' : '/login';
      },
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (_, __) => const DashboardPage(),
    ),
  ],
);
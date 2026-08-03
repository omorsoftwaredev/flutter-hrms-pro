/// ===============================================================
/// Flutter HRMS Pro
/// App Router
///
/// Version : 0.8.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/pages/dashboard_home_page.dart';

import 'company_dashboard_router.dart';
import 'route_names.dart';
import 'route_paths.dart';
import 'developer_router.dart';
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,

    initialLocation: RoutePaths.splash,

    debugLogDiagnostics: true,

    routes: [
      // ===========================================================
      // Splash
      // ===========================================================

      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // ===========================================================
      // Login
      // ===========================================================

      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),

      // ===========================================================
      // Dashboard
      // ===========================================================

      GoRoute(
        path: RoutePaths.dashboard,
        name: RouteNames.dashboard,
        builder: (context, state) => const DashboardHomePage(),
      ),

      ...DeveloperRouter.routes,
      ...CompanyDashboardRouter.routes,
    ],

    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('404'),
        ),
        body: Center(
          child: Text(
            'Route not found\n\n${state.uri}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    },
  );
}
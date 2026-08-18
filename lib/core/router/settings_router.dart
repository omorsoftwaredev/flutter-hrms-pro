/// ===============================================================
/// Flutter HRMS Pro
/// Settings Router
///
/// Version : 1.0.0
/// ===============================================================

import 'package:go_router/go_router.dart';
import '../../features/settings/presentation/pages/theme_settings_page.dart';
import '../../features/settings/presentation/pages/working_days_settings_page.dart';
import 'route_paths.dart';

class SettingsRouter {
  const SettingsRouter._();

  static List<RouteBase> get routes => [

    // =========================================================
    // THEME
    // =========================================================

    GoRoute(
      path: RoutePaths.themeSettings,
      name: 'themeSettings',
      builder: (context, state) {
        return const ThemeSettingsPage();
      },
    ),

    // =========================================================
    // WORKING DAYS
    // =========================================================

    GoRoute(
      path: RoutePaths.workingDaysSettings,
      name: 'workingDaysSettings',
      builder: (context, state) {
        return const WorkingDaysSettingsPage();
      },
    ),

  ];
}
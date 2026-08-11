/// ===============================================================
/// Flutter HRMS Pro
/// Settings Router
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/settings/presentation/pages/attendance_rules_settings_page.dart';
import '../../features/settings/presentation/pages/attendance_settings_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/theme_settings_page.dart';
import '../../features/settings/presentation/pages/weekend_settings_page.dart';
import '../../features/settings/presentation/pages/working_days_settings_page.dart';
import 'route_paths.dart';

class SettingsRouter {
  const SettingsRouter._();

  static List<RouteBase> get routes => [
    // =========================================================
    // SETTINGS
    // =========================================================

    GoRoute(
      path: RoutePaths.settings,
      name: 'settings',
      builder: (context, state) {
        return const SettingsPage();
      },
    ),

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
    // ATTENDANCE SETTINGS
    // =========================================================

    GoRoute(
      path: RoutePaths.attendanceSettings,
      name: 'attendanceSettings',
      builder: (context, state) {
        return const AttendanceSettingsPage();
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

    GoRoute(
      path: RoutePaths.attendanceRulesSettings,
      name: 'attendanceRulesSettings',
      builder: (context, state) {
        return const AttendanceRulesSettingsPage();
      },
    ),

  ];
}
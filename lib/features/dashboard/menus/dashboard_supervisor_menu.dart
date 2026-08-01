/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Dashboard Menu
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';
import '../widgets/dashboard_menu_item.dart';

class DashboardSupervisorMenu {
  DashboardSupervisorMenu._();

  static const List<DashboardMenuItem> menus = [

    DashboardMenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      route: '/dashboard',
    ),

    DashboardMenuItem(
      title: 'Attendance',
      icon: Icons.fingerprint,
      route: '/dashboard/attendance',
    ),

    DashboardMenuItem(
      title: 'Leave Approval',
      icon: Icons.fact_check,
      route: '/dashboard/leave',
    ),

    DashboardMenuItem(
      title: 'Reports',
      icon: Icons.bar_chart,
      route: '/dashboard/reports',
    ),
  ];
}
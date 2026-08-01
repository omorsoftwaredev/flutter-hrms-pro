/// ===============================================================
/// Flutter HRMS Pro
/// Employee Dashboard Menu
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';
import '../widgets/dashboard_menu_item.dart';

class DashboardEmployeeMenu {
  DashboardEmployeeMenu._();

  static const List<DashboardMenuItem> menus = [

    DashboardMenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      route: '/dashboard',
    ),

    DashboardMenuItem(
      title: 'Mobile Attendance',
      icon: Icons.fingerprint,
      route: '/dashboard/mobile-attendance',
    ),

    DashboardMenuItem(
      title: 'My Leave',
      icon: Icons.event_note,
      route: '/dashboard/leave',
    ),

    DashboardMenuItem(
      title: 'Profile',
      icon: Icons.person,
      route: '/dashboard/profile',
    ),
  ];
}
import 'package:flutter/material.dart';
import '../widgets/dashboard_menu_item.dart';

class DashboardSuperAdminMenu {
  DashboardSuperAdminMenu._();

  static const List<DashboardMenuItem> menus = [
    DashboardMenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      route: '/dashboard',
    ),

    DashboardMenuItem(
      title: 'Companies',
      icon: Icons.business,
      route: '/dashboard/companies',
    ),

    DashboardMenuItem(
      title: 'Departments',
      icon: Icons.apartment,
      route: '/dashboard/departments',
    ),

    DashboardMenuItem(
      title: 'Designations',
      icon: Icons.badge,
      route: '/dashboard/designations',
    ),

    DashboardMenuItem(
      title: 'Shifts',
      icon: Icons.schedule,
      route: '/dashboard/shifts',
    ),

    DashboardMenuItem(
      title: 'Employees',
      icon: Icons.people,
      route: '/dashboard/employees',
    ),

    DashboardMenuItem(
      title: 'Attendance',
      icon: Icons.fingerprint,
      route: '/dashboard/attendance',
    ),

    DashboardMenuItem(
      title: 'Leave',
      icon: Icons.event_note,
      route: '/dashboard/leave',
    ),

    DashboardMenuItem(
      title: 'Reports',
      icon: Icons.bar_chart,
      route: '/dashboard/reports',
    ),

    DashboardMenuItem(
      title: 'Settings',
      icon: Icons.settings,
      route: '/dashboard/settings',
    ),
  ];
}
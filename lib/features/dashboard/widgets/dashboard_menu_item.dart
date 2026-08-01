/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Menu Item
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';

class DashboardMenuItem {
  final String title;

  final IconData icon;

  final String route;

  final Color? color;

  const DashboardMenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.color,
  });

  DashboardMenuItem copyWith({
    String? title,
    IconData? icon,
    String? route,
    Color? color,
  }) {
    return DashboardMenuItem(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return '''
DashboardMenuItem(
  title: $title,
  route: $route,
)
''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashboardMenuItem &&
        other.title == title &&
        other.icon == icon &&
        other.route == route &&
        other.color == color;
  }

  @override
  int get hashCode {
    return title.hashCode ^
    icon.hashCode ^
    route.hashCode ^
    color.hashCode;
  }
}
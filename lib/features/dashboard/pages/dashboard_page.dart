/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Base Page
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';

import '../sidebar/dashboard_sidebar.dart';

class DashboardPage extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const DashboardPage({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DashboardSidebar(),

      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        actions: actions,
      ),

      body: SafeArea(
        child: body,
      ),

      floatingActionButton: floatingActionButton,
    );
  }
}
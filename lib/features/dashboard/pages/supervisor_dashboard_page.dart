/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Dashboard
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';

import '../menus/dashboard_supervisor_menu.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/notification_card.dart';
import '../widgets/quick_menu.dart';
import '../widgets/recent_attendance_card.dart';

class SupervisorDashboardPage extends StatelessWidget {
  const SupervisorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DashboardAppBar(
        title: 'Supervisor Dashboard',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [

            QuickMenu(
              menus: DashboardSupervisorMenu.menus,
            ),

            SizedBox(height: 20),

            RecentAttendanceCard(),

            SizedBox(height: 16),

            NotificationCard(),
          ],
        ),
      ),
    );
  }
}
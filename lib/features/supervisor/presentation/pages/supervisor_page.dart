/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Page
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';

import 'supervisor_assignment_page.dart';
import 'supervisor_crud_page.dart';

class SupervisorPage extends StatelessWidget {
  const SupervisorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Supervisor Management',
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.supervisor_account_outlined,
                ),
                text: 'Supervisors',
              ),
              Tab(
                icon: Icon(
                  Icons.account_tree_outlined,
                ),
                text: 'Department Assignment',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SupervisorCrudPage(),
            SupervisorAssignmentPage(),
          ],
        ),
      ),
    );
  }
}
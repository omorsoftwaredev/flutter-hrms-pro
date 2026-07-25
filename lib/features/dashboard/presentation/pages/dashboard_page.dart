import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/data/repositories/auth_repository.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter HRMS Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
              onPressed: () async {
                await AuthRepository().signOut();

                if (context.mounted) {
                  context.go('/');
                }
              }
          ),
        ],
      ),

      body: const Center(
        child: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
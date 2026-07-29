// lib/features/dashboard/presentation/pages/dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_dashboard_grid.dart';
import '../../../../core/widgets/app_section_title.dart';
import '../../../../core/widgets/app_stat_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),

      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const DrawerHeader(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment:
                  MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.business_center,
                      size: 50,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Flutter HRMS Pro',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () {
                  context.pop();
                  context.go('/dashboard');
                },
              ),

              ListTile(
                leading: const Icon(Icons.business),
                title: const Text('Companies'),
                onTap: () {
                  Navigator.pop(context);

                  Future.microtask(() {
                    if (context.mounted) {
                      context.pushNamed('companies');
                    }
                  });
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.badge_outlined,
                ),
                title: const Text(
                  'Designations',
                ),
                onTap: () {
                  context.go(
                    '/dashboard/designations',
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Employees'),
                onTap: () {},
              ),

              ListTile(
                leading: const Icon(Icons.apartment),
                title: const Text('Departments'),
                onTap: () async {
                  Navigator.of(context).pop();

                  await Future.delayed(
                    const Duration(milliseconds: 200),
                  );

                  if (context.mounted) {
                    context.go('/dashboard/departments');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Shifts'),
                onTap: () async {
                  Navigator.pop(context);

                  await Future.delayed(
                    const Duration(milliseconds: 200),
                  );

                  if (context.mounted) {
                    context.go('/dashboard/shifts');
                  }
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '👋 Welcome Back',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Manage your company from one place.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),

          const SizedBox(height: 24),

          const AppSectionTitle(
            title: 'Overview',
          ),

          const SizedBox(height: 12),

          AppDashboardGrid(
            children: const [
              AppStatCard(
                title: 'Companies',
                value: '1',
                icon: Icons.business,
              ),
              AppStatCard(
                title: 'Employees',
                value: '25',
                icon: Icons.people,
              ),
              AppStatCard(
                title: 'Departments',
                value: '5',
                icon: Icons.apartment,
              ),
              AppStatCard(
                title: 'Attendance',
                value: '18',
                icon: Icons.fingerprint,
              ),
              AppStatCard(
                title: 'Leave',
                value: '2',
                icon: Icons.event_note,
              ),
              AppStatCard(
                title: 'Shifts',
                value: '3',
                icon: Icons.schedule,
              ),
            ],
          ),

          const SizedBox(height: 30),

          const AppSectionTitle(
            title: 'Quick Actions',
          ),

          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.person_add),
            label: const Text('Add Employee'),
          ),

          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: () {
              context.pushNamed('companies');
            },
            icon: const Icon(Icons.business),
            label: const Text('Manage Companies'),
          ),

          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: () {
              context.go('/dashboard/departments');
            },
            icon: const Icon(Icons.apartment),
            label: const Text('Departments'),
          ),


          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              context.go('/dashboard/designations');
            },
            icon: const Icon(Icons.badge_outlined),
            label: const Text('Designations'),
          ),

          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: () {
              context.go('/dashboard/shifts');
            },
            icon: const Icon(Icons.schedule),
            label: const Text('Shifts'),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
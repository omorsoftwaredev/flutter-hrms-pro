// lib/features/dashboard/presentation/pages/dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_dashboard_grid.dart';
import '../../../../core/widgets/app_section_title.dart';
import '../../../../core/widgets/app_stat_card.dart';

import '../widgets/dashboard_menu_grid.dart';

class DashboardPage extends StatelessWidget {
const DashboardPage({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
elevation: 0,
title: const Text(
'Dashboard',
),
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
size: 55,
),

SizedBox(height: 12),

Text(
'Flutter HRMS Pro',
style: TextStyle(
fontSize: 22,
fontWeight:
FontWeight.bold,
),
),

],
),
),

ListTile(
leading:
const Icon(Icons.dashboard),
title:
const Text('Dashboard'),
onTap: () {
context.pop();
context.go('/dashboard');
},
),

ListTile(
leading:
const Icon(Icons.location_on),
title: const Text(
'Mobile Attendance',
),
onTap: () {
context.pop();
context.go(
'/dashboard/mobile-attendance',
);
},
),

ListTile(
leading:
const Icon(Icons.business),
title:
const Text('Companies'),
onTap: () {
Navigator.pop(context);

Future.microtask(() {
if (context.mounted) {
context.pushNamed(
'companies',
);
}
});
},
),

ListTile(
leading: const Icon(
Icons.people,
),
title: const Text(
'Employees',
),
onTap: () async {

Navigator.pop(context);

await Future.delayed(
const Duration(
milliseconds: 150,
),
);

if (context.mounted) {
context.go(
'/dashboard/employees',
);
}
},
),

ListTile(
leading: const Icon(
Icons.apartment,
),
title: const Text(
'Departments',
),
onTap: () async {

Navigator.pop(context);

await Future.delayed(
const Duration(
milliseconds: 150,
),
);

if (context.mounted) {
context.go(
'/dashboard/departments',
);
}
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
leading:
const Icon(Icons.schedule),
title:
const Text('Shifts'),
onTap: () async {

Navigator.pop(context);

await Future.delayed(
const Duration(
milliseconds: 150,
),
);

if (context.mounted) {
context.go(
'/dashboard/shifts',
);
}
},
),

const Divider(),

ListTile(
leading:
const Icon(Icons.logout),
title:
const Text('Logout'),
onTap: () {},
),
],
),
),
),

body: ListView(
padding:
const EdgeInsets.all(16),
children: [

const Text(
'👋 Welcome Back',
style: TextStyle(
fontSize: 26,
fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 6),

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

const SizedBox(height: 16),

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
    title: 'Quick Menu',
  ),

  const SizedBox(height: 16),

  const DashboardMenuGrid(),

  const SizedBox(height: 30),

  const AppSectionTitle(
    title: 'Today\'s Attendance',
  ),

  const SizedBox(height: 12),

  Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          Row(
            children: const [

              Icon(
                Icons.location_on,
                size: 28,
              ),

              SizedBox(width: 10),

              Expanded(
                child: Text(
                  'Mobile Attendance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),

            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Tap below to Check In / Check Out using your current GPS location.',
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {

                context.go(
                  '/dashboard/mobile-attendance',
                );

              },
              icon: const Icon(
                Icons.fingerprint,
              ),
              label: const Text(
                'OPEN MOBILE ATTENDANCE',
              ),
            ),
          ),

        ],
      ),
    ),
  ),

  const SizedBox(height: 30),

  const AppSectionTitle(
    title: 'Recent Activity',
  ),

  const SizedBox(height: 12),

  Card(
    child: Column(
      children: const [

        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.login),
          ),
          title: Text(
            'Check In',
          ),
          subtitle: Text(
            'Today 09:00 AM',
          ),
        ),

        Divider(height: 1),

        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.logout),
          ),
          title: Text(
            'Check Out',
          ),
          subtitle: Text(
            'Today 06:00 PM',
          ),
        ),

      ],
    ),
  ),

  const SizedBox(height: 30),

],
),
);
}
}
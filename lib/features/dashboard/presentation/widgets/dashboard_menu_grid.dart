import 'package:flutter/material.dart';

class DashboardMenuGrid extends StatelessWidget {
  const DashboardMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: const [

        _DashboardMenuCard(
          title: "Mobile Attendance",
          icon: Icons.location_on,
          route: "/mobile-attendance",
        ),

        _DashboardMenuCard(
          title: "Attendance",
          icon: Icons.fact_check,
          route: "/attendance",
        ),

        _DashboardMenuCard(
          title: "Employees",
          icon: Icons.people,
          route: "/employees",
        ),

        _DashboardMenuCard(
          title: "Departments",
          icon: Icons.apartment,
          route: "/departments",
        ),

        _DashboardMenuCard(
          title: "Designations",
          icon: Icons.badge,
          route: "/designations",
        ),

        _DashboardMenuCard(
          title: "Shifts",
          icon: Icons.schedule,
          route: "/shifts",
        ),

        _DashboardMenuCard(
          title: "Reports",
          icon: Icons.bar_chart,
          route: "/reports",
        ),

        _DashboardMenuCard(
          title: "Settings",
          icon: Icons.settings,
          route: "/settings",
        ),
      ],
    );
  }
}

class _DashboardMenuCard extends StatelessWidget {

  final String title;
  final IconData icon;
  final String route;

  const _DashboardMenuCard({
    required this.title,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 2,

      child: InkWell(

        borderRadius:
        BorderRadius.circular(12),

        onTap: () {

          Navigator.pushNamed(
            context,
            route,
          );

        },

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              size: 42,
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
    );
  }
}
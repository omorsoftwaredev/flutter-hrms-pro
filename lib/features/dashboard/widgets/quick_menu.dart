/// ===============================================================
/// Flutter HRMS Pro
/// Quick Menu
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';

import 'dashboard_menu_item.dart';

class QuickMenu extends StatelessWidget {
  final List<DashboardMenuItem> menus;

  const QuickMenu({
    super.key,
    required this.menus,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menus.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: .90,
      ),
      itemBuilder: (context, index) {
        final menu = menus[index];

        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pushNamed(
                context,
                menu.route,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [

                  Icon(
                    menu.icon,
                    size: 32,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    menu.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
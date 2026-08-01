/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard App Bar
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const DashboardAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: Text(title),
      actions: [

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        ),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.account_circle),
        ),

      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}
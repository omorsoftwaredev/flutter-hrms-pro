import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),

      // =========================================================
      // SIDEBAR MENU
      // =========================================================
      leading: Builder(
        builder: (context) {
          return IconButton(
            tooltip: 'Open menu',
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),

      actions: actions,

      elevation: 0,

      centerTitle: false,

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      foregroundColor: Theme.of(context).colorScheme.onSurface,

      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// ===============================================================
/// Flutter HRMS Pro
/// Notification Card
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.notifications),
        ),
        title: const Text("Notifications"),
        subtitle: const Text(
          "No new notifications.",
        ),
      ),
    );
  }
}
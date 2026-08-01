/// ===============================================================
/// Flutter HRMS Pro
/// Welcome Card
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';

class WelcomeCard extends StatelessWidget {
  final String userName;
  final String role;

  const WelcomeCard({
    super.key,
    required this.userName,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              child: Icon(Icons.person),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Welcome Back 👋",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(role),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [

            CircleAvatar(
              radius: 28,
              backgroundColor:
              (color ?? theme.colorScheme.primary)
                  .withOpacity(.12),
              child: Icon(
                icon,
                color:
                color ?? theme.colorScheme.primary,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style:
                    theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    value,
                    style: theme
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
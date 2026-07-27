import 'package:flutter/material.dart';

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 4),

                Text(
                  subtitle!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ]
            ],
          ),
        ),

        if (trailing != null) trailing!,
      ],
    );
  }
}
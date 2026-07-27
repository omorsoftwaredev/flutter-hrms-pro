import 'package:flutter/material.dart';

class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        Row(
          children: [

            Expanded(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge,
              ),
            ),

            if (trailing != null) trailing!,
          ],
        ),

        const SizedBox(height: 16),

        child,
      ],
    );
  }
}
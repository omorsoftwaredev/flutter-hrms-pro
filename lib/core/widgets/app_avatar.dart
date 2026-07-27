import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 24,
  });

  final String? imageUrl;
  final String? name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
      );
    }

    return CircleAvatar(
      radius: radius,
      child: Text(
        name == null || name!.isEmpty
            ? "?"
            : name![0].toUpperCase(),
      ),
    );
  }
}
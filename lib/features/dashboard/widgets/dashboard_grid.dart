/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Grid
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';

class DashboardGrid extends StatelessWidget {
  final List<Widget> children;

  const DashboardGrid({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.30,
      children: children,
    );
  }
}
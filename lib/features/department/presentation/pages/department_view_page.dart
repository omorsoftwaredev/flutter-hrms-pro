import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/department_entity.dart';

class DepartmentViewPage extends StatelessWidget {
  const DepartmentViewPage({
    super.key,
    required this.department,
  });

  final DepartmentEntity department;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppCard(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(
                      Icons.apartment,
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    department.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    department.code,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),

                  const SizedBox(height: 20),

                  AppStatusChip(
                    isActive: department.isActive,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            AppCard(
              child: Column(
                children: [
                  AppDetailTile(
                    icon: Icons.business,
                    title: 'Company ID',
                    value: department.companyId,
                  ),

                  AppDetailTile(
                    icon: Icons.badge,
                    title: 'Department Code',
                    value: department.code,
                  ),

                  AppDetailTile(
                    icon: Icons.apartment,
                    title: 'Department Name',
                    value: department.name,
                  ),

                  AppDetailTile(
                    icon: Icons.description,
                    title: 'Description',
                    value: department.description,
                  ),

                  AppDetailTile(
                    icon: Icons.person,
                    title: 'Manager',
                    value: department.managerName,
                  ),

                  AppDetailTile(
                    icon: Icons.phone,
                    title: 'Phone',
                    value: department.phone,
                  ),

                  AppDetailTile(
                    icon: Icons.email,
                    title: 'Email',
                    value: department.email,
                  ),

                  AppDetailTile(
                    icon: Icons.location_on,
                    title: 'Location',
                    value: department.location,
                  ),

                  AppDetailTile(
                    icon: Icons.access_time,
                    title: 'Created At',
                    value: department.createdAt.toString(),
                  ),

                  AppDetailTile(
                    icon: Icons.update,
                    title: 'Updated At',
                    value: department.updatedAt.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
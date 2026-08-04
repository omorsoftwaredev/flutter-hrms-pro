import 'package:flutter/material.dart';

import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';

import '../../domain/entities/role_entity.dart';

class RoleViewPage extends StatelessWidget {
  const RoleViewPage({
    super.key,
    required this.role,
  });

  final RoleEntity role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Role Details',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    role.roleName,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    role.roleCode,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),

                  const SizedBox(height: 20),

                  AppStatusChip(
                    isActive: role.isActive,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppDetailTile(
                    title: 'Company ID',
                    value: role.companyId,
                  ),

                  AppDetailTile(
                    title: 'Role Code',
                    value: role.roleCode,
                  ),

                  AppDetailTile(
                    title: 'Role Name',
                    value: role.roleName,
                  ),

                  AppDetailTile(
                    title: 'Description',
                    value: role.description.isEmpty
                        ? '-'
                        : role.description,
                  ),

                  AppDetailTile(
                    title: 'Created At',
                    value: role.createdAt.toString(),
                  ),

                  AppDetailTile(
                    title: 'Updated At',
                    value: role.updatedAt?.toString() ?? '-',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
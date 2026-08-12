import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AppCard(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =================================================
              // ROLE HEADER
              // =================================================

              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      child: Icon(
                        Icons.admin_panel_settings,
                        size: 40,
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    Text(
                      role.roleName,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    AppStatusChip(
                      isActive: role.isActive,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // =================================================
              // ROLE DETAILS
              // =================================================

              AppDetailTile(
                title: 'Company ID',
                value: role.companyId,
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
                value:
                role.updatedAt?.toString() ?? '-',
              ),

              AppDetailTile(
                title: 'Created By',
                value:
                role.createdBy?.isNotEmpty == true
                    ? role.createdBy!
                    : '-',
              ),

              AppDetailTile(
                title: 'Updated By',
                value:
                role.updatedBy?.isNotEmpty == true
                    ? role.updatedBy!
                    : '-',
              ),

              const SizedBox(
                height: 20,
              ),

              Align(
                alignment:
                Alignment.centerRight,
                child: AppStatusChip(
                  isActive: role.isActive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
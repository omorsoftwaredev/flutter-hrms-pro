import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/designation_entity.dart';

class DesignationViewPage extends StatelessWidget {
  const DesignationViewPage({
    super.key,
    required this.designation,
  });

  final DesignationEntity designation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Designation Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 34,
                  child: const Icon(
                    Icons.badge_outlined,
                    size: 34,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              AppDetailTile(
                title: 'Company ID',
                value: designation.companyId,
              ),

              AppDetailTile(
                title: 'Designation',
                value: designation.name,
              ),

              AppDetailTile(
                title: 'Description',
                value: designation.description.isEmpty
                    ? '-'
                    : designation.description,
              ),

              AppDetailTile(
                title: 'Created At',
                value: designation.createdAt.toString(),
              ),

              AppDetailTile(
                title: 'Updated At',
                value: designation.updatedAt.toString(),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: AppStatusChip(
                  isActive: designation.isActive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
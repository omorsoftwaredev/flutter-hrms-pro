import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/designation_entity.dart';

class DesignationViewPage extends StatelessWidget {
  const DesignationViewPage({super.key, required this.designation});

  final DesignationEntity designation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // ===========================================================
      // APP BAR
      // ===========================================================
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        title: Text(
          'Designation Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ===========================================================
      // BODY
      // ===========================================================
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final bool isDesktop = width >= 1000;
            final bool isTablet = width >= 600;

            final double horizontalPadding = isDesktop
                ? 32
                : isTablet
                ? 24
                : 14;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                20,
                horizontalPadding,
                32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // =========================================
                        // HEADER
                        // =========================================
                        _buildHeader(context),

                        const SizedBox(height: 24),

                        Divider(height: 1, color: colorScheme.outlineVariant),

                        const SizedBox(height: 12),

                        // =========================================
                        // COMPANY ID
                        // =========================================
                        AppDetailTile(
                          title: 'Company ID',
                          value: designation.companyId,
                        ),

                        // =========================================
                        // DESIGNATION
                        // =========================================
                        AppDetailTile(
                          title: 'Designation',
                          value: designation.name,
                        ),

                        // =========================================
                        // DESCRIPTION
                        // =========================================
                        AppDetailTile(
                          title: 'Description',
                          value: designation.description.isEmpty
                              ? '-'
                              : designation.description,
                        ),

                        // =========================================
                        // CREATED AT
                        // =========================================
                        AppDetailTile(
                          title: 'Created At',
                          value: designation.createdAt.toString(),
                        ),

                        // =========================================
                        // UPDATED AT
                        // =========================================
                        AppDetailTile(
                          title: 'Updated At',
                          value: designation.updatedAt.toString(),
                        ),

                        const SizedBox(height: 20),

                        // =========================================
                        // STATUS
                        // =========================================
                        Align(
                          alignment: Alignment.centerRight,
                          child: AppStatusChip(isActive: designation.isActive),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // =============================================================
  // HEADER
  // =============================================================

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxWidth < 420;

        return Column(
          children: [
            // ===================================================
            // ICON
            // ===================================================
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.badge_outlined,
                size: 38,
                color: colorScheme.onPrimaryContainer,
              ),
            ),

            const SizedBox(height: 14),

            // ===================================================
            // DESIGNATION NAME
            // ===================================================
            Text(
              designation.name,
              textAlign: TextAlign.center,
              maxLines: compact ? 3 : 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            // ===================================================
            // STATUS
            // ===================================================
            AppStatusChip(isActive: designation.isActive),
          ],
        );
      },
    );
  }
}

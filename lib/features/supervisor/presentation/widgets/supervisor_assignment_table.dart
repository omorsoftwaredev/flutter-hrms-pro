/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Assignment Table
///
/// Version : 3.1.0
///
/// UI Update:
/// - Theme aware
/// - Light / Dark mode support
/// - Material 3 ColorScheme
/// - Responsive desktop/tablet/mobile layout
/// - Desktop: DataTable
/// - Mobile: Assignment cards
/// - Modern HRMS UI
/// - Existing callbacks preserved
/// - No functionality changed
/// ===============================================================

import 'package:flutter/material.dart';

class SupervisorAssignmentTable extends StatelessWidget {
  final List<Map<String, dynamic>> assignments;
  final List<Map<String, dynamic>> unassignedDepartments;

  final ValueChanged<Map<String, dynamic>>? onUnassign;
  final ValueChanged<Map<String, dynamic>>? onAssign;

  const SupervisorAssignmentTable({
    super.key,
    required this.assignments,
    this.unassignedDepartments = const [],
    this.onUnassign,
    this.onAssign,
  });

  // =============================================================
  // VALUE
  // =============================================================

  String _value(
      Map<String, dynamic> data,
      String key,
      ) {
    final value = data[key];

    if (value == null) {
      return '-';
    }

    final text = value.toString().trim();

    return text.isEmpty ? '-' : text;
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isMobile = width < 600;
        final bool isTablet = width >= 600 && width < 900;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // ASSIGNED HEADER
            // =====================================================

            _sectionHeader(
              context,
              icon: Icons.link_outlined,
              title: 'Assigned Departments',
              count: assignments.length,
            ),

            const SizedBox(height: 12),

            // =====================================================
            // ASSIGNED
            // =====================================================

            isMobile
                ? _buildAssignedMobile(context)
                : _buildAssignedTable(
              context,
              isTablet: isTablet,
            ),

            const SizedBox(height: 28),

            // =====================================================
            // UNASSIGNED HEADER
            // =====================================================

            _sectionHeader(
              context,
              icon: Icons.link_off_outlined,
              title: 'Unassigned Departments',
              count: unassignedDepartments.length,
            ),

            const SizedBox(height: 12),

            // =====================================================
            // UNASSIGNED
            // =====================================================

            _buildUnassignedList(
              context,
              isMobile: isMobile,
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // SECTION HEADER
  // =============================================================

  Widget _sectionHeader(
      BuildContext context, {
        required IconData icon,
        required String title,
        required int count,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: colorScheme.onPrimaryContainer,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Container(
          constraints: const BoxConstraints(
            minWidth: 32,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // DESKTOP / TABLET TABLE
  // =============================================================

  Widget _buildAssignedTable(
      BuildContext context, {
        required bool isTablet,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (assignments.isEmpty) {
      return _emptyCard(
        context,
        icon: Icons.link_off_outlined,
        text: 'No department assignment found',
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: isTablet ? 24 : 36,
          horizontalMargin: isTablet ? 14 : 18,
          headingRowHeight: 52,
          dataRowMinHeight: 62,
          dataRowMaxHeight: 70,

          dividerThickness: 0.6,

          headingRowColor:
          WidgetStateProperty.resolveWith<Color?>(
                (states) {
              return colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.45);
            },
          ),

          headingTextStyle:
          theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),

          columns: const [
            DataColumn(
              label: Text('Supervisor'),
            ),
            DataColumn(
              label: Text('Department'),
            ),
            DataColumn(
              label: Text('Status'),
            ),
            DataColumn(
              label: Text('Action'),
            ),
          ],

          rows: assignments.map((assignment) {
            final supervisorName = _value(
              assignment,
              'supervisor_name',
            );

            final departmentName = _value(
              assignment,
              'department_name',
            );

            return DataRow(
              cells: [
                // =================================================
                // SUPERVISOR
                // =================================================

                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _avatar(
                        context,
                        Icons.supervisor_account_outlined,
                      ),

                      const SizedBox(width: 10),

                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 150 : 190,
                        ),
                        child: Text(
                          supervisorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                          theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // =================================================
                // DEPARTMENT
                // =================================================

                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.apartment_outlined,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),

                      const SizedBox(width: 7),

                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 170 : 210,
                        ),
                        child: Text(
                          departmentName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                          theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // =================================================
                // STATUS
                // =================================================

                DataCell(
                  _statusChip(
                    context,
                    'Assigned',
                    colorScheme.primary,
                  ),
                ),

                // =================================================
                // ACTION
                // =================================================

                DataCell(
                  IconButton(
                    tooltip: 'Unassign',
                    onPressed: onUnassign == null
                        ? null
                        : () {
                      onUnassign!(assignment);
                    },
                    icon: Icon(
                      Icons.link_off_outlined,
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // =============================================================
  // MOBILE ASSIGNED LIST
  // =============================================================

  Widget _buildAssignedMobile(
      BuildContext context,
      ) {
    if (assignments.isEmpty) {
      return _emptyCard(
        context,
        icon: Icons.link_off_outlined,
        text: 'No department assignment found',
      );
    }

    return Column(
      children: assignments.map((assignment) {
        final supervisorName = _value(
          assignment,
          'supervisor_name',
        );

        final departmentName = _value(
          assignment,
          'department_name',
        );

        return _assignmentCard(
          context,
          assignment: assignment,
          supervisorName: supervisorName,
          departmentName: departmentName,
        );
      }).toList(),
    );
  }

  // =============================================================
  // ASSIGNMENT CARD
  // =============================================================

  Widget _assignmentCard(
      BuildContext context, {
        required Map<String, dynamic> assignment,
        required String supervisorName,
        required String departmentName,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // ===================================================
            // TOP
            // ===================================================

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _avatar(
                  context,
                  Icons.supervisor_account_outlined,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        supervisorName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                        theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.apartment_outlined,
                            size: 16,
                            color:
                            colorScheme.onSurfaceVariant,
                          ),

                          const SizedBox(width: 5),

                          Expanded(
                            child: Text(
                              departmentName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:
                              theme.textTheme.bodySmall?.copyWith(
                                color:
                                colorScheme.onSurfaceVariant,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                _statusChip(
                  context,
                  'Assigned',
                  colorScheme.primary,
                ),
              ],
            ),

            const SizedBox(height: 13),

            Divider(
              height: 1,
              color: colorScheme.outlineVariant,
            ),

            const SizedBox(height: 10),

            // ===================================================
            // UNASSIGN
            // ===================================================

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onUnassign == null
                    ? null
                    : () {
                  onUnassign!(assignment);
                },
                icon: Icon(
                  Icons.link_off_outlined,
                  size: 18,
                ),
                label: const Text(
                  'Unassign Department',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.error,
                  side: BorderSide(
                    color: colorScheme.error
                        .withValues(alpha: 0.45),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // UNASSIGNED LIST
  // =============================================================

  Widget _buildUnassignedList(
      BuildContext context, {
        required bool isMobile,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (unassignedDepartments.isEmpty) {
      return _emptyCard(
        context,
        icon: Icons.check_circle_outline,
        text: 'All departments are assigned',
      );
    }

    return Column(
      children: unassignedDepartments.map((department) {
        final name = _value(
          department,
          'name',
        );

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              isMobile ? 14 : 16,
            ),
            child: isMobile
                ? _buildMobileUnassigned(
              context,
              department,
              name,
            )
                : _buildDesktopUnassigned(
              context,
              department,
              name,
            ),
          ),
        );
      }).toList(),
    );
  }

  // =============================================================
  // MOBILE UNASSIGNED
  // =============================================================

  Widget _buildMobileUnassigned(
      BuildContext context,
      Map<String, dynamic> department,
      String name,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          children: [
            _avatar(
              context,
              Icons.apartment_outlined,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                    theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'No supervisor assigned',
                    style:
                    theme.textTheme.bodySmall?.copyWith(
                      color:
                      colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onAssign == null
                ? null
                : () {
              onAssign!(department);
            },
            icon: const Icon(
              Icons.link,
              size: 18,
            ),
            label: const Text(
              'Assign Department',
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // DESKTOP UNASSIGNED
  // =============================================================

  Widget _buildDesktopUnassigned(
      BuildContext context,
      Map<String, dynamic> department,
      String name,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        _avatar(
          context,
          Icons.apartment_outlined,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'No supervisor assigned',
                style:
                theme.textTheme.bodySmall?.copyWith(
                  color:
                  colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        FilledButton.icon(
          onPressed: onAssign == null
              ? null
              : () {
            onAssign!(department);
          },
          icon: const Icon(
            Icons.link,
            size: 18,
          ),
          label: const Text(
            'Assign',
          ),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 11,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(11),
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // AVATAR
  // =============================================================

  Widget _avatar(
      BuildContext context,
      IconData icon,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 21,
        color: colorScheme.onPrimaryContainer,
      ),
    );
  }

  // =============================================================
  // STATUS CHIP
  // =============================================================

  Widget _statusChip(
      BuildContext context,
      String text,
      Color color,
      ) {
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 6),

          Text(
            text,
            style:
            theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // EMPTY CARD
  // =============================================================

  Widget _emptyCard(
      BuildContext context, {
        required IconData icon,
        required String text,
      }) {
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color:
              colorScheme.onPrimaryContainer,
              size: 25,
            ),
          ),

          const SizedBox(height: 11),

          Text(
            text,
            textAlign: TextAlign.center,
            style:
            theme.textTheme.bodyMedium?.copyWith(
              color:
              colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
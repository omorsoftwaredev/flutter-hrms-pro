/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Assignment Table
///
/// Version : 3.0.0
///
/// Features:
/// - Theme aware
/// - Light / Dark mode support
/// - Responsive desktop/tablet/mobile layout
/// - Desktop: DataTable
/// - Mobile: Assignment cards
/// - Modern HRMS UI
/// - Existing callbacks preserved
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

  String _value(Map<String, dynamic> data, String key) {
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
        final isMobile = constraints.maxWidth < 600;

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
                : _buildAssignedTable(context),

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
            _buildUnassignedList(context),
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
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 20, color: colorScheme.primary),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // DESKTOP / TABLET TABLE
  // =============================================================

  Widget _buildAssignedTable(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (assignments.isEmpty) {
      return _emptyCard(
        context,
        icon: Icons.link_off_outlined,
        text: 'No department assignment found',
      );
    }

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.18)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 36,
          horizontalMargin: 18,
          headingRowHeight: 52,
          dataRowMinHeight: 62,
          dataRowMaxHeight: 70,

          headingTextStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),

          columns: const [
            DataColumn(label: Text('Supervisor')),
            DataColumn(label: Text('Department')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Action')),
          ],

          rows: assignments.map((assignment) {
            final supervisorName = _value(assignment, 'supervisor_name');

            final departmentName = _value(assignment, 'department_name');

            return DataRow(
              cells: [
                // =============================================
                // SUPERVISOR
                // =============================================
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _avatar(context, Icons.supervisor_account_outlined),

                      const SizedBox(width: 10),

                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: Text(
                          supervisorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // =============================================
                // DEPARTMENT
                // =============================================
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.apartment_outlined,
                        size: 18,
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                      ),

                      const SizedBox(width: 7),

                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Text(
                          departmentName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // =============================================
                // STATUS
                // =============================================
                DataCell(_statusChip(context, 'Assigned', colorScheme.primary)),

                // =============================================
                // ACTION
                // =============================================
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

  Widget _buildAssignedMobile(BuildContext context) {
    if (assignments.isEmpty) {
      return _emptyCard(
        context,
        icon: Icons.link_off_outlined,
        text: 'No department assignment found',
      );
    }

    return Column(
      children: assignments.map((assignment) {
        final supervisorName = _value(assignment, 'supervisor_name');

        final departmentName = _value(assignment, 'department_name');

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

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _avatar(context, Icons.supervisor_account_outlined),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supervisorName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Icon(
                            Icons.apartment_outlined,
                            size: 16,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.55,
                            ),
                          ),

                          const SizedBox(width: 5),

                          Expanded(
                            child: Text(
                              departmentName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.60,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                _statusChip(context, 'Assigned', colorScheme.primary),
              ],
            ),

            const SizedBox(height: 12),

            Divider(
              height: 1,
              color: colorScheme.outline.withValues(alpha: 0.15),
            ),

            const SizedBox(height: 10),

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
                  size: 19,
                  color: colorScheme.error,
                ),
                label: Text(
                  'Unassign Department',
                  style: TextStyle(color: colorScheme.error),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.error,
                  side: BorderSide(
                    color: colorScheme.error.withValues(alpha: 0.45),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
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

  Widget _buildUnassignedList(BuildContext context) {
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
        final name = _value(department, 'name');

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // =============================================
                // ICON
                // =============================================
                _avatar(context, Icons.apartment_outlined),

                const SizedBox(width: 12),

                // =============================================
                // NAME
                // =============================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'No supervisor assigned',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // =============================================
                // ASSIGN
                // =============================================
                FilledButton.icon(
                  onPressed: onAssign == null
                      ? null
                      : () {
                          onAssign!(department);
                        },
                  icon: const Icon(Icons.link, size: 18),
                  label: const Text('Assign'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // =============================================================
  // AVATAR
  // =============================================================

  Widget _avatar(BuildContext context, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 21, color: colorScheme.primary),
    );
  }

  // =============================================================
  // STATUS CHIP
  // =============================================================

  Widget _statusChip(BuildContext context, String text, Color color) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),

          const SizedBox(width: 6),

          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
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
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.18)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: colorScheme.primary.withValues(alpha: 0.70),
              size: 25,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.60),
            ),
          ),
        ],
      ),
    );
  }
}

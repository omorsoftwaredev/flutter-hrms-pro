/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Department Assignment Page
///
/// Version : 2.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../supervisor/presentation/providers/supervisor_provider.dart';
import '../../../supervisor/presentation/widgets/supervisor_assignment_table.dart';

class SupervisorAssignmentPage extends ConsumerStatefulWidget {
  const SupervisorAssignmentPage({
    super.key,
  });

  @override
  ConsumerState<SupervisorAssignmentPage> createState() =>
      _SupervisorAssignmentPageState();
}

class _SupervisorAssignmentPageState
    extends ConsumerState<SupervisorAssignmentPage> {
  String? _selectedSupervisor;
  String? _selectedDepartment;

  // =============================================================
  // RESPONSIVE CONTENT WIDTH
  // =============================================================

  double _maxContentWidth(double width) {
    if (width >= 1400) {
      return 1150;
    }

    if (width >= 1100) {
      return 1000;
    }

    if (width >= 700) {
      return 760;
    }

    return double.infinity;
  }

  // =============================================================
  // RESPONSIVE HORIZONTAL PADDING
  // =============================================================

  double _horizontalPadding(double width) {
    if (width >= 1200) {
      return 28;
    }

    if (width >= 700) {
      return 22;
    }

    return 14;
  }

  // =============================================================
  // PAGE HEADER
  // =============================================================

  Widget _buildHeader(
      BuildContext context,
      double width,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width >= 700 ? 48 : 44,
              height: width >= 700 ? 48 : 44,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.account_tree_outlined,
                color: colorScheme.onPrimaryContainer,
                size: width >= 700 ? 25 : 23,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Department Assignment',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.3,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Assign or unassign departments to supervisors.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =============================================================
  // ASSIGNMENT CARD
  // =============================================================

  Widget _buildAssignmentCard(
      BuildContext context,
      double width,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isReady =
        _selectedSupervisor != null &&
            _selectedDepartment != null;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          width >= 700 ? 24 : 18,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // =====================================================
            // CARD HEADER
            // =====================================================

            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.link_outlined,
                    color:
                    colorScheme.onPrimaryContainer,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assign Department',
                        style: theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        'Select a supervisor and department.',
                        style: theme
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // =====================================================
            // RESPONSIVE FORM
            // =====================================================

            if (width >= 800)
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSupervisorDropdown(
                      context,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: _buildDepartmentDropdown(
                      context,
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildSupervisorDropdown(
                    context,
                  ),

                  const SizedBox(height: 14),

                  _buildDepartmentDropdown(
                    context,
                  ),
                ],
              ),

            const SizedBox(height: 18),

            // =====================================================
            // ASSIGN BUTTON
            // =====================================================

            SizedBox(
              width: double.infinity,
              height: width >= 700 ? 50 : 48,
              child: FilledButton.icon(
                onPressed: !isReady
                    ? null
                    : () {
                  // Assignment action
                  //
                  // এখানে তোমার existing
                  // SupervisorNotifier method
                  // call করবে।
                },
                icon: const Icon(
                  Icons.link,
                  size: 20,
                ),
                label: const Text(
                  'Assign Department',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // SUPERVISOR DROPDOWN
  // =============================================================

  Widget _buildSupervisorDropdown(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DropdownButtonFormField<String>(
      value: _selectedSupervisor,
      decoration: InputDecoration(
        labelText: 'Supervisor',
        hintText: 'Select supervisor',
        prefixIcon: Icon(
          Icons.supervisor_account_outlined,
          color: colorScheme.primary,
        ),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
      ),

      items: const [],

      onChanged: (value) {
        setState(() {
          _selectedSupervisor = value;
        });
      },

      hint: const Text(
        'Select supervisor',
      ),
    );
  }

  // =============================================================
  // DEPARTMENT DROPDOWN
  // =============================================================

  Widget _buildDepartmentDropdown(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DropdownButtonFormField<String>(
      value: _selectedDepartment,
      decoration: InputDecoration(
        labelText: 'Department',
        hintText: 'Select department',
        prefixIcon: Icon(
          Icons.apartment_outlined,
          color: colorScheme.primary,
        ),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
      ),

      items: const [],

      onChanged: (value) {
        setState(() {
          _selectedDepartment = value;
        });
      },

      hint: const Text(
        'Select department',
      ),
    );
  }

  // =============================================================
  // ASSIGNMENT TABLE SECTION
  // =============================================================

  Widget _buildAssignmentTable(
      BuildContext context,
      double width,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          width >= 700 ? 20 : 14,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                    colorScheme.secondaryContainer,
                    borderRadius:
                    BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.table_rows_outlined,
                    color:
                    colorScheme.onSecondaryContainer,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    'Current Assignments',
                    style: theme
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Existing functionality/widget unchanged.
            const SupervisorAssignmentTable(
              assignments: [],
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final supervisorState = ref.watch(
      supervisorProvider,
    );

    final size =
    MediaQuery.sizeOf(context);

    final width = size.width;

    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Scaffold(
      backgroundColor:
      colorScheme.surfaceContainerLowest,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final horizontalPadding =
            _horizontalPadding(
              constraints.maxWidth,
            );

            return ListView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                width >= 700 ? 24 : 18,
                horizontalPadding,
                30,
              ),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                      _maxContentWidth(
                        constraints.maxWidth,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                      children: [
                        // =========================================
                        // HEADER
                        // =========================================

                        _buildHeader(
                          context,
                          constraints.maxWidth,
                        ),

                        const SizedBox(
                          height: 22,
                        ),

                        // =========================================
                        // ASSIGNMENT ACTION
                        // =========================================

                        _buildAssignmentCard(
                          context,
                          constraints.maxWidth,
                        ),

                        const SizedBox(
                          height: 22,
                        ),

                        // =========================================
                        // ASSIGNMENT TABLE
                        // =========================================

                        _buildAssignmentTable(
                          context,
                          constraints.maxWidth,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
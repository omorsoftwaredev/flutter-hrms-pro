import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';

import '../providers/employee_provider.dart';
import '../widgets/employee_card.dart';

class EmployeeListPage extends ConsumerStatefulWidget {
  const EmployeeListPage({super.key});

  @override
  ConsumerState<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends ConsumerState<EmployeeListPage> {
  // =============================================================
  // SEARCH CONTROLLER
  // =============================================================

  final TextEditingController _searchController = TextEditingController();

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(employeeProvider.notifier).loadEmployees();
    });
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // =============================================================
  // REFRESH
  // =============================================================

  Future<void> _refresh() async {
    await ref.read(employeeProvider.notifier).refresh();
  }

  // =============================================================
  // DELETE DIALOG
  // =============================================================

  Future<bool?> _deleteDialog(BuildContext context, String employeeName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Employee'),
          content: Text(
            'Are you sure you want to delete '
            '"$employeeName"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // SUCCESS SNACKBAR
  // =============================================================

  void _showSuccessSnackBar(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.fixed,
          backgroundColor: colorScheme.inverseSurface,
          elevation: 0,
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 20,
                color: colorScheme.onInverseSurface,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onInverseSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // =============================================================
  // ERROR SNACKBAR
  // =============================================================

  void _showErrorSnackBar(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: colorScheme.error,
          behavior: SnackBarBehavior.fixed,
          content: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 20,
                color: colorScheme.onError,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onError,
                  ),
                ),
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
    final state = ref.watch(employeeProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // =========================================================
      // APP BAR
      // =========================================================
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,

        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RoutePaths.companyDashboard);
            }
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),

        title: Text(
          'Employees',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(RoutePaths.employeeCreate);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 2,
        icon: const Icon(
          Icons.person_add_alt_1_rounded,
        ),
        label: const Text(
          'Add Employee',
        ),
      ),
      // =========================================================
      // BODY
      // =========================================================
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            // ===================================================
            // RESPONSIVE BREAKPOINTS
            // ===================================================

            final bool isDesktop = width >= 1000;

            final bool isTablet = width >= 600;

            final double horizontalPadding = isDesktop
                ? 32
                : isTablet
                ? 24
                : 14;

            final double maxContentWidth = isDesktop ? 1200 : 800;

            return RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  100,
                ),

                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // =========================================
                        // SEARCH
                        // =========================================
                        AppSearchField(
                          controller: _searchController,
                          onChanged: (value) {
                            ref.read(employeeProvider.notifier).search(value);
                          },
                        ),

                        const SizedBox(height: 18),

                        // =========================================
                        // SECTION TITLE
                        // =========================================
                        AppSectionTitle(
                          title:
                              'Employee List '
                              '(${state.filteredEmployees.length})',
                        ),

                        const SizedBox(height: 12),

                        // =========================================
                        // CONTENT
                        // =========================================
                        if (state.isLoading)
                          const Padding(
                            padding: EdgeInsets.only(top: 80),
                            child: AppLoading(),
                          )
                        else if (state.filteredEmployees.isEmpty)
                          _buildEmptyState(context)
                        else
                          _buildEmployeeList(
                            context,
                            state,
                            isDesktop: isDesktop,
                          ),

                        const SizedBox(height: 20),
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
  // EMPTY STATE
  // =============================================================

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: const AppEmpty(title: 'No Employee Found'),
      ),
    );
  }

  // =============================================================
  // EMPLOYEE LIST
  // =============================================================

  Widget _buildEmployeeList(
    BuildContext context,
    dynamic state, {
    required bool isDesktop,
  }) {
    final employees = state.filteredEmployees;

    // ===========================================================
    // DESKTOP GRID
    // ===========================================================

    if (isDesktop) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: employees.length,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.55,
        ),

        itemBuilder: (context, index) {
          return _buildEmployeeCard(context, employees[index]);
        },
      );
    }

    // ===========================================================
    // MOBILE / TABLET
    // ===========================================================

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: employees.length,

      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },

      itemBuilder: (context, index) {
        return _buildEmployeeCard(context, employees[index]);
      },
    );
  }

  // =============================================================
  // EMPLOYEE CARD
  // =============================================================

  Widget _buildEmployeeCard(BuildContext context, dynamic employee) {
    return EmployeeCard(
      employee: employee,

      // =========================================================
      // VIEW
      // =========================================================
      onView: () {
        context.push(RoutePaths.employeeView, extra: employee);
      },

      // =========================================================
      // EDIT
      // =========================================================
      onEdit: () {
        context.push(RoutePaths.employeeEdit, extra: employee);
      },

      // =========================================================
      // TOGGLE STATUS
      // =========================================================
      onToggleStatus: () async {
        try {
          await ref
              .read(employeeProvider.notifier)
              .toggleEmployeeStatus(employee);

          if (!context.mounted) {
            return;
          }

          _showSuccessSnackBar(
            context,
            employee.isActive
                ? 'Employee deactivated successfully.'
                : 'Employee activated successfully.',
          );
        } catch (e) {
          if (!context.mounted) {
            return;
          }

          _showErrorSnackBar(context, e.toString());
        }
      },

      // =========================================================
      // DELETE
      // =========================================================
      onDelete: () async {
        final employeeName = employee.fullName.trim().isNotEmpty
            ? employee.fullName
            : employee.firstName;

        final confirm = await _deleteDialog(context, employeeName);

        if (confirm != true) {
          return;
        }

        try {
          await ref.read(employeeProvider.notifier).deleteEmployee(employee.id);

          if (!context.mounted) {
            return;
          }

          _showSuccessSnackBar(context, '$employeeName deleted successfully.');
        } catch (e) {
          if (!context.mounted) {
            return;
          }

          _showErrorSnackBar(context, e.toString());
        }
      },
    );
  }
}

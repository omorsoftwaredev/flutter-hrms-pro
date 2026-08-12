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
  ConsumerState<EmployeeListPage> createState() =>
      _EmployeeListPageState();
}

class _EmployeeListPageState
    extends ConsumerState<EmployeeListPage> {
  final _searchController = TextEditingController();

  // ===========================================================
  // INIT
  // ===========================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(employeeProvider.notifier)
          .loadEmployees();
    });
  }

  // ===========================================================
  // DISPOSE
  // ===========================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ===========================================================
  // REFRESH
  // ===========================================================

  Future<void> _refresh() async {
    await ref
        .read(employeeProvider.notifier)
        .refresh();
  }

  // ===========================================================
  // DELETE DIALOG
  // ===========================================================

  Future<bool?> _deleteDialog(
      String employeeName,
      ) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Employee',
        ),
        content: Text(
          'Are you sure you want to delete "$employeeName"?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                false,
              );
            },
            child: const Text(
              'Cancel',
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(
                context,
                true,
              );
            },
            child: const Text(
              'Delete',
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // BUILD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      employeeProvider,
    );

    return Scaffold(
      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(
                RoutePaths.companyDashboard,
              );
            }
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: const Text(
          'Employees',
        ),
      ),

      // =======================================================
      // ADD EMPLOYEE
      // =======================================================

      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: () {
          context.push(
            RoutePaths.employeeCreate,
          );
        },
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add',
        ),
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =================================================
            // SEARCH
            // =================================================

            AppSearchField(
              controller: _searchController,
              onChanged: (value) {
                ref
                    .read(
                  employeeProvider.notifier,
                )
                    .search(value);
              },
            ),

            const SizedBox(
              height: 20,
            ),

            // =================================================
            // SECTION TITLE
            // =================================================

            AppSectionTitle(
              title:
              'Employee List (${state.filteredEmployees.length})',
            ),

            const SizedBox(
              height: 12,
            ),

            // =================================================
            // EMPLOYEE LIST
            // =================================================

            Expanded(
              child: Builder(
                builder: (_) {
                  // =========================================
                  // LOADING
                  // =========================================

                  if (state.isLoading) {
                    return const AppLoading();
                  }

                  // =========================================
                  // EMPTY
                  // =========================================

                  if (state.filteredEmployees.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(
                        physics:
                        const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(
                            height: 120,
                          ),
                          AppEmpty(
                            title:
                            'No Employee Found',
                          ),
                        ],
                      ),
                    );
                  }

                  // =========================================
                  // LIST
                  // =========================================

                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.separated(
                      physics:
                      const AlwaysScrollableScrollPhysics(),

                      itemCount:
                      state.filteredEmployees.length,

                      separatorBuilder:
                          (_, __) =>
                      const SizedBox(
                        height: 12,
                      ),

                      itemBuilder:
                          (_, index) {
                        final employee =
                        state.filteredEmployees[
                        index];

                        return EmployeeCard(
                          employee: employee,

                          // =================================
                          // VIEW
                          // =================================

                          onView: () {
                            context.push(
                              RoutePaths.employeeView,
                              extra: employee,
                            );
                          },

                          // =================================
                          // EDIT
                          // =================================

                          onEdit: () {
                            context.push(
                              RoutePaths.employeeEdit,
                              extra: employee,
                            );
                          },

                          // =================================
                          // TOGGLE STATUS
                          // =================================

                          onToggleStatus: () async {
                            try {
                              await ref
                                  .read(
                                employeeProvider
                                    .notifier,
                              )
                                  .toggleEmployeeStatus(
                                employee,
                              );

                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    employee.isActive
                                        ? 'Employee deactivated successfully.'
                                        : 'Employee activated successfully.',
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                  Colors.red,
                                  content: Text(
                                    e.toString(),
                                  ),
                                ),
                              );
                            }
                          },

                          // =================================
                          // DELETE
                          // =================================

                          onDelete: () async {
                            final employeeName =
                            employee.fullName.trim().isNotEmpty
                                ? employee.fullName
                                : employee.firstName;

                            final confirm =
                            await _deleteDialog(
                              employeeName,
                            );

                            if (confirm != true) {
                              return;
                            }

                            try {
                              await ref
                                  .read(
                                employeeProvider
                                    .notifier,
                              )
                                  .deleteEmployee(
                                employee.id,
                              );

                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '$employeeName deleted successfully.',
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                  Colors.red,
                                  content: Text(
                                    e.toString(),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
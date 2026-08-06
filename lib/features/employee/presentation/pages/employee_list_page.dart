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
  final _searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(employeeProvider.notifier)
          .loadEmployees();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<bool?> _deleteDialog() {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Employee',
        ),
        content: const Text(
          'Are you sure you want to delete this employee?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                false,
              );
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(
                context,
                true,
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state =
    ref.watch(employeeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
      ),

      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: () {
          context.push(
            RoutePaths.employeeCreate,
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(16),
        child: Column(
          children: [

            AppSearchField(
              controller:
              _searchController,
              onChanged: (value) {
                ref
                    .read(
                  employeeProvider
                      .notifier,
                )
                    .search(value);
              },
            ),

            const SizedBox(height: 20),

            AppSectionTitle(
              title:
              'Employee List (${state.filteredEmployees.length})',
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Builder(
                builder: (_) {

                  if (state.isLoading) {
                    return const AppLoading();
                  }

                  if (state
                      .filteredEmployees
                      .isEmpty) {
                    return const AppEmpty(
                      title:
                      'No Employee Found',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      return ref
                          .read(
                        employeeProvider
                            .notifier,
                      )
                          .refresh();
                    },
                    child:
                    ListView.separated(
                      physics:
                      const AlwaysScrollableScrollPhysics(),

                      itemCount: state
                          .filteredEmployees
                          .length,

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

                        return
                          EmployeeCard(
                            employee: employee,

                            onView: () {
                              context.push(
                                RoutePaths.employeeView,
                                extra: employee,
                              );
                            },

                            onEdit: () {
                              context.push(
                                RoutePaths.employeeEdit,
                                extra: employee,
                              );
                            },

                            onToggleStatus: () async {
                              await ref
                                  .read(employeeProvider.notifier)
                                  .toggleEmployeeStatus(employee);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      employee.isActive
                                          ? 'Employee deactivated successfully'
                                          : 'Employee activated successfully',
                                    ),
                                  ),
                                );
                              }
                            },

                            onDelete: () async {
                              final delete = await _deleteDialog();

                              if (delete != true) return;

                              await ref
                                  .read(employeeProvider.notifier)
                                  .deleteEmployee(employee.id);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Employee deleted successfully',
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
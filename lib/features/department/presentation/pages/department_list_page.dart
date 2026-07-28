import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';

import '../providers/department_provider.dart';
import '../widgets/department_card.dart';

class DepartmentListPage extends ConsumerStatefulWidget {
  const DepartmentListPage({super.key});

  @override
  ConsumerState<DepartmentListPage> createState() =>
      _DepartmentListPageState();
}

class _DepartmentListPageState
    extends ConsumerState<DepartmentListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(departmentProvider.notifier)
          .loadDepartments();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref
        .read(departmentProvider.notifier)
        .loadDepartments();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(departmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Departments'),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed('add-department');
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppSearchField(
                controller: _searchController,
                onChanged: (value) {
                  ref
                      .read(
                    departmentProvider.notifier,
                  )
                      .search(value);
                },
              ),

              const SizedBox(height: 20),

              AppSectionTitle(
                title:
                'Department List (${state.filteredDepartments.length})',
              ),

              const SizedBox(height: 12),

              Expanded(
                child: Builder(
                  builder: (_) {
                    if (state.isLoading) {
                      return const AppLoading();
                    }

                    if (state.filteredDepartments.isEmpty) {
                      return ListView(
                        children: const [
                          SizedBox(height: 120),
                          AppEmpty(
                            title: 'No Department Found',
                          ),
                        ],
                      );
                    }

                    return ListView.separated(
                      physics:
                      const AlwaysScrollableScrollPhysics(),

                      itemCount:
                      state.filteredDepartments.length,

                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),

                      itemBuilder: (_, index) {
                        final department =
                        state.filteredDepartments[index];

                        return DepartmentCard(
                          department: department,

                          onEdit: () {
                            context.pushNamed(
                              'edit-department',
                              extra: department,
                            );
                          },

                          onDelete: () async {
                            final confirm =
                            await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text(
                                  'Delete Department',
                                ),
                                content: Text(
                                  'Are you sure you want to delete "${department.name}"?',
                                ),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        false,
                                      );
                                    },
                                    child:
                                    const Text('Cancel'),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        true,
                                      );
                                    },
                                    child:
                                    const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm != true) {
                              return;
                            }

                            await ref
                                .read(
                              departmentProvider
                                  .notifier,
                            )
                                .deleteDepartment(
                              department.id,
                            );

                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${department.name} deleted successfully.',
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
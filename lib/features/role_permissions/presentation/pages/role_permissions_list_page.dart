import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';

import '../providers/role_permissions_provider.dart';
import '../widgets/role_permissions_card.dart';

class RolePermissionsListPage extends ConsumerStatefulWidget {
  const RolePermissionsListPage({
    super.key,
  });

  @override
  ConsumerState<RolePermissionsListPage> createState() =>
      _RolePermissionsListPageState();
}

class _RolePermissionsListPageState
    extends ConsumerState<RolePermissionsListPage> {
  final _searchController = TextEditingController();

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(rolePermissionsProvider.notifier)
          .loadRolePermissions();
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
    await ref
        .read(rolePermissionsProvider.notifier)
        .refresh();
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      rolePermissionsProvider,
    );

    return Scaffold(
      // =========================================================
      // APP BAR
      // =========================================================

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
          'Role Permissions',
        ),
      ),

      // =========================================================
      // ADD BUTTON
      // =========================================================

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(
            RoutePaths.rolePermissionsCreate,
          );
        },
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add Permission',
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ===================================================
              // SEARCH
              // ===================================================

              AppSearchField(
                controller: _searchController,
                onChanged: (value) {
                  ref
                      .read(
                    rolePermissionsProvider.notifier,
                  )
                      .search(value);
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // ===================================================
              // SECTION TITLE
              // ===================================================

              AppSectionTitle(
                title:
                'Permission List (${state.filteredPermissions.length})',
              ),

              const SizedBox(
                height: 12,
              ),

              // ===================================================
              // LIST
              // ===================================================

              Expanded(
                child: Builder(
                  builder: (_) {
                    // =============================================
                    // LOADING
                    // =============================================

                    if (state.isLoading) {
                      return const AppLoading();
                    }

                    // =============================================
                    // EMPTY
                    // =============================================

                    if (state.filteredPermissions.isEmpty) {
                      return ListView(
                        physics:
                        const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(
                            height: 120,
                          ),
                          AppEmpty(
                            title: 'No Permission Found',
                          ),
                        ],
                      );
                    }

                    // =============================================
                    // PERMISSION LIST
                    // =============================================

                    return ListView.separated(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      itemCount:
                      state.filteredPermissions.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(
                        height: 12,
                      ),
                      itemBuilder: (_, index) {
                        final permission =
                        state.filteredPermissions[index];

                        return RolePermissionsCard(
                          data: permission,

                          // =======================================
                          // VIEW
                          // =======================================

                          onView: () {
                            context.push(
                              RoutePaths.rolePermissionsView,
                              extra: permission,
                            );
                          },

                          // =======================================
                          // EDIT
                          // =======================================

                          onEdit: () {
                            context.push(
                              RoutePaths.rolePermissionsEdit,
                              extra: permission.permission,
                            );
                          },

                          // =======================================
                          // DELETE
                          // =======================================

                          onDelete: () async {
                            final confirm =
                            await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text(
                                  'Delete Permission',
                                ),
                                content: Text(
                                  'Are you sure you want to delete '
                                      '"${permission.permission.moduleName}"?',
                                ),
                                actions: [
                                  OutlinedButton(
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

                            if (confirm != true) {
                              return;
                            }

                            try {
                              await ref
                                  .read(
                                rolePermissionsProvider
                                    .notifier,
                              )
                                  .deleteRolePermission(
                                permission.permission.id,
                              );

                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${permission.permission.moduleName} '
                                        'deleted successfully.',
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    e.toString(),
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
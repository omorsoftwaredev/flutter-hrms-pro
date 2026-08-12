import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';

import '../../../company/presentation/providers/company_provider.dart';

import '../providers/role_provider.dart';
import '../widgets/role_card.dart';

class RoleListPage extends ConsumerStatefulWidget {
  const RoleListPage({super.key});

  @override
  ConsumerState<RoleListPage> createState() =>
      _RoleListPageState();
}

class _RoleListPageState
    extends ConsumerState<RoleListPage> {
  final _searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref
          .read(companyProvider.notifier)
          .loadCompanies();

      await ref
          .read(roleProvider.notifier)
          .loadRoles();
    });
  }

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
        .read(companyProvider.notifier)
        .loadCompanies();

    await ref
        .read(roleProvider.notifier)
        .refresh();
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final roleState =
    ref.watch(roleProvider);

    final companyState =
    ref.watch(companyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Role Management',
        ),
      ),

      // =========================================================
      // ADD ROLE
      // =========================================================

      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: () {
          context.push(
            RoutePaths.roleCreate,
          );
        },
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add Role',
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding:
          const EdgeInsets.all(16),
          child: Column(
            children: [
              // =================================================
              // SEARCH
              // =================================================

              AppSearchField(
                controller:
                _searchController,
                onChanged: (value) {
                  ref
                      .read(
                    roleProvider
                        .notifier,
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
                'Role List (${roleState.filteredRoles.length})',
              ),

              const SizedBox(
                height: 12,
              ),

              // =================================================
              // ROLE LIST
              // =================================================

              Expanded(
                child: Builder(
                  builder: (_) {
                    if (roleState.isLoading) {
                      return const AppLoading();
                    }

                    if (roleState
                        .filteredRoles
                        .isEmpty) {
                      return ListView(
                        physics:
                        const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(
                            height: 120,
                          ),
                          AppEmpty(
                            title:
                            'No Role Found',
                          ),
                        ],
                      );
                    }

                    return ListView.separated(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      itemCount: roleState
                          .filteredRoles
                          .length,
                      separatorBuilder:
                          (_, __) =>
                      const SizedBox(
                        height: 12,
                      ),
                      itemBuilder:
                          (_, index) {
                        final role =
                        roleState
                            .filteredRoles[
                        index];

                        String companyName =
                            '-';

                        try {
                          companyName =
                              companyState
                                  .companies
                                  .firstWhere(
                                    (e) =>
                                e.id ==
                                    role
                                        .companyId,
                              )
                                  .name;
                        } catch (_) {
                          companyName =
                          '-';
                        }

                        return RoleCard(
                          role: role,

                          companyName:
                          companyName,

                          // ===================================
                          // VIEW
                          // ===================================

                          onView: () {
                            context.push(
                              RoutePaths
                                  .roleView,
                              extra: role,
                            );
                          },

                          // ===================================
                          // EDIT
                          // ===================================

                          onEdit: () {
                            context.push(
                              RoutePaths
                                  .roleEdit,
                              extra: role,
                            );
                          },

                          // ===================================
                          // DELETE
                          // ===================================

                          onDelete: () async {
                            final confirm =
                            await showDialog<
                                bool>(
                              context:
                              context,
                              builder:
                                  (_) =>
                                  AlertDialog(
                                    title:
                                    const Text(
                                      'Delete Role',
                                    ),
                                    content:
                                    Text(
                                      'Are you sure you want to delete "${role.roleName}"?',
                                    ),
                                    actions: [
                                      OutlinedButton(
                                        onPressed:
                                            () {
                                          Navigator.pop(
                                            context,
                                            false,
                                          );
                                        },
                                        child:
                                        const Text(
                                          'Cancel',
                                        ),
                                      ),
                                      FilledButton(
                                        onPressed:
                                            () {
                                          Navigator.pop(
                                            context,
                                            true,
                                          );
                                        },
                                        child:
                                        const Text(
                                          'Delete',
                                        ),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirm !=
                                true) {
                              return;
                            }

                            await ref
                                .read(
                              roleProvider
                                  .notifier,
                            )
                                .deleteRole(
                              role.id,
                            );

                            if (context
                                .mounted) {
                              ScaffoldMessenger
                                  .of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content:
                                  Text(
                                    '${role.roleName} deleted successfully.',
                                  ),
                                ),
                              );
                            }
                          },

                          // ===================================
                          // TOGGLE STATUS
                          // ===================================

                          onToggleStatus:
                              () async {
                            await ref
                                .read(
                              roleProvider
                                  .notifier,
                            )
                                .toggleRoleStatus(
                              role,
                            );
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
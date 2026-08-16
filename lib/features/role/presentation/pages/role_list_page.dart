import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';

import '../providers/role_provider.dart';
import '../widgets/role_card.dart';

class RoleListPage extends ConsumerStatefulWidget {
  const RoleListPage({super.key});

  @override
  ConsumerState<RoleListPage> createState() => _RoleListPageState();
}

class _RoleListPageState extends ConsumerState<RoleListPage> {
  // =============================================================
  // SEARCH CONTROLLER
  // =============================================================

  final TextEditingController _searchController =
  TextEditingController();

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(roleProvider.notifier).loadRoles();
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
    await ref.read(roleProvider.notifier).refresh();
  }

  // =============================================================
  // DELETE CONFIRMATION
  // =============================================================

  Future<void> _confirmDelete(
      BuildContext context,
      dynamic role,
      ) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Role'),
          content: Text(
            'Are you sure you want to delete '
                '"${role.roleName}"?',
          ),
          actions: [
            OutlinedButton(
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

    if (confirm != true) {
      return;
    }

    await ref.read(roleProvider.notifier).deleteRole(role.id);

    if (!context.mounted) {
      return;
    }

    _showSuccessSnackBar(
      context,
      '${role.roleName} deleted successfully.',
    );
  }

  // =============================================================
  // SUCCESS SNACKBAR
  // =============================================================

  void _showSuccessSnackBar(
      BuildContext context,
      String message,
      ) {
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
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final roleState = ref.watch(roleProvider);

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

        title: Text(
          'Role Management',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(
                RoutePaths.companyDashboard,
              );
            }
          },
        ),
      ),

      // =========================================================
      // ADD ROLE
      // =========================================================

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(
            RoutePaths.roleCreate,
          );
        },
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          'Add Role',
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final double width = constraints.maxWidth;

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

            final double maxContentWidth = isDesktop
                ? 1100
                : 760;

            return RefreshIndicator(
              onRefresh: _refresh,

              child: SingleChildScrollView(
                physics:
                const AlwaysScrollableScrollPhysics(),

                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  100,
                ),

                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxContentWidth,
                    ),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        // =========================================
                        // SEARCH
                        // =========================================

                        AppSearchField(
                          controller:
                          _searchController,

                          onChanged: (value) {
                            ref
                                .read(
                              roleProvider.notifier,
                            )
                                .search(value);
                          },
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        // =========================================
                        // SECTION TITLE
                        // =========================================

                        AppSectionTitle(
                          title:
                          'Role List '
                              '(${roleState.filteredRoles.length})',
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        // =========================================
                        // CONTENT
                        // =========================================

                        if (roleState.isLoading)
                          const Padding(
                            padding:
                            EdgeInsets.only(
                              top: 80,
                            ),
                            child: AppLoading(),
                          )
                        else if (
                        roleState
                            .filteredRoles
                            .isEmpty
                        )
                          _buildEmptyState(
                            context,
                          )
                        else
                          _buildRoleList(
                            context,
                            roleState,
                            isDesktop:
                            isDesktop,
                          ),

                        const SizedBox(
                          height: 20,
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
  // EMPTY STATE
  // =============================================================

  Widget _buildEmptyState(
      BuildContext context,
      ) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 80,
        ),
        child: const AppEmpty(
          title: 'No Role Found',
        ),
      ),
    );
  }

  // =============================================================
  // ROLE LIST
  // =============================================================

  Widget _buildRoleList(
      BuildContext context,
      dynamic roleState, {
        required bool isDesktop,
      }) {
    final roles = roleState.filteredRoles;

    // ===========================================================
    // DESKTOP GRID
    // ===========================================================

    if (isDesktop) {
      return GridView.builder(
        shrinkWrap: true,
        physics:
        const NeverScrollableScrollPhysics(),

        itemCount: roles.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.65,
        ),

        itemBuilder: (
            context,
            index,
            ) {
          return _buildRoleCard(
            context,
            roles[index],
          );
        },
      );
    }

    // ===========================================================
    // TABLET / MOBILE
    // ===========================================================

    return ListView.separated(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),

      itemCount: roles.length,

      separatorBuilder: (
          context,
          index,
          ) {
        return const SizedBox(
          height: 12,
        );
      },

      itemBuilder: (
          context,
          index,
          ) {
        return _buildRoleCard(
          context,
          roles[index],
        );
      },
    );
  }

  // =============================================================
  // ROLE CARD
  // =============================================================

  Widget _buildRoleCard(
      BuildContext context,
      dynamic role,
      ) {
    return RoleCard(
      role: role,

      // =========================================================
      // VIEW
      // =========================================================

      onView: () {
        context.push(
          RoutePaths.roleView,
          extra: role,
        );
      },

      // =========================================================
      // EDIT
      // =========================================================

      onEdit: () {
        context.push(
          RoutePaths.roleEdit,
          extra: role,
        );
      },

      // =========================================================
      // DELETE
      // =========================================================

      onDelete: () async {
        await _confirmDelete(
          context,
          role,
        );
      },

      // =========================================================
      // TOGGLE STATUS
      // =========================================================

      onToggleStatus: () async {
        await ref
            .read(
          roleProvider.notifier,
        )
            .toggleRoleStatus(
          role,
        );
      },
    );
  }
}
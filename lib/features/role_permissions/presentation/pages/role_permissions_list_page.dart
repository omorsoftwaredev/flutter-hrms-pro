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
  const RolePermissionsListPage({super.key});

  @override
  ConsumerState<RolePermissionsListPage> createState() =>
      _RolePermissionsListPageState();
}

class _RolePermissionsListPageState
    extends ConsumerState<RolePermissionsListPage> {
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

    Future.microtask(() async {
      await ref.read(rolePermissionsProvider.notifier).loadRolePermissions();
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
    await ref.read(rolePermissionsProvider.notifier).refresh();
  }

  // =============================================================
  // DELETE CONFIRMATION
  // =============================================================

  Future<void> _confirmDelete(BuildContext context, dynamic permission) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Permission'),
          content: Text(
            'Are you sure you want to delete '
            '"${permission.permission.moduleName}"?',
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

    try {
      await ref
          .read(rolePermissionsProvider.notifier)
          .deleteRolePermission(permission.permission.id);

      if (!context.mounted) {
        return;
      }

      _showSuccessSnackBar(
        context,
        '${permission.permission.moduleName} '
        'deleted successfully.',
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      _showErrorSnackBar(context, e.toString());
    }
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
          behavior: SnackBarBehavior.fixed,
          backgroundColor: colorScheme.error,
          elevation: 0,
          duration: const Duration(seconds: 4),
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
    final state = ref.watch(rolePermissionsProvider);

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
          'Role Permissions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // =========================================================
      // ADD PERMISSION
      // =========================================================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(RoutePaths.rolePermissionsCreate);
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Permission'),
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
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

            final double maxContentWidth = isDesktop ? 1100 : 760;

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
                            ref
                                .read(rolePermissionsProvider.notifier)
                                .search(value);
                          },
                        ),

                        const SizedBox(height: 18),

                        // =========================================
                        // SECTION TITLE
                        // =========================================
                        AppSectionTitle(
                          title:
                              'Permission List '
                              '(${state.filteredPermissions.length})',
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
                        else if (state.filteredPermissions.isEmpty)
                          _buildEmptyState(context)
                        else
                          _buildPermissionList(
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
        child: const AppEmpty(title: 'No Permission Found'),
      ),
    );
  }

  // =============================================================
  // PERMISSION LIST
  // =============================================================

  Widget _buildPermissionList(
    BuildContext context,
    dynamic state, {
    required bool isDesktop,
  }) {
    final permissions = state.filteredPermissions;

    // ===========================================================
    // DESKTOP GRID
    // ===========================================================

    if (isDesktop) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),

        itemCount: permissions.length,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.65,
        ),

        itemBuilder: (context, index) {
          return _buildPermissionCard(context, permissions[index]);
        },
      );
    }

    // ===========================================================
    // TABLET / MOBILE
    // ===========================================================

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: permissions.length,

      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },

      itemBuilder: (context, index) {
        return _buildPermissionCard(context, permissions[index]);
      },
    );
  }

  // =============================================================
  // PERMISSION CARD
  // =============================================================

  Widget _buildPermissionCard(BuildContext context, dynamic permission) {
    return RolePermissionsCard(
      data: permission,

      // =========================================================
      // VIEW
      // =========================================================
      onView: () {
        context.push(RoutePaths.rolePermissionsView, extra: permission);
      },

      // =========================================================
      // EDIT
      // =========================================================
      onEdit: () {
        context.push(
          RoutePaths.rolePermissionsEdit,
          extra: permission.permission,
        );
      },

      // =========================================================
      // DELETE
      // =========================================================
      onDelete: () async {
        await _confirmDelete(context, permission);
      },
    );
  }
}

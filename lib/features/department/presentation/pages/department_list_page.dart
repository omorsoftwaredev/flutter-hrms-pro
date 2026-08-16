import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';

import '../providers/department_provider.dart';
import '../widgets/department_card.dart';

class DepartmentListPage extends ConsumerStatefulWidget {
  const DepartmentListPage({
    super.key,
  });

  @override
  ConsumerState<DepartmentListPage> createState() =>
      _DepartmentListPageState();
}

class _DepartmentListPageState
    extends ConsumerState<DepartmentListPage> {
  // =============================================================
  // CONTROLLERS
  // =============================================================

  final TextEditingController _searchController =
  TextEditingController();

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      ref
          .read(departmentProvider.notifier)
          .loadDepartments();
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
        .read(departmentProvider.notifier)
        .loadDepartments();
  }

  // =============================================================
  // BACK
  // =============================================================

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(
      RoutePaths.companyDashboard,
    );
  }

  // =============================================================
  // ADD DEPARTMENT
  // =============================================================

  void _addDepartment() {
    context.push(
      RoutePaths.departmentCreate,
    );
  }

  // =============================================================
  // DELETE CONFIRMATION
  // =============================================================

  Future<void> _confirmDelete(
      BuildContext context,
      dynamic department,
      ) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Department',
          ),
          content: Text(
            'Are you sure you want to delete '
                '"${department.name}"?',
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                colorScheme.error,
                foregroundColor:
                colorScheme.onError,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(
                  true,
                );
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    if (!mounted) {
      return;
    }

    await ref
        .read(departmentProvider.notifier)
        .deleteDepartment(
      department.id,
    );

    if (!mounted) {
      return;
    }

    _showSuccessSnackBar(
      '${department.name} deleted successfully.',
    );
  }

  // =============================================================
  // SUCCESS SNACKBAR
  // =============================================================

  void _showSuccessSnackBar(
      String message,
      ) {
    if (!mounted) {
      return;
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor:
          colorScheme.inverseSurface,
          elevation: 0,
          duration: const Duration(
            seconds: 3,
          ),
          content: Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 20,
                color:
                colorScheme.onInverseSurface,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                    colorScheme.onInverseSurface,
                    fontWeight:
                    FontWeight.w500,
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

  void _showErrorSnackBar(
      String message,
      ) {
    if (!mounted) {
      return;
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor:
          colorScheme.error,
          elevation: 0,
          duration: const Duration(
            seconds: 4,
          ),
          content: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 20,
                color:
                colorScheme.onError,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                    colorScheme.onError,
                    fontWeight:
                    FontWeight.w500,
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
  Widget build(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final state = ref.watch(
      departmentProvider,
    );

    return Scaffold(
      backgroundColor:
      colorScheme.surface,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor:
        colorScheme.surface,
        foregroundColor:
        colorScheme.onSurface,

        leading: IconButton(
          tooltip: 'Back',
          onPressed: _handleBack,
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),

        title: Text(
          'Departments',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight:
            FontWeight.w700,
          ),
        ),
      ),

      // =========================================================
      // FLOATING ADD BUTTON
      // =========================================================

      floatingActionButton:
      _buildFloatingActionButton(
        context,
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
            return _buildResponsiveBody(
              context,
              constraints,
              state,
            );
          },
        ),
      ),
    );
  }

  // =============================================================
  // RESPONSIVE BODY
  // =============================================================

  Widget _buildResponsiveBody(
      BuildContext context,
      BoxConstraints constraints,
      dynamic state,
      ) {
    final double width =
        constraints.maxWidth;

    final bool isDesktop =
        width >= 1100;

    final bool isTablet =
        width >= 600;

    final double horizontalPadding =
    isDesktop
        ? 32
        : isTablet
        ? 24
        : 14;

    final double maxContentWidth =
    isDesktop
        ? 1100
        : 850;

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
              CrossAxisAlignment.stretch,

              children: [
                // =================================================
                // HEADER
                // =================================================

                _buildPageHeader(
                  context,
                  isTablet,
                ),

                const SizedBox(
                  height: 18,
                ),

                // =================================================
                // SEARCH
                // =================================================

                _buildSearchSection(
                  context,
                ),

                const SizedBox(
                  height: 18,
                ),

                // =================================================
                // SECTION TITLE
                // =================================================

                _buildSectionHeader(
                  context,
                  state,
                  isTablet,
                ),

                const SizedBox(
                  height: 12,
                ),

                // =================================================
                // CONTENT
                // =================================================

                _buildDepartmentContent(
                  context,
                  state,
                  isDesktop,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // PAGE HEADER
  // =============================================================

  Widget _buildPageHeader(
      BuildContext context,
      bool isTablet,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isTablet ? 20 : 16,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer
            .withOpacity(.55),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.primary
              .withOpacity(.16),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =======================================================
          // ICON
          // =======================================================

          Container(
            width: isTablet ? 52 : 46,
            height: isTablet ? 52 : 46,
            decoration: BoxDecoration(
              color: colorScheme.primary
                  .withOpacity(.12),
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.apartment_rounded,
              color:
              colorScheme.primary,
              size: isTablet ? 27 : 24,
            ),
          ),

          const SizedBox(
            width: 13,
          ),

          // =======================================================
          // TEXT
          // =======================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Department Management',
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  'Manage your company departments, '
                      'status and department information.',
                  maxLines: 3,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    height: 1.4,
                    color: colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SEARCH SECTION
  // =============================================================

  Widget _buildSearchSection(
      BuildContext context,
      ) {
    return AppSearchField(
      controller: _searchController,
      onChanged: (value) {
        ref
            .read(
          departmentProvider.notifier,
        )
            .search(value);
      },
    );
  }

  // =============================================================
  // SECTION HEADER
  // =============================================================

  Widget _buildSectionHeader(
      BuildContext context,
      dynamic state,
      bool isTablet,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.center,
      children: [
        Expanded(
          child: AppSectionTitle(
            title:
            'Department List '
                '(${state.filteredDepartments.length})',
          ),
        ),

        const SizedBox(
          width: 8,
        ),

        // =======================================================
        // COUNT BADGE
        // =======================================================

        Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: colorScheme
                .secondaryContainer,
            borderRadius:
            BorderRadius.circular(20),
          ),
          child: Text(
            '${state.filteredDepartments.length}',
            style: theme
                .textTheme
                .labelMedium
                ?.copyWith(
              color: colorScheme
                  .onSecondaryContainer,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // DEPARTMENT CONTENT
  // =============================================================

  Widget _buildDepartmentContent(
      BuildContext context,
      dynamic state,
      bool isDesktop,
      ) {
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 100,
        ),
        child: AppLoading(),
      );
    }

    if (state.filteredDepartments.isEmpty) {
      return SizedBox(
        height: 320,
        child: Center(
          child: AppEmpty(
            title: 'No Department Found',
          ),
        ),
      );
    }

    // ===========================================================
    // DESKTOP
    // ===========================================================

    if (isDesktop) {
      return _buildDesktopDepartmentList(
        context,
        state,
      );
    }

    // ===========================================================
    // MOBILE / TABLET
    // ===========================================================

    return _buildMobileDepartmentList(
      context,
      state,
    );
  }

  // =============================================================
  // MOBILE / TABLET LIST
  // =============================================================

  Widget _buildMobileDepartmentList(
      BuildContext context,
      dynamic state,
      ) {
    return ListView.separated(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),

      itemCount:
      state.filteredDepartments.length,

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
        final department =
        state.filteredDepartments[index];

        return _buildDepartmentCard(
          context,
          department,
        );
      },
    );
  }

  // =============================================================
  // DESKTOP LIST
  // =============================================================

  Widget _buildDesktopDepartmentList(
      BuildContext context,
      dynamic state,
      ) {
    return GridView.builder(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),

      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.8,
      ),

      itemCount:
      state.filteredDepartments.length,

      itemBuilder: (
          context,
          index,
          ) {
        final department =
        state.filteredDepartments[index];

        return _buildDepartmentCard(
          context,
          department,
        );
      },
    );
  }

  // =============================================================
  // DEPARTMENT CARD
  // =============================================================

  Widget _buildDepartmentCard(
      BuildContext context,
      dynamic department,
      ) {
    return DepartmentCard(
      department: department,

      // =========================================================
      // VIEW
      // =========================================================

      onView: () {
        context.push(
          RoutePaths.departmentView,
          extra: department,
        );
      },

      // =========================================================
      // EDIT
      // =========================================================

      onEdit: () {
        context.push(
          RoutePaths.departmentEdit,
          extra: department,
        );
      },

      // =========================================================
      // DELETE
      // =========================================================

      onDelete: () async {
        await _confirmDelete(
          context,
          department,
        );
      },

      // =========================================================
      // STATUS TOGGLE
      // =========================================================

      onToggleStatus: () async {
        try {
          await ref
              .read(
            departmentProvider.notifier,
          )
              .toggleDepartmentStatus(
            department,
          );
        } catch (e) {
          if (!mounted) {
            return;
          }

          _showErrorSnackBar(
            'Failed to update department status.\n$e',
          );
        }
      },
    );
  }

  // =============================================================
  // FLOATING ACTION BUTTON
  // =============================================================

  Widget _buildFloatingActionButton(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final width =
            MediaQuery.sizeOf(context).width;

        final bool isDesktop =
            width >= 900;

        if (isDesktop) {
          return FloatingActionButton.extended(
            heroTag:
            'department_add_fab',
            onPressed: _addDepartment,
            backgroundColor:
            colorScheme.primary,
            foregroundColor:
            colorScheme.onPrimary,
            icon: const Icon(
              Icons.add_rounded,
            ),
            label: Text(
              'Add Department',
              style: theme
                  .textTheme
                  .labelLarge
                  ?.copyWith(
                fontWeight:
                FontWeight.w700,
              ),
            ),
          );
        }

        return FloatingActionButton(
          heroTag:
          'department_add_fab',
          onPressed: _addDepartment,
          backgroundColor:
          colorScheme.primary,
          foregroundColor:
          colorScheme.onPrimary,
          tooltip:
          'Add Department',
          child: const Icon(
            Icons.add_rounded,
          ),
        );
      },
    );
  }
}
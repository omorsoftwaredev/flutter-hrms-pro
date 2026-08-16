import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';

import '../providers/designation_provider.dart';
import '../widgets/designation_card.dart';

class DesignationListPage extends ConsumerStatefulWidget {
  const DesignationListPage({super.key});

  @override
  ConsumerState<DesignationListPage> createState() =>
      _DesignationListPageState();
}

class _DesignationListPageState extends ConsumerState<DesignationListPage> {
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
      await ref.read(designationProvider.notifier).loadDesignations();
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
    await ref.read(designationProvider.notifier).loadDesignations();
  }

  // =============================================================
  // DELETE CONFIRMATION
  // =============================================================

  Future<void> _confirmDelete(BuildContext context, dynamic designation) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Designation'),
          content: Text(
            'Are you sure you want to delete '
            '"${designation.name}"?',
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

    await ref
        .read(designationProvider.notifier)
        .deleteDesignation(designation.id);

    if (!context.mounted) {
      return;
    }

    _showSuccessSnackBar(context, '${designation.name} deleted successfully.');
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
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final designationState = ref.watch(designationProvider);

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
          'Designations',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RoutePaths.companyDashboard);
            }
          },
        ),
      ),

      // =========================================================
      // ADD BUTTON
      // =========================================================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(RoutePaths.designationCreate);
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;

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
                        // =======================================
                        // SEARCH
                        // =======================================
                        AppSearchField(
                          controller: _searchController,
                          onChanged: (value) {
                            ref
                                .read(designationProvider.notifier)
                                .search(value);
                          },
                        ),

                        const SizedBox(height: 18),

                        // =======================================
                        // SECTION TITLE
                        // =======================================
                        AppSectionTitle(
                          title:
                              'Designation List '
                              '(${designationState.filteredDesignations.length})',
                        ),

                        const SizedBox(height: 12),

                        // =======================================
                        // CONTENT
                        // =======================================
                        if (designationState.isLoading)
                          const Padding(
                            padding: EdgeInsets.only(top: 80),
                            child: AppLoading(),
                          )
                        else if (designationState.filteredDesignations.isEmpty)
                          _buildEmptyState(context)
                        else
                          _buildDesignationList(
                            context,
                            designationState,
                            isDesktop: isDesktop,
                          ),

                        // =======================================
                        // FAB SPACE
                        // =======================================
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
        child: const AppEmpty(title: 'No Designation Found'),
      ),
    );
  }

  // =============================================================
  // DESIGNATION LIST
  // =============================================================

  Widget _buildDesignationList(
    BuildContext context,
    dynamic designationState, {
    required bool isDesktop,
  }) {
    final designations = designationState.filteredDesignations;

    // ===========================================================
    // DESKTOP GRID
    // ===========================================================

    if (isDesktop) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),

        itemCount: designations.length,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.65,
        ),

        itemBuilder: (context, index) {
          return _buildDesignationCard(context, designations[index]);
        },
      );
    }

    // ===========================================================
    // TABLET / MOBILE
    // ===========================================================

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: designations.length,

      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },

      itemBuilder: (context, index) {
        return _buildDesignationCard(context, designations[index]);
      },
    );
  }

  // =============================================================
  // DESIGNATION CARD
  // =============================================================

  Widget _buildDesignationCard(BuildContext context, dynamic designation) {
    return DesignationCard(
      designation: designation,

      // =========================================================
      // IMPORTANT
      //
      // Company list / company query completely removed.
      //
      // Login করা user's company scope
      // provider/notifier level-এ handle করবে।
      //
      // =========================================================
      onView: () {
        context.push(RoutePaths.designationView, extra: designation);
      },

      onEdit: () {
        context.push(RoutePaths.designationEdit, extra: designation);
      },

      onDelete: () async {
        await _confirmDelete(context, designation);
      },

      onToggleStatus: () async {
        await ref
            .read(designationProvider.notifier)
            .toggleDesignationStatus(designation);
      },
    );
  }
}

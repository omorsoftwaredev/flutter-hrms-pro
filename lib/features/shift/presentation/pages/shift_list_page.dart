import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';

import '../../domain/entities/shift_entity.dart';
import '../providers/shift_provider.dart';
import '../widgets/shift_card.dart';

class ShiftListPage extends ConsumerStatefulWidget {
  const ShiftListPage({super.key});

  @override
  ConsumerState<ShiftListPage> createState() =>
      _ShiftListPageState();
}

class _ShiftListPageState extends ConsumerState<ShiftListPage> {
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
      await ref.read(shiftProvider.notifier).loadShifts();
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
    await ref.read(shiftProvider.notifier).loadShifts();
  }

  // =============================================================
  // DELETE CONFIRMATION
  // =============================================================

  Future<void> _confirmDelete(
      BuildContext context,
      ShiftEntity shift,
      ) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Shift'),

          content: Text(
            'Are you sure you want to delete '
                '"${shift.name}"?',
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
          .read(shiftProvider.notifier)
          .deleteShift(shift.id);

      if (!context.mounted) {
        return;
      }

      _showSuccessSnackBar(
        context,
        '${shift.name} deleted successfully.',
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      _showErrorSnackBar(
        context,
        'Failed to delete ${shift.name}.',
      );
    }
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
          behavior: SnackBarBehavior.floating,
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

  void _showErrorSnackBar(
      BuildContext context,
      String message,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: colorScheme.errorContainer,
          elevation: 0,
          duration: const Duration(seconds: 4),
          content: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 20,
                color: colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onErrorContainer,
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
    final shiftState = ref.watch(shiftProvider);

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
          'Shifts',
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
      // ADD SHIFT
      // =========================================================

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(
            RoutePaths.shiftCreate,
          );
        },
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text('Add'),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              BuildContext context,
              BoxConstraints constraints,
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
                        // =======================================
                        // SEARCH
                        // =======================================

                        AppSearchField(
                          controller: _searchController,
                          onChanged: (value) {
                            ref
                                .read(
                              shiftProvider.notifier,
                            )
                                .search(value);
                          },
                        ),

                        const SizedBox(height: 18),

                        // =======================================
                        // SECTION TITLE
                        // =======================================

                        AppSectionTitle(
                          title:
                          'Shift List '
                              '(${shiftState.filteredShifts.length})',
                        ),

                        const SizedBox(height: 12),

                        // =======================================
                        // CONTENT
                        // =======================================

                        if (shiftState.isLoading)
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 80,
                            ),
                            child: AppLoading(),
                          )
                        else if (shiftState.filteredShifts.isEmpty)
                          _buildEmptyState(context)
                        else
                          _buildShiftList(
                            context,
                            shiftState.filteredShifts,
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

  Widget _buildEmptyState(
      BuildContext context,
      ) {
    return const SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          top: 80,
        ),
        child: AppEmpty(
          title: 'No Shift Found',
        ),
      ),
    );
  }

  // =============================================================
  // SHIFT LIST
  // =============================================================

  Widget _buildShiftList(
      BuildContext context,
      List<ShiftEntity> shifts, {
        required bool isDesktop,
      }) {
    // ===========================================================
    // DESKTOP GRID
    // ===========================================================

    if (isDesktop) {
      return GridView.builder(
        shrinkWrap: true,

        physics:
        const NeverScrollableScrollPhysics(),

        itemCount: shifts.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,

          childAspectRatio: 1.65,
        ),

        itemBuilder: (context, index) {
          return _buildShiftCard(
            context,
            shifts[index],
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

      itemCount: shifts.length,

      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12,
        );
      },

      itemBuilder: (context, index) {
        return _buildShiftCard(
          context,
          shifts[index],
        );
      },
    );
  }

  // =============================================================
  // SHIFT CARD
  // =============================================================

  Widget _buildShiftCard(
      BuildContext context,
      ShiftEntity shift,
      ) {
    return ShiftCard(
      shift: shift,

      // =========================================================
      // VIEW
      // =========================================================

      onView: () {
        context.push(
          RoutePaths.shiftView,
          extra: shift,
        );
      },

      // =========================================================
      // EDIT
      // =========================================================

      onEdit: () {
        context.push(
          RoutePaths.shiftEdit,
          extra: shift,
        );
      },

      // =========================================================
      // DELETE
      // =========================================================

      onDelete: () async {
        await _confirmDelete(
          context,
          shift,
        );
      },

      // =========================================================
      // TOGGLE STATUS
      // =========================================================

      onToggleStatus: () async {
        try {
          await ref
              .read(shiftProvider.notifier)
              .toggleShiftStatus(shift);
        } catch (e) {
          if (!context.mounted) {
            return;
          }

          _showErrorSnackBar(
            context,
            'Failed to update shift status.',
          );
        }
      },
    );
  }
}
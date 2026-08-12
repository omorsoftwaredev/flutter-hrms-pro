import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';

import '../../../company/presentation/providers/company_provider.dart';

import '../providers/shift_provider.dart';
import '../widgets/shift_card.dart';

class ShiftListPage extends ConsumerStatefulWidget {
  const ShiftListPage({super.key});

  @override
  ConsumerState<ShiftListPage> createState() =>
      _ShiftListPageState();
}

class _ShiftListPageState
    extends ConsumerState<ShiftListPage> {
  final _searchController =
  TextEditingController();

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref
          .read(companyProvider.notifier)
          .loadCompanies();

      await ref
          .read(shiftProvider.notifier)
          .loadShifts();
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
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final shiftState =
    ref.watch(shiftProvider);

    final companyState =
    ref.watch(companyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shifts',
        ),
      ),

      // ===========================================================
      // ADD SHIFT
      // ===========================================================

      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: () {
          context.push(
            RoutePaths.shiftCreate,
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),

      // ===========================================================
      // BODY
      // ===========================================================

      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(companyProvider.notifier)
              .loadCompanies();

          await ref
              .read(shiftProvider.notifier)
              .loadShifts();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ===================================================
              // SEARCH
              // ===================================================

              AppSearchField(
                controller:
                _searchController,
                onChanged: (value) {
                  ref
                      .read(
                    shiftProvider
                        .notifier,
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
                'Shift List '
                    '(${shiftState.filteredShifts.length})',
              ),

              const SizedBox(
                height: 10,
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

                    if (shiftState.isLoading) {
                      return const AppLoading();
                    }

                    // =============================================
                    // EMPTY
                    // =============================================

                    if (shiftState
                        .filteredShifts
                        .isEmpty) {
                      return const AppEmpty(
                        title:
                        'No Shift Found',
                      );
                    }

                    // =============================================
                    // SHIFT LIST
                    // =============================================

                    return ListView.separated(
                      itemCount:
                      shiftState
                          .filteredShifts
                          .length,

                      separatorBuilder:
                          (_, __) =>
                      const SizedBox(
                        height: 12,
                      ),

                      itemBuilder:
                          (_, index) {
                        final shift =
                        shiftState
                            .filteredShifts[
                        index];

                        // =========================================
                        // COMPANY
                        // =========================================

                        final company =
                            companyState
                                .companies
                                .where(
                                  (e) =>
                              e.id ==
                                  shift.companyId,
                            )
                                .firstOrNull;

                        // =========================================
                        // SHIFT CARD
                        // =========================================

                        return ShiftCard(
                          shift: shift,

                          companyName:
                          company?.name,

                          // =======================================
                          // VIEW
                          // =======================================

                          onView: () {
                            context.push(
                              RoutePaths.shiftView,
                              extra: shift,
                            );
                          },

                          // =======================================
                          // EDIT
                          // =======================================

                          onEdit: () {
                            context.push(
                              RoutePaths.shiftEdit,
                              extra: shift,
                            );
                          },

                          // =======================================
                          // DELETE
                          // =======================================

                          onDelete: () async {
                            final confirm =
                            await showDialog<bool>(
                              context: context,
                              builder: (_) =>
                                  AlertDialog(
                                    title: const Text(
                                      'Delete Shift',
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete '
                                          '"${shift.name}"?',
                                    ),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () =>
                                            Navigator.pop(
                                              context,
                                              false,
                                            ),
                                        child:
                                        const Text(
                                          'Cancel',
                                        ),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.pop(
                                              context,
                                              true,
                                            ),
                                        child:
                                        const Text(
                                          'Delete',
                                        ),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirm != true) {
                              return;
                            }

                            await ref
                                .read(
                              shiftProvider
                                  .notifier,
                            )
                                .deleteShift(
                              shift.id,
                            );

                            if (context.mounted) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${shift.name} '
                                        'deleted successfully.',
                                  ),
                                ),
                              );
                            }
                          },

                          // =======================================
                          // TOGGLE STATUS
                          // =======================================

                          onToggleStatus:
                              () async {
                            await ref
                                .read(
                              shiftProvider
                                  .notifier,
                            )
                                .toggleShiftStatus(
                              shift,
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
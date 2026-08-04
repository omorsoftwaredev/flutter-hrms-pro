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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final shiftState =
    ref.watch(shiftProvider);

    final companyState =
    ref.watch(companyProvider);

    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Shift Management'),
      ),

      floatingActionButton:
      FloatingActionButton.extended(

        onPressed: () {

          context.push(
            RoutePaths.shiftCreate,
          );

        },

        icon: const Icon(Icons.add),

        label: const Text(
          'Add Shift',
        ),
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
                  shiftProvider.notifier,
                )
                    .search(value);

              },

            ),

            const SizedBox(
              height: 20,
            ),

            const AppSectionTitle(

              title:
              'Shift List',

            ),

            const SizedBox(
              height: 12,
            ),

            Expanded(

              child: Builder(

                builder: (_) {

                  if (shiftState.isLoading) {

                    return const AppLoading();

                  }

                  if (shiftState
                      .filteredShifts
                      .isEmpty) {

                    return const AppEmpty(

                      title:
                      'No Shift Found',

                    );

                  }

                  return ListView.separated(

                    itemCount: shiftState
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

                      String companyName =
                          '-';

                      try {

                        companyName =
                            companyState
                                .companies
                                .firstWhere(
                                  (e) =>
                              e.id ==
                                  shift.companyId,
                            )
                                .name;

                      } catch (_) {}

                      return ShiftCard(
                        shift: shift,

                        companyName: companyName,

                        onView: () {
                          context.push(
                            RoutePaths.shiftView,
                            extra: shift,
                          );
                        },

                        onEdit: () {
                          context.push(
                            RoutePaths.shiftEdit,
                            extra: shift,
                          );
                        },

                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete Shift'),
                              content: Text(
                                'Are you sure you want to delete "${shift.name}"?',
                              ),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirm != true) return;

                          await ref
                              .read(shiftProvider.notifier)
                              .deleteShift(shift.id);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${shift.name} deleted successfully.',
                                ),
                              ),
                            );
                          }
                        },

                        onToggleStatus: () async {
                          await ref
                              .read(shiftProvider.notifier)
                              .toggleShiftStatus(shift);
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

    );

  }

}
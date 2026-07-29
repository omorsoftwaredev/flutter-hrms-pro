import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';

import '../../../company/presentation/providers/company_provider.dart';
import '../../../department/presentation/providers/department_provider.dart';

import '../providers/designation_provider.dart';
import '../widgets/designation_card.dart';

class DesignationListPage extends ConsumerStatefulWidget {
  const DesignationListPage({super.key});

  @override
  ConsumerState<DesignationListPage> createState() =>
      _DesignationListPageState();
}

class _DesignationListPageState
    extends ConsumerState<DesignationListPage> {
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
          .read(designationProvider.notifier)
          .loadDesignations();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final designationState =
    ref.watch(designationProvider);

    final companyState =
    ref.watch(companyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Designations',
        ),
      ),

      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(
            'add-designation',
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
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
                  designationProvider
                      .notifier,
                )
                    .search(value);
              },
            ),

            const SizedBox(
              height: 20,
            ),

            const AppSectionTitle(
              title:
              'Designation List',
            ),

            const SizedBox(
              height: 10,
            ),

            Expanded(
              child: Builder(
                builder: (_) {
                  if (designationState
                      .isLoading) {
                    return const AppLoading();
                  }

                  if (designationState
                      .filteredDesignations
                      .isEmpty) {
                    return const AppEmpty(
                      title:
                      'No Designation Found',
                    );
                  }

                  return ListView.separated(
                    itemCount:
                    designationState
                        .filteredDesignations
                        .length,

                    separatorBuilder:
                        (_, __) =>
                    const SizedBox(
                      height: 12,
                    ),

                    itemBuilder:
                        (_, index) {
                      final designation =
                      designationState
                          .filteredDesignations[
                      index];

                      final company =
                          companyState
                              .companies
                              .where(
                                (e) =>
                            e.id ==
                                designation
                                    .companyId,
                          )
                              .firstOrNull;


                      return DesignationCard(
                        designation:
                        designation,

                        companyName:
                        company?.name,

                        onEdit: () {
                          context
                              .pushNamed(
                            'edit-designation',
                            extra:
                            designation,
                          );
                        },

                        onDelete:
                            () async {
                          final delete =
                          await showDialog<
                              bool>(
                            context:
                            context,
                            builder:
                                (_) =>
                                AlertDialog(
                                  title:
                                  const Text(
                                    'Delete Designation',
                                  ),
                                  content:
                                  const Text(
                                    'Are you sure you want to delete this designation?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
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
                                      onPressed: () {
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

                          if (delete ==
                              true) {
                            await ref
                                .read(
                              designationProvider
                                  .notifier,
                            )
                                .deleteDesignation(
                              designation
                                  .id,
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
    );
  }
}
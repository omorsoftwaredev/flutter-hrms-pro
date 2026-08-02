/// ===============================================================
/// Flutter HRMS Pro
/// Company List Page
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/company_controller.dart';
import '../models/company_model.dart';
import '../providers/company_provider.dart';

class CompanyListPage extends ConsumerWidget {
  const CompanyListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies =
    ref.watch(companyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Company List',
        ),
      ),

      body: companies.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (error, stackTrace) {
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        },

        data: (List<CompanyModel> data) {
          if (data.isEmpty) {
            return const Center(
              child: Text(
                'No Company Found',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                companyListProvider,
              );
            },

            child: ListView.separated(
              padding:
              const EdgeInsets.all(16),

              itemCount: data.length,

              separatorBuilder:
                  (_, __) =>
              const SizedBox(
                height: 10,
              ),

              itemBuilder: (context, index) {
                final company =
                data[index];

                return Card(
                  elevation: 2,

                  child: ListTile(
                    leading:
                    CircleAvatar(
                      child: Text(
                        company.name
                            .substring(0, 1)
                            .toUpperCase(),
                      ),
                    ),

                    title: Text(
                      company.name,
                    ),

                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [

                        Text(
                          company.code,
                        ),

                        if (company.phone !=
                            null)
                          Text(
                            company.phone!,
                          ),

                        if (company.email !=
                            null)
                          Text(
                            company.email!,
                          ),
                      ],
                    ),

                    trailing: PopupMenuButton(
                      itemBuilder:
                          (context) => [

                        const PopupMenuItem(
                          value: 'view',
                          child: Text(
                            'View',
                          ),
                        ),

                        const PopupMenuItem(
                          value: 'edit',
                          child: Text(
                            'Edit',
                          ),
                        ),

                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete',
                          ),
                        ),
                      ],

                      onSelected:
                          (value) async {
                        switch (value) {
                          case 'view':
                            break;

                          case 'edit':
                            break;

                          case 'delete':
                            final ok =
                                await showDialog<bool>(
                                  context:
                                  context,
                                  builder:
                                      (_) =>
                                      AlertDialog(
                                        title:
                                        const Text(
                                          'Delete Company',
                                        ),
                                        content:
                                        const Text(
                                          'Are you sure?',
                                        ),
                                        actions: [
                                          TextButton(
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
                                          ElevatedButton(
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
                                ) ??
                                    false;

                            if (!ok) {
                              return;
                            }

                            await ref
                                .read(
                              companyControllerProvider,
                            )
                                .deleteCompany(
                              company.id!,
                            );

                            break;
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          // TODO
          // context.push(...)
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
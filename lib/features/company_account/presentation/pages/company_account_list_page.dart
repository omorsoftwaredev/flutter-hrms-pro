//===============================================================
// lib/features/company_account/presentation/pages/company_account_list_page.dart
//===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';

import '../../domain/entities/company_account_entity.dart';
import '../providers/company_account_provider.dart';
import '../widgets/company_account_card.dart';
import '../widgets/company_account_view_dialog.dart';

class CompanyAccountListPage extends ConsumerStatefulWidget {
  const CompanyAccountListPage({super.key});

  @override
  ConsumerState<CompanyAccountListPage> createState() =>
      _CompanyAccountListPageState();
}

class _CompanyAccountListPageState
    extends ConsumerState<CompanyAccountListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(companyAccountProvider.notifier)
          .loadAccounts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddAccount() async {
    await context.push(
      RoutePaths.companyAccountCreate,
    );

    if (mounted) {
      ref
          .read(companyAccountProvider.notifier)
          .loadAccounts();
    }
  }

  Future<void> _openEditAccount(
      CompanyAccountEntity account,
      ) async {
    await context.push(
      RoutePaths.companyAccountEdit,
      extra: account,
    );

    if (mounted) {
      ref
          .read(companyAccountProvider.notifier)
          .loadAccounts();
    }
  }

  Future<void> _deleteAccount(
      String id,
      ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Delete Account',
          ),
          content: const Text(
            'Are you sure you want to delete this account?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
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
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    await ref
        .read(companyAccountProvider.notifier)
        .deleteAccount(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Account deleted successfully.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state =
    ref.watch(companyAccountProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(
                RoutePaths.developerDashboard,
              );
            }
          },
        ),
        title: const Text(
          'Company Accounts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: _openAddAccount,
        icon: const Icon(Icons.add),
        label: const Text(
          'Create Account',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            AppSearchField(
              controller: _searchController,
              onChanged: (value) {
                ref
                    .read(
                  companyAccountProvider
                      .notifier,
                )
                    .search(value);
              },
            ),

            const SizedBox(height: 20),

            const AppSectionTitle(
              title: 'Account List',
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Builder(
                builder: (_) {

                  if (state.isLoading) {
                    return const AppLoading();
                  }

                  if (state
                      .filteredAccounts
                      .isEmpty) {
                    return const AppEmpty(
                      title:
                      'No Company Account Found',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      return ref
                          .read(
                        companyAccountProvider
                            .notifier,
                      )
                          .refresh();
                    },
                    child: ListView.separated(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      itemCount: state
                          .filteredAccounts
                          .length,
                      separatorBuilder:
                          (_, __) =>
                      const SizedBox(
                        height: 12,
                      ),
                      itemBuilder:
                          (_, index) {
                        final account =
                        state.filteredAccounts[
                        index];

                        return CompanyAccountCard(
                          account: account,

                          onView: () {
                            showCompanyAccountDialog(
                              context,
                              account,
                            );
                          },

                          onEdit: () {
                            _openEditAccount(
                              account,
                            );
                          },

                          onDelete: () {
                            if (account.id != null) {
                              _deleteAccount(account.id!);
                            }
                          },

                          onToggleStatus:
                              () async {
                            await ref
                                .read(
                              companyAccountProvider
                                  .notifier,
                            )
                                .toggleAccountStatus(
                              account,
                            );
                          },
                        );
                      },
                    ),
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
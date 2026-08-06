//===============================================================
// lib/features/employee_account/presentation/pages/employee_account_list_page.dart
//===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';

import '../../domain/entities/employee_account_entity.dart';
import '../providers/employee_account_provider.dart';
import '../widgets/employee_account_card.dart';
import '../widgets/employee_account_delete_dialog.dart';
import '../widgets/employee_account_view_dialog.dart';

class EmployeeAccountListPage extends ConsumerStatefulWidget {
  const EmployeeAccountListPage({super.key});

  @override
  ConsumerState<EmployeeAccountListPage> createState() =>
      _EmployeeAccountListPageState();
}

class _EmployeeAccountListPageState
    extends ConsumerState<EmployeeAccountListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(employeeAccountProvider.notifier).loadAccounts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openCreatePage() async {
    await context.push(RoutePaths.employeeAccountCreate);

    if (!mounted) return;

    ref.read(employeeAccountProvider.notifier).refresh();
  }

  Future<void> _openEditPage(EmployeeAccountEntity account) async {
    await context.push(RoutePaths.employeeAccountEdit, extra: account);

    if (!mounted) return;

    ref.read(employeeAccountProvider.notifier).refresh();
  }

  Future<void> _deleteAccount(String id) async {
    final result = await EmployeeAccountDeleteDialog.show(context);

    if (result != true) {
      return;
    }

    await ref.read(employeeAccountProvider.notifier).deleteAccount(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Employee account deleted successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeeAccountProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),

          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RoutePaths.companyDashboard);
            }
          },
        ),

        title: const Text(
          'Employee Accounts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreatePage,

        icon: const Icon(Icons.add),

        label: const Text('Create Account'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            AppSearchField(
              controller: _searchController,

              onChanged: (value) {
                ref.read(employeeAccountProvider.notifier).search(value);
              },
            ),

            const SizedBox(height: 20),

            AppSectionTitle(
              title: 'Employee Accounts (${state.filteredAccounts.length})',
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Builder(
                builder: (_) {
                  if (state.isLoading) {
                    return const AppLoading();
                  }

                  if (state.filteredAccounts.isEmpty) {
                    return const AppEmpty(title: 'No Employee Account Found');
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      return ref
                          .read(employeeAccountProvider.notifier)
                          .refresh();
                    },

                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),

                      itemCount: state.filteredAccounts.length,

                      separatorBuilder: (_, __) => const SizedBox(height: 12),

                      itemBuilder: (_, index) {
                        final account = state.filteredAccounts[index];
                        return EmployeeAccountCard(
                          account: account,

                          onView: () {
                            showEmployeeAccountDialog(context, account);
                          },

                          onEdit: () {
                            _openEditPage(account);
                          },

                          onDelete: () {
                            _deleteAccount(account.id);
                          },
                          onToggleActive: () async {
                            await ref
                                .read(employeeAccountProvider.notifier)
                                .toggleActive(account);

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  account.isActive
                                      ? 'Account deactivated successfully.'
                                      : 'Account activated successfully.',
                                ),
                              ),
                            );
                          },

                          onToggleCanLogin: () async {
                            await ref
                                .read(employeeAccountProvider.notifier)
                                .toggleCanLogin(account);

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  account.canLogin
                                      ? 'Login disabled successfully.'
                                      : 'Login enabled successfully.',
                                ),
                              ),
                            );
                          },
                          onToggleLock: () async {
                            await ref
                                .read(employeeAccountProvider.notifier)
                                .toggleLock(account);

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  account.isLocked
                                      ? 'Account unlocked successfully.'
                                      : 'Account locked successfully.',
                                ),
                              ),
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

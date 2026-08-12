//===============================================================
// lib/features/employee_account/presentation/pages/
// employee_account_list_page.dart
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
  const EmployeeAccountListPage({
    super.key,
  });

  @override
  ConsumerState<EmployeeAccountListPage> createState() =>
      _EmployeeAccountListPageState();
}

class _EmployeeAccountListPageState
    extends ConsumerState<EmployeeAccountListPage> {
  // =============================================================
  // SEARCH
  // =============================================================

  final _searchController = TextEditingController();

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(employeeAccountProvider.notifier)
          .loadAccounts();
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
        .read(employeeAccountProvider.notifier)
        .refresh();
  }

  // =============================================================
  // CREATE
  // =============================================================

  Future<void> _openCreatePage() async {
    await context.push(
      RoutePaths.employeeAccountCreate,
    );

    if (!mounted) {
      return;
    }

    await _refresh();
  }

  // =============================================================
  // EDIT
  // =============================================================

  Future<void> _openEditPage(
      EmployeeAccountEntity account,
      ) async {
    await context.push(
      RoutePaths.employeeAccountEdit,
      extra: account,
    );

    if (!mounted) {
      return;
    }

    await _refresh();
  }

  // =============================================================
  // VIEW
  // =============================================================

  void _openViewDialog(
      EmployeeAccountEntity account,
      ) {
    showEmployeeAccountDialog(
      context,
      account,
    );
  }

  // =============================================================
  // DELETE
  // =============================================================

  Future<void> _deleteAccount(
      EmployeeAccountEntity account,
      ) async {
    final result =
    await EmployeeAccountDeleteDialog.show(
      context,
    );

    if (result != true) {
      return;
    }

    try {
      await ref
          .read(employeeAccountProvider.notifier)
          .deleteAccount(account.id);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${account.username} deleted successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // =============================================================
  // TOGGLE ACTIVE
  // =============================================================

  Future<void> _toggleActive(
      EmployeeAccountEntity account,
      ) async {
    try {
      await ref
          .read(employeeAccountProvider.notifier)
          .toggleActive(account);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            account.isActive
                ? 'Account deactivated successfully.'
                : 'Account activated successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // =============================================================
  // TOGGLE LOGIN
  // =============================================================

  Future<void> _toggleCanLogin(
      EmployeeAccountEntity account,
      ) async {
    try {
      await ref
          .read(employeeAccountProvider.notifier)
          .toggleCanLogin(account);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            account.canLogin
                ? 'Login disabled successfully.'
                : 'Login enabled successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // =============================================================
  // TOGGLE LOCK
  // =============================================================

  Future<void> _toggleLock(
      EmployeeAccountEntity account,
      ) async {
    try {
      await ref
          .read(employeeAccountProvider.notifier)
          .toggleLock(account);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            account.isLocked
                ? 'Account unlocked successfully.'
                : 'Account locked successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final state =
    ref.watch(employeeAccountProvider);

    return Scaffold(
      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(
                RoutePaths.companyDashboard,
              );
            }
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),

        title: const Text(
          'Employee Accounts',
        ),
      ),

      // =========================================================
      // CREATE BUTTON
      // =========================================================

      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: _openCreatePage,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add Account',
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: RefreshIndicator(
        onRefresh: _refresh,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              // =================================================
              // SEARCH
              // =================================================

              AppSearchField(
                controller: _searchController,

                onChanged: (value) {
                  ref
                      .read(
                    employeeAccountProvider
                        .notifier,
                  )
                      .search(value);
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // =================================================
              // SECTION TITLE
              // =================================================

              AppSectionTitle(
                title:
                'Employee Accounts '
                    '(${state.filteredAccounts.length})',
              ),

              const SizedBox(
                height: 12,
              ),

              // =================================================
              // LIST
              // =================================================

              Expanded(
                child: Builder(
                  builder: (_) {
                    // =========================================
                    // LOADING
                    // =========================================

                    if (state.isLoading) {
                      return const AppLoading();
                    }

                    // =========================================
                    // EMPTY
                    // =========================================

                    if (state.filteredAccounts.isEmpty) {
                      return ListView(
                        physics:
                        const AlwaysScrollableScrollPhysics(),

                        children: const [
                          SizedBox(
                            height: 120,
                          ),
                          AppEmpty(
                            title:
                            'No Employee Account Found',
                          ),
                        ],
                      );
                    }

                    // =========================================
                    // ACCOUNTS
                    // =========================================

                    return ListView.separated(
                      physics:
                      const AlwaysScrollableScrollPhysics(),

                      itemCount:
                      state.filteredAccounts.length,

                      separatorBuilder:
                          (_, __) =>
                      const SizedBox(
                        height: 12,
                      ),

                      itemBuilder: (_, index) {
                        final account =
                        state.filteredAccounts[index];

                        return EmployeeAccountCard(
                          account: account,

                          // ===================================
                          // VIEW
                          // ===================================

                          onView: () {
                            _openViewDialog(
                              account,
                            );
                          },

                          // ===================================
                          // EDIT
                          // ===================================

                          onEdit: () {
                            _openEditPage(
                              account,
                            );
                          },

                          // ===================================
                          // DELETE
                          // ===================================

                          onDelete: () {
                            _deleteAccount(
                              account,
                            );
                          },

                          // ===================================
                          // ACTIVE
                          // ===================================

                          onToggleActive: () {
                            _toggleActive(
                              account,
                            );
                          },

                          // ===================================
                          // CAN LOGIN
                          // ===================================

                          onToggleCanLogin: () {
                            _toggleCanLogin(
                              account,
                            );
                          },

                          // ===================================
                          // LOCK
                          // ===================================

                          onToggleLock: () {
                            _toggleLock(
                              account,
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
//===============================================================
// Flutter HRMS Pro
// Company Account List Page
//
// Clean + Professional + Theme Aware
//
// Shows only useful account information.
// Technical fields such as Company ID are not displayed.
//===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';

import '../../domain/entities/company_account_entity.dart';
import '../providers/company_account_provider.dart';
import '../providers/company_account_state.dart';
import '../widgets/company_account_card.dart';
import '../widgets/company_account_view_dialog.dart';

class CompanyAccountListPage extends ConsumerStatefulWidget {
  const CompanyAccountListPage({
    super.key,
  });

  @override
  ConsumerState<CompanyAccountListPage> createState() =>
      _CompanyAccountListPageState();
}

class _CompanyAccountListPageState
    extends ConsumerState<CompanyAccountListPage> {

  // =============================================================
  // SEARCH
  // =============================================================

  final TextEditingController _searchController =
  TextEditingController();

  // =============================================================
  // RESPONSIVE
  // =============================================================

  double _contentMaxWidth(double width) {
    if (width >= 1400) {
      return 1200;
    }

    if (width >= 1100) {
      return 1100;
    }

    if (width >= 700) {
      return 850;
    }

    return double.infinity;
  }

  double _pagePadding(double width) {
    if (width >= 1200) {
      return 32;
    }

    if (width >= 700) {
      return 24;
    }

    return 16;
  }

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      ref
          .read(companyAccountProvider.notifier)
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
  // CREATE
  // =============================================================

  Future<void> _openAddAccount() async {
    await context.push(
      RoutePaths.companyAccountCreate,
    );

    if (!mounted) return;

    await ref
        .read(companyAccountProvider.notifier)
        .loadAccounts();
  }

  // =============================================================
  // EDIT
  // =============================================================

  Future<void> _openEditAccount(
      CompanyAccountEntity account,
      ) async {
    await context.push(
      RoutePaths.companyAccountEdit,
      extra: account,
    );

    if (!mounted) return;

    await ref
        .read(companyAccountProvider.notifier)
        .loadAccounts();
  }

  // =============================================================
  // DELETE
  // =============================================================

  Future<void> _deleteAccount(
      String id,
      ) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final dialogWidth =
            MediaQuery.sizeOf(dialogContext).width;

        return AlertDialog(
          icon: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color:
              colorScheme.onErrorContainer,
              size: 27,
            ),
          ),

          title: const Text(
            'Delete Account',
            textAlign: TextAlign.center,
          ),

          content: SizedBox(
            width: dialogWidth >= 600
                ? 420
                : null,
            child: const Text(
              'Are you sure you want to delete this company account? '
                  'This action cannot be undone.',
              textAlign: TextAlign.center,
            ),
          ),

          actionsAlignment:
          MainAxisAlignment.end,

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
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
                Navigator.pop(
                  dialogContext,
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

    try {
      await ref
          .read(
        companyAccountProvider.notifier,
      )
          .deleteAccount(id);

      if (!mounted) return;

      _showSuccessMessage(
        'Account deleted successfully.',
      );
    } catch (e) {
      if (!mounted) return;

      _showErrorMessage(
        e.toString(),
      );
    }
  }

  // =============================================================
  // SUCCESS MESSAGE
  // =============================================================

  void _showSuccessMessage(
      String message,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    final messenger =
    ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        behavior:
        SnackBarBehavior.floating,

        backgroundColor:
        colorScheme.inverseSurface,

        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(14),
        ),

        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color:
              colorScheme.onInverseSurface,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color:
                  colorScheme.onInverseSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // ERROR MESSAGE
  // =============================================================

  void _showErrorMessage(
      String message,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    final messenger =
    ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        behavior:
        SnackBarBehavior.floating,

        backgroundColor:
        colorScheme.errorContainer,

        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(14),
        ),

        content: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color:
              colorScheme.onErrorContainer,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                message,
                maxLines: 3,
                overflow:
                TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                  colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // =============================================================
  // SEARCH
  // =============================================================

  Widget _buildSearchSection(
      BuildContext context,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,

      elevation: 0,

      color:
      colorScheme.surfaceContainerLow,

      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(20),

        side: BorderSide(
          color:
          colorScheme.outlineVariant,
        ),
      ),

      child: Padding(
        padding:
        const EdgeInsets.all(12),

        child: AppSearchField(
          controller:
          _searchController,

          onChanged: (value) {
            ref
                .read(
              companyAccountProvider
                  .notifier,
            )
                .search(value);
          },
        ),
      ),
    );
  }

  // =============================================================
  // ACCOUNT LIST
  // =============================================================

  Widget _buildAccountList(
      BuildContext context,
      CompanyAccountState state,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    // -----------------------------------------------------------
    // LOADING
    // -----------------------------------------------------------

    if (state.isLoading) {
      return const AppLoading();
    }

    // -----------------------------------------------------------
    // EMPTY
    // -----------------------------------------------------------

    if (state.filteredAccounts.isEmpty) {
      return const AppEmpty(
        title:
        'No Company Account Found',
      );
    }

    // -----------------------------------------------------------
    // LIST
    // -----------------------------------------------------------

    return RefreshIndicator(
      color:
      colorScheme.primary,

      backgroundColor:
      colorScheme.surface,

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

        padding:
        const EdgeInsets.only(
          bottom: 100,
        ),

        itemCount:
        state.filteredAccounts.length,

        separatorBuilder:
            (_, __) =>
        const SizedBox(
          height: 12,
        ),

        itemBuilder:
            (_, index) {
          final account =
          state.filteredAccounts[index];

          return CompanyAccountCard(
            account: account,

            // ---------------------------------------------------
            // VIEW
            // ---------------------------------------------------

            onView: () {
              showCompanyAccountDialog(
                context,
                account,
              );
            },

            // ---------------------------------------------------
            // EDIT
            // ---------------------------------------------------

            onEdit: () {
              _openEditAccount(
                account,
              );
            },

            // ---------------------------------------------------
            // DELETE
            // ---------------------------------------------------

            onDelete: () {
              final id =
                  account.id;

              if (id != null) {
                _deleteAccount(id);
              }
            },

            // ---------------------------------------------------
            // STATUS
            // ---------------------------------------------------

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
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    final state =
    ref.watch(
      companyAccountProvider,
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

          icon: const Icon(
            Icons
                .arrow_back_ios_new_rounded,
          ),

          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(
                RoutePaths
                    .developerDashboard,
              );
            }
          },
        ),

        title: const Text(
          'Company Accounts',
          style: TextStyle(
            fontWeight:
            FontWeight.w800,
          ),
        ),
      ),
// =========================================================
// MOBILE CREATE
// =========================================================

      floatingActionButton:
      MediaQuery.sizeOf(context).width < 700
          ? FloatingActionButton.extended(
        onPressed: _openAddAccount,

        backgroundColor:
        colorScheme.primaryContainer,

        foregroundColor:
        colorScheme.onPrimaryContainer,

        elevation: 2,

        icon: const Icon(
          Icons.add_rounded,
        ),

        label: const Text(
          'Create Account',
        ),
      )
          : null,
      // =========================================================
      // BODY
      // =========================================================

      body: LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          final width =
              constraints.maxWidth;

          final maxWidth =
          _contentMaxWidth(width);

          final horizontalPadding =
          _pagePadding(width);

          final isDesktop =
              width >= 700;

          return Center(
            child: ConstrainedBox(
              constraints:
              BoxConstraints(
                maxWidth: maxWidth,
              ),

              child: Padding(
                padding:
                EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
                  horizontalPadding,
                  32,
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    // =================================================
                    // SEARCH
                    // =================================================

                    _buildSearchSection(
                      context,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // =================================================
                    // ACCOUNT LIST
                    // =================================================

                    Expanded(
                      child:
                      _buildAccountList(
                        context,
                        state,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
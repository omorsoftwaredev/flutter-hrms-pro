// lib/features/company/presentation/pages/company_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';
import '../../domain/entities/company_entity.dart';
import '../providers/company_provider.dart';
import '../widgets/company_card.dart';
import 'company_form_page.dart';
import 'package:go_router/go_router.dart';

class CompanyListPage extends ConsumerStatefulWidget {
  const CompanyListPage({super.key});

  @override
  ConsumerState<CompanyListPage> createState() =>
      _CompanyListPageState();
}

class _CompanyListPageState
    extends ConsumerState<CompanyListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(companyProvider.notifier).loadCompanies();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddCompany() async {
    await context.pushNamed('add-company');

    if (mounted) {
      ref.read(companyProvider.notifier).loadCompanies();
    }
  }

  Future<void> _openEditCompany(
      CompanyEntity company,
      ) async {
    await context.pushNamed(
      'edit-company',
      extra: company,
    );

    if (mounted) {
      ref.read(companyProvider.notifier).loadCompanies();
    }
  }

  Future<void> _deleteCompany(String id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete Company'),
          content: const Text(
            'Are you sure you want to delete this company?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    await ref
        .read(companyProvider.notifier)
        .deleteCompany(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Company deleted successfully.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(companyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Companies'),
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: _openAddCompany,
        icon: const Icon(Icons.add),
        label: const Text('Add Company'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppSearchField(
              controller: _searchController,
              onChanged: (value) {
                ref
                    .read(companyProvider.notifier)
                    .search(value);
              },
            ),

            const SizedBox(height: 20),

            const AppSectionTitle(
              title: 'Company List',
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Builder(
                builder: (_) {
                  if (state.isLoading) {
                    return const AppLoading();
                  }

                  if (state.filteredCompanies.isEmpty) {
                    return const AppEmpty(
                      title: 'No Company Found',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => ref
                        .read(companyProvider.notifier)
                        .refresh(),
                    child: ListView.separated(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      itemCount:
                      state.filteredCompanies.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final company =
                        state.filteredCompanies[index];

                        return CompanyCard(
                          company: company,
                          onEdit: () =>
                              _openEditCompany(company),
                          onDelete: () =>
                              _deleteCompany(company.id),
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
// lib/features/company/presentation/pages/company_form_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../domain/entities/company_entity.dart';
import '../providers/company_provider.dart';
import '../widgets/company_form.dart';

class CompanyFormPage extends ConsumerWidget {
  const CompanyFormPage({
    super.key,
    this.company,
  });

  final CompanyEntity? company;

  bool get isEdit => company != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(companyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Company' : 'Add Company',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: CompanyForm(
            initialName: company?.name,
            initialCode: company?.code,
            initialEmail: company?.email,
            initialPhone: company?.phone,
            initialAddress: company?.address,
            initialIsActive: company?.isActive ?? true,
            isLoading: state.isSaving,
            onSubmit: (
                name,
                code,
                email,
                phone,
                address,
                isActive,
                ) async {
              final entity = CompanyEntity(
                id: company?.id ?? '',
                name: name,
                code: code,
                email: email,
                phone: phone,
                address: address,
                logoUrl: company?.logoUrl ?? '',
                website: company?.website ?? '',
                contactPerson: company?.contactPerson ?? '',
                taxNumber: company?.taxNumber ?? '',
                registrationNumber:
                company?.registrationNumber ?? '',
                notes: company?.notes ?? '',
                isActive: isActive,
                createdAt:
                company?.createdAt ?? DateTime.now(),
                updatedAt: DateTime.now(),
              );

              try {
                if (isEdit) {
                  await ref
                      .read(companyProvider.notifier)
                      .updateCompany(entity);
                } else {
                  await ref
                      .read(companyProvider.notifier)
                      .createCompany(entity);
                }

                if (context.mounted) {
                  context.go(
                    RoutePaths.companies,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
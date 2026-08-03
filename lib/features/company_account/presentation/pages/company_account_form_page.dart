//===============================================================
// lib/features/company_account/presentation/pages/company_account_form_page.dart
//===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/company_account_entity.dart';
import 'company_account_form.dart';

class CompanyAccountFormPage extends ConsumerWidget {
  const CompanyAccountFormPage({
    super.key,
    this.account,
  });

  final CompanyAccountEntity? account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = account != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? 'Edit Company Account'
              : 'Create Company Account',
        ),
      ),

      body: CompanyAccountForm(
        account: account,
      ),
    );
  }
}
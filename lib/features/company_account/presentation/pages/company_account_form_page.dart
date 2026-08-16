//===============================================================
// Flutter HRMS Pro
// Company Account Form Page
//
// Responsive + Theme Aware
// Mobile / Tablet / Desktop
//
// Create / Edit Company Account
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

  bool get isEdit => account != null;

  // =============================================================
  // RESPONSIVE HELPERS
  // =============================================================

  double _contentMaxWidth(double width) {
    if (width >= 1400) {
      return 1100;
    }

    if (width >= 1100) {
      return 1000;
    }

    if (width >= 700) {
      return 820;
    }

    return double.infinity;
  }

  double _horizontalPadding(double width) {
    if (width >= 1200) {
      return 32;
    }

    if (width >= 700) {
      return 24;
    }

    return 16;
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final maxWidth = _contentMaxWidth(width);
    final horizontalPadding = _horizontalPadding(width);

    final pageTitle = isEdit
        ? 'Edit Company Account'
        : 'Create Company Account';

    final pageSubtitle = isEdit
        ? 'Update account credentials and access settings.'
        : 'Create a secure login account for a company.';

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,

        backgroundColor: colorScheme.surface,

        foregroundColor: colorScheme.onSurface,

        centerTitle: false,

        titleSpacing: 0,

        title: Row(
          children: [
            // ---------------------------------------------------
            // HEADER ICON
            // ---------------------------------------------------

            Container(
              width: 40,
              height: 40,

              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(
                isEdit
                    ? Icons.manage_accounts_outlined
                    : Icons.person_add_alt_1_outlined,
                color: colorScheme.onPrimaryContainer,
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            // ---------------------------------------------------
            // TITLE
            // ---------------------------------------------------

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    pageTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  if (width >= 600) ...[
                    const SizedBox(height: 2),

                    Text(
                      'Company Account Management',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                        colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            20,
            horizontalPadding,
            20,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // FORM CARD
                  // =================================================

                  _buildFormCard(
                    context,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  // =============================================================
  // FORM CARD
  // =============================================================

  Widget _buildFormCard(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        // ===================================================
        // FORM
        // ===================================================

        CompanyAccountForm(
          account: account,
        ),
      ],
    );
  }
}
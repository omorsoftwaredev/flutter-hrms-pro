// ===============================================================
// Flutter HRMS Pro
// Company Account View Dialog
//
// Responsive + Theme Aware
//
// Version : 2.0.0
// ===============================================================

import 'package:flutter/material.dart';

import '../../domain/entities/company_account_entity.dart';

Future<void> showCompanyAccountDialog(
    BuildContext context,
    CompanyAccountEntity account,
    ) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final screenWidth =
          MediaQuery.sizeOf(dialogContext).width;

      final screenHeight =
          MediaQuery.sizeOf(dialogContext).height;

      final dialogWidth =
      screenWidth >= 900
          ? 650.0
          : screenWidth * 0.92;

      return Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogWidth,
            maxHeight: screenHeight * 0.88,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // =================================================
              // HEADER
              // =================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  20,
                  14,
                  16,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color:
                        colorScheme.primaryContainer,
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.manage_accounts_outlined,
                        color: colorScheme
                            .onPrimaryContainer,
                        size: 25,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company Account',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: theme
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              fontWeight:
                              FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            account.username.trim().isEmpty
                                ? 'Account Information'
                                : account.username,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: theme
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      tooltip: 'Close',
                      onPressed: () {
                        Navigator.pop(
                          dialogContext,
                        );
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 1,
                color:
                colorScheme.outlineVariant,
              ),

              // =================================================
              // CONTENT
              // =================================================

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      // -------------------------------------------
                      // ACCOUNT SUMMARY
                      // -------------------------------------------

                      _buildSummaryCard(
                        context,
                        account,
                      ),

                      const SizedBox(height: 18),

                      // -------------------------------------------
                      // COMPANY
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon:
                        Icons.business_outlined,
                        title: 'Company',
                        value:
                        account.companyName,
                      ),

                      // -------------------------------------------
                      // COMPANY ID
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon:
                        Icons.fingerprint_rounded,
                        title: 'Company ID',
                        value:
                        account.companyId,
                      ),

                      // -------------------------------------------
                      // USERNAME
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon:
                        Icons.person_outline_rounded,
                        title: 'Username',
                        value:
                        account.username,
                      ),

                      // -------------------------------------------
                      // PASSWORD STATUS
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon:
                        Icons.lock_outline_rounded,
                        title:
                        'Password Status',
                        value: account
                            .mustChangePassword
                            ? 'Password change required'
                            : 'Password is OK',
                      ),

                      // -------------------------------------------
                      // LAST LOGIN
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon:
                        Icons.login_outlined,
                        title: 'Last Login',
                        value:
                        account.lastLoginAt
                            ?.toString(),
                      ),

                      // -------------------------------------------
                      // CREATED
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon:
                        Icons.calendar_today_outlined,
                        title: 'Created At',
                        value:
                        account.createdAt
                            .toString(),
                      ),

                      // -------------------------------------------
                      // UPDATED
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon:
                        Icons.update_outlined,
                        title: 'Updated At',
                        value:
                        account.updatedAt
                            ?.toString(),
                      ),

                      // -------------------------------------------
                      // STATUS
                      // -------------------------------------------

                      _buildStatus(
                        context,
                        account.isActive,
                      ),
                    ],
                  ),
                ),
              ),

              // =================================================
              // FOOTER
              // =================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  22,
                  14,
                  22,
                  18,
                ),
                decoration: BoxDecoration(
                  color:
                  colorScheme.surfaceContainerLow,
                  borderRadius:
                  const BorderRadius.only(
                    bottomLeft:
                    Radius.circular(24),
                    bottomRight:
                    Radius.circular(24),
                  ),
                ),
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ===============================================================
// SUMMARY CARD
// ===============================================================

Widget _buildSummaryCard(
    BuildContext context,
    CompanyAccountEntity account,
    ) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  final username =
  account.username.trim().isEmpty
      ? '?'
      : account.username
      .trim()
      .substring(0, 1)
      .toUpperCase();

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          colorScheme.primaryContainer
              .withValues(alpha: 0.75),
          colorScheme.surfaceContainerLow,
        ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: colorScheme.outlineVariant,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius:
            BorderRadius.circular(17),
          ),
          alignment: Alignment.center,
          child: Text(
            username,
            style:
            theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                account.username.trim().isEmpty
                    ? 'Unknown User'
                    : account.username,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style:
                theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                account.companyName
                    ?.trim()
                    .isNotEmpty ==
                    true
                    ? account.companyName!
                    : 'Company Account',
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
                style:
                theme.textTheme.bodySmall?.copyWith(
                  color:
                  colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ===============================================================
// INFO ITEM
// ===============================================================

Widget _buildInfo(
    BuildContext context, {
      required IconData icon,
      required String title,
      required String? value,
    }) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  final displayValue =
  value == null || value.trim().isEmpty
      ? '-'
      : value.trim();

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color:
      colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: colorScheme.outlineVariant,
      ),
    ),
    child: Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color:
            colorScheme.primaryContainer,
            borderRadius:
            BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 19,
            color:
            colorScheme.onPrimaryContainer,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                theme.textTheme.labelMedium?.copyWith(
                  color:
                  colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                displayValue,
                maxLines: 3,
                overflow:
                TextOverflow.ellipsis,
                style:
                theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ===============================================================
// STATUS
// ===============================================================

Widget _buildStatus(
    BuildContext context,
    bool isActive,
    ) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  final backgroundColor = isActive
      ? colorScheme.secondaryContainer
      : colorScheme.errorContainer;

  final foregroundColor = isActive
      ? colorScheme.onSecondaryContainer
      : colorScheme.onErrorContainer;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        Icon(
          isActive
              ? Icons.check_circle_outline_rounded
              : Icons.cancel_outlined,
          color: foregroundColor,
          size: 21,
        ),

        const SizedBox(width: 10),

        Text(
          'Account Status',
          style:
          theme.textTheme.labelMedium?.copyWith(
            color:
            foregroundColor.withValues(
              alpha: 0.75,
            ),
            fontWeight: FontWeight.w600,
          ),
        ),

        const Spacer(),

        Text(
          isActive ? 'Active' : 'Inactive',
          style:
          theme.textTheme.bodyMedium?.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}
// ===============================================================
// Flutter HRMS Pro
// Company Account View Dialog
//
// Responsive + Theme Aware
//
// Version : 3.0.0
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
      // =========================================================
      // RESPONSIVE
      // =========================================================

      final width = MediaQuery.sizeOf(dialogContext).width;
      final height = MediaQuery.sizeOf(dialogContext).height;

      final bool isDesktop = width >= 900;
      final bool isTablet = width >= 600 && width < 900;

      final double dialogWidth = isDesktop
          ? 650
          : isTablet
          ? 560
          : width * 0.92;

      final double dialogMaxHeight = isDesktop
          ? height * 0.86
          : height * 0.88;

      final double contentPadding = isDesktop
          ? 22
          : isTablet
          ? 20
          : 16;

      final double headerHorizontalPadding = isDesktop
          ? 22
          : isTablet
          ? 20
          : 16;

      final double titleSize = isDesktop
          ? 20
          : 19;

      final double headerIconBox = isDesktop
          ? 48
          : 46;

      final double headerIconSize = isDesktop
          ? 25
          : 23;

      return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 24 : 16,
          vertical: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogWidth,
            maxHeight: dialogMaxHeight,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // =================================================
              // HEADER
              // =================================================

              Padding(
                padding: EdgeInsets.fromLTRB(
                  headerHorizontalPadding,
                  18,
                  12,
                  16,
                ),
                child: Row(
                  children: [
                    // -------------------------------------------------
                    // HEADER ICON
                    // -------------------------------------------------

                    Container(
                      width: headerIconBox,
                      height: headerIconBox,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.manage_accounts_outlined,
                        color: colorScheme.onPrimaryContainer,
                        size: headerIconSize,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // -------------------------------------------------
                    // TITLE
                    // -------------------------------------------------

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company Account',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            account.username.trim().isEmpty
                                ? 'Account Information'
                                : account.username.trim(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // -------------------------------------------------
                    // CLOSE
                    // -------------------------------------------------

                    IconButton(
                      tooltip: 'Close',
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      style: IconButton.styleFrom(
                        foregroundColor:
                        colorScheme.onSurfaceVariant,
                      ),
                      icon: const Icon(
                        Icons.close_rounded,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 1,
                color: colorScheme.outlineVariant,
              ),

              // =================================================
              // CONTENT
              // =================================================

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(contentPadding),
                  child: Column(
                    children: [
                      // -------------------------------------------
                      // SUMMARY
                      // -------------------------------------------

                      _buildSummaryCard(
                        context,
                        account,
                      ),

                      const SizedBox(height: 16),

                      // -------------------------------------------
                      // COMPANY
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon: Icons.business_outlined,
                        title: 'Company',
                        value: account.companyName,
                      ),

                      // -------------------------------------------
                      // COMPANY ID
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon: Icons.fingerprint_rounded,
                        title: 'Company ID',
                        value: account.companyId,
                      ),

                      // -------------------------------------------
                      // USERNAME
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon: Icons.person_outline_rounded,
                        title: 'Username',
                        value: account.username,
                      ),

                      // -------------------------------------------
                      // PASSWORD STATUS
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon: Icons.lock_outline_rounded,
                        title: 'Password Status',
                        value: account.mustChangePassword
                            ? 'Password change required'
                            : 'Password is OK',
                      ),

                      // -------------------------------------------
                      // LAST LOGIN
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon: Icons.login_outlined,
                        title: 'Last Login',
                        value: account.lastLoginAt?.toString(),
                      ),

                      // -------------------------------------------
                      // CREATED
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon: Icons.calendar_today_outlined,
                        title: 'Created At',
                        value: account.createdAt.toString(),
                      ),

                      // -------------------------------------------
                      // UPDATED
                      // -------------------------------------------

                      _buildInfo(
                        context,
                        icon: Icons.update_outlined,
                        title: 'Updated At',
                        value: account.updatedAt?.toString(),
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
                padding: EdgeInsets.fromLTRB(
                  contentPadding,
                  12,
                  contentPadding,
                  16,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: SizedBox(
                  height: isDesktop ? 50 : 48,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    style: FilledButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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

  final username = account.username.trim().isEmpty
      ? '?'
      : account.username
      .trim()
      .substring(0, 1)
      .toUpperCase();

  final userName = account.username.trim().isEmpty
      ? 'Unknown User'
      : account.username.trim();

  final companyName =
  account.companyName?.trim().isNotEmpty == true
      ? account.companyName!.trim()
      : 'Company Account';

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: colorScheme.primaryContainer.withValues(
        alpha: 0.45,
      ),
      borderRadius: BorderRadius.circular(17),
      border: Border.all(
        color: colorScheme.outlineVariant,
      ),
    ),
    child: Row(
      children: [
        // ---------------------------------------------------------
        // AVATAR
        // ---------------------------------------------------------

        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Text(
            username,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(width: 13),

        // ---------------------------------------------------------
        // USER INFORMATION
        // ---------------------------------------------------------

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 15,
                    color: colorScheme.onSurfaceVariant,
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                    child: Text(
                      companyName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
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
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: colorScheme.outlineVariant,
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------------------------------------------------
        // ICON
        // ---------------------------------------------------------

        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(11),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 19,
            color: colorScheme.onPrimaryContainer,
          ),
        ),

        const SizedBox(width: 11),

        // ---------------------------------------------------------
        // INFORMATION
        // ---------------------------------------------------------

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                displayValue,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
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
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 13,
    ),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: foregroundColor.withValues(
          alpha: 0.10,
        ),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: foregroundColor.withValues(
              alpha: 0.10,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(
            isActive
                ? Icons.check_circle_outline_rounded
                : Icons.cancel_outlined,
            color: foregroundColor,
            size: 19,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Account Status',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: foregroundColor.withValues(
                    alpha: 0.75,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                isActive ? 'Active' : 'Inactive',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: foregroundColor,
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
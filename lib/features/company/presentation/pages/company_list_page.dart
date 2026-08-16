// ===============================================================
// Flutter HRMS Pro
// Company List Page
//
// Responsive + Theme Aware
// Mobile / Tablet / Desktop
//
// Premium Company Management UI
//
// Version : 3.0.0
// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';

import '../../domain/entities/company_entity.dart';
import '../providers/company_provider.dart';
import '../widgets/company_card.dart';

// ===============================================================
// COMPANY LIST PAGE
// ===============================================================

class CompanyListPage extends ConsumerStatefulWidget {
  const CompanyListPage({
    super.key,
  });

  @override
  ConsumerState<CompanyListPage> createState() =>
      _CompanyListPageState();
}

// ===============================================================
// STATE
// ===============================================================

class _CompanyListPageState
    extends ConsumerState<CompanyListPage> {
  // =============================================================
  // SEARCH CONTROLLER
  // =============================================================

  final TextEditingController _searchController =
  TextEditingController();

  // =============================================================
  // RESPONSIVE
  // =============================================================

  double _contentMaxWidth(double width) {
    if (width >= 1500) {
      return 1280;
    }

    if (width >= 1200) {
      return 1160;
    }

    if (width >= 900) {
      return 900;
    }

    if (width >= 700) {
      return 760;
    }

    return double.infinity;
  }

  double _pagePadding(double width) {
    if (width >= 1400) {
      return 32;
    }

    if (width >= 1000) {
      return 28;
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
          .read(companyProvider.notifier)
          .loadCompanies();
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
  // ADD COMPANY
  // =============================================================

  Future<void> _openAddCompany() async {
    await context.push(
      RoutePaths.companyCreate,
    );

    if (!mounted) return;

    await ref
        .read(companyProvider.notifier)
        .loadCompanies();
  }

  // =============================================================
  // EDIT COMPANY
  // =============================================================

  Future<void> _openEditCompany(
      CompanyEntity company,
      ) async {
    await context.push(
      RoutePaths.companyEdit,
      extra: company,
    );

    if (!mounted) return;

    await ref
        .read(companyProvider.notifier)
        .loadCompanies();
  }

  // =============================================================
  // DELETE COMPANY
  // =============================================================

  Future<void> _deleteCompany(
      String id,
      ) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final dialogTheme =
        Theme.of(dialogContext);

        final dialogColorScheme =
            dialogTheme.colorScheme;

        return AlertDialog(
          backgroundColor:
          dialogColorScheme.surface,

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(24),
          ),

          icon: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color:
              dialogColorScheme.errorContainer,
              borderRadius:
              BorderRadius.circular(17),
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color:
              dialogColorScheme
                  .onErrorContainer,
              size: 28,
            ),
          ),

          title: Text(
            'Delete Company',
            textAlign: TextAlign.center,
            style: dialogTheme
                .textTheme
                .titleLarge
                ?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          content: Text(
            'Are you sure you want to delete this company? '
                'This action cannot be undone.',
            textAlign: TextAlign.center,
            style: dialogTheme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color:
              dialogColorScheme
                  .onSurfaceVariant,
              height: 1.45,
            ),
          ),

          actionsAlignment:
          MainAxisAlignment.center,

          actionsPadding:
          const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            20,
          ),

          actions: [
            Expanded(
              child: OutlinedButton(
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
            ),

            const SizedBox(width: 10),

            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor:
                  dialogColorScheme.error,
                  foregroundColor:
                  dialogColorScheme.onError,
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
            ),
          ],
        );
      },
    );

    if (result != true) return;

    try {
      await ref
          .read(companyProvider.notifier)
          .deleteCompany(id);

      if (!mounted) return;

      final messenger =
      ScaffoldMessenger.of(context);

      messenger.hideCurrentSnackBar();

      messenger.showSnackBar(
        SnackBar(
          behavior:
          SnackBarBehavior.floating,
          backgroundColor:
          colorScheme.inverseSurface,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              Icon(
                Icons
                    .check_circle_outline_rounded,
                color:
                colorScheme
                    .onInverseSurface,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Company deleted successfully.',
                  style: TextStyle(
                    color:
                    colorScheme
                        .onInverseSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final messenger =
      ScaffoldMessenger.of(context);

      messenger.hideCurrentSnackBar();

      messenger.showSnackBar(
        SnackBar(
          behavior:
          SnackBarBehavior.floating,
          backgroundColor:
          colorScheme.error,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              Icon(
                Icons
                    .error_outline_rounded,
                color:
                colorScheme.onError,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  e.toString(),
                  maxLines: 3,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                    colorScheme.onError,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // =============================================================
  // COMPANY DETAILS
  // =============================================================

  Future<void> _showCompanyDetails(
      CompanyEntity company,
      ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme =
        Theme.of(dialogContext);

        final colorScheme =
            theme.colorScheme;

        final screenSize =
        MediaQuery.sizeOf(
          dialogContext,
        );

        final bool isMobile =
            screenSize.width < 600;

        final double dialogWidth =
        isMobile
            ? screenSize.width * .94
            : screenSize.width >= 1200
            ? 900
            : 720;

        final double dialogHeight =
            screenSize.height * .88;

        return Dialog(
          insetPadding:
          EdgeInsets.symmetric(
            horizontal:
            isMobile ? 10 : 24,
            vertical: 20,
          ),

          backgroundColor:
          colorScheme.surface,

          elevation: 0,

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              isMobile ? 20 : 28,
            ),
          ),

          child: ConstrainedBox(
            constraints:
            BoxConstraints(
              maxWidth: dialogWidth,
              maxHeight: dialogHeight,
            ),

            child: Column(
              children: [
                // =================================================
                // HEADER
                // =================================================

                _buildDetailsHeader(
                  dialogContext,
                  company,
                ),

                Divider(
                  height: 1,
                  color:
                  colorScheme
                      .outlineVariant,
                ),

                // =================================================
                // BODY
                // =================================================

                Expanded(
                  child:
                  SingleChildScrollView(
                    physics:
                    const BouncingScrollPhysics(),

                    padding:
                    EdgeInsets.all(
                      isMobile ? 16 : 24,
                    ),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        // =========================================
                        // SUMMARY
                        // =========================================

                        _buildCompanySummary(
                          dialogContext,
                          company,
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        // =========================================
                        // CONTACT
                        // =========================================

                        _buildDetailsSection(
                          dialogContext,
                          title:
                          'Contact Information',
                          subtitle:
                          'Company communication details',
                          icon: Icons
                              .contact_phone_outlined,
                          children: [
                            _buildResponsiveInfoGrid(
                              dialogContext,
                              [
                                _buildInfoItem(
                                  dialogContext,
                                  icon: Icons
                                      .phone_outlined,
                                  title: 'Phone',
                                  value:
                                  company.phone,
                                ),
                                _buildInfoItem(
                                  dialogContext,
                                  icon: Icons
                                      .email_outlined,
                                  title: 'Email',
                                  value:
                                  company.email,
                                ),
                                _buildInfoItem(
                                  dialogContext,
                                  icon: Icons
                                      .language_outlined,
                                  title:
                                  'Website',
                                  value:
                                  company.website,
                                ),
                                _buildInfoItem(
                                  dialogContext,
                                  icon: Icons
                                      .person_outline_rounded,
                                  title:
                                  'Contact Person',
                                  value:
                                  company.contactPerson,
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        // =========================================
                        // BUSINESS
                        // =========================================

                        _buildDetailsSection(
                          dialogContext,
                          title:
                          'Business Information',
                          subtitle:
                          'Registration and identification details',
                          icon: Icons
                              .business_center_outlined,
                          children: [
                            _buildResponsiveInfoGrid(
                              dialogContext,
                              [
                                _buildInfoItem(
                                  dialogContext,
                                  icon: Icons
                                      .receipt_long_outlined,
                                  title:
                                  'Tax Number',
                                  value:
                                  company.taxNumber,
                                ),
                                _buildInfoItem(
                                  dialogContext,
                                  icon: Icons
                                      .badge_outlined,
                                  title:
                                  'Registration Number',
                                  value:
                                  company.registrationNumber,
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        // =========================================
                        // ADDRESS
                        // =========================================

                        _buildDetailsSection(
                          dialogContext,
                          title: 'Address',
                          subtitle:
                          'Registered company address',
                          icon: Icons
                              .location_on_outlined,
                          children: [
                            _buildLargeInfoItem(
                              dialogContext,
                              icon: Icons
                                  .location_on_outlined,
                              title:
                              'Company Address',
                              value:
                              company.address,
                            ),
                          ],
                        ),

                        // =========================================
                        // NOTES
                        // =========================================

                        if (company.notes !=
                            null &&
                            company.notes!
                                .trim()
                                .isNotEmpty) ...[
                          const SizedBox(
                            height: 16,
                          ),

                          _buildDetailsSection(
                            dialogContext,
                            title: 'Notes',
                            subtitle:
                            'Additional company information',
                            icon: Icons
                                .notes_outlined,
                            children: [
                              _buildLargeInfoItem(
                                dialogContext,
                                icon: Icons
                                    .notes_outlined,
                                title:
                                'Additional Notes',
                                value:
                                company.notes,
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(
                          height: 16,
                        ),

                        // =========================================
                        // STATUS
                        // =========================================

                        _buildCompanyStatus(
                          dialogContext,
                          company.isActive,
                        ),

                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),

                // =================================================
                // FOOTER
                // =================================================

                _buildDetailsFooter(
                  dialogContext,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =============================================================
  // DETAILS HEADER
  // =============================================================

  Widget _buildDetailsHeader(
      BuildContext context,
      CompanyEntity company,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final bool isMobile =
        screenWidth < 600;

    final String companyName =
    company.name.trim().isEmpty
        ? 'Company'
        : company.name.trim();

    final String initial =
    companyName.isNotEmpty
        ? companyName[0]
        .toUpperCase()
        : 'C';

    return Padding(
      padding:
      EdgeInsets.fromLTRB(
        isMobile ? 18 : 24,
        isMobile ? 18 : 22,
        isMobile ? 10 : 14,
        isMobile ? 16 : 20,
      ),

      child: Row(
        children: [
          // =======================================================
          // AVATAR
          // =======================================================

          Container(
            width: isMobile ? 52 : 60,
            height: isMobile ? 52 : 60,

            decoration:
            BoxDecoration(
              gradient:
              LinearGradient(
                begin:
                Alignment.topLeft,
                end:
                Alignment.bottomRight,
                colors: [
                  colorScheme.primary,
                  colorScheme.primary
                      .withValues(
                    alpha: .72,
                  ),
                ],
              ),
              borderRadius:
              BorderRadius.circular(
                isMobile ? 15 : 18,
              ),
            ),

            child: Center(
              child: Text(
                initial,
                style: theme
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                  color:
                  colorScheme
                      .onPrimary,
                  fontWeight:
                  FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          // =======================================================
          // NAME
          // =======================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  companyName,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w900,
                    letterSpacing: -.3,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

              ],
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          // =======================================================
          // CLOSE
          // =======================================================

          IconButton(
            tooltip: 'Close',
            onPressed: () {
              Navigator.pop(context);
            },
            style:
            IconButton.styleFrom(
              backgroundColor:
              colorScheme
                  .surfaceContainerHighest,
            ),
            icon: const Icon(
              Icons.close_rounded,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // COMPANY SUMMARY
  // =============================================================

  Widget _buildCompanySummary(
      BuildContext context,
      CompanyEntity company,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(18),

      decoration:
      BoxDecoration(
        color: colorScheme
            .primaryContainer
            .withValues(
          alpha: .32,
        ),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color:
          colorScheme.outlineVariant,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration:
            BoxDecoration(
              color:
              colorScheme.primary,
              borderRadius:
              BorderRadius.circular(
                13,
              ),
            ),
            child: Icon(
              Icons.business_outlined,
              color:
              colorScheme.onPrimary,
              size: 22,
            ),
          ),

          const SizedBox(
            width: 13,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Company Profile',
                  style: theme
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  'Company information and current status',
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

          const SizedBox(
            width: 10,
          ),

          _buildStatusChip(
            context,
            company.isActive,
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DETAILS SECTION
  // =============================================================

  Widget _buildDetailsSection(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required List<Widget> children,
      }) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(16),

      decoration:
      BoxDecoration(
        color:
        colorScheme.surfaceContainerLow,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color:
          colorScheme.outlineVariant,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =======================================================
          // HEADER
          // =======================================================

          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration:
                BoxDecoration(
                  color: colorScheme
                      .primaryContainer,
                  borderRadius:
                  BorderRadius.circular(
                    11,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: colorScheme
                      .onPrimaryContainer,
                ),
              ),

              const SizedBox(
                width: 11,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    Text(
                      subtitle,
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
            ],
          ),

          const SizedBox(
            height: 15,
          ),

          ...children,
        ],
      ),
    );
  }

  // =============================================================
  // RESPONSIVE INFO GRID
  // =============================================================

  Widget _buildResponsiveInfoGrid(
      BuildContext context,
      List<Widget> items,
      ) {
    final width =
        MediaQuery.sizeOf(context).width;

    final bool twoColumns =
        width >= 650;

    if (!twoColumns) {
      return Column(
        children: [
          for (
          int i = 0;
          i < items.length;
          i++
          ) ...[
            items[i],

            if (i != items.length - 1)
              const SizedBox(
                height: 10,
              ),
          ],
        ],
      );
    }

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final itemWidth =
            (constraints.maxWidth - 10) /
                2;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final item in items)
              SizedBox(
                width: itemWidth,
                child: item,
              ),
          ],
        );
      },
    );
  }

  // =============================================================
  // INFO ITEM
  // =============================================================

  Widget _buildInfoItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String? value,
      }) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final displayValue =
    value == null ||
        value.trim().isEmpty
        ? '-'
        : value.trim();

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 12,
      ),

      decoration:
      BoxDecoration(
        color:
        colorScheme.surface,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color:
          colorScheme.outlineVariant,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,

            decoration:
            BoxDecoration(
              color: colorScheme
                  .primaryContainer,
              borderRadius:
              BorderRadius.circular(
                10,
              ),
            ),

            child: Icon(
              icon,
              size: 17,
              color: colorScheme
                  .onPrimaryContainer,
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  displayValue,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // LARGE INFO ITEM
  // =============================================================

  Widget _buildLargeInfoItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String? value,
      }) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final displayValue =
    value == null ||
        value.trim().isEmpty
        ? '-'
        : value.trim();

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(14),

      decoration:
      BoxDecoration(
        color:
        colorScheme.surface,
        borderRadius:
        BorderRadius.circular(15),
        border: Border.all(
          color:
          colorScheme.outlineVariant,
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,

            decoration:
            BoxDecoration(
              color: colorScheme
                  .primaryContainer,
              borderRadius:
              BorderRadius.circular(
                11,
              ),
            ),

            child: Icon(
              icon,
              size: 19,
              color: colorScheme
                  .onPrimaryContainer,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme
                      .textTheme
                      .labelMedium
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  displayValue,
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w600,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // COMPANY STATUS
  // =============================================================

  Widget _buildCompanyStatus(
      BuildContext context,
      bool isActive,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final backgroundColor =
    isActive
        ? colorScheme
        .secondaryContainer
        : colorScheme
        .errorContainer;

    final foregroundColor =
    isActive
        ? colorScheme
        .onSecondaryContainer
        : colorScheme
        .onErrorContainer;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(16),

      decoration:
      BoxDecoration(
        color: backgroundColor,
        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration:
            BoxDecoration(
              color:
              foregroundColor
                  .withValues(
                alpha: .12,
              ),
              shape:
              BoxShape.circle,
            ),

            child: Icon(
              isActive
                  ? Icons
                  .check_circle_rounded
                  : Icons
                  .cancel_rounded,
              color:
              foregroundColor,
              size: 22,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Company Status',
                  style: theme
                      .textTheme
                      .labelMedium
                      ?.copyWith(
                    color:
                    foregroundColor
                        .withValues(
                      alpha: .75,
                    ),
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  isActive
                      ? 'This company is currently active'
                      : 'This company is currently inactive',
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    foregroundColor,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Text(
            isActive
                ? 'ACTIVE'
                : 'INACTIVE',
            style: theme
                .textTheme
                .labelMedium
                ?.copyWith(
              color:
              foregroundColor,
              fontWeight:
              FontWeight.w900,
              letterSpacing: .5,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // STATUS CHIP
  // =============================================================

  Widget _buildStatusChip(
      BuildContext context,
      bool isActive,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final backgroundColor =
    isActive
        ? colorScheme
        .secondaryContainer
        : colorScheme
        .errorContainer;

    final foregroundColor =
    isActive
        ? colorScheme
        .onSecondaryContainer
        : colorScheme
        .onErrorContainer;

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration:
      BoxDecoration(
        color: backgroundColor,
        borderRadius:
        BorderRadius.circular(30),
      ),

      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration:
            BoxDecoration(
              color:
              foregroundColor,
              shape:
              BoxShape.circle,
            ),
          ),

          const SizedBox(
            width: 6,
          ),

          Text(
            isActive
                ? 'Active'
                : 'Inactive',
            style: theme
                .textTheme
                .labelSmall
                ?.copyWith(
              color:
              foregroundColor,
              fontWeight:
              FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DETAILS FOOTER
  // =============================================================

  Widget _buildDetailsFooter(
      BuildContext context,
      ) {
    final colorScheme =
        Theme.of(context)
            .colorScheme;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        18,
      ),

      decoration:
      BoxDecoration(
        color: colorScheme
            .surfaceContainerLow,

        borderRadius:
        const BorderRadius.only(
          bottomLeft:
          Radius.circular(28),
          bottomRight:
          Radius.circular(28),
        ),

        border: Border(
          top: BorderSide(
            color: colorScheme
                .outlineVariant,
          ),
        ),
      ),

      child: SizedBox(
        width: double.infinity,

        child: FilledButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.check_rounded,
          ),

          label: const Text(
            'Done',
          ),
        ),
      ),
    );
  }

  // =============================================================
  // PAGE HEADER
  // =============================================================

  Widget _buildPageHeader(
      BuildContext context,
      bool isDesktop,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        if (isDesktop) ...[
          const SizedBox(
            width: 20,
          ),

          FilledButton.icon(
            onPressed:
            _openAddCompany,
            icon: const Icon(
              Icons.add_rounded,
            ),
            label: const Text(
              'Add Company',
            ),
          ),
        ],
      ],
    );
  }

// =============================================================
// SEARCH SECTION
// =============================================================

  Widget _buildSearchSection(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: AppSearchField(
          controller: _searchController,
          onChanged: (value) {
            ref
                .read(companyProvider.notifier)
                .search(value);
          },
        ),
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
        Theme.of(context)
            .colorScheme;

    final state =
    ref.watch(companyProvider);

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
          'Company Management',
          style: TextStyle(
            fontWeight:
            FontWeight.w800,
          ),
        ),
      ),

      // =========================================================
// MOBILE FAB
// Theme Aware
// =========================================================

      floatingActionButton:
      MediaQuery.sizeOf(context).width < 700
          ? FloatingActionButton.extended(
        onPressed: _openAddCompany,

        // -------------------------------------------------
        // Theme Aware Colors
        // -------------------------------------------------
        backgroundColor:
        Theme.of(context).colorScheme.primary,

        foregroundColor:
        Theme.of(context).colorScheme.onPrimary,

        elevation: 3,

        icon: const Icon(
          Icons.add_rounded,
        ),

        label: const Text(
          'Add Company',
        ),
      )
          : null,

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              BuildContext context,
              BoxConstraints constraints,
              ) {
            final width =
                constraints.maxWidth;

            final horizontalPadding =
            _pagePadding(width);

            final maxWidth =
            _contentMaxWidth(width);

            final bool isDesktop =
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
                      // =========================================
                      // HEADER
                      // =========================================

                      _buildPageHeader(
                        context,
                        isDesktop,
                      ),

                      const SizedBox(
                        height: 22,
                      ),

                      // =========================================
                      // SEARCH
                      // =========================================

                      _buildSearchSection(
                        context,
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      // =========================================
                      // SECTION TITLE
                      // =========================================

                      AppSectionTitle(
                        title:
                        'Company List',
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      // =========================================
                      // LIST
                      // =========================================

                      Expanded(
                        child: Builder(
                          builder: (_) {
                            // ===================================
                            // LOADING
                            // ===================================

                            if (state
                                .isLoading) {
                              return const AppLoading();
                            }

                            // ===================================
                            // EMPTY
                            // ===================================

                            if (state
                                .filteredCompanies
                                .isEmpty) {
                              return const AppEmpty(
                                title:
                                'No Company Found',
                              );
                            }

                            // ===================================
                            // LIST
                            // ===================================

                            return RefreshIndicator(
                              color:
                              colorScheme
                                  .primary,

                              backgroundColor:
                              colorScheme
                                  .surface,

                              onRefresh:
                                  () {
                                return ref
                                    .read(
                                  companyProvider
                                      .notifier,
                                )
                                    .refresh();
                              },

                              child:
                              ListView.separated(
                                physics:
                                const AlwaysScrollableScrollPhysics(),

                                padding:
                                const EdgeInsets.only(
                                  bottom: 100,
                                ),

                                itemCount:
                                state
                                    .filteredCompanies
                                    .length,

                                separatorBuilder:
                                    (
                                    _,
                                    __,
                                    ) {
                                  return const SizedBox(
                                    height: 12,
                                  );
                                },

                                itemBuilder:
                                    (
                                    _,
                                    index,
                                    ) {
                                  final company =
                                  state
                                      .filteredCompanies[index];

                                  return CompanyCard(
                                    company:
                                    company,

                                    // =================================
                                    // VIEW
                                    // =================================

                                    onView: () {
                                      _showCompanyDetails(
                                        company,
                                      );
                                    },

                                    // =================================
                                    // EDIT
                                    // =================================

                                    onEdit: () {
                                      _openEditCompany(
                                        company,
                                      );
                                    },

                                    // =================================
                                    // DELETE
                                    // =================================

                                    onDelete: () {
                                      _deleteCompany(
                                        company.id,
                                      );
                                    },

                                    // =================================
                                    // STATUS
                                    // =================================

                                    onToggleStatus:
                                        () async {
                                      await ref
                                          .read(
                                        companyProvider
                                            .notifier,
                                      )
                                          .toggleCompanyStatus(
                                        company,
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
              ),
            );
          },
        ),
      ),
    );
  }
}
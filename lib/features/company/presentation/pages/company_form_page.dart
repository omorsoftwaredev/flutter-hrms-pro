// ===============================================================
// Flutter HRMS Pro
// Company Form Page
//
// Stable Layout - Final
//
// Add Company / Edit Company
// Mobile / Tablet / Desktop
//
// IMPORTANT
// - No Align
// - No ConstrainedBox
// - No nested vertical scroll
// - One ListView only
// - Explicit width for content
// - Safe Card constraints
// ===============================================================

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

  // =============================================================
  // EDIT MODE
  // =============================================================

  bool get isEdit => company != null;

  // =============================================================
  // CONTENT WIDTH
  // =============================================================

  double _contentWidth(double screenWidth) {
    if (screenWidth >= 1400) {
      return 1100;
    }

    if (screenWidth >= 1200) {
      return 1050;
    }

    if (screenWidth >= 900) {
      return 850;
    }

    return screenWidth;
  }

  // =============================================================
  // HORIZONTAL PADDING
  // =============================================================

  double _horizontalPadding(double width) {
    if (width >= 1400) {
      return 32;
    }

    if (width >= 1100) {
      return 28;
    }

    if (width >= 800) {
      return 24;
    }

    if (width >= 600) {
      return 20;
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
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    final state =
    ref.watch(companyProvider);

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final horizontalPadding =
    _horizontalPadding(
      screenWidth,
    );

    final availableWidth =
        screenWidth -
            (horizontalPadding * 2);

    final maxWidth =
    _contentWidth(screenWidth);

    final contentWidth =
    availableWidth < maxWidth
        ? availableWidth
        : maxWidth;

    return Scaffold(
      backgroundColor:
      colors.surface,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,

        scrolledUnderElevation: 0,

        backgroundColor:
        colors.surface,

        foregroundColor:
        colors.onSurface,

        leading: IconButton(
          tooltip: 'Back',

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),

          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(
                RoutePaths.companies,
              );
            }
          },
        ),

        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,

              decoration:
              BoxDecoration(
                color:
                colors.primaryContainer,

                borderRadius:
                BorderRadius.circular(
                  12,
                ),
              ),

              child: Icon(
                isEdit
                    ? Icons.edit_outlined
                    : Icons.add_business_outlined,

                size: 21,

                color:
                colors.onPrimaryContainer,
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: Column(
                mainAxisSize:
                MainAxisSize.min,

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Text(
                    isEdit
                        ? 'Edit Company'
                        : 'Add Company',

                    maxLines: 1,

                    overflow:
                    TextOverflow.ellipsis,

                    style: theme.textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),

                  if (screenWidth >= 600)
                    Text(
                      isEdit
                          ? 'Update company information'
                          : 'Create a new company',

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style: theme.textTheme
                          .bodySmall
                          ?.copyWith(
                        color: colors
                            .onSurfaceVariant,
                      ),
                    ),
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
        child: ListView(
          padding:
          EdgeInsets.fromLTRB(
            horizontalPadding,
            20,
            horizontalPadding,
            40,
          ),

          physics:
          const ClampingScrollPhysics(),

          children: [
            // =====================================================
            // PAGE HEADER
            // =====================================================

            SizedBox(
              width: contentWidth,

              child: _buildPageHeader(
                context,
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            // =====================================================
            // FORM CARD
            // =====================================================

            SizedBox(
              width: contentWidth,

              child: _buildFormCard(
                context,
                ref,
                state,
                contentWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // PAGE HEADER
  // =============================================================

  Widget _buildPageHeader(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    return Column(
      mainAxisSize:
      MainAxisSize.min,

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        // =======================================================
        // BREADCRUMB
        // =======================================================

        Wrap(
          crossAxisAlignment:
          WrapCrossAlignment.center,

          children: [
            Icon(
              Icons.business_center_outlined,

              size: 17,

              color:
              colors.primary,
            ),

            const SizedBox(
              width: 7,
            ),

            Text(
              'Company Management',

              style: theme.textTheme
                  .labelLarge
                  ?.copyWith(
                color:
                colors.primary,

                fontWeight:
                FontWeight.w700,
              ),
            ),

            Padding(
              padding:
              const EdgeInsets
                  .symmetric(
                horizontal: 7,
              ),

              child: Icon(
                Icons.chevron_right_rounded,

                size: 18,

                color: colors
                    .onSurfaceVariant,
              ),
            ),

            Text(
              isEdit
                  ? 'Edit'
                  : 'Create',

              style: theme.textTheme
                  .labelLarge
                  ?.copyWith(
                color: colors
                    .onSurfaceVariant,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 14,
        ),

        // =======================================================
        // TITLE
        // =======================================================

        Text(
          isEdit
              ? 'Edit Company'
              : 'Create Company',

          maxLines: 2,

          overflow:
          TextOverflow.ellipsis,

          style: theme.textTheme
              .headlineSmall
              ?.copyWith(
            fontWeight:
            FontWeight.w800,

            letterSpacing:
            -0.3,
          ),
        ),

        const SizedBox(
          height: 6,
        ),

        // =======================================================
        // SUBTITLE
        // =======================================================

        Text(
          isEdit
              ? 'Review and update the company information below.'
              : 'Enter the company information to create a new HRMS company.',

          maxLines: 3,

          overflow:
          TextOverflow.ellipsis,

          style: theme.textTheme
              .bodyMedium
              ?.copyWith(
            color:
            colors.onSurfaceVariant,

            height: 1.45,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // FORM CARD
  // =============================================================

  Widget _buildFormCard(
      BuildContext context,
      WidgetRef ref,
      dynamic state,
      double width,
      ) {
    final colors =
        Theme.of(context)
            .colorScheme;

    return SizedBox(
      width: width,

      child: Card(
        margin: EdgeInsets.zero,

        elevation: 0,

        color:
        colors.surfaceContainerLow,

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(
            24,
          ),

          side: BorderSide(
            color:
            colors.outlineVariant,
          ),
        ),

        child: Padding(
          padding:
          const EdgeInsets.all(
            22,
          ),

          child: CompanyForm(
            initialName:
            company?.name,

            initialEmail:
            company?.email,

            initialPhone:
            company?.phone,

            initialWebsite:
            company?.website,

            initialAddress:
            company?.address,

            initialContactPerson:
            company?.contactPerson,

            initialLogoUrl:
            company?.logoUrl,

            initialTaxNumber:
            company?.taxNumber,

            initialRegistrationNumber:
            company?.registrationNumber,

            initialNotes:
            company?.notes,

            initialIsActive:
            company?.isActive ??
                true,

            isLoading:
            state.isSaving,

            // ===================================================
            // SUBMIT
            // ===================================================

            onSubmit: (
                name,
                email,
                phone,
                website,
                address,
                contactPerson,
                logoUrl,
                taxNumber,
                registrationNumber,
                notes,
                isActive,
                ) async {
              final entity =
              CompanyEntity(
                id:
                company?.id ?? '',

                name:
                name,

                email:
                email,

                phone:
                phone,

                website:
                website,

                address:
                address,

                contactPerson:
                contactPerson,

                logoUrl:
                logoUrl,

                taxNumber:
                taxNumber,

                registrationNumber:
                registrationNumber,

                notes:
                notes,

                isActive:
                isActive,

                createdAt:
                company?.createdAt ??
                    DateTime.now(),

                updatedAt:
                DateTime.now(),
              );

              try {
                // =============================================
                // UPDATE
                // =============================================

                if (isEdit) {
                  await ref
                      .read(
                    companyProvider
                        .notifier,
                  )
                      .updateCompany(
                    entity,
                  );
                }

                // =============================================
                // CREATE
                // =============================================

                else {
                  await ref
                      .read(
                    companyProvider
                        .notifier,
                  )
                      .createCompany(
                    entity,
                  );
                }

                // =============================================
                // SUCCESS
                // =============================================

                if (!context.mounted) {
                  return;
                }

                context.go(
                  RoutePaths.companies,
                );
              } catch (e) {
                // =============================================
                // ERROR
                // =============================================

                if (!context.mounted) {
                  return;
                }

                final messenger =
                ScaffoldMessenger.of(
                  context,
                );

                messenger
                    .hideCurrentSnackBar();

                messenger.showSnackBar(
                  SnackBar(
                    behavior:
                    SnackBarBehavior
                        .floating,

                    margin:
                    const EdgeInsets.all(
                      16,
                    ),

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),

                    content:
                    Row(
                      children: [
                        const Icon(
                          Icons
                              .error_outline_rounded,

                          color:
                          Colors.white,
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(
                          child: Text(
                            e.toString(),

                            maxLines: 3,

                            overflow:
                            TextOverflow
                                .ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
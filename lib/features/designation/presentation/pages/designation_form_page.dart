import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/designation_entity.dart';
import '../providers/designation_provider.dart';
import '../widgets/designation_form.dart';

class DesignationFormPage extends ConsumerWidget {
  const DesignationFormPage({super.key, this.designation});

  final DesignationEntity? designation;

  bool get isEdit => designation != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final state = ref.watch(designationProvider);

    return Scaffold(
      // ===========================================================
      // APP BAR
      // ===========================================================
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,

        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),

        title: Text(
          isEdit ? 'Edit Designation' : 'Add Designation',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ===========================================================
      // BODY
      // ===========================================================
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final bool isDesktop = width >= 1000;
            final bool isTablet = width >= 600;

            final double horizontalPadding = isDesktop
                ? 32
                : isTablet
                ? 24
                : 14;

            final double verticalPadding = isDesktop
                ? 28
                : isTablet
                ? 24
                : 16;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                verticalPadding,
                horizontalPadding,
                32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =========================================
                      // PAGE HEADER
                      // =========================================
                      _buildHeader(context),

                      const SizedBox(height: 18),

                      // =========================================
                      // FORM
                      // =========================================
                      DesignationForm(
                        // =========================================
                        // INITIAL NAME
                        // =========================================
                        initialName: designation?.name ?? '',

                        // =========================================
                        // INITIAL DESCRIPTION
                        // =========================================
                        initialDescription: designation?.description ?? '',

                        // =========================================
                        // INITIAL GRADE
                        // =========================================
                        initialGrade: designation?.grade ?? 1,

                        // =========================================
                        // INITIAL DISPLAY ORDER
                        // =========================================
                        initialDisplayOrder: designation?.displayOrder ?? 0,

                        // =========================================
                        // INITIAL BASE SALARY
                        // =========================================
                        initialBaseSalary: designation?.baseSalary ?? 0,

                        // =========================================
                        // INITIAL ACTIVE
                        // =========================================
                        initialIsActive: designation?.isActive ?? true,

                        // =========================================
                        // LOADING
                        // =========================================
                        isLoading: state.isSaving,

                        // =========================================
                        // SUBMIT
                        // =========================================
                        onSubmit:
                            (
                              name,
                              description,
                              grade,
                              displayOrder,
                              baseSalary,
                              isActive,
                            ) async {
                              // =======================================
                              // ENTITY
                              // =======================================

                              final entity = DesignationEntity(
                                id: designation?.id ?? '',

                                // -------------------------------------
                                // COMPANY ID
                                // -------------------------------------
                                //
                                // Existing logic preserved.
                                //
                                // CREATE:
                                // Provider/Notifier CurrentUser.companyId
                                // থেকে company scope করবে.
                                //
                                // UPDATE:
                                // Existing designation.companyId
                                // preserve করা হচ্ছে.
                                //
                                // -------------------------------------
                                companyId: designation?.companyId ?? '',

                                // -------------------------------------
                                // DESIGNATION
                                // -------------------------------------
                                name: name,

                                description: description,

                                // -------------------------------------
                                // GRADE
                                // -------------------------------------
                                grade: grade,

                                // -------------------------------------
                                // DISPLAY ORDER
                                // -------------------------------------
                                displayOrder: displayOrder,

                                // -------------------------------------
                                // BASE SALARY
                                // -------------------------------------
                                baseSalary: baseSalary,

                                // -------------------------------------
                                // ACTIVE
                                // -------------------------------------
                                isActive: isActive,

                                // -------------------------------------
                                // CREATED AT
                                // -------------------------------------
                                createdAt:
                                    designation?.createdAt ?? DateTime.now(),

                                // -------------------------------------
                                // UPDATED AT
                                // -------------------------------------
                                updatedAt: designation?.updatedAt,
                              );

                              try {
                                // =====================================
                                // UPDATE
                                // =====================================

                                if (isEdit) {
                                  await ref
                                      .read(designationProvider.notifier)
                                      .updateDesignation(entity);
                                }
                                // =====================================
                                // CREATE
                                // =====================================
                                else {
                                  await ref
                                      .read(designationProvider.notifier)
                                      .createDesignation(entity);
                                }

                                // =====================================
                                // CONTEXT CHECK
                                // =====================================

                                if (!context.mounted) {
                                  return;
                                }

                                // =====================================
                                // RELOAD LIST
                                // =====================================

                                await ref
                                    .read(designationProvider.notifier)
                                    .loadDesignations();

                                // =====================================
                                // CONTEXT CHECK
                                // =====================================

                                if (!context.mounted) {
                                  return;
                                }

                                // =====================================
                                // BACK TO DESIGNATION LIST
                                // =====================================

                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go('/designations');
                                }
                              } catch (e) {
                                // =====================================
                                // ERROR
                                // =====================================

                                if (!context.mounted) {
                                  return;
                                }

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      backgroundColor: colorScheme.error,
                                      behavior: SnackBarBehavior.fixed,
                                      content: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.error_outline_rounded,
                                            color: colorScheme.onError,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              e.toString(),
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: colorScheme.onError,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                              }
                            },
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

  // =============================================================
  // PAGE HEADER
  // =============================================================

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.primary.withOpacity(.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =======================================================
          // ICON
          // =======================================================
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isEdit ? Icons.edit_outlined : Icons.badge_outlined,
              color: colorScheme.primary,
              size: 27,
            ),
          ),

          const SizedBox(width: 13),

          // =======================================================
          // TEXT
          // =======================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Edit Designation' : 'Add Designation',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  isEdit
                      ? 'Update the designation information and settings.'
                      : 'Create a new designation with the required information.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../domain/entities/shift_entity.dart';
import '../providers/shift_provider.dart';
import '../widgets/shift_form.dart';

class ShiftFormPage extends ConsumerWidget {
  const ShiftFormPage({
    super.key,
    this.shift,
  });

  final ShiftEntity? shift;

  bool get isEdit => shift != null;

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final state = ref.watch(shiftProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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

        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),

        title: Text(
          isEdit
              ? 'Edit Shift'
              : 'Add Shift',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              BuildContext context,
              BoxConstraints constraints,
              ) {
            final double width =
                constraints.maxWidth;

            final bool isDesktop =
                width >= 1000;

            final bool isTablet =
                width >= 600;

            // ---------------------------------------------------
            // RESPONSIVE PADDING
            // ---------------------------------------------------

            final double horizontalPadding =
            isDesktop
                ? 32
                : isTablet
                ? 24
                : 16;

            final double verticalPadding =
            isDesktop
                ? 28
                : isTablet
                ? 24
                : 16;

            // ---------------------------------------------------
            // MAX CONTENT WIDTH
            // ---------------------------------------------------

            final double maxContentWidth =
            isDesktop
                ? 1000
                : isTablet
                ? 850
                : double.infinity;

            return SingleChildScrollView(
              physics:
              const AlwaysScrollableScrollPhysics(),

              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                verticalPadding,
                horizontalPadding,
                40,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxContentWidth,
                  ),

                  child: ShiftForm(
                    // =================================================
                    // INITIAL NAME
                    // =================================================

                    initialName:
                    shift?.name ?? '',

                    // =================================================
                    // INITIAL DESCRIPTION
                    // =================================================

                    initialDescription:
                    shift?.description ?? '',

                    // =================================================
                    // INITIAL START TIME
                    // =================================================

                    initialStartTime:
                    shift?.startTime ??
                        '09:00:00',

                    // =================================================
                    // INITIAL END TIME
                    // =================================================

                    initialEndTime:
                    shift?.endTime ??
                        '18:00:00',

                    // =================================================
                    // INITIAL BREAK
                    // =================================================

                    initialBreakMinutes:
                    shift?.breakMinutes ??
                        60,

                    // =================================================
                    // INITIAL GRACE IN
                    // =================================================

                    initialGraceInMinutes:
                    shift?.graceInMinutes ??
                        15,

                    // =================================================
                    // INITIAL GRACE OUT
                    // =================================================

                    initialGraceOutMinutes:
                    shift?.graceOutMinutes ??
                        15,

                    // =================================================
                    // INITIAL LATE AFTER
                    // =================================================

                    initialLateAfterMinutes:
                    shift?.lateAfterMinutes ??
                        15,

                    // =================================================
                    // INITIAL HALF DAY
                    // =================================================

                    initialHalfDayAfterMinutes:
                    shift?.halfDayAfterMinutes ??
                        240,

                    // =================================================
                    // INITIAL WEEKLY OFF
                    // =================================================

                    initialWeeklyOffDay:
                    shift?.weeklyOffDay,

                    // =================================================
                    // INITIAL NIGHT SHIFT
                    // =================================================

                    initialNightShift:
                    shift?.isNightShift ??
                        false,

                    // =================================================
                    // INITIAL FLEXIBLE
                    // =================================================

                    initialFlexible:
                    shift?.isFlexible ??
                        false,

                    // =================================================
                    // INITIAL ACTIVE
                    // =================================================

                    initialActive:
                    shift?.isActive ??
                        true,

                    // =================================================
                    // LOADING
                    // =================================================

                    isLoading:
                    state.isSaving,

                    // =================================================
                    // SUBMIT
                    // =================================================

                    onSubmit: (
                        name,
                        description,
                        startTime,
                        endTime,
                        breakMinutes,
                        graceIn,
                        graceOut,
                        lateAfter,
                        halfDayAfter,
                        weeklyOff,
                        nightShift,
                        flexible,
                        active,
                        ) async {
                      // =================================================
                      // ENTITY
                      // =================================================

                      final entity = ShiftEntity(
                        id: shift?.id ?? '',

                        // ------------------------------------------------
                        // COMPANY ID
                        // ------------------------------------------------
                        //
                        // CREATE:
                        // Provider / Repository
                        // CurrentUser.companyId ব্যবহার করবে।
                        //
                        // EDIT:
                        // Existing companyId preserve করছি।
                        //
                        // ------------------------------------------------

                        companyId:
                        shift?.companyId ?? '',

                        // ------------------------------------------------
                        // NAME
                        // ------------------------------------------------

                        name: name.trim(),

                        // ------------------------------------------------
                        // DESCRIPTION
                        // ------------------------------------------------

                        description:
                        description.trim(),

                        // ------------------------------------------------
                        // START TIME
                        // ------------------------------------------------

                        startTime:
                        startTime,

                        // ------------------------------------------------
                        // END TIME
                        // ------------------------------------------------

                        endTime:
                        endTime,

                        // ------------------------------------------------
                        // BREAK
                        // ------------------------------------------------

                        breakMinutes:
                        breakMinutes,

                        // ------------------------------------------------
                        // GRACE IN
                        // ------------------------------------------------

                        graceInMinutes:
                        graceIn,

                        // ------------------------------------------------
                        // GRACE OUT
                        // ------------------------------------------------

                        graceOutMinutes:
                        graceOut,

                        // ------------------------------------------------
                        // LATE AFTER
                        // ------------------------------------------------

                        lateAfterMinutes:
                        lateAfter,

                        // ------------------------------------------------
                        // HALF DAY AFTER
                        // ------------------------------------------------

                        halfDayAfterMinutes:
                        halfDayAfter,

                        // ------------------------------------------------
                        // WEEKLY OFF
                        // ------------------------------------------------

                        weeklyOffDay:
                        weeklyOff,

                        // ------------------------------------------------
                        // NIGHT SHIFT
                        // ------------------------------------------------

                        isNightShift:
                        nightShift,

                        // ------------------------------------------------
                        // FLEXIBLE
                        // ------------------------------------------------

                        isFlexible:
                        flexible,

                        // ------------------------------------------------
                        // ACTIVE
                        // ------------------------------------------------

                        isActive:
                        active,

                        // ------------------------------------------------
                        // CREATED AT
                        // ------------------------------------------------

                        createdAt:
                        shift?.createdAt ??
                            DateTime.now(),

                        // ------------------------------------------------
                        // UPDATED AT
                        // ------------------------------------------------

                        updatedAt:
                        shift?.updatedAt,
                      );

                      try {
                        // =================================================
                        // UPDATE
                        // =================================================

                        if (isEdit) {
                          await ref
                              .read(
                            shiftProvider
                                .notifier,
                          )
                              .updateShift(
                            entity,
                          );
                        }

                        // =================================================
                        // CREATE
                        // =================================================

                        else {
                          await ref
                              .read(
                            shiftProvider
                                .notifier,
                          )
                              .createShift(
                            entity,
                          );
                        }

                        // =================================================
                        // CONTEXT CHECK
                        // =================================================

                        if (!context.mounted) {
                          return;
                        }

                        // =================================================
                        // RELOAD SHIFT LIST
                        // =================================================

                        await ref
                            .read(
                          shiftProvider
                              .notifier,
                        )
                            .loadShifts();

                        // =================================================
                        // CONTEXT CHECK
                        // =================================================

                        if (!context.mounted) {
                          return;
                        }

                        // =================================================
                        // SUCCESS MESSAGE
                        // =================================================

                        final String message =
                        isEdit
                            ? 'Shift updated successfully.'
                            : 'Shift created successfully.';

                        ScaffoldMessenger.of(
                          context,
                        )
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              behavior:
                              SnackBarBehavior.floating,
                              backgroundColor:
                              colorScheme.inverseSurface,
                              content: Row(
                                children: [
                                  Icon(
                                    Icons
                                        .check_circle_outline_rounded,
                                    color: colorScheme
                                        .onInverseSurface,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      message,
                                      style: theme
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                        color: colorScheme
                                            .onInverseSurface,
                                        fontWeight:
                                        FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                        // =================================================
                        // BACK TO SHIFT LIST
                        // =================================================

                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(
                            RoutePaths.shifts,
                          );
                        }
                      } catch (e) {
                        // =================================================
                        // ERROR
                        // =================================================

                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(
                          context,
                        )
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              behavior:
                              SnackBarBehavior.floating,
                              backgroundColor:
                              colorScheme.error,
                              content: Text(
                                e.toString(),
                                style: TextStyle(
                                  color:
                                  colorScheme.onError,
                                ),
                              ),
                            ),
                          );
                      }
                    },
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
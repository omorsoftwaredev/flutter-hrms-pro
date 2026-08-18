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

  // =============================================================
  // BUILD
  // =============================================================

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
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }

            context.go(
              RoutePaths.shifts,
            );
          },
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
                    // INITIAL BASIC INFORMATION
                    // =================================================

                    initialName:
                    shift?.name ?? '',

                    initialDescription:
                    shift?.description ?? '',

                    // =================================================
                    // INITIAL SHIFT TIME
                    // =================================================

                    initialStartTime:
                    shift?.startTime ??
                        '09:00:00',

                    initialEndTime:
                    shift?.endTime ??
                        '18:00:00',

                    // =================================================
                    // INITIAL TIME & GRACE
                    // =================================================

                    initialBreakMinutes:
                    shift?.breakMinutes ??
                        60,

                    initialGraceInMinutes:
                    shift?.graceInMinutes ??
                        15,

                    initialGraceOutMinutes:
                    shift?.graceOutMinutes ??
                        15,

                    initialLateAfterMinutes:
                    shift?.lateAfterMinutes ??
                        15,

                    initialHalfDayAfterMinutes:
                    shift?.halfDayAfterMinutes ??
                        240,

                    // =================================================
                    // INITIAL ADDITIONAL GRACE
                    // =================================================

                    initialLateGraceMinutes:
                    shift?.lateGraceMinutes ??
                        15,

                    initialEarlyLeaveGraceMinutes:
                    shift?.earlyLeaveGraceMinutes ??
                        15,

                    // =================================================
                    // INITIAL WORKING HOURS
                    // =================================================

                    initialMinimumWorkingHours:
                    shift?.minimumWorkingHours ??
                        8.00,

                    initialHalfDayThresholdHours:
                    shift?.halfDayThresholdHours ??
                        4.00,

                    // =================================================
                    // INITIAL SHIFT OPTIONS
                    // =================================================

                    initialNightShift:
                    shift?.isNightShift ??
                        false,

                    initialFlexible:
                    shift?.isFlexible ??
                        false,

                    // =================================================
                    // INITIAL ATTENDANCE REQUIREMENTS
                    // =================================================

                    initialCheckInRequired:
                    shift?.checkInRequired ??
                        true,

                    initialCheckOutRequired:
                    shift?.checkOutRequired ??
                        true,

                    // =================================================
                    // INITIAL STATUS
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
                        graceInMinutes,
                        graceOutMinutes,
                        lateAfterMinutes,
                        halfDayAfterMinutes,
                        lateGraceMinutes,
                        earlyLeaveGraceMinutes,
                        minimumWorkingHours,
                        halfDayThresholdHours,
                        weeklyOffDay,
                        isNightShift,
                        isFlexible,
                        checkInRequired,
                        checkOutRequired,
                        isActive,
                        ) async {
                      // =================================================
                      // BUILD SHIFT ENTITY
                      // =================================================

                      final entity = ShiftEntity(

                        // -------------------------------------------------
                        // ID
                        // -------------------------------------------------

                        id:
                        shift?.id ?? '',

                        // -------------------------------------------------
                        // COMPANY ID
                        // -------------------------------------------------
                        //
                        // EDIT:
                        // Existing companyId preserve হবে.
                        //
                        // CREATE:
                        // Repository / backend current user's
                        // companyId handle করবে.
                        //
                        // -------------------------------------------------

                        companyId:
                        shift?.companyId ?? '',

                        // -------------------------------------------------
                        // CODE
                        // -------------------------------------------------
                        //
                        // Existing shift হলে code preserve হবে.
                        //
                        // New shift হলে empty থাকবে.
                        // Backend / database trigger code generate করতে
                        // পারবে.
                        //
                        // -------------------------------------------------

                        code:
                        shift?.code ?? '',

                        // -------------------------------------------------
                        // NAME
                        // -------------------------------------------------

                        name:
                        name.trim(),

                        // -------------------------------------------------
                        // DESCRIPTION
                        // -------------------------------------------------

                        description:
                        description.trim(),

                        // -------------------------------------------------
                        // SHIFT TIME
                        // -------------------------------------------------

                        startTime:
                        startTime,

                        endTime:
                        endTime,

                        // -------------------------------------------------
                        // BREAK
                        // -------------------------------------------------

                        breakMinutes:
                        breakMinutes,

                        // -------------------------------------------------
                        // ATTENDANCE RULES
                        // -------------------------------------------------

                        graceInMinutes:
                        graceInMinutes,

                        graceOutMinutes:
                        graceOutMinutes,

                        lateAfterMinutes:
                        lateAfterMinutes,

                        halfDayAfterMinutes:
                        halfDayAfterMinutes,

                        // -------------------------------------------------
                        // ADDITIONAL GRACE RULES
                        // -------------------------------------------------

                        lateGraceMinutes:
                        lateGraceMinutes,

                        earlyLeaveGraceMinutes:
                        earlyLeaveGraceMinutes,

                        // -------------------------------------------------
                        // WORKING HOUR RULES
                        // -------------------------------------------------

                        minimumWorkingHours:
                        minimumWorkingHours,

                        halfDayThresholdHours:
                        halfDayThresholdHours,

                        // -------------------------------------------------
                        // SHIFT TYPE
                        // -------------------------------------------------

                        isNightShift:
                        isNightShift,

                        isFlexible:
                        isFlexible,

                        // -------------------------------------------------
                        // ATTENDANCE REQUIREMENT
                        // -------------------------------------------------

                        checkInRequired:
                        checkInRequired,

                        checkOutRequired:
                        checkOutRequired,

                        // -------------------------------------------------
                        // STATUS
                        // -------------------------------------------------

                        isActive:
                        isActive,

                        // -------------------------------------------------
                        // AUDIT
                        // -------------------------------------------------

                        createdAt:
                        shift?.createdAt ??
                            DateTime.now(),

                        updatedAt:
                        shift?.updatedAt,

                        // -------------------------------------------------
                        // USER AUDIT
                        // -------------------------------------------------

                        createdBy:
                        shift?.createdBy,

                        updatedBy:
                        shift?.updatedBy,
                      );

                      try {
                        // =================================================
                        // SAVE
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
                        } else {
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
                        // CHECK PROVIDER ERROR
                        // =================================================
                        //
                        // তোমার notifier বর্তমানে exception catch করে
                        // state.error-এ রাখে এবং throw করে না।
                        //
                        // তাই এখানে save-এর পরে provider state check করছি।
                        //
                        // =================================================

                        final currentState =
                        ref.read(
                          shiftProvider,
                        );

                        if (currentState.error !=
                            null &&
                            currentState.error!
                                .trim()
                                .isNotEmpty) {
                          throw Exception(
                            _cleanError(
                              currentState.error!,
                            ),
                          );
                        }

                        // =================================================
                        // RELOAD LIST
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
                              colorScheme
                                  .inverseSurface,

                              duration:
                              const Duration(
                                seconds: 3,
                              ),

                              content: Row(
                                children: [
                                  Icon(
                                    Icons
                                        .check_circle_outline_rounded,
                                    size: 20,
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

                              duration:
                              const Duration(
                                seconds: 4,
                              ),

                              content: Row(
                                children: [
                                  Icon(
                                    Icons
                                        .error_outline_rounded,
                                    size: 20,
                                    color:
                                    colorScheme
                                        .onError,
                                  ),

                                  const SizedBox(
                                    width: 10,
                                  ),

                                  Expanded(
                                    child: Text(
                                      _errorMessage(e),
                                      style: theme
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                        color:
                                        colorScheme
                                            .onError,
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // =============================================================
  // CLEAN PROVIDER ERROR
  // =============================================================

  String _cleanError(String error) {
    final message = error.trim();

    if (message.isEmpty) {
      return 'Something went wrong.';
    }

    if (message.startsWith('Exception:')) {
      return message
          .replaceFirst(
        'Exception:',
        '',
      )
          .trim();
    }

    return message;
  }

  // =============================================================
  // ERROR MESSAGE
  // =============================================================

  String _errorMessage(Object error) {
    final message =
    error.toString().trim();

    if (message.isEmpty) {
      return 'Something went wrong. Please try again.';
    }

    if (message.startsWith('Exception:')) {
      return message
          .replaceFirst(
        'Exception:',
        '',
      )
          .trim();
    }

    return message;
  }
}
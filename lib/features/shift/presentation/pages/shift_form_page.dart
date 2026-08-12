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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          isEdit
              ? 'Edit Shift'
              : 'Add Shift',
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ShiftForm(
            // =====================================================
            // INITIAL VALUES
            // =====================================================

            initialStartTime:
            shift?.startTime ??
                '09:00:00',

            initialEndTime:
            shift?.endTime ??
                '18:00:00',

            initialName:
            shift?.name ?? '',

            initialDescription:
            shift?.description ?? '',

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

            initialWeeklyOffDay:
            shift?.weeklyOffDay,

            initialNightShift:
            shift?.isNightShift ??
                false,

            initialFlexible:
            shift?.isFlexible ??
                false,

            initialActive:
            shift?.isActive ??
                true,

            isLoading:
            state.isSaving,

            // =====================================================
            // SUBMIT
            // =====================================================
            //
            // companyId নেই
            // code নেই
            //
            // companyId:
            //     CurrentUser.companyId
            //
            // code:
            //     Database trigger
            //
            // =====================================================

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
              final entity = ShiftEntity(
                id: shift?.id ?? '',

                // -------------------------------------------------
                // IMPORTANT
                //
                // companyId manually দেওয়া হচ্ছে না।
                //
                // Repository:
                //     CurrentUser.companyId
                //
                // থেকে company scope করবে।
                //
                // -------------------------------------------------

                companyId:
                shift?.companyId ??
                    '',

                // -------------------------------------------------
                // IMPORTANT
                //
                // code manually দেওয়া হচ্ছে না।
                //
                // Create:
                //     Database trigger code generate করবে।
                //
                // Update:
                //     Existing code অপরিবর্তিত থাকবে।
                //
                // -------------------------------------------------


                name: name,

                description:
                description,

                startTime:
                startTime,

                endTime:
                endTime,

                breakMinutes:
                breakMinutes,

                graceInMinutes:
                graceIn,

                graceOutMinutes:
                graceOut,

                lateAfterMinutes:
                lateAfter,

                halfDayAfterMinutes:
                halfDayAfter,

                weeklyOffDay:
                weeklyOff,

                isNightShift:
                nightShift,

                isFlexible:
                flexible,

                isActive:
                active,

                createdAt:
                shift?.createdAt ??
                    DateTime.now(),

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

                if (!context.mounted) {
                  return;
                }

                // =================================================
                // SUCCESS MESSAGE
                // =================================================

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEdit
                          ? 'Shift updated successfully.'
                          : 'Shift created successfully.',
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
                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.toString(),
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
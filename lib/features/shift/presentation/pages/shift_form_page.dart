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
        title: Text(
          isEdit
              ? 'Edit Shift'
              : 'Add Shift',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.all(16),
          child: ShiftForm(
            initialCompanyId:
            shift?.companyId ?? '',
            initialCode:
            shift?.code ?? '',
            initialName:
            shift?.name ?? '',
            initialDescription:
            shift?.description ?? '',
            initialStartTime:
            shift?.startTime ??
                '09:00:00',
            initialEndTime:
            shift?.endTime ??
                '18:00:00',
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
            shift
                ?.lateAfterMinutes ??
                15,
            initialHalfDayAfterMinutes:
            shift
                ?.halfDayAfterMinutes ??
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
            shift?.isActive ?? true,
            isLoading:
            state.isSaving,
            onSubmit: (
                companyId,
                code,
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
              final entity =
              ShiftEntity(
                id: shift?.id ?? '',
                companyId:
                companyId,
                code: code,
                name: name,
                description:
                description,
                startTime:
                startTime,
                endTime: endTime,
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
                shift
                    ?.createdAt ??
                    DateTime.now(),
                updatedAt:
                DateTime.now(),
              );

              try {
                if (isEdit) {
                  await ref
                      .read(shiftProvider.notifier)
                      .updateShift(entity);
                } else {
                  await ref
                      .read(shiftProvider.notifier)
                      .createShift(entity);
                }

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEdit
                          ? 'Shift updated successfully.'
                          : 'Shift created successfully.',
                    ),
                  ),
                );

                context.go(RoutePaths.shifts);

              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
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
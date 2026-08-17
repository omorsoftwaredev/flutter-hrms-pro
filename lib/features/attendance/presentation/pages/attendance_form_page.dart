import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../company/domain/entities/company_entity.dart';
import '../../domain/entities/attendance_entity.dart';
import '../providers/attendance_provider.dart';

import '../../../department/domain/entities/department_entity.dart';
import '../../../designation/domain/entities/designation_entity.dart';
import '../../../employee/domain/entities/employee_entity.dart';
import '../../../shift/domain/entities/shift_entity.dart';

import '../../../employee/presentation/providers/employee_provider.dart';
import '../../../shift/presentation/providers/shift_provider.dart';

import '../widgets/attendance_employee_dropdown.dart';
import '../widgets/attendance_shift_dropdown.dart';
import '../widgets/attendance_status_dropdown.dart';

class AttendanceFormPage extends ConsumerStatefulWidget {
  final AttendanceEntity? attendance;

  const AttendanceFormPage({
    super.key,
    this.attendance,
  });

  @override
  ConsumerState<AttendanceFormPage> createState() =>
      _AttendanceFormPageState();
}

class _AttendanceFormPageState
    extends ConsumerState<AttendanceFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _attendanceNoController =
  TextEditingController();

  final TextEditingController _remarksController =
  TextEditingController();

  CompanyEntity? selectedCompany;
  DepartmentEntity? selectedDepartment;
  DesignationEntity? selectedDesignation;
  EmployeeEntity? selectedEmployee;
  ShiftEntity? selectedShift;

  List<EmployeeEntity> employees = [];
  List<ShiftEntity> shifts = [];

  DateTime? attendanceDate;
  DateTime? checkInTime;
  DateTime? checkOutTime;

  String attendanceStatus = 'PRESENT';

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    _loadData();

    final item = widget.attendance;

    if (item != null) {
      _attendanceNoController.text = item.attendanceNo;
      _remarksController.text = item.remarks ?? '';

      attendanceDate = item.attendanceDate;
      checkInTime = item.checkInTime;
      checkOutTime = item.checkOutTime;
      attendanceStatus = item.attendanceStatus;
    }
  }

  @override
  void dispose() {
    _attendanceNoController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final employeeNotifier =
    ref.read(employeeProvider.notifier);

    final shiftNotifier =
    ref.read(shiftProvider.notifier);

    await employeeNotifier.loadEmployees();
    await shiftNotifier.loadShifts();

    if (!mounted) return;

    setState(() {
      employees = ref.read(employeeProvider).employees;
      shifts = ref.read(shiftProvider).shifts;
    });

    if (widget.attendance != null) {
      final item = widget.attendance!;

      if (item.employeeId != null) {
        try {
          selectedEmployee = employees.firstWhere(
                (e) => e.id == item.employeeId,
          );
        } catch (_) {}
      }

      if (item.shiftId != null) {
        try {
          selectedShift = shifts.firstWhere(
                (e) => e.id == item.shiftId,
          );
        } catch (_) {}
      }

      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _pickAttendanceDate() async {
    final theme = Theme.of(context);

    final picked = await showDatePicker(
      context: context,
      initialDate: attendanceDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        attendanceDate = picked;
      });
    }
  }

  Future<void> _pickCheckInTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: checkInTime == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(checkInTime!),
    );

    if (picked == null) return;

    final date = attendanceDate ?? DateTime.now();

    setState(() {
      checkInTime = DateTime(
        date.year,
        date.month,
        date.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  Future<void> _pickCheckOutTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: checkOutTime == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(checkOutTime!),
    );

    if (picked == null) return;

    final date = attendanceDate ?? DateTime.now();

    setState(() {
      checkOutTime = DateTime(
        date.year,
        date.month,
        date.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (attendanceDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select attendance date.',
          ),
        ),
      );
      return;
    }

    if (selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select an employee.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final entity = AttendanceEntity(
        id: widget.attendance?.id,
        companyId: selectedEmployee?.companyId,
        departmentId: selectedEmployee?.departmentId,
        designationId: selectedEmployee?.designationId,
        employeeId: selectedEmployee?.id,
        shiftId: selectedShift?.id,
        attendanceNo:
        _attendanceNoController.text.trim(),
        attendanceDate: attendanceDate!,
        shiftName: selectedShift?.name,
        checkInTime: checkInTime,
        checkOutTime: checkOutTime,
        attendanceStatus: attendanceStatus,
        remarks: _remarksController.text.trim(),
      );

      final notifier =
      ref.read(attendanceProvider.notifier);

      bool success;

      if (widget.attendance == null) {
        success = await notifier.insert(entity);
      } else {
        success = await notifier.update(entity);
      }

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.attendance == null
                  ? 'Failed to save attendance.'
                  : 'Failed to update attendance.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // =============================================================
  // SECTION TITLE
  // =============================================================

  Widget _sectionTitle({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 22,
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // FORM CARD
  // =============================================================

  Widget _formCard({
    required BuildContext context,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  // =============================================================
  // DATE / TIME FIELD
  // =============================================================

  Widget _buildDateTimeField({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool hasValue = value.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withOpacity(.45),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 21,
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
                      theme.textTheme.bodySmall?.copyWith(
                        color:
                        colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hasValue ? value : 'Select $title',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: hasValue
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: hasValue
                            ? colorScheme.onSurface
                            : colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isEdit = widget.attendance != null;

    return Scaffold(
      backgroundColor:
      colorScheme.surfaceContainerLowest,

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 1,
        titleSpacing: 20,
        title: Text(
          isEdit
              ? 'Edit Attendance'
              : 'Add Attendance',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double horizontalPadding =
            constraints.maxWidth >= 1000
                ? 28
                : constraints.maxWidth >= 600
                ? 22
                : 16;

            final double maxWidth =
            constraints.maxWidth >= 1200
                ? 900
                : constraints.maxWidth >= 800
                ? 760
                : double.infinity;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      20,
                      horizontalPadding,
                      30,
                    ),
                    children: [

                      // =================================================
                      // HEADER
                      // =================================================

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.primary,
                              colorScheme.primaryContainer,
                            ],
                          ),
                          borderRadius:
                          BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color:
                                colorScheme.onPrimary
                                    .withOpacity(.14),
                                borderRadius:
                                BorderRadius.circular(15),
                              ),
                              child: Icon(
                                isEdit
                                    ? Icons.edit_note_rounded
                                    : Icons
                                    .event_available_rounded,
                                color:
                                colorScheme.onPrimary,
                                size: 27,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isEdit
                                        ? 'Update Attendance'
                                        : 'New Attendance',
                                    style: theme
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                      color: colorScheme
                                          .onPrimary,
                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isEdit
                                        ? 'Update attendance information'
                                        : 'Enter attendance information',
                                    style: theme
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                      color: colorScheme
                                          .onPrimary
                                          .withOpacity(.78),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // =================================================
                      // EMPLOYEE & SHIFT
                      // =================================================

                      _formCard(
                        context: context,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            _sectionTitle(
                              context: context,
                              icon: Icons.badge_outlined,
                              title:
                              'Employee Information',
                              subtitle:
                              'Select employee and assigned shift',
                            ),

                            LayoutBuilder(
                              builder:
                                  (context, box) {
                                final bool wide =
                                    box.maxWidth >= 650;

                                if (wide) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child:
                                        AttendanceEmployeeDropdown(
                                          employees:
                                          employees,
                                          value:
                                          selectedEmployee,
                                          onChanged:
                                              (value) {
                                            setState(() {
                                              selectedEmployee =
                                                  value;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                          width: 16),
                                      Expanded(
                                        child:
                                        AttendanceShiftDropdown(
                                          shifts: shifts,
                                          value:
                                          selectedShift,
                                          onChanged:
                                              (value) {
                                            setState(() {
                                              selectedShift =
                                                  value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                return Column(
                                  children: [
                                    AttendanceEmployeeDropdown(
                                      employees:
                                      employees,
                                      value:
                                      selectedEmployee,
                                      onChanged:
                                          (value) {
                                        setState(() {
                                          selectedEmployee =
                                              value;
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                        height: 16),
                                    AttendanceShiftDropdown(
                                      shifts: shifts,
                                      value:
                                      selectedShift,
                                      onChanged:
                                          (value) {
                                        setState(() {
                                          selectedShift =
                                              value;
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // =================================================
                      // BASIC INFORMATION
                      // =================================================

                      _formCard(
                        context: context,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            _sectionTitle(
                              context: context,
                              icon:
                              Icons.assignment_outlined,
                              title: 'Attendance Information',
                              subtitle:
                              'Basic attendance details',
                            ),

                            TextFormField(
                              controller:
                              _attendanceNoController,
                              decoration: InputDecoration(
                                labelText:
                                'Attendance No',
                                hintText:
                                'Enter attendance number',
                                prefixIcon: const Icon(
                                  Icons
                                      .confirmation_number_outlined,
                                ),
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      15),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'Attendance No is required';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            LayoutBuilder(
                              builder:
                                  (context, box) {
                                final bool wide =
                                    box.maxWidth >= 650;

                                final dateField =
                                _buildDateTimeField(
                                  context: context,
                                  icon: Icons
                                      .calendar_month_outlined,
                                  title:
                                  'Attendance Date',
                                  value:
                                  attendanceDate == null
                                      ? ''
                                      : attendanceDate!
                                      .toString()
                                      .split(' ')
                                      .first,
                                  onTap:
                                  _pickAttendanceDate,
                                );

                                final checkInField =
                                _buildDateTimeField(
                                  context: context,
                                  icon: Icons.login_rounded,
                                  title:
                                  'Check In Time',
                                  value:
                                  checkInTime == null
                                      ? ''
                                      : TimeOfDay
                                      .fromDateTime(
                                      checkInTime!)
                                      .format(context),
                                  onTap:
                                  _pickCheckInTime,
                                );

                                final checkOutField =
                                _buildDateTimeField(
                                  context: context,
                                  icon:
                                  Icons.logout_rounded,
                                  title:
                                  'Check Out Time',
                                  value:
                                  checkOutTime == null
                                      ? ''
                                      : TimeOfDay
                                      .fromDateTime(
                                      checkOutTime!)
                                      .format(context),
                                  onTap:
                                  _pickCheckOutTime,
                                );

                                if (wide) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child:
                                            dateField,
                                          ),
                                          const SizedBox(
                                              width: 12),
                                          Expanded(
                                            child:
                                            checkInField,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                          height: 12),
                                      checkOutField,
                                    ],
                                  );
                                }

                                return Column(
                                  children: [
                                    dateField,
                                    const SizedBox(
                                        height: 12),
                                    checkInField,
                                    const SizedBox(
                                        height: 12),
                                    checkOutField,
                                  ],
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            AttendanceStatusDropdown(
                              value: attendanceStatus,
                              onChanged: (value) {
                                setState(() {
                                  attendanceStatus =
                                  value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // =================================================
                      // REMARKS
                      // =================================================

                      _formCard(
                        context: context,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            _sectionTitle(
                              context: context,
                              icon: Icons.notes_rounded,
                              title: 'Remarks',
                              subtitle:
                              'Additional attendance information',
                            ),

                            TextFormField(
                              controller:
                              _remarksController,
                              maxLines: 4,
                              textInputAction:
                              TextInputAction.newline,
                              decoration: InputDecoration(
                                labelText: 'Remarks',
                                hintText:
                                'Enter remarks (optional)',
                                alignLabelWithHint: true,
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 65),
                                  child: Icon(
                                    Icons
                                        .sticky_note_2_outlined,
                                  ),
                                ),
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // =================================================
                      // SAVE BUTTON
                      // =================================================

                      SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed:
                          isSaving ? null : _save,
                          style: FilledButton.styleFrom(
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                          ),
                          icon: isSaving
                              ? const SizedBox(
                            width: 19,
                            height: 19,
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                              : Icon(
                            isEdit
                                ? Icons
                                .save_as_rounded
                                : Icons
                                .save_rounded,
                          ),
                          label: Text(
                            isSaving
                                ? 'Saving...'
                                : isEdit
                                ? 'Update Attendance'
                                : 'Save Attendance',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
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
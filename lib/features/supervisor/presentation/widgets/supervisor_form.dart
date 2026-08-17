/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Form
///
/// Version : 6.0.0
///
/// Responsibilities:
/// - Department selection
/// - Employee selection
/// - Supervisor creation form
/// - Theme aware
/// - Responsive layout
/// - Light / Dark mode support
///
/// Company ID:
/// - Form থেকে company select করা হবে না
/// - Current logged-in user's company context ব্যবহার হবে
/// - Parent/Notifier create করার সময় company_id provide করবে
/// ===============================================================

import 'package:flutter/material.dart';

class SupervisorForm extends StatefulWidget {
// =============================================================
// DEPARTMENTS
// =============================================================

  final List<Map<String, dynamic>> departments;

// =============================================================
// EMPLOYEES
// =============================================================

  final List<Map<String, dynamic>> employees;

// =============================================================
// SAVING
// =============================================================

  final bool isSaving;

// =============================================================
// DEPARTMENT CHANGED
// =============================================================

  final Future<void> Function(String? departmentId)?
  onDepartmentChanged;

// =============================================================
// SUBMIT
// =============================================================

  final Future<void> Function(
      Map<String, dynamic> data,
      )? onSubmit;

// =============================================================
// CONSTRUCTOR
// =============================================================

  const SupervisorForm({
    super.key,
    this.departments = const [],
    this.employees = const [],
    this.isSaving = false,
    this.onDepartmentChanged,
    this.onSubmit,
  });

  @override
  State<SupervisorForm> createState() =>
      _SupervisorFormState();
}

// ===============================================================
// STATE
// ===============================================================

class _SupervisorFormState extends State<SupervisorForm> {
// =============================================================
// FORM KEY
// =============================================================

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

// =============================================================
// SELECTED DEPARTMENT
// =============================================================

  String? _departmentId;

// =============================================================
// SELECTED EMPLOYEE
// =============================================================

  String? _employeeId;

// =============================================================
// SUBMITTING
// =============================================================

  bool _submitting = false;

// =============================================================
// BUILD
// =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isBusy =
        widget.isSaving || _submitting;

    return LayoutBuilder(
      builder: (context,
          constraints,) {
        final width = constraints.maxWidth;

        final bool isMobile =
            width < 600;

        final bool isTablet =
            width >= 600 && width < 1000;

        final double horizontalPadding =
        isMobile
            ? 0
            : isTablet
            ? 8
            : 16;

        return Form(
          key: _formKey,

          child: Center(
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 850,
              ),

              child: Padding(
                padding:
                EdgeInsets.symmetric(
                  horizontal:
                  horizontalPadding,
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
// =================================================
// HEADER
// =================================================

                    _buildHeader(
                      context,
                      isMobile,
                    ),

                    SizedBox(
                      height:
                      isMobile ? 18 : 22,
                    ),

// =================================================
// FORM CARD
// =================================================

                    Card(
                      elevation: 0,

                      margin: EdgeInsets.zero,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),

                        side: BorderSide(
                          color: colorScheme
                              .outlineVariant,
                        ),
                      ),

                      child: Padding(
                        padding:
                        EdgeInsets.all(
                          isMobile ? 14 : 20,
                        ),

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [
// =========================================
// DEPARTMENT
// =========================================

                            _buildDepartmentDropdown(
                              context,
                              isBusy,
                            ),

                            SizedBox(
                              height:
                              isMobile
                                  ? 14
                                  : 18,
                            ),

// =========================================
// EMPLOYEE
// =========================================

                            _buildEmployeeDropdown(
                              context,
                              isBusy,
                            ),

                            SizedBox(
                              height:
                              isMobile
                                  ? 18
                                  : 24,
                            ),

// =========================================
// SUMMARY
// =========================================

                            if (_departmentId !=
                                null &&
                                _employeeId != null)
                              _buildSummary(
                                context,
                                isMobile,
                              ),

                            SizedBox(
                              height:
                              isMobile
                                  ? 16
                                  : 20,
                            ),

// =========================================
// CREATE BUTTON
// =========================================

                            _buildCreateButton(
                              context,
                              isBusy,
                              isMobile,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height:
                      isMobile ? 16 : 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// =============================================================
// HEADER
// =============================================================

  Widget _buildHeader(BuildContext context,
      bool isMobile,) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        Container(
          width: isMobile ? 44 : 50,
          height: isMobile ? 44 : 50,

          decoration: BoxDecoration(
            color: colorScheme
                .primaryContainer,

            borderRadius:
            BorderRadius.circular(14),
          ),

          child: Icon(
            Icons
                .supervisor_account_outlined,

            size: isMobile ? 24 : 28,

            color: colorScheme
                .onPrimaryContainer,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              Text(
                'Create Supervisor',

                style: theme
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  fontWeight:
                  FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Select department and employee.',

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
    );
  }

// =============================================================
// DEPARTMENT DROPDOWN
// =============================================================

  Widget _buildDepartmentDropdown(BuildContext context,
      bool isBusy,) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DropdownButtonFormField<String>(
      value: _departmentId,

      isExpanded: true,

      decoration: InputDecoration(
        labelText: 'Department',
        hintText: widget.departments.isEmpty
            ? 'No departments available'
            : 'Select department',

        prefixIcon: const Icon(
          Icons.apartment_outlined,
        ),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),

          borderSide: BorderSide(
            color: colorScheme
                .outlineVariant,
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),

          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),

        filled: true,

        fillColor:
        colorScheme.surfaceContainerLow,
      ),

      items: widget.departments
          .map(
            (department) {
          final id =
          department['id']
              ?.toString();

          final name =
              department['name']
                  ?.toString() ??
                  department[
                  'department_name']
                      ?.toString() ??
                  '-';

          if (id == null ||
              id.isEmpty) {
            return null;
          }

          return DropdownMenuItem<
              String>(
            value: id,

            child: Text(
              name.isEmpty
                  ? '-'
                  : name,

              maxLines: 1,

              overflow:
              TextOverflow.ellipsis,

              style: theme
                  .textTheme
                  .bodyMedium,
            ),
          );
        },
      )
          .whereType<
          DropdownMenuItem<String>>()
          .toList(),

      onChanged:
      isBusy ||
          widget.departments
              .isEmpty
          ? null
          : (value) async {
        if (value ==
            null ||
            value.isEmpty) {
          return;
        }

        setState(() {
          _departmentId =
              value;

// Department change হলে
// আগের employee clear হবে।
          _employeeId = null;
        });

        debugPrint(
          '================================================',
        );

        debugPrint(
          'SUPERVISOR FORM',
        );

        debugPrint(
          'DEPARTMENT SELECTED = $value',
        );

        debugPrint(
          '================================================',
        );

        await widget
            .onDepartmentChanged
            ?.call(value);
      },

      validator: (value) {
        if (value == null ||
            value.isEmpty) {
          return 'Please select department';
        }

        return null;
      },
    );
  }

// =============================================================
// EMPLOYEE DROPDOWN
// =============================================================

  Widget _buildEmployeeDropdown(BuildContext context,
      bool isBusy,) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool departmentSelected =
        _departmentId != null &&
            _departmentId!.isNotEmpty;

    return DropdownButtonFormField<String>(
      value: _employeeId,

      isExpanded: true,

      decoration: InputDecoration(
        labelText: 'Employee',

        hintText:
        !departmentSelected
            ? 'Select department first'
            : widget.employees.isEmpty
            ? 'No employees available'
            : 'Select employee',

        prefixIcon: const Icon(
          Icons.person_outline,
        ),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),

          borderSide: BorderSide(
            color: colorScheme
                .outlineVariant,
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),

          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),

        filled: true,

        fillColor:
        colorScheme.surfaceContainerLow,
      ),

      items: widget.employees
          .map(
            (employee) {
          final id =
          employee['id']
              ?.toString();

          final fullName =
              employee[
              'full_name']
                  ?.toString() ??
                  employee[
                  'employee_name']
                      ?.toString() ??
                  '${employee['first_name'] ?? ''} '
                      '${employee['last_name'] ?? ''}'
                      .trim();

          final employeeCode =
              employee[
              'employee_code']
                  ?.toString() ??
                  '';

          final label =
          employeeCode.isEmpty
              ? fullName
              : '$fullName '
              '($employeeCode)';

          if (id == null ||
              id.isEmpty) {
            return null;
          }

          return DropdownMenuItem<
              String>(
            value: id,

            child: Text(
              label.isEmpty
                  ? '-'
                  : label,

              maxLines: 1,

              overflow:
              TextOverflow.ellipsis,

              style: theme
                  .textTheme
                  .bodyMedium,
            ),
          );
        },
      )
          .whereType<
          DropdownMenuItem<String>>()
          .toList(),

      onChanged:
      isBusy ||
          !departmentSelected ||
          widget.employees.isEmpty
          ? null
          : (value) {
        if (value ==
            null ||
            value.isEmpty) {
          return;
        }

        setState(() {
          _employeeId =
              value;
        });

        debugPrint(
          '================================================',
        );

        debugPrint(
          'SUPERVISOR FORM',
        );

        debugPrint(
          'EMPLOYEE SELECTED = $value',
        );

        debugPrint(
          '================================================',
        );
      },

      validator: (value) {
        if (!departmentSelected) {
          return 'Select department first';
        }

        if (value == null ||
            value.isEmpty) {
          return 'Please select employee';
        }

        return null;
      },
    );
  }

// =============================================================
// SUMMARY
// =============================================================

  Widget _buildSummary(BuildContext context,
      bool isMobile,) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color color =
        colorScheme.tertiary;

    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(
        isMobile ? 12 : 14,
      ),

      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.10,
        ),

        borderRadius:
        BorderRadius.circular(12),

        border: Border.all(
          color: color.withValues(
            alpha: 0.25,
          ),
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Icon(
            Icons.check_circle_outline,
            color: color,
            size: 21,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              'All information selected. '
                  'You can create the supervisor now.',

              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color: color,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

// =============================================================
// CREATE BUTTON
// =============================================================

  Widget _buildCreateButton(BuildContext context,
      bool isBusy,
      bool isMobile,) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,

      height: isMobile ? 50 : 52,

      child: FilledButton.icon(
        onPressed:
        isBusy ? null : _submit,

        icon: isBusy
            ? const SizedBox(
          width: 19,
          height: 19,

          child:
          CircularProgressIndicator(
            strokeWidth: 2,
          ),
        )
            : const Icon(
          Icons
              .supervisor_account_outlined,
        ),

        label: Text(
          isBusy
              ? 'Creating...'
              : 'Create Supervisor',

          style: theme
              .textTheme
              .labelLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w600,
          ),
        ),

        style: FilledButton.styleFrom(
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

// =============================================================
// SUBMIT
// =============================================================

  Future<void> _submit() async {
    debugPrint(
      '================================================',
    );

    debugPrint(
      'SUPERVISOR CREATE BUTTON CLICKED',
    );

    debugPrint(
      'department_id = $_departmentId',
    );

    debugPrint(
      'employee_id = $_employeeId',
    );

    debugPrint(
      '================================================',
    );

// ===========================================================
// VALIDATE FORM
// ===========================================================

    final valid =
        _formKey.currentState
            ?.validate() ??
            false;

    if (!valid) {
      debugPrint(
        'SUPERVISOR FORM VALIDATION FAILED',
      );

      return;
    }

// ===========================================================
// SAFETY CHECK
// ===========================================================

    if (_departmentId == null ||
        _departmentId!.isEmpty ||
        _employeeId == null ||
        _employeeId!.isEmpty) {
      debugPrint(
        'SUPERVISOR CREATE FAILED: '
            'Required ID missing',
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select department and employee.',
            ),
          ),
        );
      }

      return;
    }

// ===========================================================
// START SUBMITTING
// ===========================================================

    setState(() {
      _submitting = true;
    });

// ===========================================================
// DATA
//
// IMPORTANT:
//
// company_id এখানে Form থেকে নেওয়া হচ্ছে না।
//
// Current logged-in user's company_id
// Parent/Notifier/Repository layer থেকে
// database operation-এর সময় নেওয়া হবে।
// ===========================================================

    final data =
    <String, dynamic>{
      'department_id':
      _departmentId,

      'employee_id':
      _employeeId,

      'status': true,
    };

    debugPrint(
      'SUPERVISOR CREATE DATA = $data',
    );

// ===========================================================
// SUBMIT
// ===========================================================

    try {
      await widget.onSubmit
          ?.call(data);

      debugPrint(
        'SUPERVISOR FORM SUBMIT CALLBACK COMPLETED',
      );
    }
    catch
    (
    e
    ,
    stackTrace
    ) {
    debugPrint(
    'SUPERVISOR CREATE ERROR = $e',
    );

    debugPrint(
    'STACK TRACE = $stackTrace',
    );

    if (mounted) {
    ScaffoldMessenger.of(
    context,
    ).showSnackBar(
    SnackBar(
    backgroundColor:
    Theme.of(context)
        .colorScheme
        .error,

    content: Text(
    'Create Supervisor failed: $e',
    ),
    ),
    );
    }
    } finally {
// =========================================================
// STOP SUBMITTING
// =========================================================

    if (mounted) {
    setState(() {
    _submitting = false;
    });
    }
    }
  }
}

/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Form
///
/// Version : 5.1.0
///
/// Responsibilities:
/// - Department selection
/// - Employee selection
/// - Supervisor creation form
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

  final Future<void> Function(String? departmentId)? onDepartmentChanged;

  // =============================================================
  // SUBMIT
  // =============================================================

  final Future<void> Function(Map<String, dynamic> data)? onSubmit;

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
  State<SupervisorForm> createState() => _SupervisorFormState();
}

// ===============================================================
// STATE
// ===============================================================

class _SupervisorFormState extends State<SupervisorForm> {
  // =============================================================
  // FORM KEY
  // =============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =======================================================
          // TITLE
          // =======================================================
          const Text(
            'Create Supervisor',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          const Text(
            'Select department and employee.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),

          const SizedBox(height: 22),

          // =======================================================
          // DEPARTMENT
          // =======================================================
          DropdownButtonFormField<String>(
            value: _departmentId,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Department',
              hintText: 'Select department',
              prefixIcon: Icon(Icons.apartment_outlined),
              border: OutlineInputBorder(),
            ),

            // -----------------------------------------------------
            // DEPARTMENT ITEMS
            // -----------------------------------------------------
            items: widget.departments.map((department) {
              final id = department['id']?.toString();

              final name =
                  department['name']?.toString() ??
                  department['department_name']?.toString() ??
                  '-';

              return DropdownMenuItem<String>(
                value: id,
                child: Text(name, overflow: TextOverflow.ellipsis),
              );
            }).toList(),

            // -----------------------------------------------------
            // DEPARTMENT CHANGE
            // -----------------------------------------------------
            onChanged: widget.isSaving || _submitting
                ? null
                : (value) async {
                    if (value == null || value.isEmpty) {
                      return;
                    }

                    setState(() {
                      _departmentId = value;

                      // Department change হলে
                      // আগের employee clear হবে।
                      _employeeId = null;
                    });

                    debugPrint(
                      '================================================',
                    );

                    debugPrint('SUPERVISOR FORM');

                    debugPrint('DEPARTMENT SELECTED = $value');

                    debugPrint(
                      '================================================',
                    );

                    // -------------------------------------------------
                    // LOAD EMPLOYEES
                    // -------------------------------------------------

                    await widget.onDepartmentChanged?.call(value);
                  },

            // -----------------------------------------------------
            // VALIDATION
            // -----------------------------------------------------
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select department';
              }

              return null;
            },
          ),

          const SizedBox(height: 18),

          // =======================================================
          // EMPLOYEE
          // =======================================================
          DropdownButtonFormField<String>(
            value: _employeeId,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Employee',
              hintText: 'Select employee',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),

            // -----------------------------------------------------
            // EMPLOYEE ITEMS
            // -----------------------------------------------------
            items: widget.employees.map((employee) {
              final id = employee['id']?.toString();

              final fullName =
                  employee['full_name']?.toString() ??
                  employee['employee_name']?.toString() ??
                  '${employee['first_name'] ?? ''} '
                          '${employee['last_name'] ?? ''}'
                      .trim();

              final employeeCode = employee['employee_code']?.toString() ?? '';

              final label = employeeCode.isEmpty
                  ? fullName
                  : '$fullName ($employeeCode)';

              return DropdownMenuItem<String>(
                value: id,
                child: Text(
                  label.isEmpty ? '-' : label,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),

            // -----------------------------------------------------
            // EMPLOYEE CHANGE
            // -----------------------------------------------------
            onChanged: widget.isSaving || _submitting
                ? null
                : _departmentId == null
                ? null
                : (value) {
                    if (value == null || value.isEmpty) {
                      return;
                    }

                    setState(() {
                      _employeeId = value;
                    });

                    debugPrint(
                      '================================================',
                    );

                    debugPrint('SUPERVISOR FORM');

                    debugPrint('EMPLOYEE SELECTED = $value');

                    debugPrint(
                      '================================================',
                    );
                  },

            // -----------------------------------------------------
            // VALIDATION
            // -----------------------------------------------------
            validator: (value) {
              if (_departmentId == null || _departmentId!.isEmpty) {
                return 'Select department first';
              }

              if (value == null || value.isEmpty) {
                return 'Please select employee';
              }

              return null;
            },
          ),

          const SizedBox(height: 24),

          // =======================================================
          // SUMMARY
          // =======================================================
          if (_departmentId != null && _employeeId != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.withOpacity(.25)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All information selected. '
                      'You can create the supervisor now.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 18),

          // =======================================================
          // CREATE BUTTON
          // =======================================================
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: widget.isSaving || _submitting ? null : _submit,

              // ---------------------------------------------------
              // ICON
              // ---------------------------------------------------
              icon: widget.isSaving || _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.supervisor_account_outlined),

              // ---------------------------------------------------
              // LABEL
              // ---------------------------------------------------
              label: Text(
                widget.isSaving || _submitting
                    ? 'Creating...'
                    : 'Create Supervisor',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SUBMIT
  // =============================================================

  Future<void> _submit() async {
    debugPrint('================================================');

    debugPrint('SUPERVISOR CREATE BUTTON CLICKED');

    debugPrint('department_id = $_departmentId');

    debugPrint('employee_id = $_employeeId');

    debugPrint('================================================');

    // ===========================================================
    // VALIDATE FORM
    // ===========================================================

    final valid = _formKey.currentState?.validate() ?? false;

    if (!valid) {
      debugPrint('SUPERVISOR FORM VALIDATION FAILED');

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select department and employee.'),
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

    final data = <String, dynamic>{
      'department_id': _departmentId,
      'employee_id': _employeeId,
      'status': true,
    };

    debugPrint('SUPERVISOR CREATE DATA = $data');

    // ===========================================================
    // SUBMIT
    // ===========================================================

    try {
      await widget.onSubmit?.call(data);

      debugPrint('SUPERVISOR FORM SUBMIT CALLBACK COMPLETED');
    } catch (e, stackTrace) {
      debugPrint('SUPERVISOR CREATE ERROR = $e');

      debugPrint('STACK TRACE = $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Create Supervisor failed: $e')));
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

/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Form
///
/// Version : 5.0.0
/// ===============================================================

import 'package:flutter/material.dart';

class SupervisorForm extends StatefulWidget {
  final List<Map<String, dynamic>> companies;
  final List<Map<String, dynamic>> departments;
  final List<Map<String, dynamic>> employees;

  final bool isSaving;

  final Future<void> Function(String? companyId)? onCompanyChanged;

  final Future<void> Function(String? departmentId)?
  onDepartmentChanged;

  final Future<void> Function(
      Map<String, dynamic> data,
      )? onSubmit;

  const SupervisorForm({
    super.key,
    this.companies = const [],
    this.departments = const [],
    this.employees = const [],
    this.isSaving = false,
    this.onCompanyChanged,
    this.onDepartmentChanged,
    this.onSubmit,
  });

  @override
  State<SupervisorForm> createState() =>
      _SupervisorFormState();
}

class _SupervisorFormState
    extends State<SupervisorForm> {
  // =============================================================
  // FORM
  // =============================================================

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  // =============================================================
  // SELECTED VALUES
  // =============================================================

  String? _companyId;
  String? _departmentId;
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
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =======================================================
          // TITLE
          // =======================================================

          const Text(
            'Create Supervisor',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Select company, department and employee.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 22),

          // =======================================================
          // COMPANY
          // =======================================================

          DropdownButtonFormField<String>(
            value: _companyId,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Company',
              hintText: 'Select company',
              prefixIcon: Icon(
                Icons.business_outlined,
              ),
              border: OutlineInputBorder(),
            ),
            items: widget.companies.map(
                  (company) {
                final id =
                company['id']?.toString();

                final name =
                    company['name']?.toString() ??
                        company['company_name']
                            ?.toString() ??
                        '-';

                return DropdownMenuItem<String>(
                  value: id,
                  child: Text(
                    name,
                    overflow:
                    TextOverflow.ellipsis,
                  ),
                );
              },
            ).toList(),
            onChanged:
            widget.isSaving || _submitting
                ? null
                : (value) async {
              if (value == null ||
                  value.isEmpty) {
                return;
              }

              setState(() {
                _companyId = value;

                // Company change হলে
                // নিচের selection reset
                _departmentId = null;
                _employeeId = null;
              });

              debugPrint(
                'SUPERVISOR FORM '
                    'COMPANY = $value',
              );

              await widget
                  .onCompanyChanged
                  ?.call(value);
            },
            validator: (value) {
              if (value == null ||
                  value.isEmpty) {
                return 'Please select company';
              }

              return null;
            },
          ),

          const SizedBox(height: 18),

          // =======================================================
          // DEPARTMENT
          // =======================================================

          DropdownButtonFormField<String>(
            value: _departmentId,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Department',
              hintText: 'Select department',
              prefixIcon: Icon(
                Icons.apartment_outlined,
              ),
              border: OutlineInputBorder(),
            ),
            items: widget.departments.map(
                  (department) {
                final id =
                department['id']?.toString();

                final name =
                    department['name']?.toString() ??
                        department['department_name']
                            ?.toString() ??
                        '-';

                return DropdownMenuItem<String>(
                  value: id,
                  child: Text(
                    name,
                    overflow:
                    TextOverflow.ellipsis,
                  ),
                );
              },
            ).toList(),
            onChanged:
            widget.isSaving || _submitting
                ? null
                : _companyId == null
                ? null
                : (value) async {
              if (value == null ||
                  value.isEmpty) {
                return;
              }

              setState(() {
                _departmentId =
                    value;

                _employeeId = null;
              });

              debugPrint(
                'SUPERVISOR FORM '
                    'DEPARTMENT = $value',
              );

              await widget
                  .onDepartmentChanged
                  ?.call(value);
            },
            validator: (value) {
              if (_companyId == null ||
                  _companyId!.isEmpty) {
                return 'Select company first';
              }

              if (value == null ||
                  value.isEmpty) {
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
              prefixIcon: Icon(
                Icons.person_outline,
              ),
              border: OutlineInputBorder(),
            ),
            items: widget.employees.map(
                  (employee) {
                final id =
                employee['id']?.toString();

                final name =
                    employee['full_name']
                        ?.toString() ??
                        employee['employee_name']
                            ?.toString() ??
                        '${employee['first_name'] ?? ''} '
                            '${employee['last_name'] ?? ''}'
                            .trim();

                final code =
                    employee['employee_code']
                        ?.toString() ??
                        '';

                final label =
                code.isEmpty
                    ? name
                    : '$name ($code)';

                return DropdownMenuItem<String>(
                  value: id,
                  child: Text(
                    label.isEmpty
                        ? '-'
                        : label,
                    overflow:
                    TextOverflow.ellipsis,
                  ),
                );
              },
            ).toList(),
            onChanged:
            widget.isSaving || _submitting
                ? null
                : _departmentId == null
                ? null
                : (value) {
              if (value == null ||
                  value.isEmpty) {
                return;
              }

              setState(() {
                _employeeId =
                    value;
              });

              debugPrint(
                'SUPERVISOR FORM '
                    'EMPLOYEE = $value',
              );
            },
            validator: (value) {
              if (_departmentId == null ||
                  _departmentId!.isEmpty) {
                return 'Select department first';
              }

              if (value == null ||
                  value.isEmpty) {
                return 'Please select employee';
              }

              return null;
            },
          ),

          const SizedBox(height: 24),

          // =======================================================
          // SUMMARY
          // =======================================================

          if (_companyId != null &&
              _departmentId != null &&
              _employeeId != null)
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green
                    .withOpacity(.08),
                borderRadius:
                BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.green
                      .withOpacity(.25),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All information selected. '
                          'You can create the supervisor now.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight:
                        FontWeight.w600,
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
              onPressed:
              widget.isSaving ||
                  _submitting
                  ? null
                  : _submit,
              icon:
              widget.isSaving ||
                  _submitting
                  ? const SizedBox(
                width: 18,
                height: 18,
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
                widget.isSaving ||
                    _submitting
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
    debugPrint(
      '================================================',
    );

    debugPrint(
      'SUPERVISOR CREATE BUTTON CLICKED',
    );

    debugPrint(
      'company_id = $_companyId',
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
    // VALIDATE
    // ===========================================================

    final valid =
        _formKey.currentState?.validate() ??
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

    if (_companyId == null ||
        _departmentId == null ||
        _employeeId == null) {
      debugPrint(
        'SUPERVISOR CREATE FAILED: '
            'Required ID missing',
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please select company, department and employee.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _submitting = true;
    });

    // ===========================================================
    // DATA
    // ===========================================================

    final data =
    <String, dynamic>{
      'company_id': _companyId,
      'department_id': _departmentId,
      'employee_id': _employeeId,
      'status': 'active',
    };

    debugPrint(
      'SUPERVISOR CREATE DATA = $data',
    );

    try {
      await widget.onSubmit?.call(data);

      debugPrint(
        'SUPERVISOR FORM SUBMIT CALLBACK COMPLETED',
      );
    } catch (e, stackTrace) {
      debugPrint(
        'SUPERVISOR CREATE ERROR = $e',
      );

      debugPrint(
        'STACK TRACE = $stackTrace',
      );

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              'Create Supervisor failed: $e',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }
}
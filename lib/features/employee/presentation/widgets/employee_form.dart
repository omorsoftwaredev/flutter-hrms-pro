// ===============================================================
// Flutter HRMS Pro
// Employee Form
//
// Company Owner Login Based
//
// Company ID:
// currentUserProvider → CurrentUser.companyId
//
// Company Owner কোনো Company Dropdown ব্যবহার করবে না.
//
// Company ID automatically logged-in session থেকে নেওয়া হবে.
//
// Version : 2.5.0
// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user_provider.dart';

import '../../../department/presentation/providers/department_provider.dart';
import '../../../designation/presentation/providers/designation_provider.dart';
import '../../../shift/presentation/providers/shift_provider.dart';
import '../../../role/presentation/providers/role_provider.dart';

class EmployeeForm extends ConsumerStatefulWidget {
  const EmployeeForm({
    super.key,

    this.initialCompanyId,
    this.initialDepartmentId,
    this.initialDesignationId,
    this.initialShiftId,
    this.initialRoleId,

    this.initialEmployeeCode = '',
    this.initialCardNo = '',

    this.initialFirstName = '',
    this.initialLastName = '',
    this.initialFullName = '',

    this.initialMobile = '',
    this.initialEmail = '',

    this.initialGender = 'Male',

    this.initialEmploymentType = 'Permanent',
    this.initialEmployeeStatus = 'Active',

    this.initialBasicSalary = 0,

    this.initialIsActive = true,

    this.isLoading = false,

    required this.onSubmit,
  });

  // =============================================================
  // INITIAL VALUES
  // =============================================================

  final String? initialCompanyId;
  final String? initialDepartmentId;
  final String? initialDesignationId;
  final String? initialShiftId;
  final String? initialRoleId;

  final String initialEmployeeCode;
  final String initialCardNo;

  final String initialFirstName;
  final String initialLastName;
  final String initialFullName;

  final String initialMobile;
  final String initialEmail;

  final String initialGender;

  final String initialEmploymentType;
  final String initialEmployeeStatus;

  final double initialBasicSalary;

  final bool initialIsActive;

  final bool isLoading;

  // =============================================================
  // SUBMIT
  // =============================================================

  final Future<void> Function(
      String? companyId,
      String? departmentId,
      String? designationId,
      String? shiftId,
      String? roleId,
      String employeeCode,
      String cardNo,
      String firstName,
      String lastName,
      String fullName,
      String mobile,
      String email,
      String gender,
      String employmentType,
      String employeeStatus,
      double basicSalary,
      bool isActive,
      ) onSubmit;

  @override
  ConsumerState<EmployeeForm> createState() =>
      _EmployeeFormState();
}

// ===============================================================
// STATE
// ===============================================================

class _EmployeeFormState
    extends ConsumerState<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();

  String? companyId;
  String? departmentId;
  String? designationId;
  String? shiftId;
  String? roleId;

  late String gender;
  late String employmentType;
  late String employeeStatus;

  late bool isActive;

  late final TextEditingController employeeCode;
  late final TextEditingController cardNo;

  late final TextEditingController firstName;
  late final TextEditingController lastName;
  late final TextEditingController fullName;

  late final TextEditingController mobile;
  late final TextEditingController email;

  late final TextEditingController salary;

  // =============================================================
  // INIT STATE
  // =============================================================

  @override
  void initState() {
    super.initState();

    // -----------------------------------------------------------
    // CURRENT LOGGED-IN USER
    // -----------------------------------------------------------
    //
    // Company Owner:
    //
    // currentUserProvider
    //        ↓
    // CurrentUser.companyId
    //        ↓
    // Employee.companyId
    //
    // Company dropdown ব্যবহার করা হচ্ছে না।
    // -----------------------------------------------------------

    final user = ref.read(currentUserProvider);

    final loggedInCompanyId =
        user?.companyId.trim() ?? '';

    // -----------------------------------------------------------
    // COMPANY ID
    // -----------------------------------------------------------
    //
    // Logged-in user's company ID সর্বোচ্চ priority।
    //
    // Edit mode-এ initialCompanyId fallback হিসেবে থাকবে।
    //
    // -----------------------------------------------------------

    companyId = loggedInCompanyId.isNotEmpty
        ? loggedInCompanyId
        : widget.initialCompanyId;

    // -----------------------------------------------------------
    // INITIAL RELATIONS
    // -----------------------------------------------------------

    departmentId =
        widget.initialDepartmentId;

    designationId =
        widget.initialDesignationId;

    shiftId =
        widget.initialShiftId;

    roleId =
        widget.initialRoleId;

    // -----------------------------------------------------------
    // INITIAL OPTIONS
    // -----------------------------------------------------------

    gender = widget.initialGender;

    employmentType =
        widget.initialEmploymentType;

    employeeStatus =
        widget.initialEmployeeStatus;

    isActive =
        widget.initialIsActive;

    // -----------------------------------------------------------
    // CONTROLLERS
    // -----------------------------------------------------------

    employeeCode =
        TextEditingController(
          text: widget.initialEmployeeCode,
        );

    cardNo =
        TextEditingController(
          text: widget.initialCardNo,
        );

    firstName =
        TextEditingController(
          text: widget.initialFirstName,
        );

    lastName =
        TextEditingController(
          text: widget.initialLastName,
        );

    fullName =
        TextEditingController(
          text: widget.initialFullName,
        );

    mobile =
        TextEditingController(
          text: widget.initialMobile,
        );

    email =
        TextEditingController(
          text: widget.initialEmail,
        );

    salary =
        TextEditingController(
          text: widget.initialBasicSalary.toString(),
        );

    // -----------------------------------------------------------
    // LOAD REQUIRED DATA
    // -----------------------------------------------------------

    Future.microtask(() {
      ref
          .read(departmentProvider.notifier)
          .loadDepartments();

      ref
          .read(designationProvider.notifier)
          .loadDesignations();

      ref
          .read(shiftProvider.notifier)
          .loadShifts();

      ref
          .read(roleProvider.notifier)
          .loadRoles();
    });
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    employeeCode.dispose();
    cardNo.dispose();

    firstName.dispose();
    lastName.dispose();
    fullName.dispose();

    mobile.dispose();
    email.dispose();

    salary.dispose();

    super.dispose();
  }

  // =============================================================
  // SAVE
  // =============================================================

  Future<void> save() async {
    // -----------------------------------------------------------
    // FORM VALIDATION
    // -----------------------------------------------------------

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // -----------------------------------------------------------
    // CURRENT USER
    // -----------------------------------------------------------

    final user =
    ref.read(currentUserProvider);

    if (user == null) {
      _showError(
        'Current user information not found.',
      );

      return;
    }

    // -----------------------------------------------------------
    // COMPANY ID
    // -----------------------------------------------------------

    final finalCompanyId =
    user.companyId.trim();

    // -----------------------------------------------------------
    // COMPANY VALIDATION
    // -----------------------------------------------------------

    if (finalCompanyId.isEmpty) {
      _showError(
        'Company ID not found for the logged-in account.',
      );

      return;
    }

    // -----------------------------------------------------------
    // SUBMIT
    // -----------------------------------------------------------

    await widget.onSubmit(
      finalCompanyId,

      departmentId,
      designationId,
      shiftId,
      roleId,

      employeeCode.text.trim(),
      cardNo.text.trim(),

      firstName.text.trim(),
      lastName.text.trim(),
      fullName.text.trim(),

      mobile.text.trim(),
      email.text.trim(),

      gender,

      employmentType,
      employeeStatus,

      double.tryParse(
        salary.text.trim(),
      ) ??
          0,

      isActive,
    );
  }

  // =============================================================
  // ERROR
  // =============================================================

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final departmentState =
    ref.watch(departmentProvider);

    final designationState =
    ref.watch(designationProvider);

    final shiftState =
    ref.watch(shiftProvider);

    final roleState =
    ref.watch(roleProvider);

    // ===========================================================
    // CURRENT COMPANY
    // ===========================================================

    final user =
    ref.watch(currentUserProvider);

    final loggedInCompanyId =
        user?.companyId.trim() ?? '';

    final effectiveCompanyId =
    loggedInCompanyId.isNotEmpty
        ? loggedInCompanyId
        : companyId;

    // ===========================================================
    // COMPANY BASED FILTER
    // ===========================================================

    final departments =
    departmentState.departments
        .where(
          (department) =>
      department.companyId ==
          effectiveCompanyId,
    )
        .toList();

    final designations =
    designationState.designations
        .where(
          (designation) =>
      designation.companyId ==
          effectiveCompanyId,
    )
        .toList();

    final shifts =
    shiftState.shifts
        .where(
          (shift) =>
      shift.companyId ==
          effectiveCompanyId,
    )
        .toList();

    final roles =
    roleState.filteredRoles
        .where(
          (role) =>
      role.companyId ==
          effectiveCompanyId,
    )
        .toList();

    // ===========================================================
    // COMPANY VALIDATION
    // ===========================================================

    if (user == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Logged-in user information is not available.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (effectiveCompanyId == null ||
        effectiveCompanyId.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Company information is not available for this account.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // ===========================================================
    // FORM
    // ===========================================================

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [

            // =====================================================
            // DEPARTMENT
            // =====================================================

            DropdownButtonFormField<String>(
              value: departments.any(
                    (e) => e.id == departmentId,
              )
                  ? departmentId
                  : null,
              decoration:
              const InputDecoration(
                labelText: 'Department',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.apartment_outlined,
                ),
              ),
              items: departments
                  .map(
                    (e) => DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                ),
              )
                  .toList(),
              onChanged: widget.isLoading
                  ? null
                  : (value) {
                setState(() {
                  departmentId = value;

                  designationId =
                  null;
                });
              },
            ),

            const SizedBox(height: 16),

            // =====================================================
            // DESIGNATION
            // =====================================================

            DropdownButtonFormField<String>(
              value: designations.any(
                    (e) => e.id == designationId,
              )
                  ? designationId
                  : null,
              decoration:
              const InputDecoration(
                labelText: 'Designation',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.badge_outlined,
                ),
              ),
              items: designations
                  .map(
                    (e) => DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                ),
              )
                  .toList(),
              onChanged: widget.isLoading
                  ? null
                  : (value) {
                setState(() {
                  designationId =
                      value;
                });
              },
            ),

            const SizedBox(height: 16),

            // =====================================================
            // SHIFT
            // =====================================================

            DropdownButtonFormField<String>(
              value: shifts.any(
                    (e) => e.id == shiftId,
              )
                  ? shiftId
                  : null,
              decoration:
              const InputDecoration(
                labelText: 'Shift',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.schedule_outlined,
                ),
              ),
              items: shifts
                  .map(
                    (e) => DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                ),
              )
                  .toList(),
              onChanged: widget.isLoading
                  ? null
                  : (value) {
                setState(() {
                  shiftId = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // =====================================================
            // ROLE
            // =====================================================

            DropdownButtonFormField<String>(
              value: roles.any(
                    (e) => e.id == roleId,
              )
                  ? roleId
                  : null,
              decoration:
              const InputDecoration(
                labelText: 'Role',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.admin_panel_settings_outlined,
                ),
              ),
              items: roles
                  .map(
                    (e) => DropdownMenuItem(
                  value: e.id,
                  child: Text(e.roleName),
                ),
              )
                  .toList(),
              onChanged: widget.isLoading
                  ? null
                  : (value) {
                setState(() {
                  roleId = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // =====================================================
            // CARD NO
            // =====================================================

            TextFormField(
              controller: cardNo,
              decoration:
              const InputDecoration(
                labelText: 'Card No',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.credit_card_outlined,
                ),
              ),
              textInputAction:
              TextInputAction.next,
            ),

            const SizedBox(height: 16),

            // =====================================================
            // FIRST NAME
            // =====================================================

            TextFormField(
              controller: firstName,
              decoration:
              const InputDecoration(
                labelText: 'First Name',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.person_outline,
                ),
              ),
              textInputAction:
              TextInputAction.next,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'First Name is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // =====================================================
            // LAST NAME
            // =====================================================

            TextFormField(
              controller: lastName,
              decoration:
              const InputDecoration(
                labelText: 'Last Name',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.person_outline,
                ),
              ),
              textInputAction:
              TextInputAction.next,
            ),

            const SizedBox(height: 16),

            // =====================================================
            // FULL NAME
            // =====================================================

            TextFormField(
              controller: fullName,
              decoration:
              const InputDecoration(
                labelText: 'Full Name',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.person,
                ),
              ),
              textInputAction:
              TextInputAction.next,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Full Name is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // =====================================================
            // MOBILE
            // =====================================================

            TextFormField(
              controller: mobile,
              keyboardType:
              TextInputType.phone,
              decoration:
              const InputDecoration(
                labelText: 'Mobile',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.phone_outlined,
                ),
              ),
              textInputAction:
              TextInputAction.next,
            ),

            const SizedBox(height: 16),

            // =====================================================
            // EMAIL
            // =====================================================

            TextFormField(
              controller: email,
              keyboardType:
              TextInputType.emailAddress,
              decoration:
              const InputDecoration(
                labelText: 'Email',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.email_outlined,
                ),
              ),
              textInputAction:
              TextInputAction.next,
              validator: (value) {
                final emailValue =
                    value?.trim() ?? '';

                if (emailValue.isEmpty) {
                  return null;
                }

                final emailRegex = RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                );

                if (!emailRegex
                    .hasMatch(emailValue)) {
                  return 'Enter a valid email address';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // =====================================================
            // GENDER
            // =====================================================

            DropdownButtonFormField<String>(
              value: gender,
              decoration:
              const InputDecoration(
                labelText: 'Gender',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.wc_outlined,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Male',
                  child: Text('Male'),
                ),
                DropdownMenuItem(
                  value: 'Female',
                  child: Text('Female'),
                ),
                DropdownMenuItem(
                  value: 'Other',
                  child: Text('Other'),
                ),
              ],
              onChanged: widget.isLoading
                  ? null
                  : (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  gender = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // =====================================================
            // EMPLOYMENT TYPE
            // =====================================================

            DropdownButtonFormField<String>(
              value: employmentType,
              decoration:
              const InputDecoration(
                labelText: 'Employment Type',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.work_outline,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Permanent',
                  child: Text('Permanent'),
                ),
                DropdownMenuItem(
                  value: 'Contract',
                  child: Text('Contract'),
                ),
                DropdownMenuItem(
                  value: 'Intern',
                  child: Text('Intern'),
                ),
              ],
              onChanged: widget.isLoading
                  ? null
                  : (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  employmentType =
                      value;
                });
              },
            ),

            const SizedBox(height: 16),

            // =====================================================
            // EMPLOYEE STATUS
            // =====================================================

            DropdownButtonFormField<String>(
              value: employeeStatus,
              decoration:
              const InputDecoration(
                labelText: 'Employee Status',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.toggle_on_outlined,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Active',
                  child: Text('Active'),
                ),
                DropdownMenuItem(
                  value: 'Inactive',
                  child: Text('Inactive'),
                ),
              ],
              onChanged: widget.isLoading
                  ? null
                  : (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  employeeStatus =
                      value;
                });
              },
            ),

            const SizedBox(height: 16),

            // =====================================================
            // BASIC SALARY
            // =====================================================

            TextFormField(
              controller: salary,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration:
              const InputDecoration(
                labelText: 'Basic Salary',
                border:
                OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.payments_outlined,
                ),
              ),
              validator: (value) {
                final salaryValue =
                double.tryParse(
                  value?.trim() ?? '',
                );

                if (salaryValue == null) {
                  return 'Enter a valid salary';
                }

                if (salaryValue < 0) {
                  return 'Salary cannot be negative';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // =====================================================
            // ACTIVE STATUS
            // =====================================================

            SwitchListTile(
              contentPadding:
              EdgeInsets.zero,
              title: const Text(
                'Active',
                style: TextStyle(
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Enable or disable this employee',
              ),
              value: isActive,
              onChanged: widget.isLoading
                  ? null
                  : (value) {
                setState(() {
                  isActive = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // =====================================================
            // SAVE BUTTON
            // =====================================================

            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed:
                widget.isLoading
                    ? null
                    : save,
                child: widget.isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Save Employee',
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
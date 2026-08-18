// ===============================================================
// Flutter HRMS Pro
// Employee Form
//
// Company Owner Login Based
//
// UI:
// Responsive + Theme Aware + Professional
//
// IMPORTANT:
// Business logic / Provider / Submit Signature unchanged.
//
// Version : 3.0.0 UI Refresh
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
    this.initialCardNo = '',
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

  final String? initialCompanyId;
  final String? initialDepartmentId;
  final String? initialDesignationId;
  final String? initialShiftId;
  final String? initialRoleId;

  final String initialCardNo;

  final String initialFullName;

  final String initialMobile;
  final String initialEmail;

  final String initialGender;

  final String initialEmploymentType;
  final String initialEmployeeStatus;

  final double initialBasicSalary;

  final bool initialIsActive;

  final bool isLoading;

  final Future<void> Function(
      String? companyId,
      String? departmentId,
      String? designationId,
      String? shiftId,
      String? roleId,
      String cardNo,
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
  ConsumerState<EmployeeForm> createState() => _EmployeeFormState();
}

// ===============================================================
// STATE
// ===============================================================

class _EmployeeFormState extends ConsumerState<EmployeeForm> {
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

  late final TextEditingController cardNo;

  late final TextEditingController fullName;

  late final TextEditingController mobile;
  late final TextEditingController email;

  late final TextEditingController salary;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    final user = ref.read(currentUserProvider);

    final loggedInCompanyId = user?.companyId.trim() ?? '';

    companyId = loggedInCompanyId.isNotEmpty
        ? loggedInCompanyId
        : widget.initialCompanyId;

    departmentId = widget.initialDepartmentId;
    designationId = widget.initialDesignationId;
    shiftId = widget.initialShiftId;
    roleId = widget.initialRoleId;

    gender = widget.initialGender;
    employmentType = widget.initialEmploymentType;
    employeeStatus = widget.initialEmployeeStatus;

    isActive = widget.initialIsActive;


    cardNo = TextEditingController(
      text: widget.initialCardNo,
    );


    fullName = TextEditingController(
      text: widget.initialFullName,
    );

    mobile = TextEditingController(
      text: widget.initialMobile,
    );

    email = TextEditingController(
      text: widget.initialEmail,
    );

    salary = TextEditingController(
      text: widget.initialBasicSalary.toString(),
    );

    Future.microtask(() {
      ref.read(departmentProvider.notifier).loadDepartments();

      ref.read(designationProvider.notifier).loadDesignations();

      ref.read(shiftProvider.notifier).loadShifts();

      ref.read(roleProvider.notifier).loadRoles();
    });
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    cardNo.dispose();

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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = ref.read(currentUserProvider);

    if (user == null) {
      _showError(
        'Current user information not found.',
      );
      return;
    }

    final finalCompanyId = user.companyId.trim();

    if (finalCompanyId.isEmpty) {
      _showError(
        'Company ID not found for the logged-in account.',
      );
      return;
    }

    await widget.onSubmit(
      finalCompanyId,
      departmentId,
      designationId,
      shiftId,
      roleId,
      cardNo.text.trim(),
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
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
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

    final departmentState = ref.watch(departmentProvider);
    final designationState = ref.watch(designationProvider);
    final shiftState = ref.watch(shiftProvider);
    final roleState = ref.watch(roleProvider);

    // ===========================================================
    // CURRENT COMPANY
    // ===========================================================

    final user = ref.watch(currentUserProvider);

    final loggedInCompanyId =
        user?.companyId.trim() ?? '';

    final effectiveCompanyId =
    loggedInCompanyId.isNotEmpty
        ? loggedInCompanyId
        : companyId;

    // ===========================================================
    // COMPANY BASED FILTER
    // ===========================================================

    final departments = departmentState.departments
        .where(
          (department) =>
      department.companyId == effectiveCompanyId,
    )
        .toList();

    final designations = designationState.designations
        .where(
          (designation) =>
      designation.companyId == effectiveCompanyId,
    )
        .toList();

    final shifts = shiftState.shifts
        .where(
          (shift) =>
      shift.companyId == effectiveCompanyId,
    )
        .toList();

    final roles = roleState.filteredRoles
        .where(
          (role) =>
      role.companyId == effectiveCompanyId,
    )
        .toList();

    // ===========================================================
    // USER VALIDATION
    // ===========================================================

    if (user == null) {
      return _buildMessageState(
        context,
        icon: Icons.person_off_outlined,
        title: 'User information unavailable',
        message:
        'Logged-in user information is not available.',
      );
    }

    if (effectiveCompanyId == null ||
        effectiveCompanyId.isEmpty) {
      return _buildMessageState(
        context,
        icon: Icons.business_outlined,
        title: 'Company information unavailable',
        message:
        'Company information is not available for this account.',
      );
    }

    // ===========================================================
    // RESPONSIVE
    // ===========================================================

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isDesktop = width >= 900;
        final bool isTablet = width >= 600 && width < 900;

        final double horizontalPadding = isDesktop
            ? 32
            : isTablet
            ? 24
            : 16;

        final double maxFormWidth =
        isDesktop ? 920 : double.infinity;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxFormWidth,
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  isDesktop ? 28 : 20,
                  horizontalPadding,
                  32,
                ),
                children: [
                  // =================================================
                  // FORM HEADER
                  // =================================================

                  _buildFormHeader(
                    context,
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // ORGANIZATION SECTION
                  // =================================================

                  _buildSectionCard(
                    context,
                    title: 'Organization',
                    subtitle:
                    'Assign department, designation, shift and role.',
                    icon: Icons.account_tree_outlined,
                    child: Column(
                      children: [
                        _buildDropdown<String>(
                          context: context,
                          label: 'Department',
                          icon: Icons.apartment_outlined,
                          value: departments.any(
                                (e) => e.id == departmentId,
                          )
                              ? departmentId
                              : null,
                          items: departments
                              .map(
                                (e) => DropdownMenuItem<String>(
                              value: e.id,
                              child: Text(
                                e.name,
                                overflow:
                                TextOverflow.ellipsis,
                              ),
                            ),
                          )
                              .toList(),
                          onChanged: widget.isLoading
                              ? null
                              : (value) {
                            setState(() {
                              departmentId = value;
                              designationId = null;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildDropdown<String>(
                          context: context,
                          label: 'Designation',
                          icon: Icons.badge_outlined,
                          value: designations.any(
                                (e) => e.id == designationId,
                          )
                              ? designationId
                              : null,
                          items: designations
                              .map(
                                (e) => DropdownMenuItem<String>(
                              value: e.id,
                              child: Text(
                                e.name,
                                overflow:
                                TextOverflow.ellipsis,
                              ),
                            ),
                          )
                              .toList(),
                          onChanged: widget.isLoading
                              ? null
                              : (value) {
                            setState(() {
                              designationId = value;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildDropdown<String>(
                          context: context,
                          label: 'Shift',
                          icon: Icons.schedule_outlined,
                          value: shifts.any(
                                (e) => e.id == shiftId,
                          )
                              ? shiftId
                              : null,
                          items: shifts
                              .map(
                                (e) => DropdownMenuItem<String>(
                              value: e.id,
                              child: Text(
                                e.name,
                                overflow:
                                TextOverflow.ellipsis,
                              ),
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

                        _buildDropdown<String>(
                          context: context,
                          label: 'Role',
                          icon:
                          Icons.admin_panel_settings_outlined,
                          value: roles.any(
                                (e) => e.id == roleId,
                          )
                              ? roleId
                              : null,
                          items: roles
                              .map(
                                (e) => DropdownMenuItem<String>(
                              value: e.id,
                              child: Text(
                                e.roleName,
                                overflow:
                                TextOverflow.ellipsis,
                              ),
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =================================================
                  // EMPLOYEE INFORMATION
                  // =================================================

                  _buildSectionCard(
                    context,
                    title: 'Employee Information',
                    subtitle:
                    'Basic identification and contact information.',
                    icon: Icons.person_outline_rounded,
                    child: _buildResponsiveFields(
                      context,
                      isDesktop: isDesktop,
                      children: [
                        _buildTextField(
                          context,
                          controller: cardNo,
                          label: 'Card No',
                          icon: Icons.credit_card_outlined,
                          textInputAction:
                          TextInputAction.next,
                        ),

                        _buildTextField(
                          context,
                          controller: fullName,
                          label: 'Full Name',
                          icon: Icons.person_rounded,
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

                        _buildTextField(
                          context,
                          controller: mobile,
                          label: 'Mobile',
                          icon: Icons.phone_outlined,
                          keyboardType:
                          TextInputType.phone,
                          textInputAction:
                          TextInputAction.next,
                        ),

                        _buildTextField(
                          context,
                          controller: email,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType:
                          TextInputType.emailAddress,
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =================================================
                  // EMPLOYMENT DETAILS
                  // =================================================

                  _buildSectionCard(
                    context,
                    title: 'Employment Details',
                    subtitle:
                    'Define employee category, status and salary.',
                    icon: Icons.work_outline_rounded,
                    child: _buildResponsiveFields(
                      context,
                      isDesktop: isDesktop,
                      children: [
                        _buildDropdown<String>(
                          context: context,
                          label: 'Gender',
                          icon: Icons.wc_outlined,
                          value: gender,
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

                        _buildDropdown<String>(
                          context: context,
                          label: 'Employment Type',
                          icon: Icons.work_outline,
                          value: employmentType,
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
                              employmentType = value;
                            });
                          },
                        ),

                        _buildDropdown<String>(
                          context: context,
                          label: 'Employee Status',
                          icon: Icons.toggle_on_outlined,
                          value: employeeStatus,
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
                              employeeStatus = value;
                            });
                          },
                        ),

                        _buildTextField(
                          context,
                          controller: salary,
                          label: 'Basic Salary',
                          icon:
                          Icons.payments_outlined,
                          keyboardType:
                          const TextInputType
                              .numberWithOptions(
                            decimal: true,
                          ),
                          textInputAction:
                          TextInputAction.done,
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =================================================
                  // ACTIVE STATUS CARD
                  // =================================================

                  _buildStatusCard(context),

                  const SizedBox(height: 24),

                  // =================================================
                  // SAVE BUTTON
                  // =================================================

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      onPressed:
                      widget.isLoading ? null : save,
                      icon: widget.isLoading
                          ? const SizedBox(
                        width: 21,
                        height: 21,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2.2,
                        ),
                      )
                          : const Icon(
                        Icons.save_outlined,
                      ),
                      label: Text(
                        widget.isLoading
                            ? 'Saving Employee...'
                            : 'Save Employee',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
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
    );
  }

  // =============================================================
  // FORM HEADER
  // =============================================================

  Widget _buildFormHeader(
      BuildContext context, {
        required bool isDesktop,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(
        isDesktop ? 22 : 18,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.surfaceContainerLow,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isDesktop ? 58 : 52,
            height: isDesktop ? 58 : 52,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              Icons.person_add_alt_1_rounded,
              color: colorScheme.onPrimary,
              size: isDesktop ? 28 : 25,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Employee Information',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Create and manage employee details',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                    colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SECTION CARD
  // =============================================================

  Widget _buildSectionCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Widget child,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(
              alpha: 0.05,
            ),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color:
                  colorScheme.primaryContainer,
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color:
                  colorScheme.onPrimaryContainer,
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
                      theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      theme.textTheme.bodySmall?.copyWith(
                        color:
                        colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }

  // =============================================================
  // RESPONSIVE FIELD LAYOUT
  // =============================================================

  Widget _buildResponsiveFields(
      BuildContext context, {
        required bool isDesktop,
        required List<Widget> children,
      }) {
    if (!isDesktop) {
      return Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              const SizedBox(height: 16),
          ],
        ],
      );
    }

    final rows = <Widget>[];

    for (int i = 0; i < children.length; i += 2) {
      final first = children[i];

      final second =
      i + 1 < children.length
          ? children[i + 1]
          : const SizedBox.shrink();

      rows.add(
        Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: 14),
            Expanded(child: second),
          ],
        ),
      );

      if (i + 2 < children.length) {
        rows.add(
          const SizedBox(height: 16),
        );
      }
    }

    return Column(
      children: rows,
    );
  }

  // =============================================================
  // TEXT FIELD
  // =============================================================

  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String label,
        required IconData icon,
        TextInputType? keyboardType,
        TextInputAction? textInputAction,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      enabled: !widget.isLoading,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .primary,
            width: 2,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // DROPDOWN
  // =============================================================

  Widget _buildDropdown<T>({
    required BuildContext context,
    required String label,
    required IconData icon,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?>? onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .primary,
            width: 2,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // STATUS CARD
  // =============================================================

  Widget _buildStatusCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final background = isActive
        ? colorScheme.primaryContainer
        : colorScheme.errorContainer;

    final foreground = isActive
        ? colorScheme.onPrimaryContainer
        : colorScheme.onErrorContainer;

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: foreground.withValues(
            alpha: 0.15,
          ),
        ),
      ),
      child: SwitchListTile(
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        secondary: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: foreground.withValues(
              alpha: 0.10,
            ),
            borderRadius:
            BorderRadius.circular(12),
          ),
          child: Icon(
            isActive
                ? Icons.check_circle_outline_rounded
                : Icons.cancel_outlined,
            color: foreground,
          ),
        ),
        title: Text(
          isActive
              ? 'Employee is Active'
              : 'Employee is Inactive',
          style:
          theme.textTheme.titleSmall?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          isActive
              ? 'This employee is currently active.'
              : 'This employee is currently inactive.',
          style:
          theme.textTheme.bodySmall?.copyWith(
            color: foreground.withValues(
              alpha: 0.75,
            ),
          ),
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
    );
  }

  // =============================================================
  // MESSAGE STATE
  // =============================================================

  Widget _buildMessageState(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String message,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 520,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 44,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style:
                theme.textTheme.bodyMedium?.copyWith(
                  color:
                  colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//===============================================================
// Employee Account Form
//===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../../department/presentation/providers/department_provider.dart';
import '../../../employee/presentation/providers/employee_provider.dart';

class EmployeeAccountForm extends ConsumerStatefulWidget {
  const EmployeeAccountForm({
    super.key,

    this.initialCompanyId,
    this.initialDepartmentId,
    this.initialEmployeeId,

    this.initialUsername = '',
    this.initialPassword = '',

    this.initialCanLogin = true,
    this.initialIsActive = true,
    this.initialIsLocked = false,

    this.isEdit = false,

    required this.isLoading,
    required this.onSubmit,
  });

  // =============================================================
  // INITIAL DATA
  // =============================================================

  final String? initialCompanyId;
  final String? initialDepartmentId;
  final String? initialEmployeeId;

  final String initialUsername;
  final String initialPassword;

  final bool initialCanLogin;
  final bool initialIsActive;
  final bool initialIsLocked;

  // =============================================================
  // MODE
  // =============================================================

  final bool isEdit;

  // =============================================================
  // STATE
  // =============================================================

  final bool isLoading;

  // =============================================================
  // SUBMIT
  // =============================================================

  final Future<void> Function(
      String companyId,
      String departmentId,
      String employeeId,
      String username,
      String password,
      bool canLogin,
      bool isActive,
      bool isLocked,
      ) onSubmit;

  @override
  ConsumerState<EmployeeAccountForm> createState() =>
      _EmployeeAccountFormState();
}

class _EmployeeAccountFormState
    extends ConsumerState<EmployeeAccountForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  String? companyId;
  String? departmentId;
  String? employeeId;

  bool canLogin = true;
  bool isActive = true;
  bool isLocked = false;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(
      text: widget.initialUsername,
    );

    _passwordController = TextEditingController(
      text: widget.initialPassword,
    );

    companyId = widget.initialCompanyId;
    departmentId = widget.initialDepartmentId;
    employeeId = widget.initialEmployeeId;

    canLogin = widget.initialCanLogin;
    isActive = widget.initialIsActive;
    isLocked = widget.initialIsLocked;

    Future.microtask(_loadData);
  }

  // =============================================================
  // LOAD DATA
  // =============================================================

  Future<void> _loadData() async {
    try {
      // ---------------------------------------------------------
      // Current User
      // ---------------------------------------------------------

      final user = ref.read(currentUserProvider);

      if (user == null) {
        debugPrint(
          'Employee Account Form => Current user unavailable.',
        );
        return;
      }

      final currentCompanyId = user.companyId.trim();

      if (currentCompanyId.isEmpty) {
        debugPrint(
          'Employee Account Form => Company ID unavailable.',
        );
        return;
      }

      // ---------------------------------------------------------
      // IMPORTANT
      // ---------------------------------------------------------
      //
      // Current logged-in user's company-ই source of truth।
      //
      // ---------------------------------------------------------

      if (mounted) {
        setState(() {
          companyId = currentCompanyId;

          // Existing department যদি অন্য company-এর হয়,
          // তাহলে reset হবে।
          if (departmentId != null &&
              widget.initialCompanyId != currentCompanyId) {
            departmentId = null;
            employeeId = null;
          }
        });
      }

      // ---------------------------------------------------------
      // Departments
      // ---------------------------------------------------------
      //
      // DepartmentRepository already CurrentUser.companyId
      // দিয়ে filter করে।
      //
      // ---------------------------------------------------------

      await ref
          .read(departmentProvider.notifier)
          .loadDepartments();

      // ---------------------------------------------------------
      // Employees
      // ---------------------------------------------------------

      await ref
          .read(employeeProvider.notifier)
          .loadEmployees();
    } catch (e) {
      debugPrint(
        'Employee Account Form Load Error => $e',
      );
    }
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    // ===========================================================
    // CURRENT USER
    // ===========================================================

    final user = ref.watch(currentUserProvider);

    // ===========================================================
    // STATES
    // ===========================================================

    final departmentState =
    ref.watch(departmentProvider);

    final employeeState =
    ref.watch(employeeProvider);

    // ===========================================================
    // CURRENT COMPANY
    // ===========================================================

    final currentCompanyId =
        user?.companyId.trim() ?? '';

    // ===========================================================
    // KEEP COMPANY IN SYNC
    // ===========================================================

    if (currentCompanyId.isNotEmpty &&
        companyId != currentCompanyId) {
      companyId = currentCompanyId;
    }

    // ===========================================================
    // DATA
    // ===========================================================

    final departments =
        departmentState.departments;

    final employees =
        employeeState.employees;

    // ===========================================================
    // FILTER DEPARTMENTS
    // ===========================================================

    final filteredDepartments = departments
        .where(
          (department) =>
      department.companyId == currentCompanyId,
    )
        .toList();

    // ===========================================================
    // FILTER EMPLOYEES
    // ===========================================================

    final filteredEmployees = employees
        .where(
          (employee) =>
      employee.companyId == currentCompanyId &&
          employee.departmentId == departmentId,
    )
        .toList();

    // ===========================================================
    // INVALID CURRENT USER
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

    // ===========================================================
    // INVALID COMPANY
    // ===========================================================

    if (currentCompanyId.isEmpty) {
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

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [

            //=====================================================
            // DEPARTMENT
            //=====================================================

            DropdownButtonFormField<String>(
              value: filteredDepartments.any(
                    (department) =>
                department.id == departmentId,
              )
                  ? departmentId
                  : null,

              decoration: const InputDecoration(
                labelText: 'Department',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.account_tree_outlined,
                ),
              ),

              items: filteredDepartments.map(
                    (department) {
                  return DropdownMenuItem<String>(
                    value: department.id,
                    child: Text(
                      department.name,
                    ),
                  );
                },
              ).toList(),

              onChanged: widget.isLoading
                  ? null
                  : (value) {
                setState(() {
                  departmentId = value;
                  employeeId = null;
                });
              },

              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Select department';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            //=====================================================
            // EMPLOYEE
            //=====================================================

            DropdownButtonFormField<String>(
              value: filteredEmployees.any(
                    (employee) =>
                employee.id == employeeId,
              )
                  ? employeeId
                  : null,

              decoration: const InputDecoration(
                labelText: 'Employee',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.person_outline,
                ),
              ),

              items: filteredEmployees.map(
                    (employee) {
                  return DropdownMenuItem<String>(
                    value: employee.id,
                    child: Text(
                      employee.fullName,
                    ),
                  );
                },
              ).toList(),

              onChanged:
              departmentId == null ||
                  widget.isLoading
                  ? null
                  : (value) {
                setState(() {
                  employeeId = value;
                });
              },

              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Select employee';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            //=====================================================
            // USERNAME
            //=====================================================

            TextFormField(
              controller: _usernameController,

              enabled: !widget.isLoading,

              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.person_outline,
                ),
              ),

              textInputAction:
              TextInputAction.next,

              validator: (value) {
                final username =
                    value?.trim() ?? '';

                if (username.isEmpty) {
                  return 'Username is required';
                }

                if (username.length < 4) {
                  return 'Minimum 4 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            //=====================================================
            // PASSWORD
            //=====================================================

            TextFormField(
              controller: _passwordController,

              enabled: !widget.isLoading,

              obscureText: true,

              decoration: InputDecoration(
                labelText: widget.isEdit
                    ? 'New Password'
                    : 'Password',

                hintText: widget.isEdit
                    ? 'Leave empty to keep current password'
                    : 'Enter password',

                border:
                const OutlineInputBorder(),

                prefixIcon: const Icon(
                  Icons.lock_outline,
                ),
              ),

              validator: (value) {
                final password =
                    value ?? '';

                // ------------------------------------------------
                // CREATE
                // ------------------------------------------------

                if (!widget.isEdit &&
                    password.isEmpty) {
                  return 'Password is required';
                }

                // ------------------------------------------------
                // EDIT
                // ------------------------------------------------
                //
                // Empty = existing password unchanged.
                //
                // ------------------------------------------------

                if (widget.isEdit &&
                    password.isEmpty) {
                  return null;
                }

                if (password.length < 6) {
                  return 'Password must be at least 6 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            //=====================================================
            // ACCOUNT SETTINGS
            //=====================================================

            Card(
              elevation: 0,

              child: Padding(
                padding:
                const EdgeInsets.all(12),

                child: Column(
                  children: [
                    //=================================================
                    // ALLOW LOGIN
                    //=================================================

                    SwitchListTile(
                      value: canLogin,

                      title: const Text(
                        'Allow Login',
                      ),

                      subtitle: const Text(
                        'Employee can login to the system',
                      ),

                      secondary: const Icon(
                        Icons.login,
                      ),

                      onChanged:
                      widget.isLoading
                          ? null
                          : (value) {
                        setState(() {
                          canLogin =
                              value;
                        });
                      },
                    ),

                    const Divider(),

                    //=================================================
                    // ACTIVE
                    //=================================================

                    SwitchListTile(
                      value: isActive,

                      title: const Text(
                        'Active Account',
                      ),

                      subtitle: const Text(
                        'Enable / Disable account',
                      ),

                      secondary: const Icon(
                        Icons.verified_user_outlined,
                      ),

                      onChanged:
                      widget.isLoading
                          ? null
                          : (value) {
                        setState(() {
                          isActive =
                              value;
                        });
                      },
                    ),

                    const Divider(),

                    //=================================================
                    // LOCK
                    //=================================================

                    SwitchListTile(
                      value: isLocked,

                      title: const Text(
                        'Lock Account',
                      ),

                      subtitle: const Text(
                        'Prevent employee login',
                      ),

                      secondary: const Icon(
                        Icons.lock_outline,
                      ),

                      onChanged:
                      widget.isLoading
                          ? null
                          : (value) {
                        setState(() {
                          isLocked =
                              value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            //=====================================================
            // SAVE BUTTON
            //=====================================================

            SizedBox(
              width: double.infinity,
              height: 52,

              child: FilledButton.icon(
                onPressed:
                widget.isLoading
                    ? null
                    : () async {
                  // ===================================
                  // VALIDATE FORM
                  // ===================================

                  if (!_formKey
                      .currentState!
                      .validate()) {
                    return;
                  }

                  // ===================================
                  // COMPANY
                  // ===================================

                  final finalCompanyId =
                      currentCompanyId;

                  // ===================================
                  // REQUIRED IDs
                  // ===================================

                  if (finalCompanyId
                      .isEmpty ||
                      departmentId ==
                          null ||
                      employeeId == null) {
                    ScaffoldMessenger
                        .of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please complete all required fields.',
                        ),
                      ),
                    );

                    return;
                  }

                  // ===================================
                  // DEBUG
                  // ===================================

                  debugPrint(
                    '==============================================',
                  );

                  debugPrint(
                    'EMPLOYEE ACCOUNT SAVE',
                  );

                  debugPrint(
                    'Mode         => '
                        '${widget.isEdit ? 'UPDATE' : 'CREATE'}',
                  );

                  debugPrint(
                    'Company ID   => '
                        '$finalCompanyId',
                  );

                  debugPrint(
                    'Department   => '
                        '$departmentId',
                  );

                  debugPrint(
                    'Employee     => '
                        '$employeeId',
                  );

                  debugPrint(
                    'Username     => '
                        '${_usernameController.text.trim()}',
                  );

                  debugPrint(
                    'Can Login    => '
                        '$canLogin',
                  );

                  debugPrint(
                    'Active       => '
                        '$isActive',
                  );

                  debugPrint(
                    'Locked       => '
                        '$isLocked',
                  );

                  debugPrint(
                    '==============================================',
                  );

                  // ===================================
                  // SUBMIT
                  // ===================================

                  try {
                    await widget.onSubmit(
                      finalCompanyId,
                      departmentId!,
                      employeeId!,
                      _usernameController
                          .text
                          .trim(),
                      _passwordController
                          .text
                          .trim(),
                      canLogin,
                      isActive,
                      isLocked,
                    );
                  } catch (e) {
                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger
                        .of(context)
                        .showSnackBar(
                      SnackBar(
                        backgroundColor:
                        Colors.red,
                        content: Text(
                          e.toString(),
                        ),
                      ),
                    );
                  }
                },

                //=================================================
                // BUTTON ICON
                //=================================================

                icon: widget.isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(
                  Icons.save,
                ),

                //=================================================
                // BUTTON TEXT
                //=================================================

                label: Text(
                  widget.isLoading
                      ? 'Saving...'
                      : widget.isEdit
                      ? 'Update Account'
                      : 'Save Account',
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
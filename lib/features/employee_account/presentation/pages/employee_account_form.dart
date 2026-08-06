//===============================================================
// Employee Account Form
//===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../company/presentation/providers/company_provider.dart';
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

    required this.isLoading,

    required this.onSubmit,
  });

  final String? initialCompanyId;
  final String? initialDepartmentId;
  final String? initialEmployeeId;

  final String initialUsername;
  final String initialPassword;

  final bool initialCanLogin;
  final bool initialIsActive;
  final bool initialIsLocked;

  final bool isLoading;

  final Future<void> Function(
    String companyId,
    String departmentId,
    String employeeId,
    String username,
    String password,
    bool canLogin,
    bool isActive,
    bool isLocked,
  )
  onSubmit;

  @override
  ConsumerState<EmployeeAccountForm> createState() =>
      _EmployeeAccountFormState();
}

class _EmployeeAccountFormState extends ConsumerState<EmployeeAccountForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;

  late final TextEditingController _passwordController;

  String? companyId;
  String? departmentId;
  String? employeeId;

  bool canLogin = true;
  bool isActive = true;
  bool isLocked = false;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(text: widget.initialUsername);

    _passwordController = TextEditingController(text: widget.initialPassword);

    companyId = widget.initialCompanyId;

    departmentId = widget.initialDepartmentId;

    employeeId = widget.initialEmployeeId;

    canLogin = widget.initialCanLogin;

    isActive = widget.initialIsActive;

    isLocked = widget.initialIsLocked;

    Future.microtask(() async {
      await ref.read(companyProvider.notifier).loadCompanies();

      await ref.read(departmentProvider.notifier).loadDepartments();

      await ref.read(employeeProvider.notifier).loadEmployees();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyState = ref.watch(companyProvider);

    final departmentState = ref.watch(departmentProvider);

    final employeeState = ref.watch(employeeProvider);

    final companies = companyState.companies;

    final departments = departmentState.departments;

    final employees = employeeState.employees;
    final filteredDepartments = departments
        .where((e) => e.companyId == companyId)
        .toList();

    final filteredEmployees = employees
        .where(
          (e) => e.companyId == companyId && e.departmentId == departmentId,
        )
        .toList();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            //==========================================
            // Company
            //==========================================
            DropdownButtonFormField<String>(
              value: companyId,
              decoration: const InputDecoration(
                labelText: 'Company',
                border: OutlineInputBorder(),
              ),
              items: companies.map((company) {
                return DropdownMenuItem(
                  value: company.id,
                  child: Text(company.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  companyId = value;

                  departmentId = null;

                  employeeId = null;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Select company';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            //==========================================
            // Department
            //==========================================
            DropdownButtonFormField<String>(
              value: departmentId,
              decoration: const InputDecoration(
                labelText: 'Department',
                border: OutlineInputBorder(),
              ),
              items: filteredDepartments.map((department) {
                return DropdownMenuItem(
                  value: department.id,
                  child: Text(department.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  departmentId = value;

                  employeeId = null;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Select department';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            //==========================================
            // Employee
            //==========================================
            DropdownButtonFormField<String>(
              value: employeeId,
              decoration: const InputDecoration(
                labelText: 'Employee',
                border: OutlineInputBorder(),
              ),
              items: filteredEmployees.map((employee) {
                return DropdownMenuItem(
                  value: employee.id,
                  child: Text(employee.fullName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  employeeId = value;

                  final employee = filteredEmployees.firstWhere(
                    (e) => e.id == value,
                  );

                  if (_usernameController.text.trim().isEmpty) {
                    _usernameController.text = employee.employeeCode;
                  }
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Select employee';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            //==========================================
            // Username
            //==========================================
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Username is required';
                }

                if (value.trim().length < 4) {
                  return 'Minimum 4 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            //==========================================
            // Password
            //==========================================
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: canLogin,
                      title: const Text('Allow Login'),
                      subtitle: const Text('Employee can login to the system'),
                      secondary: const Icon(Icons.login),
                      onChanged: (value) {
                        setState(() {
                          canLogin = value;
                        });
                      },
                    ),

                    const Divider(),

                    SwitchListTile(
                      value: isActive,
                      title: const Text('Active Account'),
                      subtitle: const Text('Enable / Disable account'),
                      secondary: const Icon(Icons.verified_user),
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
                        });
                      },
                    ),

                    const Divider(),

                    SwitchListTile(
                      value: isLocked,
                      title: const Text('Lock Account'),
                      subtitle: const Text('Prevent employee login'),
                      secondary: const Icon(Icons.lock_outline),
                      onChanged: (value) {
                        setState(() {
                          isLocked = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: widget.isLoading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        if (companyId == null ||
                            departmentId == null ||
                            employeeId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please complete all required fields.',
                              ),
                            ),
                          );

                          return;
                        }

                        await widget.onSubmit(
                          companyId!,
                          departmentId!,
                          employeeId!,
                          _usernameController.text.trim(),
                          _passwordController.text.trim(),
                          canLogin,
                          isActive,
                          isLocked,
                        );
                      },

                icon: widget.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),

                label: Text(widget.isLoading ? 'Saving...' : 'Save Account'),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

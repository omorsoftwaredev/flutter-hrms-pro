/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor CRUD Page
///
/// Version : 6.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/supervisor_provider.dart';
import '../providers/supervisor_state.dart';
import '../widgets/supervisor_form.dart';
import '../widgets/supervisor_table.dart';

class SupervisorCrudPage extends ConsumerStatefulWidget {
  const SupervisorCrudPage({
    super.key,
  });

  @override
  ConsumerState<SupervisorCrudPage> createState() =>
      _SupervisorCrudPageState();
}

class _SupervisorCrudPageState
    extends ConsumerState<SupervisorCrudPage> {
  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final notifier =
      ref.read(supervisorProvider.notifier);

      await notifier.loadCompanies();
    });
  }

  // =============================================================
  // COMPANY CHANGED
  // =============================================================

  Future<void> _onCompanyChanged(
      String? companyId,
      ) async {
    if (companyId == null ||
        companyId.isEmpty) {
      return;
    }

    final notifier =
    ref.read(supervisorProvider.notifier);

    // ===========================================================
    // COMPANY SELECT
    // ===========================================================

    await notifier.selectCompany(
      companyId,
    );

    // ===========================================================
    // LOAD SUPERVISORS
    // ===========================================================

    await notifier.loadSupervisors(
      companyId,
    );
  }

  // =============================================================
  // OPEN CREATE FORM
  // =============================================================

  Future<void> _openCreateForm() async {
    final notifier =
    ref.read(supervisorProvider.notifier);

    // -----------------------------------------------------------
    // Company list নিশ্চিত করি
    // -----------------------------------------------------------

    final currentState =
    ref.read(supervisorProvider);

    if (currentState.companies.isEmpty) {
      await notifier.loadCompanies();
    }

    if (!mounted) {
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer(
          builder: (
              context,
              ref,
              child,
              ) {
            final state =
            ref.watch(supervisorProvider);

            return Dialog(
              insetPadding:
              const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints:
                const BoxConstraints(
                  maxWidth: 600,
                ),
                child: SingleChildScrollView(
                  padding:
                  const EdgeInsets.all(20),
                  child: SupervisorForm(
                    companies:
                    state.companies,

                    departments:
                    state.departments,

                    employees:
                    state.employees,

                    isSaving:
                    state.isSaving,

                    // =================================================
                    // COMPANY SELECT
                    // =================================================

                    onCompanyChanged:
                        (
                        String? companyId,
                        ) async {
                      if (companyId == null ||
                          companyId.isEmpty) {
                        return;
                      }

                      await notifier
                          .selectCompany(
                        companyId,
                      );
                    },

                    // =================================================
                    // DEPARTMENT SELECT
                    // =================================================

                    onDepartmentChanged:
                        (
                        String? departmentId,
                        ) async {
                      if (departmentId == null ||
                          departmentId.isEmpty) {
                        return;
                      }

                      final selectedCompany =
                          ref
                              .read(
                            supervisorProvider,
                          )
                              .selectedCompanyId;

                      if (selectedCompany == null ||
                          selectedCompany.isEmpty) {
                        return;
                      }

                      await notifier
                          .selectDepartment(
                        companyId:
                        selectedCompany,
                        departmentId:
                        departmentId,
                      );
                    },

                    // =================================================
                    // CREATE SUPERVISOR
                    // =================================================

                    onSubmit:
                        (
                        Map<String, dynamic> data,
                        ) async {
                      final success =
                      await notifier
                          .createSupervisor(
                        data,
                      );

                      if (!context.mounted) {
                        return;
                      }

                      if (success) {
                        Navigator.of(
                          context,
                        ).pop();

                        // =============================================
                        // REFRESH CURRENT COMPANY SUPERVISORS
                        // =============================================

                        final selectedCompany =
                            ref
                                .read(
                              supervisorProvider,
                            )
                                .selectedCompanyId;

                        if (selectedCompany != null &&
                            selectedCompany.isNotEmpty) {
                          await notifier
                              .loadSupervisors(
                            selectedCompany,
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =============================================================
  // REFRESH
  // =============================================================

  Future<void> _refresh() async {
    final state =
    ref.read(supervisorProvider);

    final companyId =
        state.selectedCompanyId;

    // ===========================================================
    // NO COMPANY SELECTED
    // ===========================================================

    if (companyId == null ||
        companyId.isEmpty) {
      await ref
          .read(
        supervisorProvider.notifier,
      )
          .loadCompanies();

      return;
    }

    // ===========================================================
    // REFRESH SUPERVISORS
    // ===========================================================

    await ref
        .read(
      supervisorProvider.notifier,
    )
        .loadSupervisors(
      companyId,
    );
  }

  // =============================================================
  // ERROR DIALOG
  // =============================================================
// =============================================================
// TOGGLE SUPERVISOR STATUS
// =============================================================

  Future<void> _toggleSupervisor(
      Map<String, dynamic> supervisor,
      ) async {
    final supervisorId =
    supervisor['id']?.toString();

    if (supervisorId == null ||
        supervisorId.isEmpty) {
      await _showErrorDialog(
        'Invalid supervisor ID.',
      );

      return;
    }

    final isActive =
        supervisor['is_active'] == true;

    final employee =
    supervisor['employees'];

    String employeeName = 'this supervisor';

    if (employee is Map) {
      final fullName =
      employee['full_name']
          ?.toString()
          .trim();

      if (fullName != null &&
          fullName.isNotEmpty) {
        employeeName = fullName;
      }
    }

    final action =
    isActive
        ? 'Deactivate'
        : 'Activate';

    // ===========================================================
    // CONFIRM
    // ===========================================================

    final confirmed =
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                isActive
                    ? Icons.toggle_off_outlined
                    : Icons.toggle_on_outlined,
                color: isActive
                    ? Colors.orange
                    : Colors.green,
              ),
              const SizedBox(width: 10),
              Text(
                '$action Supervisor?',
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to '
                '${action.toLowerCase()} '
                '$employeeName?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                isActive
                    ? Colors.orange
                    : Colors.green,
              ),
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              child: Text(
                action,
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    // ===========================================================
    // UPDATE
    // ===========================================================

    final notifier =
    ref.read(
      supervisorProvider.notifier,
    );

    final success =
    await notifier.updateSupervisor({
      'id': supervisor['id'],
      'company_id':
      supervisor['company_id'],
      'department_id':
      supervisor['department_id'],
      'employee_id':
      supervisor['employee_id'],
      'is_active': !isActive,
    });

    if (!mounted) {
      return;
    }

    // ===========================================================
    // ERROR
    // ===========================================================

    if (!success) {
      final error =
          ref.read(
            supervisorProvider,
          ).errorMessage;

      if (error != null &&
          error.trim().isNotEmpty) {
        await _showErrorDialog(
          error,
        );
      }
    }

    // ===========================================================
    // SUCCESS
    // ===========================================================

    // আপনার ref.listen already success dialog দেখাবে।
  }
  // =============================================================
// DELETE SUPERVISOR
// =============================================================

  Future<void> _deleteSupervisor(
      Map<String, dynamic> supervisor,
      ) async {
    final supervisorId =
    supervisor['id']?.toString();

    if (supervisorId == null ||
        supervisorId.isEmpty) {
      await _showErrorDialog(
        'Invalid supervisor ID.',
      );

      return;
    }

    final employee =
    supervisor['employees'];

    String employeeName =
        'this supervisor';

    if (employee is Map) {
      final fullName =
      employee['full_name']
          ?.toString()
          .trim();

      if (fullName != null &&
          fullName.isNotEmpty) {
        employeeName = fullName;
      }
    }

    // ===========================================================
    // CONFIRM DELETE
    // ===========================================================

    final confirmed =
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'Delete Supervisor?',
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete '
                '$employeeName as a supervisor?\n\n'
                'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                Colors.red,
              ),
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    // ===========================================================
    // DELETE
    // ===========================================================

    final notifier =
    ref.read(
      supervisorProvider.notifier,
    );

    final success =
    await notifier.deleteSupervisor(
      supervisorId,
    );

    if (!mounted) {
      return;
    }

    // ===========================================================
    // ERROR
    // ===========================================================

    if (!success) {
      final error =
          ref.read(
            supervisorProvider,
          ).errorMessage;

      if (error != null &&
          error.trim().isNotEmpty) {
        await _showErrorDialog(
          error,
        );
      }
    }

    // Success হলে আপনার ref.listen
    // automatically success dialog দেখাবে।
  }
  Future<void> _showErrorDialog(
      String message,
      ) async {
    if (!mounted) {
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 28,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Already Exists',
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child: const Text(
                'OK',
              ),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // SUCCESS DIALOG
  // =============================================================

  Future<void> _showSuccessDialog(
      String message,
      ) async {
    if (!mounted) {
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Success',
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child: const Text(
                'OK',
              ),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    // ===========================================================
    // LISTENER
    // ===========================================================

    ref.listen<SupervisorState>(
      supervisorProvider,
          (
          previous,
          next,
          ) {
        // -------------------------------------------------------
        // ERROR
        // -------------------------------------------------------

        final error =
            next.errorMessage;

        if (error != null &&
            error.trim().isNotEmpty &&
            error !=
                previous?.errorMessage) {
          WidgetsBinding.instance
              .addPostFrameCallback(
                (_) async {
              if (!mounted) {
                return;
              }

              await _showErrorDialog(
                error,
              );

              if (!mounted) {
                return;
              }

              ref
                  .read(
                supervisorProvider
                    .notifier,
              )
                  .clearError();
            },
          );
        }

        // -------------------------------------------------------
        // SUCCESS
        // -------------------------------------------------------

        final success =
            next.successMessage;

        if (success != null &&
            success.trim().isNotEmpty &&
            success !=
                previous?.successMessage) {
          WidgetsBinding.instance
              .addPostFrameCallback(
                (_) async {
              if (!mounted) {
                return;
              }

              await _showSuccessDialog(
                success,
              );

              if (!mounted) {
                return;
              }

              ref
                  .read(
                supervisorProvider
                    .notifier,
              )
                  .clearSuccess();
            },
          );
        }
      },
    );

    // ===========================================================
    // STATE
    // ===========================================================

    final state =
    ref.watch(
      supervisorProvider,
    );

    // ===========================================================
    // SCAFFOLD
    // ===========================================================

    return Scaffold(
      backgroundColor:
      const Color(0xFFF8F9FC),

      // =========================================================
      // ADD SUPERVISOR
      // =========================================================

      floatingActionButton:
      FloatingActionButton.extended(
        onPressed:
        state.isSaving
            ? null
            : _openCreateForm,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add Supervisor',
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.all(16),
          child: Column(
            children: [
              // =================================================
              // HEADER
              // =================================================
              // =================================================
              // COMPANY FILTER
              // =================================================

              _buildCompanyDropdown(
                state,
              ),

              const SizedBox(
                height: 16,
              ),

              // =================================================
              // CONTENT
              // =================================================

              Expanded(
                child:
                _buildContent(
                  state,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // COMPANY DROPDOWN
  // =============================================================

  Widget _buildCompanyDropdown(
      SupervisorState state,
      ) {
    return Card(
      elevation: 0,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(
          12,
        ),
        side:
        const BorderSide(
          color: Colors.black12,
        ),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(14),
        child:
        DropdownButtonFormField<String>(
          value:
          state.selectedCompanyId,
          decoration:
          const InputDecoration(
            labelText:
            'Company',
            hintText:
            'Select company',
            prefixIcon:
            Icon(
              Icons.business_outlined,
            ),
            border:
            OutlineInputBorder(),
          ),
          items:
          state.companies.map(
                (
                company,
                ) {
              final id =
              company['id']
                  ?.toString();

              final name =
                  company['name']
                      ?.toString() ??
                      '-';

              if (id == null ||
                  id.isEmpty) {
                return null;
              }

              return DropdownMenuItem<
                  String>(
                value: id,
                child:
                Text(name),
              );
            },
          ).whereType<
              DropdownMenuItem<
                  String>>().toList(),
          onChanged:
          state.isLoading
              ? null
              : _onCompanyChanged,
        ),
      ),
    );
  }

  // =============================================================
  // CONTENT
  // =============================================================

  Widget _buildContent(
      SupervisorState state,
      ) {
    // ===========================================================
    // NO COMPANY SELECTED
    // ===========================================================

    if (state.selectedCompanyId ==
        null ||
        state.selectedCompanyId!
            .isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons.business_outlined,
              size: 65,
              color: Colors.black38,
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              'Select a company',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              'Select a company to view its supervisors.',
              style: TextStyle(
                color:
                Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    // ===========================================================
    // LOADING
    // ===========================================================

    if (state.isLoading) {
      return const Center(
        child:
        CircularProgressIndicator(),
      );
    }

    // ===========================================================
    // ERROR
    // ===========================================================

    if (state.hasError) {
      return Center(
        child: Padding(
          padding:
          const EdgeInsets.all(24),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.red,
              ),

              const SizedBox(
                height: 12,
              ),

              Text(
                state.errorMessage ??
                    'Something went wrong.',
                textAlign:
                TextAlign.center,
              ),

              const SizedBox(
                height: 16,
              ),

              ElevatedButton.icon(
                onPressed:
                _refresh,
                icon:
                const Icon(
                  Icons.refresh,
                ),
                label:
                const Text(
                  'Retry',
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ===========================================================
    // SUPERVISOR TABLE
    // ===========================================================

    return SupervisorTable(
      supervisors: state.supervisors,

      onToggleStatus:
      _toggleSupervisor,

      onDelete:
      _deleteSupervisor,
    );
  }
}
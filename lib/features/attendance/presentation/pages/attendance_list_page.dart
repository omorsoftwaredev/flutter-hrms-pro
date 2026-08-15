/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Department Assignment Page
///
/// Version : 2.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../supervisor/presentation/providers/supervisor_provider.dart';
import '../../../supervisor/presentation/widgets/supervisor_assignment_table.dart';

class SupervisorAssignmentPage extends ConsumerStatefulWidget {
  const SupervisorAssignmentPage({
    super.key,
  });

  @override
  ConsumerState<SupervisorAssignmentPage> createState() =>
      _SupervisorAssignmentPageState();
}

class _SupervisorAssignmentPageState
    extends ConsumerState<SupervisorAssignmentPage> {

  String? _selectedSupervisor;
  String? _selectedDepartment;

  @override
  Widget build(BuildContext context) {
    final supervisorState = ref.watch(
      supervisorProvider,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ===================================================
          // HEADER
          // ===================================================

          const Text(
            'Department Assignment',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          const Text(
            'Assign or unassign departments to supervisors.',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // ===================================================
          // ASSIGNMENT ACTION CARD
          // ===================================================

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(
                color: Colors.black12,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  const Row(
                    children: [
                      Icon(
                        Icons.link_outlined,
                        color: Color(0xFF673AB7),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Assign Department',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  // ------------------------------------------------
                  // SUPERVISOR
                  // ------------------------------------------------

                  DropdownButtonFormField<String>(
                    value: _selectedSupervisor,
                    decoration:
                    const InputDecoration(
                      labelText: 'Supervisor',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.supervisor_account_outlined,
                      ),
                    ),

                    items: const [],

                    onChanged: (value) {
                      setState(() {
                        _selectedSupervisor = value;
                      });
                    },

                    hint: const Text(
                      'Select supervisor',
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  // ------------------------------------------------
                  // DEPARTMENT
                  // ------------------------------------------------

                  DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    decoration:
                    const InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.apartment_outlined,
                      ),
                    ),

                    items: const [],

                    onChanged: (value) {
                      setState(() {
                        _selectedDepartment = value;
                      });
                    },

                    hint: const Text(
                      'Select department',
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ------------------------------------------------
                  // ASSIGN BUTTON
                  // ------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                      _selectedSupervisor == null ||
                          _selectedDepartment == null
                          ? null
                          : () {
                        // Assignment action
                        //
                        // এখানে তোমার existing
                        // SupervisorNotifier method
                        // call করবে।
                      },
                      icon: const Icon(
                        Icons.link,
                      ),
                      label: const Text(
                        'Assign Department',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // ===================================================
          // ASSIGNMENT TABLE
          // ===================================================

          const SupervisorAssignmentTable(
            assignments: [],
          ),
        ],
      ),
    );
  }
}
/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Department Assignment Page
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/supervisor_assignment_table.dart';

class SupervisorAssignmentPage extends ConsumerStatefulWidget {
  const SupervisorAssignmentPage({super.key});

  @override
  ConsumerState<SupervisorAssignmentPage> createState() =>
      _SupervisorAssignmentPageState();
}

class _SupervisorAssignmentPageState
    extends ConsumerState<SupervisorAssignmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            final horizontalPadding = isMobile ? 14.0 : 24.0;

            final maxContentWidth = constraints.maxWidth > 1200
                ? 1180.0
                : double.infinity;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: isMobile ? 16 : 24,
                  ),
                  children: [
                    // =================================================
                    // HEADER
                    // =================================================
                    Text(
                      'Department Assignment',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Assign or unassign departments to supervisors.',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                    ),

                    SizedBox(height: isMobile ? 18 : 24),

                    // =================================================
                    // ASSIGNMENT ACTION CARD
                    // =================================================
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),

                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 14 : 20),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            // =========================================
                            // CARD HEADER
                            // =========================================
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,

                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF673AB7,
                                    ).withValues(alpha: .08),
                                    borderRadius: BorderRadius.circular(11),
                                  ),

                                  child: const Icon(
                                    Icons.link_outlined,
                                    color: Color(0xFF673AB7),
                                    size: 21,
                                  ),
                                ),

                                const SizedBox(width: 11),

                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Assign Department',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),

                                      SizedBox(height: 2),

                                      Text(
                                        'Connect a department with a supervisor.',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // =========================================
                            // FORM
                            // =========================================
                            if (isMobile) ...[
                              // ---------------------------------------
                              // MOBILE
                              // ---------------------------------------
                              DropdownButtonFormField<String>(
                                decoration: _inputDecoration(
                                  label: 'Supervisor',
                                  icon: Icons.supervisor_account_outlined,
                                ),

                                items: const [],

                                onChanged: null,

                                hint: const Text('Select supervisor'),
                              ),

                              const SizedBox(height: 14),

                              DropdownButtonFormField<String>(
                                decoration: _inputDecoration(
                                  label: 'Department',
                                  icon: Icons.apartment_outlined,
                                ),

                                items: const [],

                                onChanged: null,

                                hint: const Text('Select department'),
                              ),
                            ] else ...[
                              // ---------------------------------------
                              // TABLET / DESKTOP
                              // ---------------------------------------
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      decoration: _inputDecoration(
                                        label: 'Supervisor',
                                        icon: Icons.supervisor_account_outlined,
                                      ),

                                      items: const [],

                                      onChanged: null,

                                      hint: const Text('Select supervisor'),
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      decoration: _inputDecoration(
                                        label: 'Department',
                                        icon: Icons.apartment_outlined,
                                      ),

                                      items: const [],

                                      onChanged: null,

                                      hint: const Text('Select department'),
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            const SizedBox(height: 16),

                            // =========================================
                            // ASSIGN BUTTON
                            // =========================================
                            SizedBox(
                              width: double.infinity,

                              height: 48,

                              child: ElevatedButton.icon(
                                onPressed: null,

                                icon: const Icon(Icons.link_outlined, size: 19),

                                label: const Text(
                                  'Assign Department',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                style: ElevatedButton.styleFrom(
                                  elevation: 0,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: isMobile ? 18 : 22),

                    // =================================================
                    // ASSIGNMENT TABLE
                    // =================================================
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),

                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 10 : 16),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),

                          child: const SupervisorAssignmentTable(
                            assignments: [],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===============================================================
  // INPUT DECORATION
  // ===============================================================

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,

      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),

      labelStyle: const TextStyle(fontSize: 13),

      prefixIcon: Icon(icon, size: 20, color: Color(0xFF6B7280)),

      filled: true,

      fillColor: const Color(0xFFFAFBFD),

      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFF673AB7), width: 1.4),
      ),

      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
    );
  }
}

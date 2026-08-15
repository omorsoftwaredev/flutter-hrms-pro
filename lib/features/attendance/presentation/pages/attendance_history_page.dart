/// ===============================================================
/// Flutter HRMS Pro
/// Attendance History Page
///
/// Version : 2.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/attendance_provider.dart';
import '../widgets/attendance_card.dart';
import '../widgets/attendance_empty_widget.dart';
import '../widgets/attendance_search_bar.dart';

class AttendanceHistoryPage extends ConsumerStatefulWidget {
  const AttendanceHistoryPage({
    super.key,
  });

  @override
  ConsumerState<AttendanceHistoryPage> createState() =>
      _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState
    extends ConsumerState<AttendanceHistoryPage> {
  // =============================================================
  // SEARCH CONTROLLER
  // =============================================================

  final TextEditingController _searchController =
  TextEditingController();

  // =============================================================
  // INITIALIZE
  // =============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(attendanceProvider.notifier)
          .loadAttendance();
    });
  }

  // =============================================================
  // REFRESH
  // =============================================================

  Future<void> _refresh() async {
    await ref
        .read(attendanceProvider.notifier)
        .refresh();
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final attendanceState =
    ref.watch(attendanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance History',
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [

          // =====================================================
          // SEARCH
          // =====================================================

          Padding(
            padding: const EdgeInsets.all(12),
            child: AttendanceSearchBar(
              controller: _searchController,
              onChanged: (value) {
                ref
                    .read(
                  attendanceProvider.notifier,
                )
                    .search(value);
              },
            ),
          ),

          // =====================================================
          // ATTENDANCE LIST
          // =====================================================

          Expanded(
            child: attendanceState.when(
              // -------------------------------------------------
              // LOADING
              // -------------------------------------------------

              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },

              // -------------------------------------------------
              // ERROR
              // -------------------------------------------------

              error: (error, stackTrace) {
                return Center(
                  child: Padding(
                    padding:
                    const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [

                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.redAccent,
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        Text(
                          error.toString(),
                          textAlign:
                          TextAlign.center,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        ElevatedButton.icon(
                          onPressed: _refresh,
                          icon: const Icon(
                            Icons.refresh,
                          ),
                          label: const Text(
                            'Retry',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },

              // -------------------------------------------------
              // DATA
              // -------------------------------------------------

              data: (attendanceList) {

                // ------------------------------------------------
                // EMPTY
                // ------------------------------------------------

                if (attendanceList.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(
                          height: 220,
                        ),
                        AttendanceEmptyWidget(),
                      ],
                    ),
                  );
                }

                // ------------------------------------------------
                // LIST
                // ------------------------------------------------

                return RefreshIndicator(
                  onRefresh: _refresh,

                  child: ListView.builder(
                    physics:
                    const AlwaysScrollableScrollPhysics(),

                    padding:
                    const EdgeInsets.all(12),

                    itemCount:
                    attendanceList.length,

                    itemBuilder:
                        (context, index) {

                      final attendance =
                      attendanceList[index];

                      return AttendanceCard(
                        attendance:
                        attendance,

                        // ------------------------------------------------
                        // DETAILS
                        // ------------------------------------------------

                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/attendance/details',
                            arguments:
                            attendance,
                          );
                        },

                        // ------------------------------------------------
                        // EDIT
                        // ------------------------------------------------

                        onEdit: () async {
                          final result =
                          await Navigator.pushNamed(
                            context,
                            '/attendance/edit',
                            arguments:
                            attendance,
                          );

                          if (result == true) {
                            await _refresh();
                          }
                        },

                        // ------------------------------------------------
                        // DELETE
                        // ------------------------------------------------

                        onDelete: () async {
                          final id =
                              attendance.id;

                          if (id == null ||
                              id.trim().isEmpty) {
                            return;
                          }

                          final success =
                          await ref
                              .read(
                            attendanceProvider
                                .notifier,
                          )
                              .delete(id);

                          if (!mounted) {
                            return;
                          }

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Attendance deleted successfully.'
                                    : 'Failed to delete attendance.',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
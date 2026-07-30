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
  final TextEditingController _searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(attendanceProvider.notifier)
          .loadAttendance();
    });
  }

  Future<void> _refresh() async {
    await ref
        .read(attendanceProvider.notifier)
        .loadAttendance();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceState =
    ref.watch(attendanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance History",
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [

          /// Search
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

          Expanded(
            child: attendanceState.when(
              loading: () => const Center(
                child:
                CircularProgressIndicator(),
              ),

              error: (e, st) => Center(
                child: Text(
                  e.toString(),
                ),
              ),

              data: (attendanceList) {
                if (attendanceList.isEmpty) {
                  return const AttendanceEmptyWidget();
                }

                return RefreshIndicator(
                  onRefresh: _refresh,

                  child: ListView.builder(
                    padding:
                    const EdgeInsets.all(12),

                    itemCount:
                    attendanceList.length,

                    itemBuilder:
                        (context, index) {
                      final attendance =
                      attendanceList[index];

                      return AttendanceCard(
                        attendance: attendance,

                        onTap: () {
                          // Next Step
                          // Attendance Detail Page
                        },

                        onEdit: () {
                          // Edit Attendance
                        },

                        onDelete: () {
                          // Delete Attendance
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_loading.dart';

import '../../domain/entities/attendance_entity.dart';
import '../providers/attendance_provider.dart';

import '../widgets/attendance_card.dart';
import '../widgets/attendance_delete_dialog.dart';
import '../widgets/attendance_empty_widget.dart';
import '../widgets/attendance_filter_dialog.dart';
import '../widgets/attendance_search_bar.dart';

class AttendanceListPage extends ConsumerStatefulWidget {
  const AttendanceListPage({super.key});

  @override
  ConsumerState<AttendanceListPage> createState() =>
      _AttendanceListPageState();
}

class _AttendanceListPageState
    extends ConsumerState<AttendanceListPage> {

final TextEditingController _searchController =
TextEditingController();

String _search = '';

String? _status;

@override
void initState() {
super.initState();

Future.microtask(() {
ref
.read(attendanceProvider.notifier)
.loadAttendance();
});
}

@override
void dispose() {
_searchController.dispose();
super.dispose();
}

Future<void> _refresh() async {
await ref
.read(attendanceProvider.notifier)
.refresh();
}

@override
Widget build(BuildContext context) {

final state =
ref.watch(attendanceProvider);

return Scaffold(

appBar: AppBar(
title: const Text('Attendance'),

actions: [

IconButton(
icon: const Icon(
Icons.filter_alt,
),
onPressed: () async {

final result =
await showDialog<String>(
context: context,
builder: (_) =>
AttendanceFilterDialog(
selectedStatus: _status,
),
);

if (result != null) {
setState(() {
_status = result;
});
}
},
),

],
),

floatingActionButton:
FloatingActionButton(
child: const Icon(Icons.add),
onPressed: () {
Navigator.pushNamed(
context,
'/attendance/add',
);
},
),

body: Column(

children: [

Padding(
padding:
const EdgeInsets.all(16),
child: AttendanceSearchBar(
controller:
_searchController,
onChanged: (value) {
setState(() {
_search = value;
});
},
),
),

Expanded(

child: state.when(

loading: () =>
const AppLoading(),

error: (error, stack) {

return Center(
child: Text(
error.toString(),
),
);

},

data: (attendance) {

List<AttendanceEntity> items =
List.from(attendance);

if (_search.isNotEmpty) {

items = items.where((e) {

return e.attendanceNo
.toLowerCase()
.contains(
_search.toLowerCase(),
) ||

(e.shiftName ?? '')
.toLowerCase()
.contains(
_search.toLowerCase(),
);

}).toList();

}

if (_status != null) {

items = items.where((e) {

return e.attendanceStatus ==
_status;

}).toList();

}

if (items.isEmpty) {

return const AttendanceEmptyWidget();

}

return RefreshIndicator(

onRefresh: _refresh,

child: ListView.builder(

padding:
const EdgeInsets.all(16),

itemCount: items.length,

itemBuilder:
(context, index) {

final item =
items[index];
return AttendanceCard(
  attendance: item,

  onTap: () {
    Navigator.pushNamed(
      context,
      '/attendance/details',
      arguments: item,
    );
  },

  onEdit: () async {
    final result =
    await Navigator.pushNamed(
      context,
      '/attendance/edit',
      arguments: item,
    );

    if (result == true) {
      await _refresh();
    }
  },

  onDelete: () async {
    final ok =
    await showAttendanceDeleteDialog(
      context,
    );

    if (ok == true) {
      final success = await ref
          .read(
        attendanceProvider.notifier,
      )
          .delete(item.id!);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Attendance deleted successfully.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to delete attendance.',
            ),
          ),
        );
      }
    }
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
}
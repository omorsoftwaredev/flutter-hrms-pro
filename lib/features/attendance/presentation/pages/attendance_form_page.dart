import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/attendance_entity.dart';
import '../providers/attendance_provider.dart';

import '../../../company/domain/entities/company_entity.dart';
import '../../../department/domain/entities/department_entity.dart';
import '../../../designation/domain/entities/designation_entity.dart';
import '../../../employee/domain/entities/employee_entity.dart';
import '../../../shift/domain/entities/shift_entity.dart';

import '../../../employee/presentation/providers/employee_provider.dart';
import '../../../shift/presentation/providers/shift_provider.dart';

import '../widgets/attendance_employee_dropdown.dart';
import '../widgets/attendance_shift_dropdown.dart';
import '../widgets/attendance_status_dropdown.dart';

class AttendanceFormPage extends ConsumerStatefulWidget {
  final AttendanceEntity? attendance;

  const AttendanceFormPage({
    super.key,
    this.attendance,
  });

  @override
  ConsumerState<AttendanceFormPage> createState() =>
      _AttendanceFormPageState();
}

class _AttendanceFormPageState
    extends ConsumerState<AttendanceFormPage> {

final _formKey = GlobalKey<FormState>();

final TextEditingController _attendanceNoController =
TextEditingController();

final TextEditingController _remarksController =
TextEditingController();

CompanyEntity? selectedCompany;

DepartmentEntity? selectedDepartment;

DesignationEntity? selectedDesignation;

EmployeeEntity? selectedEmployee;

ShiftEntity? selectedShift;

List<EmployeeEntity> employees = [];

List<ShiftEntity> shifts = [];

DateTime? attendanceDate;

DateTime? checkInTime;

DateTime? checkOutTime;

String attendanceStatus = 'PRESENT';

bool isSaving = false;

@override
void initState() {
super.initState();

_loadData();

final item = widget.attendance;

if (item != null) {
_attendanceNoController.text =
item.attendanceNo;

_remarksController.text =
item.remarks ?? '';

attendanceDate =
item.attendanceDate;

checkInTime =
item.checkInTime;

checkOutTime =
item.checkOutTime;

attendanceStatus =
item.attendanceStatus;
}
}

@override
void dispose() {
_attendanceNoController.dispose();
_remarksController.dispose();
super.dispose();
}

Future<void> _loadData() async {
  final employeeNotifier =
  ref.read(employeeProvider.notifier);

  final shiftNotifier =
  ref.read(shiftProvider.notifier);

  await employeeNotifier.loadEmployees();

  await shiftNotifier.loadShifts();

  if (!mounted) return;

  setState(() {
    employees = ref
        .read(employeeProvider)
        .employees;

    shifts = ref
        .read(shiftProvider)
        .shifts;
  });

  if (widget.attendance != null) {
    final item = widget.attendance!;

    if (item.employeeId != null) {
      try {
        selectedEmployee = employees.firstWhere(
              (e) => e.id == item.employeeId,
        );
      } catch (_) {}
    }

    if (item.shiftId != null) {
      try {
        selectedShift = shifts.firstWhere(
              (e) => e.id == item.shiftId,
        );
      } catch (_) {}
    }
  }
}
Future<void> _pickAttendanceDate() async {
final picked = await showDatePicker(
context: context,
initialDate: attendanceDate ?? DateTime.now(),
firstDate: DateTime(2024),
lastDate: DateTime(2100),
);

if (picked != null) {
setState(() {
attendanceDate = picked;
});
}
}

Future<void> _pickCheckInTime() async {
final picked = await showTimePicker(
context: context,
initialTime: checkInTime == null
? TimeOfDay.now()
: TimeOfDay.fromDateTime(checkInTime!),
);

if (picked == null) return;

final date = attendanceDate ?? DateTime.now();

setState(() {
checkInTime = DateTime(
date.year,
date.month,
date.day,
picked.hour,
picked.minute,
);
});
}

Future<void> _pickCheckOutTime() async {
final picked = await showTimePicker(
context: context,
initialTime: checkOutTime == null
? TimeOfDay.now()
: TimeOfDay.fromDateTime(checkOutTime!),
);

if (picked == null) return;

final date = attendanceDate ?? DateTime.now();

setState(() {
checkOutTime = DateTime(
date.year,
date.month,
date.day,
picked.hour,
picked.minute,
);
});
}
Future<void> _save() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (attendanceDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please select attendance date.',
        ),
      ),
    );
    return;
  }

  if (selectedEmployee == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please select an employee.',
        ),
      ),
    );
    return;
  }

  setState(() {
    isSaving = true;
  });

  try {
    final entity = AttendanceEntity(
      id: widget.attendance?.id,
      companyId: selectedEmployee?.companyId,
      departmentId: selectedEmployee?.departmentId,
      designationId: selectedEmployee?.designationId,
      employeeId: selectedEmployee?.id,
      shiftId: selectedShift?.id,
      attendanceNo: _attendanceNoController.text.trim(),
      attendanceDate: attendanceDate!,
      shiftName: selectedShift?.name,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      attendanceStatus: attendanceStatus,
      remarks: _remarksController.text.trim(),
    );

    final notifier =
    ref.read(attendanceProvider.notifier);

    bool success;

    if (widget.attendance == null) {
      success = await notifier.insert(entity);
    } else {
      success = await notifier.update(entity);
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.attendance == null
                ? 'Failed to save attendance.'
                : 'Failed to update attendance.',
          ),
        ),
      );
    }
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        isSaving = false;
      });
    }
  }
}
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(
widget.attendance == null
? 'Add Attendance'
: 'Edit Attendance',
),
),
body: Form(
key: _formKey,
child: ListView(
padding: const EdgeInsets.all(16),
children: [

AttendanceEmployeeDropdown(
employees: employees,
value: selectedEmployee,
onChanged: (value) {
setState(() {
selectedEmployee = value;
});
},
),

const SizedBox(height: 16),

AttendanceShiftDropdown(
shifts: shifts,
value: selectedShift,
onChanged: (value) {
setState(() {
selectedShift = value;
});
},
),

const SizedBox(height: 16),

TextFormField(
controller: _attendanceNoController,
decoration: const InputDecoration(
labelText: 'Attendance No',
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.confirmation_number),
),
validator: (value) {
if (value == null ||
value.trim().isEmpty) {
return 'Attendance No is required';
}
return null;
},
),

const SizedBox(height: 16),

ListTile(
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(8),
side: const BorderSide(
color: Colors.grey,
),
),
leading: const Icon(
Icons.calendar_today,
),
title: Text(
attendanceDate == null
? 'Attendance Date'
: attendanceDate!
.toString()
.split(' ')
.first,
),
trailing: const Icon(
Icons.arrow_drop_down,
),
onTap: _pickAttendanceDate,
),

const SizedBox(height: 16),

ListTile(
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(8),
side: const BorderSide(
color: Colors.grey,
),
),
leading: const Icon(Icons.login),
title: Text(
checkInTime == null
? 'Check In Time'
: TimeOfDay.fromDateTime(
checkInTime!)
.format(context),
),
trailing: const Icon(
Icons.access_time,
),
onTap: _pickCheckInTime,
),

const SizedBox(height: 16),
ListTile(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
side: const BorderSide(
color: Colors.grey,
),
),
leading: const Icon(Icons.logout),
title: Text(
checkOutTime == null
? 'Check Out Time'
: TimeOfDay.fromDateTime(
checkOutTime!,
).format(context),
),
trailing: const Icon(
Icons.access_time,
),
onTap: _pickCheckOutTime,
),

const SizedBox(height: 16),

AttendanceStatusDropdown(
value: attendanceStatus,
onChanged: (value) {
setState(() {
attendanceStatus = value!;
});
},
),

const SizedBox(height: 16),

TextFormField(
controller: _remarksController,
maxLines: 4,
decoration: const InputDecoration(
labelText: 'Remarks',
hintText: 'Enter remarks (optional)',
border: OutlineInputBorder(),
alignLabelWithHint: true,
prefixIcon: Icon(Icons.notes),
),
),

const SizedBox(height: 24),

SizedBox(
width: double.infinity,
height: 50,
child: FilledButton.icon(
onPressed: isSaving ? null : _save,
icon: isSaving
? const SizedBox(
width: 18,
height: 18,
child: CircularProgressIndicator(
strokeWidth: 2,
color: Colors.white,
),
)
: Icon(
widget.attendance == null
? Icons.save
: Icons.edit,
),
label: Text(
isSaving
? 'Saving...'
: widget.attendance == null
? 'Save Attendance'
: 'Update Attendance',
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
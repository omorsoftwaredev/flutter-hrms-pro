import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../company/presentation/providers/company_provider.dart';


class ShiftForm extends ConsumerStatefulWidget {
  const ShiftForm({
    super.key,
    this.initialCompanyId = '',
    this.initialCode = '',
    this.initialName = '',
    this.initialDescription = '',
    this.initialStartTime = '09:00:00',
    this.initialEndTime = '18:00:00',
    this.initialBreakMinutes = 60,
    this.initialGraceInMinutes = 15,
    this.initialGraceOutMinutes = 15,
    this.initialLateAfterMinutes = 15,
    this.initialHalfDayAfterMinutes = 240,
    this.initialWeeklyOffDay,
    this.initialNightShift = false,
    this.initialFlexible = false,
    this.initialActive = true,
    this.isLoading = false,
    required this.onSubmit,
  });

  final String initialCompanyId;
  final String initialCode;
  final String initialName;
  final String initialDescription;

  final String initialStartTime;
  final String initialEndTime;

  final int initialBreakMinutes;
  final int initialGraceInMinutes;
  final int initialGraceOutMinutes;
  final int initialLateAfterMinutes;
  final int initialHalfDayAfterMinutes;

  final int? initialWeeklyOffDay;

  final bool initialNightShift;
  final bool initialFlexible;
  final bool initialActive;

  final bool isLoading;

  final Future<void> Function(
      String companyId,
      String code,
      String name,
      String description,
      String startTime,
      String endTime,
      int breakMinutes,
      int graceIn,
      int graceOut,
      int lateAfter,
      int halfDayAfter,
      int? weeklyOff,
      bool nightShift,
      bool flexible,
      bool active,
      ) onSubmit;

  @override
  ConsumerState<ShiftForm> createState() =>
      _ShiftFormState();
}

class _ShiftFormState
    extends ConsumerState<ShiftForm> {
final _formKey = GlobalKey<FormState>();

String? _companyId;

late TextEditingController _codeController;
late TextEditingController _nameController;
late TextEditingController _descriptionController;

late TextEditingController _breakController;
late TextEditingController _graceInController;
late TextEditingController _graceOutController;
late TextEditingController _lateController;
late TextEditingController _halfDayController;

late TimeOfDay _startTime;
late TimeOfDay _endTime;

int? _weeklyOff;

bool _nightShift = false;
bool _flexible = false;
bool _active = true;

@override
void initState() {
super.initState();

_companyId = widget.initialCompanyId.isEmpty
? null
: widget.initialCompanyId;

_codeController = TextEditingController(
text: widget.initialCode,
);

_nameController = TextEditingController(
text: widget.initialName,
);

_descriptionController =
TextEditingController(
text: widget.initialDescription,
);

_breakController =
TextEditingController(
text: widget.initialBreakMinutes
.toString(),
);

_graceInController =
TextEditingController(
text: widget.initialGraceInMinutes
.toString(),
);

_graceOutController =
TextEditingController(
text: widget.initialGraceOutMinutes
.toString(),
);

_lateController =
TextEditingController(
text: widget.initialLateAfterMinutes
.toString(),
);

_halfDayController =
TextEditingController(
text: widget
.initialHalfDayAfterMinutes
.toString(),
);

_startTime = _parseTime(
widget.initialStartTime,
);

_endTime = _parseTime(
widget.initialEndTime,
);

_weeklyOff =
widget.initialWeeklyOffDay;

_nightShift =
widget.initialNightShift;

_flexible =
widget.initialFlexible;

_active =
widget.initialActive;

Future.microtask(() {
ref
.read(companyProvider.notifier)
.loadCompanies();
});
}

TimeOfDay _parseTime(
String value) {
final parts = value.split(':');

return TimeOfDay(
hour: int.parse(parts[0]),
minute: int.parse(parts[1]),
);
}

String _format(TimeOfDay time) {
final h = time.hour
.toString()
.padLeft(2, '0');

final m = time.minute
.toString()
.padLeft(2, '0');

return '$h:$m:00';
}

Future<void> _pickStart() async {
final result =
await showTimePicker(
context: context,
initialTime: _startTime,
);

if (result != null) {
setState(() {
_startTime = result;
});
}
}

Future<void> _pickEnd() async {
final result =
await showTimePicker(
context: context,
initialTime: _endTime,
);

if (result != null) {
setState(() {
_endTime = result;
});
}
}
Future<void> _save() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  await widget.onSubmit(
    _companyId!,
    _codeController.text.trim(),
    _nameController.text.trim(),
    _descriptionController.text.trim(),
    _format(_startTime),
    _format(_endTime),
    int.parse(_breakController.text),
    int.parse(_graceInController.text),
    int.parse(_graceOutController.text),
    int.parse(_lateController.text),
    int.parse(_halfDayController.text),
    _weeklyOff,
    _nightShift,
    _flexible,
    _active,
  );
}

@override
Widget build(BuildContext context) {
  final state = ref.watch(companyProvider);

  if (state.isLoading) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  final companies = state.companies;

  return Form(
    key: _formKey,
    child: ListView(
      shrinkWrap: true,
      children: [

        DropdownButtonFormField<String>(
          value: _companyId,
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
          validator: (value) {
            if (value == null) {
              return 'Select company';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _companyId = value;
            });
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _codeController,
          decoration: const InputDecoration(
            labelText: 'Code',
            border: OutlineInputBorder(),
          ),
          validator: (v) =>
          v == null || v.isEmpty
              ? 'Required'
              : null,
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Shift Name',
            border: OutlineInputBorder(),
          ),
          validator: (v) =>
          v == null || v.isEmpty
              ? 'Required'
              : null,
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),

        const SizedBox(height: 20),

        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(8),
            side: const BorderSide(),
          ),
          title: const Text(
            'Start Time',
          ),
          subtitle: Text(
            _startTime.format(context),
          ),
          trailing: const Icon(
            Icons.access_time,
          ),
          onTap: _pickStart,
        ),

        const SizedBox(height: 12),

        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(8),
            side: const BorderSide(),
          ),
          title: const Text(
            'End Time',
          ),
          subtitle: Text(
            _endTime.format(context),
          ),
          trailing: const Icon(
            Icons.access_time,
          ),
          onTap: _pickEnd,
        ),

        const SizedBox(height: 20),

        TextFormField(
          controller: _breakController,
          decoration: const InputDecoration(
            labelText: 'Break Minutes',
            border: OutlineInputBorder(),
          ),
          keyboardType:
          TextInputType.number,
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _graceInController,
          decoration: const InputDecoration(
            labelText: 'Grace In Minutes',
            border: OutlineInputBorder(),
          ),
          keyboardType:
          TextInputType.number,
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _graceOutController,
          decoration: const InputDecoration(
            labelText: 'Grace Out Minutes',
            border: OutlineInputBorder(),
          ),
          keyboardType:
          TextInputType.number,
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _lateController,
          decoration: const InputDecoration(
            labelText:
            'Late After Minutes',
            border: OutlineInputBorder(),
          ),
          keyboardType:
          TextInputType.number,
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller:
          _halfDayController,
          decoration:
          const InputDecoration(
            labelText:
            'Half Day After Minutes',
            border:
            OutlineInputBorder(),
          ),
          keyboardType:
          TextInputType.number,
        ),

        const SizedBox(height: 16),

        DropdownButtonFormField<int>(
          value: _weeklyOff,
          decoration:
          const InputDecoration(
            labelText:
            'Weekly Off Day',
            border:
            OutlineInputBorder(),
          ),
          items: const [

            DropdownMenuItem(
              value: 0,
              child: Text('Sunday'),
            ),

            DropdownMenuItem(
              value: 1,
              child: Text('Monday'),
            ),

            DropdownMenuItem(
              value: 2,
              child: Text('Tuesday'),
            ),

            DropdownMenuItem(
              value: 3,
              child: Text('Wednesday'),
            ),

            DropdownMenuItem(
              value: 4,
              child: Text('Thursday'),
            ),

            DropdownMenuItem(
              value: 5,
              child: Text('Friday'),
            ),

            DropdownMenuItem(
              value: 6,
              child: Text('Saturday'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _weeklyOff = value;
            });
          },
        ),

        const SizedBox(height: 20),

        SwitchListTile(
          value: _nightShift,
          title:
          const Text('Night Shift'),
          onChanged: (v) {
            setState(() {
              _nightShift = v;
            });
          },
        ),

        SwitchListTile(
          value: _flexible,
          title:
          const Text('Flexible Shift'),
          onChanged: (v) {
            setState(() {
              _flexible = v;
            });
          },
        ),

        SwitchListTile(
          value: _active,
          title:
          const Text('Active'),
          onChanged: (v) {
            setState(() {
              _active = v;
            });
          },
        ),

        const SizedBox(height: 24),

        SizedBox(
          height: 50,
          child: FilledButton(
            onPressed: widget.isLoading
                ? null
                : _save,
            child: widget.isLoading
                ? const CircularProgressIndicator()
                : Text(
              widget.initialCode
                  .isEmpty
                  ? 'Save'
                  : 'Update',
            ),
          ),
        ),
      ],
    ),
  );
}
}
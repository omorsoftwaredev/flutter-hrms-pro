import 'package:flutter/material.dart';

class ShiftForm extends StatefulWidget {
  const ShiftForm({
    super.key,
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

  // =============================================================
  // INITIAL VALUES
  // =============================================================

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

  // =============================================================
  // SUBMIT
  // =============================================================
  //
  // IMPORTANT:
  //
  // companyId এখানে নেই।
  //
  // code এখানেও নেই।
  //
  // companyId:
  //     CurrentUser.companyId
  //
  // code:
  //     Database trigger generate করবে।
  //
  // =============================================================

  final Future<void> Function(
      String name,
      String description,
      String startTime,
      String endTime,
      int breakMinutes,
      int graceInMinutes,
      int graceOutMinutes,
      int lateAfterMinutes,
      int halfDayAfterMinutes,
      int? weeklyOffDay,
      bool isNightShift,
      bool isFlexible,
      bool isActive,
      ) onSubmit;

  @override
  State<ShiftForm> createState() =>
      _ShiftFormState();
}

class _ShiftFormState
    extends State<ShiftForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _breakController;
  late TextEditingController _graceInController;
  late TextEditingController _graceOutController;
  late TextEditingController _lateController;
  late TextEditingController _halfDayController;

  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  int? _weeklyOffDay;

  late bool _isNightShift;
  late bool _isFlexible;
  late bool _isActive;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

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
          text: widget.initialHalfDayAfterMinutes
              .toString(),
        );

    _startTime = _parseTime(
      widget.initialStartTime,
    );

    _endTime = _parseTime(
      widget.initialEndTime,
    );

    _weeklyOffDay =
        widget.initialWeeklyOffDay;

    _isNightShift =
        widget.initialNightShift;

    _isFlexible =
        widget.initialFlexible;

    _isActive =
        widget.initialActive;
  }

  // =============================================================
  // PARSE TIME
  // =============================================================

  TimeOfDay _parseTime(
      String value,
      ) {
    final parts = value.split(':');

    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 9,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  // =============================================================
  // FORMAT TIME
  // =============================================================

  String _formatTime(
      TimeOfDay time,
      ) {
    final hour =
    time.hour.toString().padLeft(2, '0');

    final minute =
    time.minute.toString().padLeft(2, '0');

    return '$hour:$minute:00';
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _breakController.dispose();
    _graceInController.dispose();
    _graceOutController.dispose();
    _lateController.dispose();
    _halfDayController.dispose();

    super.dispose();
  }

  // =============================================================
  // PICK START TIME
  // =============================================================

  Future<void> _pickStartTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (result != null) {
      setState(() {
        _startTime = result;
      });
    }
  }

  // =============================================================
  // PICK END TIME
  // =============================================================

  Future<void> _pickEndTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );

    if (result != null) {
      setState(() {
        _endTime = result;
      });
    }
  }

  // =============================================================
  // SAVE
  // =============================================================

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name =
    _nameController.text.trim();

    final description =
    _descriptionController.text.trim();

    final breakMinutes =
        int.tryParse(
          _breakController.text.trim(),
        ) ??
            60;

    final graceInMinutes =
        int.tryParse(
          _graceInController.text.trim(),
        ) ??
            15;

    final graceOutMinutes =
        int.tryParse(
          _graceOutController.text.trim(),
        ) ??
            15;

    final lateAfterMinutes =
        int.tryParse(
          _lateController.text.trim(),
        ) ??
            15;

    final halfDayAfterMinutes =
        int.tryParse(
          _halfDayController.text.trim(),
        ) ??
            240;

    await widget.onSubmit(
      name,
      description,
      _formatTime(_startTime),
      _formatTime(_endTime),
      breakMinutes,
      graceInMinutes,
      graceOutMinutes,
      lateAfterMinutes,
      halfDayAfterMinutes,
      _weeklyOffDay,
      _isNightShift,
      _isFlexible,
      _isActive,
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // =======================================================
          // SHIFT NAME
          // =======================================================

          TextFormField(
            controller: _nameController,
            decoration:
            const InputDecoration(
              labelText: 'Shift Name',
              border: OutlineInputBorder(),
            ),
            textInputAction:
            TextInputAction.next,
            enabled: !widget.isLoading,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Shift name is required';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          // =======================================================
          // DESCRIPTION
          // =======================================================

          TextFormField(
            controller:
            _descriptionController,
            decoration:
            const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            enabled: !widget.isLoading,
          ),

          const SizedBox(height: 16),

          // =======================================================
          // START TIME
          // =======================================================

          ListTile(
            contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(8),
              side: const BorderSide(),
            ),
            title:
            const Text('Start Time'),
            subtitle: Text(
              _startTime.format(context),
            ),
            trailing: const Icon(
              Icons.access_time,
            ),
            enabled: !widget.isLoading,
            onTap: widget.isLoading
                ? null
                : _pickStartTime,
          ),

          const SizedBox(height: 16),

          // =======================================================
          // END TIME
          // =======================================================

          ListTile(
            contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(8),
              side: const BorderSide(),
            ),
            title:
            const Text('End Time'),
            subtitle: Text(
              _endTime.format(context),
            ),
            trailing: const Icon(
              Icons.access_time,
            ),
            enabled: !widget.isLoading,
            onTap: widget.isLoading
                ? null
                : _pickEndTime,
          ),

          const SizedBox(height: 16),

          // =======================================================
          // BREAK MINUTES
          // =======================================================

          TextFormField(
            controller: _breakController,
            decoration:
            const InputDecoration(
              labelText: 'Break Minutes',
              border: OutlineInputBorder(),
            ),
            keyboardType:
            TextInputType.number,
            textInputAction:
            TextInputAction.next,
            enabled: !widget.isLoading,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Break minutes is required';
              }

              final minutes =
              int.tryParse(
                value.trim(),
              );

              if (minutes == null) {
                return 'Invalid number';
              }

              if (minutes < 0) {
                return 'Minutes cannot be negative';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          // =======================================================
          // GRACE IN
          // =======================================================

          TextFormField(
            controller:
            _graceInController,
            decoration:
            const InputDecoration(
              labelText:
              'Grace In Minutes',
              border: OutlineInputBorder(),
            ),
            keyboardType:
            TextInputType.number,
            textInputAction:
            TextInputAction.next,
            enabled: !widget.isLoading,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Grace In Minutes is required';
              }

              final minutes =
              int.tryParse(
                value.trim(),
              );

              if (minutes == null) {
                return 'Invalid number';
              }

              if (minutes < 0) {
                return 'Minutes cannot be negative';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          // =======================================================
          // GRACE OUT
          // =======================================================

          TextFormField(
            controller:
            _graceOutController,
            decoration:
            const InputDecoration(
              labelText:
              'Grace Out Minutes',
              border: OutlineInputBorder(),
            ),
            keyboardType:
            TextInputType.number,
            textInputAction:
            TextInputAction.next,
            enabled: !widget.isLoading,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Grace Out Minutes is required';
              }

              final minutes =
              int.tryParse(
                value.trim(),
              );

              if (minutes == null) {
                return 'Invalid number';
              }

              if (minutes < 0) {
                return 'Minutes cannot be negative';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          // =======================================================
          // LATE AFTER
          // =======================================================

          TextFormField(
            controller: _lateController,
            decoration:
            const InputDecoration(
              labelText:
              'Late After Minutes',
              border: OutlineInputBorder(),
            ),
            keyboardType:
            TextInputType.number,
            textInputAction:
            TextInputAction.next,
            enabled: !widget.isLoading,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Late After Minutes is required';
              }

              final minutes =
              int.tryParse(
                value.trim(),
              );

              if (minutes == null) {
                return 'Invalid number';
              }

              if (minutes < 0) {
                return 'Minutes cannot be negative';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          // =======================================================
          // HALF DAY AFTER
          // =======================================================

          TextFormField(
            controller:
            _halfDayController,
            decoration:
            const InputDecoration(
              labelText:
              'Half Day After Minutes',
              border: OutlineInputBorder(),
            ),
            keyboardType:
            TextInputType.number,
            textInputAction:
            TextInputAction.next,
            enabled: !widget.isLoading,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Half Day After Minutes is required';
              }

              final minutes =
              int.tryParse(
                value.trim(),
              );

              if (minutes == null) {
                return 'Invalid number';
              }

              if (minutes < 0) {
                return 'Minutes cannot be negative';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          // =======================================================
          // WEEKLY OFF
          // =======================================================

          DropdownButtonFormField<int>(
            value: _weeklyOffDay,
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
            onChanged:
            widget.isLoading
                ? null
                : (value) {
              setState(() {
                _weeklyOffDay = value;
              });
            },
          ),

          const SizedBox(height: 16),

          // =======================================================
          // NIGHT SHIFT
          // =======================================================

          SwitchListTile(
            contentPadding:
            EdgeInsets.zero,
            title:
            const Text('Night Shift'),
            value: _isNightShift,
            onChanged:
            widget.isLoading
                ? null
                : (value) {
              setState(() {
                _isNightShift = value;
              });
            },
          ),

          // =======================================================
          // FLEXIBLE SHIFT
          // =======================================================

          SwitchListTile(
            contentPadding:
            EdgeInsets.zero,
            title:
            const Text('Flexible Shift'),
            value: _isFlexible,
            onChanged:
            widget.isLoading
                ? null
                : (value) {
              setState(() {
                _isFlexible = value;
              });
            },
          ),

          // =======================================================
          // ACTIVE
          // =======================================================

          SwitchListTile(
            contentPadding:
            EdgeInsets.zero,
            title:
            const Text('Active'),
            value: _isActive,
            onChanged:
            widget.isLoading
                ? null
                : (value) {
              setState(() {
                _isActive = value;
              });
            },
          ),

          const SizedBox(height: 24),

          // =======================================================
          // SAVE / UPDATE BUTTON
          // =======================================================

          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed:
              widget.isLoading
                  ? null
                  : _save,
              child: widget.isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : Text(
                widget.initialName
                    .trim()
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
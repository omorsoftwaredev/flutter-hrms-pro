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
  State<ShiftForm> createState() => _ShiftFormState();
}

class _ShiftFormState extends State<ShiftForm> {
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

    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );

    _breakController = TextEditingController(
      text: widget.initialBreakMinutes.toString(),
    );

    _graceInController = TextEditingController(
      text: widget.initialGraceInMinutes.toString(),
    );

    _graceOutController = TextEditingController(
      text: widget.initialGraceOutMinutes.toString(),
    );

    _lateController = TextEditingController(
      text: widget.initialLateAfterMinutes.toString(),
    );

    _halfDayController = TextEditingController(
      text: widget.initialHalfDayAfterMinutes.toString(),
    );

    _startTime = _parseTime(
      widget.initialStartTime,
    );

    _endTime = _parseTime(
      widget.initialEndTime,
    );

    _weeklyOffDay = widget.initialWeeklyOffDay;

    _isNightShift = widget.initialNightShift;

    _isFlexible = widget.initialFlexible;

    _isActive = widget.initialActive;
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
    final hour = time.hour.toString().padLeft(2, '0');

    final minute = time.minute.toString().padLeft(2, '0');

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

    final name = _nameController.text.trim();

    final description = _descriptionController.text.trim();

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          final bool isWide = constraints.maxWidth >= 700;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 760,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 8 : 0,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // =================================================
                      // HEADER
                      // =================================================

                      _buildHeader(),

                      const SizedBox(height: 16),

                      // =================================================
                      // BASIC INFORMATION
                      // =================================================

                      _buildSectionCard(
                        title: 'Basic Information',
                        icon: Icons.badge_outlined,
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            label: 'Shift Name',
                            hint: 'Enter shift name',
                            icon: Icons.work_outline_rounded,
                            textInputAction:
                            TextInputAction.next,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Shift name is required';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          _buildTextField(
                            controller:
                            _descriptionController,
                            label: 'Description',
                            hint: 'Enter shift description',
                            icon:
                            Icons.description_outlined,
                            maxLines: 3,
                            textInputAction:
                            TextInputAction.newline,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // =================================================
                      // SHIFT TIME
                      // =================================================

                      _buildSectionCard(
                        title: 'Shift Time',
                        icon: Icons.schedule_outlined,
                        children: [
                          if (isWide)
                            Row(
                              children: [
                                Expanded(
                                  child:
                                  _buildTimeSelector(
                                    title: 'Start Time',
                                    time: _startTime,
                                    icon:
                                    Icons.login_rounded,
                                    onTap:
                                    _pickStartTime,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child:
                                  _buildTimeSelector(
                                    title: 'End Time',
                                    time: _endTime,
                                    icon:
                                    Icons.logout_rounded,
                                    onTap:
                                    _pickEndTime,
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            _buildTimeSelector(
                              title: 'Start Time',
                              time: _startTime,
                              icon: Icons.login_rounded,
                              onTap: _pickStartTime,
                            ),
                            const SizedBox(height: 12),
                            _buildTimeSelector(
                              title: 'End Time',
                              time: _endTime,
                              icon: Icons.logout_rounded,
                              onTap: _pickEndTime,
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 16),

                      // =================================================
                      // MINUTES SETTINGS
                      // =================================================

                      _buildSectionCard(
                        title: 'Time & Grace Settings',
                        icon: Icons.timer_outlined,
                        children: [
                          if (isWide)
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildNumberField(
                                    controller:
                                    _breakController,
                                    label:
                                    'Break Minutes',
                                    icon: Icons
                                        .free_breakfast_outlined,
                                    validator: _minutesValidator(
                                      'Break minutes',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _buildNumberField(
                                    controller:
                                    _graceInController,
                                    label:
                                    'Grace In Minutes',
                                    icon: Icons
                                        .login_outlined,
                                    validator: _minutesValidator(
                                      'Grace In Minutes',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            _buildNumberField(
                              controller:
                              _breakController,
                              label: 'Break Minutes',
                              icon: Icons
                                  .free_breakfast_outlined,
                              validator: _minutesValidator(
                                'Break minutes',
                              ),
                            ),
                            const SizedBox(height: 14),
                            _buildNumberField(
                              controller:
                              _graceInController,
                              label: 'Grace In Minutes',
                              icon: Icons.login_outlined,
                              validator: _minutesValidator(
                                'Grace In Minutes',
                              ),
                            ),
                          ],

                          const SizedBox(height: 14),

                          if (isWide)
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildNumberField(
                                    controller:
                                    _graceOutController,
                                    label:
                                    'Grace Out Minutes',
                                    icon: Icons
                                        .logout_outlined,
                                    validator: _minutesValidator(
                                      'Grace Out Minutes',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _buildNumberField(
                                    controller:
                                    _lateController,
                                    label:
                                    'Late After Minutes',
                                    icon: Icons
                                        .schedule_outlined,
                                    validator: _minutesValidator(
                                      'Late After Minutes',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            _buildNumberField(
                              controller:
                              _graceOutController,
                              label:
                              'Grace Out Minutes',
                              icon:
                              Icons.logout_outlined,
                              validator: _minutesValidator(
                                'Grace Out Minutes',
                              ),
                            ),
                            const SizedBox(height: 14),
                            _buildNumberField(
                              controller: _lateController,
                              label:
                              'Late After Minutes',
                              icon:
                              Icons.schedule_outlined,
                              validator: _minutesValidator(
                                'Late After Minutes',
                              ),
                            ),
                          ],

                          const SizedBox(height: 14),

                          _buildNumberField(
                            controller:
                            _halfDayController,
                            label:
                            'Half Day After Minutes',
                            icon:
                            Icons.timelapse_outlined,
                            validator: _minutesValidator(
                              'Half Day After Minutes',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // =================================================
                      // WEEKLY OFF
                      // =================================================

                      _buildSectionCard(
                        title: 'Weekly Schedule',
                        icon: Icons.event_available_outlined,
                        children: [
                          _buildWeeklyOffDropdown(),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // =================================================
                      // SHIFT OPTIONS
                      // =================================================

                      _buildSectionCard(
                        title: 'Shift Options',
                        icon: Icons.tune_rounded,
                        children: [
                          _buildSwitchTile(
                            title: 'Night Shift',
                            subtitle:
                            'Mark this as an overnight shift.',
                            value: _isNightShift,
                            icon:
                            Icons.nights_stay_outlined,
                            onChanged: (value) {
                              setState(() {
                                _isNightShift = value;
                              });
                            },
                          ),

                          _buildSwitchTile(
                            title: 'Flexible Shift',
                            subtitle:
                            'Allow flexible shift timing.',
                            value: _isFlexible,
                            icon:
                            Icons.swap_horiz_rounded,
                            onChanged: (value) {
                              setState(() {
                                _isFlexible = value;
                              });
                            },
                          ),

                          _buildSwitchTile(
                            title: 'Active',
                            subtitle:
                            'Allow this shift to be used by employees.',
                            value: _isActive,
                            icon:
                            Icons.check_circle_outline,
                            onChanged: (value) {
                              setState(() {
                                _isActive = value;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // =================================================
                      // SAVE / UPDATE
                      // =================================================

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton.icon(
                          onPressed: widget.isLoading
                              ? null
                              : _save,
                          icon: widget.isLoading
                              ? SizedBox(
                            width: 19,
                            height: 19,
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme
                                  .onPrimary,
                            ),
                          )
                              : const Icon(
                            Icons.save_outlined,
                          ),
                          label: Text(
                            widget.isLoading
                                ? 'Saving...'
                                : widget.initialName
                                .trim()
                                .isEmpty
                                ? 'Save Shift'
                                : 'Update Shift',
                          ),
                          style:
                          FilledButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                            colorScheme.primary,
                            foregroundColor:
                            colorScheme.onPrimary,
                            disabledBackgroundColor:
                            colorScheme
                                .surfaceContainerHighest,
                            disabledForegroundColor:
                            colorScheme
                                .onSurfaceVariant,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                14,
                              ),
                            ),
                            textStyle: theme
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // =============================================================
  // HEADER
  // =============================================================

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.schedule_rounded,
              color: colorScheme.onPrimary,
              size: 27,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  widget.initialName.trim().isEmpty
                      ? 'Create Shift'
                      : 'Edit Shift',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                    colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Configure shift timing, grace periods and other shift settings.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(
                    color: colorScheme
                        .onPrimaryContainer
                        .withValues(
                      alpha: .72,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SECTION CARD
  // =============================================================

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                  colorScheme.secondaryContainer,
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: colorScheme
                      .onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          Divider(
            height: 1,
            color: colorScheme.outlineVariant,
          ),

          const SizedBox(height: 14),

          ...children,
        ],
      ),
    );
  }

  // =============================================================
  // TEXT FIELD
  // =============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      enabled: !widget.isLoading,
      maxLines: maxLines,
      textInputAction: textInputAction,
      validator: validator,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: colorScheme.surface,
        labelStyle:
        TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle:
        TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
        border: _inputBorder(),
        enabledBorder: _inputBorder(),
        focusedBorder: _inputBorder(
          color: colorScheme.primary,
          width: 1.5,
        ),
        errorBorder: _inputBorder(
          color: colorScheme.error,
        ),
        focusedErrorBorder: _inputBorder(
          color: colorScheme.error,
          width: 1.5,
        ),
      ),
    );
  }

  // =============================================================
  // NUMBER FIELD
  // =============================================================

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      enabled: !widget.isLoading,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validator: validator,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixText: 'min',
        filled: true,
        fillColor: colorScheme.surface,
        labelStyle:
        TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
        suffixStyle:
        TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
        border: _inputBorder(),
        enabledBorder: _inputBorder(),
        focusedBorder: _inputBorder(
          color: colorScheme.primary,
          width: 1.5,
        ),
        errorBorder: _inputBorder(
          color: colorScheme.error,
        ),
        focusedErrorBorder: _inputBorder(
          color: colorScheme.error,
          width: 1.5,
        ),
      ),
    );
  }

  // =============================================================
  // INPUT BORDER
  // =============================================================

  OutlineInputBorder _inputBorder({
    Color? color,
    double width = 1,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: color ?? colorScheme.outlineVariant,
        width: width,
      ),
    );
  }

  // =============================================================
  // TIME SELECTOR
  // =============================================================

  Widget _buildTimeSelector({
    required String title,
    required TimeOfDay time,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: widget.isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                  colorScheme.primaryContainer,
                  borderRadius:
                  BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color:
                  colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      time.format(context),
                      style: theme.textTheme.titleMedium
                          ?.copyWith(
                        color:
                        colorScheme.onSurface,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // WEEKLY OFF DROPDOWN
  // =============================================================

  Widget _buildWeeklyOffDropdown() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DropdownButtonFormField<int>(
      value: _weeklyOffDay,
      decoration: InputDecoration(
        labelText: 'Weekly Off Day',
        prefixIcon:
        const Icon(Icons.event_outlined),
        filled: true,
        fillColor: colorScheme.surface,
        labelStyle:
        TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
        border: _inputBorder(),
        enabledBorder: _inputBorder(),
        focusedBorder: _inputBorder(
          color: colorScheme.primary,
          width: 1.5,
        ),
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
      onChanged: widget.isLoading
          ? null
          : (value) {
        setState(() {
          _weeklyOffDay = value;
        });
      },
      style: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // =============================================================
  // SWITCH TILE
  // =============================================================

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: SwitchListTile.adaptive(
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 3,
        ),
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: value
                ? colorScheme.primaryContainer
                : colorScheme
                .surfaceContainerHighest,
            borderRadius:
            BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 20,
            color: value
                ? colorScheme
                .onPrimaryContainer
                : colorScheme
                .onSurfaceVariant,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge
              ?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 3,
          ),
          child: Text(
            subtitle,
            style: theme.textTheme.bodySmall
                ?.copyWith(
              color:
              colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ),
        value: value,
        onChanged:
        widget.isLoading ? null : onChanged,
        activeColor: colorScheme.primary,
        activeTrackColor:
        colorScheme.primaryContainer,
        inactiveThumbColor:
        colorScheme.onSurfaceVariant,
        inactiveTrackColor:
        colorScheme.surfaceContainerHighest,
        trackOutlineColor:
        WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return colorScheme.primary;
            }

            return colorScheme.outline;
          },
        ),
      ),
    );
  }

  // =============================================================
  // VALIDATOR
  // =============================================================

  String? Function(String?) _minutesValidator(
      String fieldName,
      ) {
    return (value) {
      if (value == null ||
          value.trim().isEmpty) {
        return '$fieldName is required';
      }

      final minutes = int.tryParse(
        value.trim(),
      );

      if (minutes == null) {
        return 'Invalid number';
      }

      if (minutes < 0) {
        return 'Minutes cannot be negative';
      }

      return null;
    };
  }
}
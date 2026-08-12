import 'package:flutter/material.dart';

class DesignationForm extends StatefulWidget {
  const DesignationForm({
    super.key,
    this.initialName = '',
    this.initialDescription = '',
    this.initialGrade = 1,
    this.initialDisplayOrder = 0,
    this.initialBaseSalary = 0,
    this.initialIsActive = true,
    this.isLoading = false,
    required this.onSubmit,
  });

  // =============================================================
  // INITIAL VALUES
  // =============================================================

  final String initialName;
  final String initialDescription;

  final int initialGrade;
  final int initialDisplayOrder;

  final double initialBaseSalary;

  final bool initialIsActive;

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
      int grade,
      int displayOrder,
      double baseSalary,
      bool isActive,
      ) onSubmit;

  @override
  State<DesignationForm> createState() =>
      _DesignationFormState();
}

class _DesignationFormState
    extends State<DesignationForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _gradeController;
  late TextEditingController _displayOrderController;
  late TextEditingController _baseSalaryController;

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

    _gradeController =
        TextEditingController(
          text: widget.initialGrade.toString(),
        );

    _displayOrderController =
        TextEditingController(
          text: widget.initialDisplayOrder.toString(),
        );

    _baseSalaryController =
        TextEditingController(
          text: widget.initialBaseSalary
              .toString(),
        );

    _isActive = widget.initialIsActive;
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _gradeController.dispose();
    _displayOrderController.dispose();
    _baseSalaryController.dispose();

    super.dispose();
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

    final grade =
        int.tryParse(
          _gradeController.text.trim(),
        ) ??
            1;

    final displayOrder =
        int.tryParse(
          _displayOrderController.text
              .trim(),
        ) ??
            0;

    final baseSalary =
        double.tryParse(
          _baseSalaryController.text
              .trim(),
        ) ??
            0;

    await widget.onSubmit(
      name,
      description,
      grade,
      displayOrder,
      baseSalary,
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
          // DESIGNATION NAME
          // =======================================================

          TextFormField(
            controller: _nameController,
            decoration:
            const InputDecoration(
              labelText: 'Designation Name',
              border: OutlineInputBorder(),
            ),
            textInputAction:
            TextInputAction.next,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Designation name is required';
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
          ),

          const SizedBox(height: 16),

          // =======================================================
          // GRADE
          // =======================================================

          TextFormField(
            controller: _gradeController,
            decoration:
            const InputDecoration(
              labelText: 'Grade',
              border: OutlineInputBorder(),
            ),
            keyboardType:
            TextInputType.number,
            textInputAction:
            TextInputAction.next,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Grade is required';
              }

              final grade =
              int.tryParse(
                value.trim(),
              );

              if (grade == null) {
                return 'Invalid grade';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          // =======================================================
          // DISPLAY ORDER
          // =======================================================

          TextFormField(
            controller:
            _displayOrderController,
            decoration:
            const InputDecoration(
              labelText: 'Display Order',
              border: OutlineInputBorder(),
            ),
            keyboardType:
            TextInputType.number,
            textInputAction:
            TextInputAction.next,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Display Order is required';
              }

              final order =
              int.tryParse(
                value.trim(),
              );

              if (order == null) {
                return 'Invalid number';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          // =======================================================
          // BASE SALARY
          // =======================================================

          TextFormField(
            controller:
            _baseSalaryController,
            decoration:
            const InputDecoration(
              labelText: 'Base Salary',
              border: OutlineInputBorder(),
              prefixText: '৳ ',
            ),
            keyboardType:
            const TextInputType.numberWithOptions(
              decimal: true,
            ),
            textInputAction:
            TextInputAction.done,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return null;
              }

              final salary =
              double.tryParse(
                value.trim(),
              );

              if (salary == null) {
                return 'Invalid salary';
              }

              if (salary < 0) {
                return 'Salary cannot be negative';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          // =======================================================
          // ACTIVE
          // =======================================================

          SwitchListTile(
            contentPadding:
            EdgeInsets.zero,
            title: const Text('Active'),
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
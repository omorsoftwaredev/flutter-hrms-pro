import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../company/domain/entities/company_entity.dart';
import '../../../company/presentation/providers/company_provider.dart';

class DesignationForm extends ConsumerStatefulWidget {
  const DesignationForm({
    super.key,
    this.initialCompanyId = '',
    this.initialCode = '',
    this.initialName = '',
    this.initialDescription = '',
    this.initialGrade = 1,
    this.initialDisplayOrder = 0,
    this.initialBaseSalary = 0,
    this.initialIsActive = true,
    this.isLoading = false,
    required this.onSubmit,
  });

  final String initialCompanyId;
  final String initialCode;
  final String initialName;
  final String initialDescription;
  final int initialGrade;
  final int initialDisplayOrder;
  final double initialBaseSalary;
  final bool initialIsActive;
  final bool isLoading;

  final Future<void> Function(
      String companyId,
      String code,
      String name,
      String description,
      int grade,
      int displayOrder,
      double baseSalary,
      bool isActive,
      ) onSubmit;

  @override
  ConsumerState<DesignationForm> createState() =>
      _DesignationFormState();
}

class _DesignationFormState
    extends ConsumerState<DesignationForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _gradeController;
  late TextEditingController _displayOrderController;
  late TextEditingController _baseSalaryController;

  String? _companyId;

  bool _isActive = true;

  @override
  void initState() {
    super.initState();

    _companyId = widget.initialCompanyId.isEmpty
        ? null
        : widget.initialCompanyId;

    _codeController =
        TextEditingController(text: widget.initialCode);

    _nameController =
        TextEditingController(text: widget.initialName);

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
          text:
          widget.initialDisplayOrder.toString(),
        );

    _baseSalaryController =
        TextEditingController(
          text:
          widget.initialBaseSalary.toString(),
        );

    _isActive = widget.initialIsActive;

    Future.microtask(() async {
      await ref
          .read(companyProvider.notifier)
          .loadCompanies();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _gradeController.dispose();
    _displayOrderController.dispose();
    _baseSalaryController.dispose();

    super.dispose();
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
      int.tryParse(_gradeController.text) ?? 1,
      int.tryParse(
          _displayOrderController.text) ??
          0,
      double.tryParse(
          _baseSalaryController.text) ??
          0,
      _isActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    final companyState =
    ref.watch(companyProvider);

    final List<CompanyEntity> companies =
        companyState.companies;

    if (companies.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [

          DropdownButtonFormField<String>(
            value: _companyId,
            decoration:
            const InputDecoration(
              labelText: 'Company',
              border:
              OutlineInputBorder(),
            ),
            items: companies
                .map(
                  (e) =>
                  DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                  ),
            )
                .toList(),
            onChanged: (value) {
              setState(() {
                _companyId = value;
              });
            },
            validator: (value) =>
            value == null
                ? 'Select Company'
                : null,
          ),

          const SizedBox(height: 16),


          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'Designation Code',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Designation code is required';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Designation Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Designation name is required';
              }
              return null;
            },
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

          const SizedBox(height: 16),

          TextFormField(
            controller: _gradeController,
            decoration: const InputDecoration(
              labelText: 'Grade',
              border: OutlineInputBorder(),
            ),
            keyboardType:
            TextInputType.number,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Grade is required';
              }

              if (int.tryParse(value) ==
                  null) {
                return 'Invalid grade';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller:
            _displayOrderController,
            decoration:
            const InputDecoration(
              labelText:
              'Display Order',
              border:
              OutlineInputBorder(),
            ),
            keyboardType:
            TextInputType.number,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Display Order is required';
              }

              if (int.tryParse(value) ==
                  null) {
                return 'Invalid number';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller:
            _baseSalaryController,
            decoration:
            const InputDecoration(
              labelText:
              'Base Salary',
              border:
              OutlineInputBorder(),
              prefixText: '৳ ',
            ),
            keyboardType:
            const TextInputType.numberWithOptions(
              decimal: true,
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return null;
              }

              if (double.tryParse(value) ==
                  null) {
                return 'Invalid salary';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          SwitchListTile(
            contentPadding:
            EdgeInsets.zero,
            title:
            const Text('Active'),
            value: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value;
              });
            },
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: widget
                  .isLoading
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
                widget
                    .initialCode
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
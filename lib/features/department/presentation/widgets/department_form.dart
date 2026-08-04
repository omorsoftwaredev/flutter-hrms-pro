import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../company/presentation/providers/company_provider.dart';

class DepartmentForm extends ConsumerStatefulWidget {
  const DepartmentForm({
    super.key,
    this.initialCompanyId = '',
    this.initialCode = '',
    this.initialName = '',
    this.initialDescription = '',
    this.initialManagerName = '',
    this.initialPhone = '',
    this.initialEmail = '',
    this.initialLocation = '',
    this.initialIsActive = true,
    this.isLoading = false,
    required this.onSubmit,
  });

  final String initialCompanyId;
  final String initialCode;
  final String initialName;
  final String initialDescription;
  final String initialManagerName;
  final String initialPhone;
  final String initialEmail;
  final String initialLocation;
  final bool initialIsActive;
  final bool isLoading;

  final Future<void> Function(
      String companyId,
      String code,
      String name,
      String description,
      String managerName,
      String phone,
      String email,
      String location,
      bool isActive,
      ) onSubmit;

  @override
  ConsumerState<DepartmentForm> createState() =>
      _DepartmentFormState();
}

class _DepartmentFormState
    extends ConsumerState<DepartmentForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _companyIdController;
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _managerController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _locationController;

  late bool _isActive;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final companies = await ref
          .read(companyRepositoryProvider)
          .getCompanies();

      print("DIRECT REPOSITORY: ${companies.length}");
    });

    Future.microtask(() {
      ref
          .read(companyProvider.notifier)
          .loadCompanies();
    });

    _companyIdController =
        TextEditingController(text: widget.initialCompanyId);

    _codeController =
        TextEditingController(text: widget.initialCode);

    _nameController =
        TextEditingController(text: widget.initialName);

    _descriptionController =
        TextEditingController(
          text: widget.initialDescription,
        );

    _managerController =
        TextEditingController(
          text: widget.initialManagerName,
        );

    _phoneController =
        TextEditingController(
          text: widget.initialPhone,
        );

    _emailController =
        TextEditingController(
          text: widget.initialEmail,
        );

    _locationController =
        TextEditingController(
          text: widget.initialLocation,
        );

    _isActive = widget.initialIsActive;
  }

  @override
  void dispose() {
    _companyIdController.dispose();
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _managerController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await widget.onSubmit(
      _companyIdController.text.trim(),
      _codeController.text.trim(),
      _nameController.text.trim(),
      _descriptionController.text.trim(),
      _managerController.text.trim(),
      _phoneController.text.trim(),
      _emailController.text.trim(),
      _locationController.text.trim(),
      _isActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    final companyState = ref.watch(companyProvider);
    final companies = companyState.companies;
    print("Loading: ${companyState.isLoading}");
    print("Companies: ${companies.length}");

    if (companyState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Form(
      key: _formKey,
      child: Column(
        children: [


          DropdownButtonFormField<String>(
            value: _companyIdController.text.isEmpty
                ? null
                : _companyIdController.text,
            decoration: const InputDecoration(
              labelText: 'Company',
              border: OutlineInputBorder(),
            ),
            items: companies.map((company) {
              return DropdownMenuItem<String>(
                value: company.id,
                child: Text(company.name),
              );
            }).toList(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select company';
              }
              return null;
            },
            onChanged: (value) {
              _companyIdController.text =
                  value ?? '';
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'Department Code',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Department code is required';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Department Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Department name is required';
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
            controller: _managerController,
            decoration: const InputDecoration(
              labelText: 'Manager Name',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType:
            TextInputType.emailAddress,
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Active'),
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
              onPressed:
              widget.isLoading ? null : _save,
              child: widget.isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
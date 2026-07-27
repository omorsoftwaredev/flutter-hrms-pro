import 'package:flutter/material.dart';

import '../../../../core/validators/app_validator.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_checkbox.dart';
import '../../../../core/widgets/app_text_field.dart';

class CompanyForm extends StatefulWidget {
  const CompanyForm({
    super.key,
    this.initialName,
    this.initialCode,
    this.initialEmail,
    this.initialPhone,
    this.initialAddress,
    this.initialIsActive = true,
    required this.onSubmit,
    this.isLoading = false,
  });

  final String? initialName;
  final String? initialCode;
  final String? initialEmail;
  final String? initialPhone;
  final String? initialAddress;
  final bool initialIsActive;

  final bool isLoading;

  final Future<void> Function(
      String name,
      String code,
      String email,
      String phone,
      String address,
      bool isActive,
      ) onSubmit;

  @override
  State<CompanyForm> createState() =>
      _CompanyFormState();
}

class _CompanyFormState
    extends State<CompanyForm> {

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  late bool _isActive;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(
            text: widget.initialName);

    _codeController =
        TextEditingController(
            text: widget.initialCode);

    _emailController =
        TextEditingController(
            text: widget.initialEmail);

    _phoneController =
        TextEditingController(
            text: widget.initialPhone);

    _addressController =
        TextEditingController(
            text: widget.initialAddress);

    _isActive = widget.initialIsActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await widget.onSubmit(
      _nameController.text.trim(),
      _codeController.text.trim(),
      _emailController.text.trim(),
      _phoneController.text.trim(),
      _addressController.text.trim(),
      _isActive,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [

          AppTextField(
            controller: _nameController,
            label: "Company Name",
            prefixIcon: Icons.business,
            validator: (value) =>
                AppValidator.required(
                  value,
                  field: "Company Name",
                ),
          ),

          const SizedBox(height: 16),

          AppTextField(
            controller: _codeController,
            label: "Company Code",
            prefixIcon: Icons.qr_code,
            validator: (value) =>
                AppValidator.required(
                  value,
                  field: "Company Code",
                ),
          ),

          const SizedBox(height: 16),

          AppTextField(
            controller: _emailController,
            label: "Email",
            keyboardType:
            TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator:
            AppValidator.email,
          ),

          const SizedBox(height: 16),

          AppTextField(
            controller: _phoneController,
            label: "Phone",
            keyboardType:
            TextInputType.phone,
            prefixIcon: Icons.phone,
            validator:
            AppValidator.phone,
          ),

          const SizedBox(height: 16),

          AppTextField(
            controller:
            _addressController,
            label: "Address",
            maxLines: 3,
            prefixIcon:
            Icons.location_on_outlined,
          ),

          const SizedBox(height: 10),

          AppCheckbox(
            title: "Active Company",
            value: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value ?? true;
              });
            },
          ),

          const SizedBox(height: 30),

          AppButton(
            text: "Save Company",
            icon: Icons.save,
            isLoading: widget.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
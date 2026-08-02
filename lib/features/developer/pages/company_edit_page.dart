/// ===============================================================
/// Flutter HRMS Pro
/// Company Edit Page
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/company_controller.dart';
import '../models/company_model.dart';
import '../providers/company_provider.dart';

class CompanyEditPage extends ConsumerStatefulWidget {
  final String companyId;

  const CompanyEditPage({
    super.key,
    required this.companyId,
  });

  @override
  ConsumerState<CompanyEditPage> createState() =>
      _CompanyEditPageState();
}

class _CompanyEditPageState
    extends ConsumerState<CompanyEditPage> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactPersonController =
  TextEditingController();

  bool _loaded = false;
  bool _isActive = true;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _contactPersonController.dispose();

    super.dispose();
  }

  void _load(CompanyModel company) {
    if (_loaded) return;

    _loaded = true;

    _codeController.text = company.code;
    _nameController.text = company.name;
    _phoneController.text = company.phone ?? '';
    _emailController.text = company.email ?? '';
    _websiteController.text =
        company.website ?? '';
    _addressController.text =
        company.address ?? '';
    _contactPersonController.text =
        company.contactPerson ?? '';

    _isActive = company.isActive;
  }

  Future<void> _save(
      CompanyModel company,
      ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updated = company.copyWith(
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      website: _websiteController.text.trim(),
      address: _addressController.text.trim(),
      contactPerson:
      _contactPersonController.text.trim(),
      isActive: _isActive,
    );

    await ref
        .read(companyControllerProvider)
        .updateCompany(updated);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Company Updated Successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final company =
    ref.watch(companyProvider(widget.companyId));

    final loading =
    ref.watch(companyLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Company",
        ),
      ),
      body: company.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, s) => Center(
          child: Text(e.toString()),
        ),
        data: (company) {
          if (company == null) {
            return const Center(
              child: Text("Company Not Found"),
            );
          }

          _load(company);

          return Form(
            key: _formKey,
            child: ListView(
              padding:
              const EdgeInsets.all(16),
              children: [

                TextFormField(
                  controller:
                  _codeController,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Company Code",
                    border:
                    OutlineInputBorder(),
                  ),
                  validator: (v) =>
                  v == null || v.isEmpty
                      ? "Required"
                      : null,
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller:
                  _nameController,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Company Name",
                    border:
                    OutlineInputBorder(),
                  ),
                  validator: (v) =>
                  v == null || v.isEmpty
                      ? "Required"
                      : null,
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller:
                  _phoneController,
                  decoration:
                  const InputDecoration(
                    labelText: "Phone",
                    border:
                    OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller:
                  _emailController,
                  decoration:
                  const InputDecoration(
                    labelText: "Email",
                    border:
                    OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller:
                  _websiteController,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Website",
                    border:
                    OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller:
                  _contactPersonController,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Contact Person",
                    border:
                    OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller:
                  _addressController,
                  maxLines: 3,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Address",
                    border:
                    OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                SwitchListTile(
                  value: _isActive,
                  title: const Text(
                    "Active Company",
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),

                const SizedBox(height: 25),

                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: loading
                        ? null
                        : () => _save(
                      company,
                    ),
                    icon: loading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(
                      Icons.save,
                    ),
                    label: const Text(
                      "UPDATE COMPANY",
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
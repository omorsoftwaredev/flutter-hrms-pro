/// ===============================================================
/// Flutter HRMS Pro
/// Create Company Page
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';

class CompanyCreatePage extends StatefulWidget {
  const CompanyCreatePage({super.key});

  @override
  State<CompanyCreatePage> createState() =>
      _CompanyCreatePageState();
}

class _CompanyCreatePageState
    extends State<CompanyCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _addressController = TextEditingController();

  final _usernameController =
  TextEditingController();

  final _passwordController =
  TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _saveCompany() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    /// TODO
    /// Supabase Insert
    ///
    /// companies
    /// company_accounts

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Company Saved Successfully.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Company",
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding:
          const EdgeInsets.all(16),
          children: [

            TextFormField(
              controller: _codeController,
              decoration:
              const InputDecoration(
                labelText: "Company Code",
                border:
                OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Required";
                }
                return null;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: _nameController,
              decoration:
              const InputDecoration(
                labelText: "Company Name",
                border:
                OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Required";
                }
                return null;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: _phoneController,
              decoration:
              const InputDecoration(
                labelText: "Phone",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: _emailController,
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
                labelText: "Website",
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
                labelText: "Address",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Company Login",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller:
              _usernameController,
              decoration:
              const InputDecoration(
                labelText: "Username",
                border:
                OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Required";
                }
                return null;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller:
              _passwordController,
              obscureText: true,
              decoration:
              const InputDecoration(
                labelText: "Password",
                border:
                OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Required";
                }
                return null;
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _saveCompany,
                icon: const Icon(
                  Icons.save,
                ),
                label: const Text(
                  "SAVE COMPANY",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
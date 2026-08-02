/// ===============================================================
/// Flutter HRMS Pro
/// Company Account Page
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyAccountPage extends ConsumerStatefulWidget {
  const CompanyAccountPage({
    super.key,
  });

  @override
  ConsumerState<CompanyAccountPage> createState() =>
      _CompanyAccountPageState();
}

class _CompanyAccountPageState
    extends ConsumerState<CompanyAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final _companyController =
  TextEditingController();

  final _usernameController =
  TextEditingController();

  final _emailController =
  TextEditingController();

  final _mobileController =
  TextEditingController();

  final _passwordController =
  TextEditingController();

  final _confirmPasswordController =
  TextEditingController();

  bool _loading = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _companyController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      /// =========================================================
      /// TODO
      ///
      /// Insert Into
      /// company_accounts
      ///
      /// Supabase Auth Create User
      ///
      /// =========================================================

      await Future.delayed(
        const Duration(seconds: 1),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Company Account Created Successfully.',
          ),
        ),
      );

      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Company Account',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding:
          const EdgeInsets.all(20),
          children: [

            TextFormField(
              controller:
              _companyController,
              decoration:
              const InputDecoration(
                labelText: 'Company',
                border:
                OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
              _usernameController,
              decoration:
              const InputDecoration(
                labelText: 'Username',
                border:
                OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
              _emailController,
              decoration:
              const InputDecoration(
                labelText: 'Email',
                border:
                OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
              _mobileController,
              decoration:
              const InputDecoration(
                labelText:
                'Mobile Number',
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
              _passwordController,
              obscureText:
              _hidePassword,
              decoration:
              InputDecoration(
                labelText:
                'Password',
                border:
                const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _hidePassword =
                      !_hidePassword;
                    });
                  },
                  icon: Icon(
                    _hidePassword
                        ? Icons
                        .visibility
                        : Icons
                        .visibility_off,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.length < 6) {
                  return 'Minimum 6 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
              _confirmPasswordController,
              obscureText:
              _hideConfirmPassword,
              decoration:
              InputDecoration(
                labelText:
                'Confirm Password',
                border:
                const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _hideConfirmPassword =
                      !_hideConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _hideConfirmPassword
                        ? Icons
                        .visibility
                        : Icons
                        .visibility_off,
                  ),
                ),
              ),
              validator: (value) {
                if (value !=
                    _passwordController.text) {
                  return 'Password not matched';
                }
                return null;
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed:
                _loading ? null : _save,
                icon: _loading
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(
                  Icons.save,
                ),
                label: const Text(
                  'CREATE ACCOUNT',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
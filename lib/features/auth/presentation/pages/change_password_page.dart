import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/auth/current_user_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState
    extends ConsumerState<ChangePasswordPage> {
  // =============================================================
  // Controllers
  // =============================================================

  final _currentPasswordController =
  TextEditingController();

  final _newPasswordController =
  TextEditingController();

  final _confirmPasswordController =
  TextEditingController();

  // =============================================================
  // State
  // =============================================================

  bool _loading = false;

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  // =============================================================
  // Dispose
  // =============================================================

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // =============================================================
  // Change Password
  // =============================================================

  Future<void> _changePassword() async {
    final currentPassword =
        _currentPasswordController.text;

    final newPassword =
        _newPasswordController.text;

    final confirmPassword =
        _confirmPasswordController.text;

    // -----------------------------------------------------------
    // Validation
    // -----------------------------------------------------------

    if (currentPassword.isEmpty) {
      _showMessage(
        'Please enter your current password.',
      );
      return;
    }

    if (newPassword.isEmpty) {
      _showMessage(
        'Please enter your new password.',
      );
      return;
    }

    if (newPassword.length < 6) {
      _showMessage(
        'New password must be at least 6 characters.',
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      _showMessage(
        'Please confirm your new password.',
      );
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage(
        'New password and confirm password do not match.',
      );
      return;
    }

    if (currentPassword == newPassword) {
      _showMessage(
        'New password must be different from current password.',
      );
      return;
    }

    // -----------------------------------------------------------
    // Current User
    // -----------------------------------------------------------

    final currentUser =
    ref.read(currentUserProvider);

    if (currentUser == null) {
      _showMessage(
        'User session not found. Please login again.',
      );
      return;
    }

    if (currentUser.employeeId.isEmpty) {
      _showMessage(
        'Employee account information not found.',
      );
      return;
    }

    // -----------------------------------------------------------
    // Loading
    // -----------------------------------------------------------

    setState(() {
      _loading = true;
    });

    try {
      // ---------------------------------------------------------
      // Change Password
      // ---------------------------------------------------------

      await ref
          .read(authRepositoryProvider)
          .changeEmployeePassword(
        employeeId: currentUser.employeeId,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (!mounted) return;

      // ---------------------------------------------------------
      // Clear Fields
      // ---------------------------------------------------------

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      // ---------------------------------------------------------
      // Success Message
      // ---------------------------------------------------------

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password changed successfully.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // ---------------------------------------------------------
      // Back
      // ---------------------------------------------------------

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  // =============================================================
  // Show Message
  // =============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  // =============================================================
  // Password Field
  // =============================================================

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onVisibilityToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(
          Icons.lock_outline,
        ),
        suffixIcon: IconButton(
          onPressed: onVisibilityToggle,
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.radius,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.radius,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.radius,
          ),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // Build
  // =============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ---------------------------------------------------------
      // AppBar
      // ---------------------------------------------------------

      appBar: AppBar(
        title: const Text(
          'Change Password',
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),

      // ---------------------------------------------------------
      // Body
      // ---------------------------------------------------------

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(
              AppSizes.pagePadding,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [

                // ------------------------------------------------
                // Icon
                // ------------------------------------------------

                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary
                        .withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset_outlined,
                    size: 42,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 24),

                // ------------------------------------------------
                // Title
                // ------------------------------------------------

                const Text(
                  'Change Your Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // ------------------------------------------------
                // Description
                // ------------------------------------------------

                Text(
                  'Update your password to keep your account secure.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 32),

                // ------------------------------------------------
                // Current Password
                // ------------------------------------------------

                _passwordField(
                  controller:
                  _currentPasswordController,
                  label: 'Current Password',
                  hint: 'Enter your current password',
                  obscureText:
                  _obscureCurrentPassword,
                  onVisibilityToggle: () {
                    setState(() {
                      _obscureCurrentPassword =
                      !_obscureCurrentPassword;
                    });
                  },
                ),

                const SizedBox(height: 18),

                // ------------------------------------------------
                // New Password
                // ------------------------------------------------

                _passwordField(
                  controller:
                  _newPasswordController,
                  label: 'New Password',
                  hint: 'Enter your new password',
                  obscureText:
                  _obscureNewPassword,
                  onVisibilityToggle: () {
                    setState(() {
                      _obscureNewPassword =
                      !_obscureNewPassword;
                    });
                  },
                ),

                const SizedBox(height: 18),

                // ------------------------------------------------
                // Confirm Password
                // ------------------------------------------------

                _passwordField(
                  controller:
                  _confirmPasswordController,
                  label: 'Confirm New Password',
                  hint: 'Re-enter your new password',
                  obscureText:
                  _obscureConfirmPassword,
                  onVisibilityToggle: () {
                    setState(() {
                      _obscureConfirmPassword =
                      !_obscureConfirmPassword;
                    });
                  },
                ),

                const SizedBox(height: 12),

                // ------------------------------------------------
                // Password Requirement
                // ------------------------------------------------

                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Password must be at least 6 characters long.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ------------------------------------------------
                // Change Password Button
                // ------------------------------------------------

                SizedBox(
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton(
                    onPressed:
                    _loading
                        ? null
                        : _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          AppSizes.radius,
                        ),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : const Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_reset,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'CHANGE PASSWORD',
                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ------------------------------------------------
                // Cancel
                // ------------------------------------------------

                TextButton(
                  onPressed: _loading
                      ? null
                      : () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
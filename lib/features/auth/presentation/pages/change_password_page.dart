import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/auth/current_user_provider.dart';
import '../../../../core/constants/app_sizes.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  // =============================================================
  // Controllers
  // =============================================================

  final _currentPasswordController = TextEditingController();

  final _newPasswordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

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
    final currentPassword = _currentPasswordController.text;

    final newPassword = _newPasswordController.text;

    final confirmPassword = _confirmPasswordController.text;

    // -----------------------------------------------------------
    // Validation
    // -----------------------------------------------------------

    if (currentPassword.isEmpty) {
      _showMessage('Please enter your current password.');
      return;
    }

    if (newPassword.isEmpty) {
      _showMessage('Please enter your new password.');
      return;
    }

    if (newPassword.length < 6) {
      _showMessage('New password must be at least 6 characters.');
      return;
    }

    if (confirmPassword.isEmpty) {
      _showMessage('Please confirm your new password.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('New password and confirm password do not match.');
      return;
    }

    if (currentPassword == newPassword) {
      _showMessage('New password must be different from current password.');
      return;
    }

    // -----------------------------------------------------------
    // Current User
    // -----------------------------------------------------------

    final currentUser = ref.read(currentUserProvider);

    if (currentUser == null) {
      _showMessage('User session not found. Please login again.');
      return;
    }

    if (currentUser.employeeId.isEmpty) {
      _showMessage('Employee account information not found.');
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
        SnackBar(
          content: const Text('Password changed successfully.'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      // ---------------------------------------------------------
      // Back
      // ---------------------------------------------------------

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      _showMessage(e.toString().replaceFirst('Exception: ', ''));
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
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // =============================================================
  // Responsive Content Width
  // =============================================================

  double _contentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return width;
    }

    if (width < 1000) {
      return 560;
    }

    return 620;
  }

  // =============================================================
  // Password Field
  // =============================================================

  Widget _passwordField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onVisibilityToggle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        prefixIcon: Icon(
          Icons.lock_outline,
          color: colorScheme.onSurface.withOpacity(.55),
        ),

        suffixIcon: IconButton(
          onPressed: onVisibilityToggle,
          tooltip: obscureText ? 'Show password' : 'Hide password',
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),

        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withOpacity(.35),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(.35)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(.35)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  // =============================================================
  // Build
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final screenWidth = MediaQuery.sizeOf(context).width;

    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // ---------------------------------------------------------
      // AppBar
      // ---------------------------------------------------------
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),

      // ---------------------------------------------------------
      // Body
      // ---------------------------------------------------------
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 32,
              vertical: isMobile ? 20 : 32,
            ),
            child: SizedBox(
              width: _contentWidth(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ------------------------------------------------
                  // Header Card
                  // ------------------------------------------------
                  Container(
                    padding: EdgeInsets.all(isMobile ? 20 : 26),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorScheme.outline.withOpacity(.15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // ------------------------------------------
                        // Icon
                        // ------------------------------------------
                        Container(
                          width: isMobile ? 72 : 82,
                          height: isMobile ? 72 : 82,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(.10),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Icon(
                            Icons.lock_reset_outlined,
                            size: isMobile ? 38 : 44,
                            color: colorScheme.primary,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ------------------------------------------
                        // Title
                        // ------------------------------------------
                        Text(
                          'Change Your Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: isMobile ? 22 : 25,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.3,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ------------------------------------------
                        // Description
                        // ------------------------------------------
                        Text(
                          'Update your password to keep your account secure.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(.58),
                            fontSize: isMobile ? 12 : 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isMobile ? 22 : 28),

                  // ------------------------------------------------
                  // Current Password
                  // ------------------------------------------------
                  _passwordField(
                    context: context,
                    controller: _currentPasswordController,
                    label: 'Current Password',
                    hint: 'Enter your current password',
                    obscureText: _obscureCurrentPassword,
                    onVisibilityToggle: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // ------------------------------------------------
                  // New Password
                  // ------------------------------------------------
                  _passwordField(
                    context: context,
                    controller: _newPasswordController,
                    label: 'New Password',
                    hint: 'Enter your new password',
                    obscureText: _obscureNewPassword,
                    onVisibilityToggle: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // ------------------------------------------------
                  // Confirm Password
                  // ------------------------------------------------
                  _passwordField(
                    context: context,
                    controller: _confirmPasswordController,
                    label: 'Confirm New Password',
                    hint: 'Re-enter your new password',
                    obscureText: _obscureConfirmPassword,
                    onVisibilityToggle: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // ------------------------------------------------
                  // Password Requirement
                  // ------------------------------------------------
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            'Password must be at least 6 characters long.',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withOpacity(.62),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ------------------------------------------------
                  // Change Password Button
                  // ------------------------------------------------
                  SizedBox(
                    height: AppSizes.buttonHeight,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        disabledBackgroundColor:
                            colorScheme.surfaceContainerHighest,
                        disabledForegroundColor: colorScheme.onSurface
                            .withOpacity(.4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radius),
                        ),
                      ),
                      child: _loading
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock_reset_outlined),
                                SizedBox(width: 8),
                                Text(
                                  'CHANGE PASSWORD',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ------------------------------------------------
                  // Cancel
                  // ------------------------------------------------
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                    ),
                    child: const Text('Cancel'),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

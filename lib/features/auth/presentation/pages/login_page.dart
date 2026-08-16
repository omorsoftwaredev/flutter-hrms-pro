import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/login_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ===============================================================
  // LOGIN
  // ===============================================================

  Future<void> _login() async {
    _usernameController.text = 'waltonomor';
    _passwordController.text = 'waltonomor';
    final username = _usernameController.text.trim();
    final passwordHash = _passwordController.text;

    if (username.isEmpty || passwordHash.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username and Password are required.')),
      );
      return;
    }

    try {
      await ref
          .read(loginControllerProvider)
          .login(
            context: context,
            username: username,
            passwordHash: passwordHash,
          );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(loginLoadingProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final size = MediaQuery.sizeOf(context);

    final bool isDesktop = size.width >= 900;
    final bool isTablet = size.width >= 600 && size.width < 900;

    final double horizontalPadding = isDesktop
        ? 40
        : isTablet
        ? 32
        : 20;

    final double cardPadding = isDesktop
        ? 40
        : isTablet
        ? 32
        : 24;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: isDesktop ? 48 : 24,
            ),

            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),

              child: Card(
                elevation: 0,

                color: colorScheme.surface,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),

                  side: BorderSide(color: colorScheme.outlineVariant),
                ),

                child: Padding(
                  padding: EdgeInsets.all(cardPadding),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [
                      // =================================================
                      // LOGO
                      // =================================================
                      Center(
                        child: Container(
                          width: isDesktop ? 92 : 82,
                          height: isDesktop ? 92 : 82,

                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.10),

                            shape: BoxShape.circle,
                          ),

                          child: Icon(
                            Icons.apartment_rounded,

                            size: isDesktop ? 46 : 42,

                            color: colorScheme.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // =================================================
                      // APP NAME
                      // =================================================
                      Text(
                        'Flutter HRMS Pro',

                        textAlign: TextAlign.center,

                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Employee Management System',

                        textAlign: TextAlign.center,

                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 34),

                      // =================================================
                      // WELCOME
                      // =================================================
                      Text(
                        'Welcome Back',

                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Sign in to continue to your account.',

                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // =================================================
                      // USERNAME
                      // =================================================
                      TextField(
                        controller: _usernameController,

                        enabled: !loading,

                        keyboardType: TextInputType.emailAddress,

                        textInputAction: TextInputAction.next,

                        decoration: InputDecoration(
                          labelText: 'Username / Email',

                          hintText: 'Enter username or email',

                          prefixIcon: const Icon(Icons.person_outline_rounded),

                          filled: true,

                          fillColor: colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.35),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),

                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant,
                            ),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),

                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),

                            borderSide: BorderSide(
                              color: colorScheme.primary,

                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // =================================================
                      // PASSWORD
                      // =================================================
                      TextField(
                        controller: _passwordController,

                        enabled: !loading,

                        obscureText: _obscurePassword,

                        textInputAction: TextInputAction.done,

                        onSubmitted: (_) {
                          if (!loading) {
                            _login();
                          }
                        },

                        decoration: InputDecoration(
                          labelText: 'Password',

                          hintText: 'Enter your password',

                          prefixIcon: const Icon(Icons.lock_outline_rounded),

                          suffixIcon: IconButton(
                            tooltip: _obscurePassword
                                ? 'Show password'
                                : 'Hide password',

                            onPressed: loading
                                ? null
                                : () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },

                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),

                          filled: true,

                          fillColor: colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.35),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),

                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant,
                            ),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),

                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),

                            borderSide: BorderSide(
                              color: colorScheme.primary,

                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // =================================================
                      // LOGIN BUTTON
                      // =================================================
                      SizedBox(
                        height: 54,

                        child: ElevatedButton(
                          onPressed: loading ? null : _login,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,

                            foregroundColor: colorScheme.onPrimary,

                            disabledBackgroundColor: colorScheme.primary
                                .withValues(alpha: 0.45),

                            disabledForegroundColor: colorScheme.onPrimary
                                .withValues(alpha: 0.80),

                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),

                          child: loading
                              ? SizedBox(
                                  height: 23,
                                  width: 23,

                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,

                                    color: colorScheme.onPrimary,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    Icon(Icons.login_rounded, size: 20),

                                    SizedBox(width: 8),

                                    Text(
                                      'LOGIN',

                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // =================================================
                      // SECURITY FOOTER
                      // =================================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(
                            Icons.verified_outlined,

                            size: 15,

                            color: colorScheme.onSurfaceVariant,
                          ),

                          const SizedBox(width: 5),

                          Text(
                            'Secure HRMS Portal',

                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // =================================================
                      // VERSION
                      // =================================================
                      Text(
                        'Version 0.1.0',

                        textAlign: TextAlign.center,

                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

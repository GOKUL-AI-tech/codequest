import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/neon_button.dart';
import '../../widgets/common/neon_text_field.dart';
import '../../widgets/common/cyber_snackbar.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      CyberSnackbar.showError(context, 'Please agree to the terms & conditions');
      return;
    }

    setState(() => _isLoading = true);

    final result = await ref.read(authProvider.notifier).signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      username: _usernameController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.isSuccess) {
      CyberSnackbar.showSuccess(context, 'Account created! Welcome to CodeQuest!');
      context.go(AppRoutes.home);
    } else {
      CyberSnackbar.showError(context, result.errorMessage ?? 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Back button
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: context.cqCardSecondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.cqSurface),
                        ),
                        child: Icon(Icons.arrow_back_ios_new,
                          color: context.cqTextPrimary, size: 18),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'CREATE\nACCOUNT',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: context.cqTextPrimary,
                        height: 1.2,
                        letterSpacing: 1.5,
                      ),
                    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.3),

                    SizedBox(height: 6),

                    Text(
                      'Join millions of coders on CodeQuest',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 15,
                        color: context.cqTextSecondary,
                      ),
                    ).animate(delay: 150.ms).fadeIn(),

                    const SizedBox(height: 36),

                    // Username
                    NeonTextField(
                      controller: _usernameController,
                      label: 'USERNAME',
                      hint: 'Choose your username',
                      prefixIcon: Icons.person_outline,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Username is required';
                        if (v.length < 3) return 'At least 3 characters';
                        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v)) {
                          return 'Only letters, numbers, underscores';
                        }
                        return null;
                      },
                    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2),

                    const SizedBox(height: 16),

                    // Email
                    NeonTextField(
                      controller: _emailController,
                      label: 'EMAIL',
                      hint: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2),

                    const SizedBox(height: 16),

                    // Password
                    NeonTextField(
                      controller: _passwordController,
                      label: 'PASSWORD',
                      hint: 'Create a strong password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: context.cqTextMuted, size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 8) return 'At least 8 characters';
                        if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Include an uppercase letter';
                        if (!RegExp(r'[0-9]').hasMatch(v)) return 'Include a number';
                        return null;
                      },
                    ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2),

                    const SizedBox(height: 16),

                    // Confirm Password
                    NeonTextField(
                      controller: _confirmPasswordController,
                      label: 'CONFIRM PASSWORD',
                      hint: 'Repeat your password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscureConfirm,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: context.cqTextMuted, size: 20,
                        ),
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      validator: (v) {
                        if (v != _passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2),

                    const SizedBox(height: 20),

                    // Terms checkbox
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _agreedToTerms ? AppColors.neonCyan : context.cqSurface,
                                width: 2,
                              ),
                              color: _agreedToTerms ? AppColors.neonCyan.withOpacity(0.2) : Colors.transparent,
                            ),
                            child: _agreedToTerms
                                ? const Icon(Icons.check, color: AppColors.neonCyan, size: 16)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14),
                              children: [
                                TextSpan(text: 'I agree to the ', style: TextStyle(color: context.cqTextSecondary)),
                                TextSpan(text: 'Terms of Service', style: TextStyle(color: AppColors.neonCyan)),
                                TextSpan(text: ' and ', style: TextStyle(color: context.cqTextSecondary)),
                                TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColors.neonCyan)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).animate(delay: 600.ms).fadeIn(),

                    const SizedBox(height: 28),

                    // Register button
                    NeonButton(
                      label: 'CREATE ACCOUNT',
                      onTap: _register,
                      isLoading: _isLoading,
                      gradient: AppColors.cyberpunkGradient,
                      glowColor: AppColors.neonCyan,
                    ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.2),

                    const SizedBox(height: 24),

                    Center(
                      child: TextButton(
                        onPressed: () => context.go(AppRoutes.login),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontFamily: 'Rajdhani', fontSize: 16),
                            children: [
                              TextSpan(text: 'Already have an account? ', style: TextStyle(color: context.cqTextSecondary)),
                              TextSpan(text: 'Login', style: TextStyle(color: AppColors.neonCyan, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ).animate(delay: 800.ms).fadeIn(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.neonPurple.withOpacity(0.1), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          right: -40,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.neonGreen.withOpacity(0.06), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

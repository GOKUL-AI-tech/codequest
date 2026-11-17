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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final result = await ref.read(authProvider.notifier).signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.isSuccess) {
      context.go(AppRoutes.home);
    } else {
      CyberSnackbar.showError(context, result.errorMessage ?? 'Login failed');
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    final result = await ref.read(authProvider.notifier).signInWithGoogle();
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.isSuccess) {
      context.go(AppRoutes.home);
    } else {
      CyberSnackbar.showError(context, result.errorMessage ?? 'Google login failed');
    }
  }

  Future<void> _loginWithGithub() async {
    setState(() => _isLoading = true);
    final result = await ref.read(authProvider.notifier).signInWithGitHub();
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.isSuccess) {
      context.go(AppRoutes.home);
    } else {
      CyberSnackbar.showError(context, result.errorMessage ?? 'GitHub login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background decoration
          _buildBackground(),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),

                    // Logo + title
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: AppColors.cyberpunkGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.neonCyan.withOpacity(0.3),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text('</>',
                                style: TextStyle(
                                  fontFamily: 'Share Tech Mono',
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                          const SizedBox(height: 20),
                          ShaderMask(
                            shaderCallback: (b) => AppColors.cyberpunkGradient.createShader(b),
                            child: const Text(
                              'CODEQUEST',
                              style: TextStyle(
                                fontFamily: 'Orbitron',
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 4,
                              ),
                            ),
                          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Welcome text
                    Text(
                      'WELCOME BACK,\nCODER.',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: context.cqTextPrimary,
                        height: 1.3,
                        letterSpacing: 1,
                      ),
                    ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.3),

                    SizedBox(height: 4),

                    Text(
                      'Login to continue your mission',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 15,
                        color: context.cqTextSecondary,
                      ),
                    ).animate(delay: 400.ms).fadeIn(),

                    const SizedBox(height: 36),

                    // Email field
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
                    ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2),

                    const SizedBox(height: 16),

                    // Password field
                    NeonTextField(
                      controller: _passwordController,
                      label: 'PASSWORD',
                      hint: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: context.cqTextMuted,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),

                    const SizedBox(height: 12),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push(AppRoutes.forgotPassword),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.neonCyan,
                            fontFamily: 'Rajdhani',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login button
                    NeonButton(
                      label: 'LOGIN',
                      onTap: _login,
                      isLoading: _isLoading,
                      gradient: AppColors.cyberpunkGradient,
                      glowColor: AppColors.neonCyan,
                    ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.2),

                    SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: context.cqSurface)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: context.cqTextMuted,
                              fontFamily: 'Share Tech Mono',
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: context.cqSurface)),
                      ],
                    ).animate(delay: 800.ms).fadeIn(),

                    const SizedBox(height: 20),

                    // Social login buttons
                    Row(
                      children: [
                        Expanded(
                          child: _SocialButton(
                            label: 'Google',
                            emoji: '🔍',
                            onTap: _loginWithGoogle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SocialButton(
                            label: 'GitHub',
                            emoji: '🐙',
                            onTap: _loginWithGithub,
                          ),
                        ),
                      ],
                    ).animate(delay: 900.ms).fadeIn(),

                    const SizedBox(height: 32),

                    // Register link
                    Center(
                      child: TextButton(
                        onPressed: () => context.go(AppRoutes.register),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontFamily: 'Rajdhani', fontSize: 16),
                            children: [
                              TextSpan(text: "New to CodeQuest? ", style: TextStyle(color: context.cqTextSecondary)),
                              TextSpan(
                                text: 'Create Account',
                                style: TextStyle(
                                  color: AppColors.neonCyan,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate(delay: 1000.ms).fadeIn(),

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
          top: -120,
          right: -80,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.neonPurple.withOpacity(0.12), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.neonCyan.withOpacity(0.08), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String emoji;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: context.cqCardSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.cqSurface),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.cqTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

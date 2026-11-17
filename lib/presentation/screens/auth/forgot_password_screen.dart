import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/neon_button.dart';
import '../../widgets/common/neon_text_field.dart';
import '../../widgets/common/cyber_snackbar.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => context.pop())),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('RESET\nPASSWORD', style: TextStyle(fontFamily: 'Orbitron', fontSize: 28, fontWeight: FontWeight.w800, color: context.cqTextPrimary, height: 1.2)).animate().fadeIn().slideX(begin: -0.3),
            SizedBox(height: 8),
            Text(_sent ? 'Check your email for the reset link' : 'Enter your email and we\'ll send a reset link', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 15, color: context.cqTextSecondary)),
            const SizedBox(height: 40),
            if (!_sent) ...[
              NeonTextField(controller: _emailController, label: 'EMAIL', hint: 'Enter your email', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 28),
              NeonButton(label: 'SEND RESET LINK', onTap: () async {
                setState(() => _isLoading = true);
                final res = await ref.read(authProvider.notifier).resetPassword(_emailController.text.trim());
                setState(() { _isLoading = false; if (res.isSuccess) _sent = true; });
                if (!res.isSuccess && mounted) CyberSnackbar.showError(context, res.errorMessage ?? 'Failed');
              }, isLoading: _isLoading, gradient: AppColors.cyberpunkGradient, glowColor: AppColors.neonCyan),
            ] else ...[
              const Text('✅', style: TextStyle(fontSize: 80)).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 24),
              NeonButton(label: 'BACK TO LOGIN', onTap: () => context.pop(), gradient: AppColors.cyberpunkGradient, glowColor: AppColors.neonCyan),
            ],
          ],
        ),
      ),
    );
  }
}

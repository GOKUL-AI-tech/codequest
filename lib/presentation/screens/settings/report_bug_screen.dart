import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/cyber_snackbar.dart';
import '../../widgets/common/neon_text_field.dart';

class ReportBugScreen extends ConsumerStatefulWidget {
  const ReportBugScreen({super.key});

  @override
  ConsumerState<ReportBugScreen> createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends ConsumerState<ReportBugScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _stepsController = TextEditingController();
  final _emailController = TextEditingController();

  String _selectedCategory = 'Crash / App freezing';
  String _selectedSeverity = 'Medium';
  bool _isSubmitting = false;
  bool _submitted = false;

  static const _categories = [
    'Crash / App freezing',
    'Login / Account issue',
    'Lesson / Quiz bug',
    'Coding challenge issue',
    'AI Mentor not responding',
    'Leaderboard / XP error',
    'Notification problem',
    'UI / Display glitch',
    'Other',
  ];

  static const _severities = ['Low', 'Medium', 'High', 'Critical'];

  static const _severityColors = {
    'Low': AppColors.neonGreen,
    'Medium': AppColors.neonYellow,
    'High': AppColors.neonOrange,
    'Critical': AppColors.neonPink,
  };

  @override
  void initState() {
    super.initState();
    final email = Supabase.instance.client.auth.currentUser?.email ?? '';
    _emailController.text = email;
  }

  @override
  void dispose() {
    _descController.dispose();
    _stepsController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      await Supabase.instance.client.from('bug_reports').insert({
        'user_id': userId,
        'email': _emailController.text.trim(),
        'category': _selectedCategory,
        'severity': _selectedSeverity,
        'description': _descController.text.trim(),
        'steps_to_reproduce': _stepsController.text.trim(),
        'created_at': DateTime.now().toIso8601String(),
      });
      setState(() => _submitted = true);
    } catch (e) {
      if (mounted) {
        CyberSnackbar.showError(context, 'Failed to submit. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REPORT A BUG'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _submitted ? _buildSuccess() : _buildForm(),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🐛', style: TextStyle(fontSize: 64))
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            const Text(
              'Bug Reported!',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.neonGreen,
              ),
            ).animate(delay: 200.ms).fadeIn(),
            const SizedBox(height: 12),
            Text(
              'Thanks for helping make CodeQuest better. Our team will investigate and fix it ASAP.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 15,
                color: context.cqTextSecondary,
                height: 1.6,
              ),
            ).animate(delay: 300.ms).fadeIn(),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.neonCyan),
                ),
                child: const Text(
                  'GO BACK',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neonCyan,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ).animate(delay: 400.ms).fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.neonOrange.withOpacity(0.07),
              border: Border.all(color: AppColors.neonOrange.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                Icon(Icons.bug_report_outlined, color: AppColors.neonOrange, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Detailed reports help us fix bugs faster. Include steps to reproduce when possible.',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 13,
                      color: context.cqTextSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),

          // Category
          _SectionLabel(label: 'BUG CATEGORY'),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedCategory,
            items: _categories,
            onChanged: (v) => setState(() => _selectedCategory = v!),
          ).animate(delay: 100.ms).fadeIn(),

          const SizedBox(height: 20),

          // Severity
          _SectionLabel(label: 'SEVERITY'),
          const SizedBox(height: 8),
          Row(
            children: _severities.map((s) {
              final isSelected = _selectedSeverity == s;
              final color = _severityColors[s]!;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedSeverity = s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isSelected ? color.withOpacity(0.2) : context.cqCard,
                      border: Border.all(
                        color: isSelected ? color : context.cqSurface,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      s,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? color : context.cqTextMuted,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ).animate(delay: 150.ms).fadeIn(),

          const SizedBox(height: 20),

          // Description
          _SectionLabel(label: 'DESCRIPTION *'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descController,
            maxLines: 5,
            style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14, color: context.cqTextPrimary),
            decoration: InputDecoration(
              hintText: 'Describe what happened…',
              hintStyle: TextStyle(color: context.cqTextMuted, fontFamily: 'Rajdhani'),
              filled: true,
              fillColor: context.cqCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2A3550)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2A3550)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.neonCyan, width: 2),
              ),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Please describe the bug' : null,
          ).animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 20),

          // Steps
          _SectionLabel(label: 'STEPS TO REPRODUCE (OPTIONAL)'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _stepsController,
            maxLines: 4,
            style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14, color: context.cqTextPrimary),
            decoration: InputDecoration(
              hintText: '1. Open the app\n2. Go to…\n3. Tap…',
              hintStyle: TextStyle(color: context.cqTextMuted, fontFamily: 'Rajdhani'),
              filled: true,
              fillColor: context.cqCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2A3550)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2A3550)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.neonCyan, width: 2),
              ),
            ),
          ).animate(delay: 250.ms).fadeIn(),

          const SizedBox(height: 20),

          // Email
          _SectionLabel(label: 'YOUR EMAIL (FOR FOLLOW-UP)'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14, color: context.cqTextPrimary),
            decoration: InputDecoration(
              hintText: 'email@example.com',
              hintStyle: TextStyle(color: context.cqTextMuted, fontFamily: 'Rajdhani'),
              prefixIcon: Icon(Icons.email_outlined, color: context.cqTextMuted, size: 18),
              filled: true,
              fillColor: context.cqCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2A3550)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2A3550)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.neonCyan, width: 2),
              ),
            ),
          ).animate(delay: 300.ms).fadeIn(),

          const SizedBox(height: 32),

          // Submit button
          GestureDetector(
            onTap: _isSubmitting ? null : _submit,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: _isSubmitting
                    ? null
                    : LinearGradient(
                        colors: [AppColors.neonOrange, AppColors.neonPink],
                      ),
                color: _isSubmitting ? context.cqCard : null,
              ),
              child: Center(
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.neonCyan,
                        ),
                      )
                    : const Text(
                        'SUBMIT BUG REPORT',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
              ),
            ),
          ).animate(delay: 350.ms).fadeIn(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      {required String value,
      required List<String> items,
      required void Function(String?) onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.cqCard,
        border: Border.all(color: Color(0xFF2A3550)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: context.cqCard,
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 14,
            color: context.cqTextPrimary,
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: context.cqTextMuted),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Share Tech Mono',
        fontSize: 11,
        color: context.cqTextMuted,
        letterSpacing: 1.5,
      ),
    );
  }
}

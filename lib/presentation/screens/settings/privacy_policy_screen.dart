import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const _lastUpdated = 'Last updated: May 2025';

  static const _sections = [
    _PolicySection(
      title: '1. Information We Collect',
      body:
          'We collect information you provide directly, such as your name, email address, and username when you create an account. We also collect usage data including your learning progress, XP, achievements, and in-app activity to personalise your experience.\n\n'
          'When you use CodeQuest, we automatically collect certain technical data such as your device type, operating system, app version, and IP address for security and analytics purposes.',
    ),
    _PolicySection(
      title: '2. How We Use Your Information',
      body:
          'We use your information to:\n'
          '• Provide, maintain, and improve CodeQuest services\n'
          '• Personalise your learning experience and track progress\n'
          '• Send you streak reminders and mission notifications (which you can disable)\n'
          '• Respond to your support requests and bug reports\n'
          '• Detect and prevent fraud, abuse, and security issues\n'
          '• Analyse usage patterns to improve the app',
    ),
    _PolicySection(
      title: '3. Data Storage & Security',
      body:
          'Your data is stored securely using Supabase, hosted on AWS infrastructure with industry-standard encryption (AES-256 at rest, TLS in transit). We apply row-level security policies so users can only access their own data.\n\n'
          'We retain your account data for as long as your account is active. You may request deletion at any time by contacting support@codequest.app.',
    ),
    _PolicySection(
      title: '4. Sharing Your Information',
      body:
          'We do not sell, trade, or rent your personal information to third parties.\n\n'
          'We may share data with trusted service providers (e.g., Supabase for database, OpenAI for AI Mentor) solely to operate the service. These providers are bound by confidentiality agreements and may not use your data for any other purpose.\n\n'
          'We may disclose information if required by law or to protect the rights and safety of CodeQuest and its users.',
    ),
    _PolicySection(
      title: '5. AI Mentor Data',
      body:
          'When you chat with ALEX (the AI Mentor), your messages are sent to an AI provider (OpenAI or Google Gemini) to generate responses. Do not share sensitive personal information in your AI Mentor chats.\n\n'
          'Conversation history is stored in your account to maintain context across sessions. You can clear your conversation history at any time from the AI Mentor screen.',
    ),
    _PolicySection(
      title: '6. Leaderboard & Public Data',
      body:
          'Your username, character, rank, level, and XP are visible to other users on the leaderboard, guild pages, and battle screens. Your email address is never displayed publicly.\n\n'
          'You can adjust your visibility settings in your Profile settings.',
    ),
    _PolicySection(
      title: '7. Children\'s Privacy',
      body:
          'CodeQuest is intended for users aged 13 and older. We do not knowingly collect personal information from children under 13. If you believe a child under 13 has created an account, please contact us immediately at support@codequest.app and we will delete the account.',
    ),
    _PolicySection(
      title: '8. Your Rights',
      body:
          'Depending on your location, you may have rights including:\n'
          '• Access: Request a copy of the data we hold about you\n'
          '• Correction: Request correction of inaccurate data\n'
          '• Deletion: Request deletion of your account and data\n'
          '• Portability: Request your data in a machine-readable format\n\n'
          'To exercise any of these rights, contact us at support@codequest.app.',
    ),
    _PolicySection(
      title: '9. Cookies & Local Storage',
      body:
          'The app uses local storage (Hive) to cache your profile, settings, and offline progress on your device. This data stays on your device and is not sent to third parties. You can clear this data by uninstalling the app.',
    ),
    _PolicySection(
      title: '10. Changes to This Policy',
      body:
          'We may update this Privacy Policy from time to time. We will notify you of significant changes via in-app notification or email. Continued use of CodeQuest after changes constitutes acceptance of the updated policy.',
    ),
    _PolicySection(
      title: '11. Contact Us',
      body:
          'If you have questions about this Privacy Policy or how we handle your data, please contact us:\n\n'
          'Email: support@codequest.app\n'
          'Website: www.codequest.app/privacy',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRIVACY POLICY'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: context.cqCard,
              border: Border.all(color: context.cqSurface),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.neonCyan.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.privacy_tip_outlined,
                      color: AppColors.neonCyan, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CodeQuest Privacy Policy',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: context.cqTextPrimary,
                        ),
                      ),
                      Text(
                        _lastUpdated,
                        style: TextStyle(
                          fontFamily: 'Share Tech Mono',
                          fontSize: 11,
                          color: context.cqTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),

          // Intro
          Text(
            'At CodeQuest, your privacy matters. This policy explains what data we collect, how we use it, and your rights as a user.',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 14,
              color: context.cqTextSecondary,
              height: 1.7,
            ),
          ).animate(delay: 100.ms).fadeIn(),

          const SizedBox(height: 24),

          // Sections
          ..._sections.asMap().entries.map((e) => _PolicyBlock(
                section: e.value,
                delay: (e.key * 40).ms,
              )),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _PolicyBlock extends StatelessWidget {
  final _PolicySection section;
  final Duration delay;
  const _PolicyBlock({required this.section, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: context.cqCard,
          border: Border.all(color: context.cqSurface),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.title,
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.neonCyan,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              section.body,
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 14,
                color: context.cqTextSecondary,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: delay).fadeIn().slideY(begin: 0.05);
  }
}

class _PolicySection {
  final String title;
  final String body;
  const _PolicySection({required this.title, required this.body});
}

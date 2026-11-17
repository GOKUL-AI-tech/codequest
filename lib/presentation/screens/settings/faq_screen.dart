import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const _faqs = [
    _FaqCategory(
      title: '🎮 Gameplay',
      items: [
        _FaqItem(
          q: 'How do I earn XP?',
          a: 'You earn XP by completing lessons, quizzes, coding challenges, and boss battles. Each activity awards a different amount of XP. Completing your daily missions and maintaining a streak also gives bonus XP.',
        ),
        _FaqItem(
          q: 'What are lives and how do I get more?',
          a: 'Lives limit how many mistakes you can make in quizzes and challenges. You start with 5 lives and lose one for each wrong answer. Lives refill by 1 every 30 minutes, or you can watch an ad or use coins to refill instantly. Premium members have unlimited lives.',
        ),
        _FaqItem(
          q: 'How does the streak system work?',
          a: 'Your streak counts consecutive days you complete at least one lesson. Missing a day resets your streak to 0. You\'ll get a reminder notification at 8 PM if you haven\'t studied yet that day.',
        ),
        _FaqItem(
          q: 'What is the specialty bonus?',
          a: 'Each character has a specialty language. When you complete lessons in your character\'s specialty language, you earn 25% bonus XP. Choose your character wisely!',
        ),
      ],
    ),
    _FaqCategory(
      title: '🏆 Arena & Battles',
      items: [
        _FaqItem(
          q: 'How do coding battles work?',
          a: 'In a battle, you and an opponent are given the same coding challenge. The first to submit a correct solution with the highest test-case score wins. Battles are real-time and timed.',
        ),
        _FaqItem(
          q: 'How do I find opponents to battle?',
          a: 'Go to the Arena tab and tap "Start Battle". You\'ll be matched with a player of similar rank. You can also challenge friends directly from their profile.',
        ),
      ],
    ),
    _FaqCategory(
      title: '🤖 AI Mentor',
      items: [
        _FaqItem(
          q: 'What can ALEX help me with?',
          a: 'ALEX (your AI mentor) can explain coding concepts, debug your code, suggest learning paths, answer programming questions, and give you personalised tips based on your progress.',
        ),
        _FaqItem(
          q: 'Is there a limit to AI Mentor messages?',
          a: 'Free users get 10 AI Mentor messages per day. Premium users get unlimited access to ALEX with no daily cap.',
        ),
      ],
    ),
    _FaqCategory(
      title: '💳 Premium & Billing',
      items: [
        _FaqItem(
          q: 'What does Premium include?',
          a: 'Premium gives you unlimited lives, unlimited AI Mentor access, 2× XP on all activities, exclusive arena modes, all character skins, advanced Code DNA analytics, and an ad-free experience.',
        ),
        _FaqItem(
          q: 'Can I cancel my subscription?',
          a: 'Yes. You can cancel anytime through your Google Play or App Store subscription settings. You\'ll continue to have Premium access until the end of your current billing period.',
        ),
        _FaqItem(
          q: 'Is there a free trial?',
          a: 'New users get a 7-day free trial of Premium on the yearly plan. No charge until the trial ends — cancel anytime before to avoid being billed.',
        ),
      ],
    ),
    _FaqCategory(
      title: '⚙️ Account & Technical',
      items: [
        _FaqItem(
          q: 'How do I reset my password?',
          a: 'On the login screen, tap "Forgot Password" and enter your email. You\'ll receive a reset link within a few minutes. Check your spam folder if it doesn\'t arrive.',
        ),
        _FaqItem(
          q: 'Can I use CodeQuest on multiple devices?',
          a: 'Yes. Your progress is synced to your account via Supabase. Simply log in with the same account on any device and your data will be up to date.',
        ),
        _FaqItem(
          q: 'How do I delete my account?',
          a: 'To delete your account, contact us at support@codequest.app. Account deletion is permanent and cannot be undone. All your progress and data will be removed.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HELP & FAQ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Search hint banner
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.neonCyan.withOpacity(0.07),
              border: Border.all(color: AppColors.neonCyan.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.help_outline, color: AppColors.neonCyan, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need more help?',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: context.cqTextPrimary,
                        ),
                      ),
                      Text(
                        'Contact us at support@codequest.app',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 12,
                          color: context.cqTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),

          ..._faqs.asMap().entries.map(
                (e) => _CategorySection(category: e.value, delay: (e.key * 80).ms),
              ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final _FaqCategory category;
  final Duration delay;
  const _CategorySection({required this.category, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.title,
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: context.cqTextPrimary,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: context.cqCard,
            border: Border.all(color: context.cqSurface),
          ),
          child: Column(
            children: category.items
                .map((item) => _FaqTile(item: item))
                .toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    ).animate(delay: delay).fadeIn().slideY(begin: 0.1);
  }
}

class _FaqTile extends StatefulWidget {
  final _FaqItem item;
  const _FaqTile({required this.item});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.item.q,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.cqTextPrimary,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down,
                      color: context.cqTextMuted, size: 20),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              widget.item.a,
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 14,
                color: context.cqTextSecondary,
                height: 1.6,
              ),
            ),
          ),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        if (widget.item != widget.item) // divider between items
          const Divider(height: 1, color: Color(0xFF1E2A3F)),
      ],
    );
  }
}

class _FaqCategory {
  final String title;
  final List<_FaqItem> items;
  const _FaqCategory({required this.title, required this.items});
}

class _FaqItem {
  final String q;
  final String a;
  const _FaqItem({required this.q, required this.a});
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class SkillLevelScreen extends StatefulWidget {
  const SkillLevelScreen({super.key});

  @override
  State<SkillLevelScreen> createState() => _SkillLevelScreenState();
}

class _SkillLevelScreenState extends State<SkillLevelScreen> {
  String _selected = 'beginner';

  static const _levels = [
    {
      'id': 'beginner',
      'label': 'BEGINNER',
      'emoji': '🌱',
      'desc': 'Start from scratch.\nLearn the absolute basics step by step.',
      'tags': ['Hello World', 'Variables', 'Data Types', 'Basic I/O'],
      'color': 0xFF00F5FF,
      'glow': 0xFF00C8FF,
    },
    {
      'id': 'intermediate',
      'label': 'INTERMEDIATE',
      'emoji': '⚡',
      'desc': 'You know the basics.\nDive into functions, loops & OOP.',
      'tags': ['Functions', 'OOP', 'Algorithms', 'Data Structures'],
      'color': 0xFF7B2FFF,
      'glow': 0xFF9D5FFF,
    },
    {
      'id': 'expert',
      'label': 'EXPERT',
      'emoji': '🔥',
      'desc': 'Challenge yourself.\nAdvanced concepts, patterns & optimisation.',
      'tags': ['Design Patterns', 'Concurrency', 'Optimization', 'System Design'],
      'color': 0xFFFF2D78,
      'glow': 0xFFFF5599,
    },
  ];

  Future<void> _continue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.kSkillLevel, _selected);
    if (mounted) context.go('/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Title
            Text(
              'YOUR SKILL LEVEL',
              style: const TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

            const SizedBox(height: 8),

            Text(
              'We\'ll tailor your learning path',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 16,
                color: context.cqTextSecondary,
              ),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: 40),

            // Level cards
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _levels.length,
                itemBuilder: (ctx, i) {
                  final level = _levels[i];
                  final isSelected = _selected == level['id'];
                  final color = Color(level['color'] as int);
                  final glow = Color(level['glow'] as int);
                  final tags = level['tags'] as List<String>;

                  return GestureDetector(
                    onTap: () => setState(() => _selected = level['id'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isSelected
                            ? color.withOpacity(0.12)
                            : context.cqCard,
                        border: Border.all(
                          color: isSelected ? color : context.cqTextMuted.withOpacity(0.2),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: glow.withOpacity(0.25), blurRadius: 20, spreadRadius: 2)]
                            : [],
                      ),
                      child: Row(
                        children: [
                          // Emoji + radio
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color.withOpacity(0.12),
                                  border: Border.all(color: color.withOpacity(0.4)),
                                ),
                                child: Center(
                                  child: Text(
                                    level['emoji'] as String,
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color,
                                  ),
                                  child: const Icon(Icons.check, size: 13, color: Colors.black),
                                ),
                            ],
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level['label'] as String,
                                  style: TextStyle(
                                    fontFamily: 'Orbitron',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected ? color : context.cqTextPrimary,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  level['desc'] as String,
                                  style: TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontSize: 13,
                                    color: context.cqTextSecondary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: tags.map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: color.withOpacity(0.1),
                                      border: Border.all(color: color.withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontFamily: 'Rajdhani',
                                        fontSize: 11,
                                        color: color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: Duration(milliseconds: i * 100)).fadeIn().slideX(begin: 0.15),
                  );
                },
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonCyan,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'START MY JOURNEY',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3),
          ],
        ),
      ),
    );
  }
}

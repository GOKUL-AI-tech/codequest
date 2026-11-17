import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

// ─── Specialty info data ──────────────────────────────────────────────────────

const _specialtyInfo = <String, Map<String, String>>{
  'Python': {
    'emoji': '🐍',
    'tagline': 'The Data Science King',
    'bonus': '+25% XP on all Python lessons',
    'why': 'Python is the #1 language for AI, data science, and automation. Beginner-friendly syntax means you level up faster.',
    'best_for': 'AI/ML, Web Scraping, Automation, Data Analysis',
    'difficulty': 'Beginner',
  },
  'JavaScript': {
    'emoji': '⚡',
    'tagline': 'The Web Everywhere Language',
    'bonus': '+25% XP on all JavaScript lessons',
    'why': 'JavaScript runs in every browser and on servers via Node.js. It\'s the most in-demand language for frontend & full-stack jobs.',
    'best_for': 'Web Apps, Frontend, React, Node.js backends',
    'difficulty': 'Beginner',
  },
  'Dart': {
    'emoji': '🎯',
    'tagline': 'Flutter\'s Native Tongue',
    'bonus': '+25% XP on all Dart lessons',
    'why': 'Dart powers Flutter — the fastest-growing mobile framework. One codebase for iOS, Android, Web and Desktop.',
    'best_for': 'Mobile Apps (Flutter), Cross-platform, Google ecosystem',
    'difficulty': 'Intermediate',
  },
  'Java': {
    'emoji': '☕',
    'tagline': 'The Enterprise Standard',
    'bonus': '+25% XP on all Java lessons',
    'why': 'Java is used in enterprise backends, Android apps, and is the go-to language for software engineering interviews at big tech.',
    'best_for': 'Android, Backend APIs, Big Tech Interviews, Enterprise',
    'difficulty': 'Intermediate',
  },
  'C++': {
    'emoji': '⚙️',
    'tagline': 'The Performance Champion',
    'bonus': '+25% XP on all C++ lessons',
    'why': 'C++ is used in game engines (Unreal), operating systems, and competitive programming. Mastering it makes every other language easier.',
    'best_for': 'Game Development, Systems Programming, Competitive Coding',
    'difficulty': 'Advanced',
  },
  'C': {
    'emoji': '🔧',
    'tagline': 'The Foundation of Everything',
    'bonus': '+25% XP on all C lessons',
    'why': 'C is the mother of all languages. Linux, Python, and the entire internet were built on it. Knowing C means you understand how computers actually work.',
    'best_for': 'OS/Kernel, Embedded Systems, Firmware, Low-level mastery',
    'difficulty': 'Advanced',
  },
};

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.75);

  final List<Map<String, String>> _characters = AppConstants.characters;

  void _showSpecialtyInfo(BuildContext context, String specialty) {
    final info = _specialtyInfo[specialty];
    if (info == null) return;

    final diffColor = switch (info['difficulty']) {
      'Beginner' => AppColors.neonGreen,
      'Intermediate' => AppColors.neonOrange,
      _ => AppColors.neonPink,
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.fromLTRB(24, 20, 24, 32),
        decoration: BoxDecoration(
          color: context.cqCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.neonCyan.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonCyan.withOpacity(0.15),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: context.cqTextMuted.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Row(
              children: [
                Text(info['emoji']!,
                    style: const TextStyle(fontSize: 38)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        specialty,
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: context.cqTextPrimary,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        info['tagline']!,
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 14,
                          color: context.cqTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: diffColor.withOpacity(0.12),
                    border: Border.all(color: diffColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    info['difficulty']!,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 9,
                      color: diffColor,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // XP Bonus highlight
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [
                    AppColors.neonCyan.withOpacity(0.15),
                    AppColors.neonPurple.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                    color: AppColors.neonCyan.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('SPECIALTY BONUS',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 11,
                              color: AppColors.neonCyan,
                              letterSpacing: 1.5,
                            )),
                        const SizedBox(height: 3),
                        Text(
                          info['bonus']!,
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: context.cqTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Why this language
            _InfoRow(
              icon: '💡',
              label: 'WHY THIS LANGUAGE?',
              body: info['why']!,
            ),
            const SizedBox(height: 14),
            _InfoRow(
              icon: '🎯',
              label: 'BEST FOR',
              body: info['best_for']!,
            ),

            const SizedBox(height: 24),

            // CTA
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: AppColors.cyberpunkGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonCyan.withOpacity(0.3),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('GOT IT — KEEP BROWSING',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectCharacter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.kSelectedCharacter, _characters[_selectedIndex]['id']!);
    if (mounted) context.go(AppRoutes.skillLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Title
            Text(
              'CHOOSE YOUR\nCHARACTER',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 2,
                height: 1.2,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: -0.3),

            const SizedBox(height: 8),

            Text(
              'YOUR AVATAR REPRESENTS YOU IN BATTLE',
              style: TextStyle(
                fontFamily: 'Share Tech Mono',
                fontSize: 11,
                color: AppColors.neonCyan,
                letterSpacing: 2,
              ),
            )
                .animate(delay: 200.ms)
                .fadeIn(duration: 400.ms),

            const SizedBox(height: 40),

            // Character carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _selectedIndex = i),
                itemCount: _characters.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedIndex;
                  final char = _characters[index];
                  return AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    scale: isSelected ? 1.0 : 0.85,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isSelected ? 1.0 : 0.6,
                      child: _CharacterCard(
                        character: char,
                        isSelected: isSelected,
                        index: index,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Character info
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Padding(
                key: ValueKey(_selectedIndex),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Column(
                  children: [
                    Text(
                      _characters[_selectedIndex]['name']!,
                      style: const TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Specialty badge + info icon
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: AppColors.cyberpunkGradient,
                          ),
                          child: Text(
                            'SPECIALTY: ${_characters[_selectedIndex]['specialty']!}',
                            style: const TextStyle(
                              fontFamily: 'Share Tech Mono',
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showSpecialtyInfo(
                            context,
                            _characters[_selectedIndex]['specialty']!,
                          ),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.neonCyan.withOpacity(0.15),
                              border: Border.all(
                                color: AppColors.neonCyan.withOpacity(0.6),
                                width: 1.5,
                              ),
                            ),
                            child: const Center(
                              child: Text('ⓘ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.neonCyan,
                                  )),
                            ),
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .shimmer(
                                duration: 1800.ms,
                                color: AppColors.neonCyan.withOpacity(0.4)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Nudge text
                    GestureDetector(
                      onTap: () => _showSpecialtyInfo(
                        context,
                        _characters[_selectedIndex]['specialty']!,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome,
                              size: 12,
                              color: AppColors.neonCyan.withOpacity(0.7)),
                          const SizedBox(width: 5),
                          Text(
                            'Tap ⓘ to see what your specialty unlocks',
                            style: TextStyle(
                              fontFamily: 'Rajdhani',
                              fontSize: 12,
                              color: AppColors.neonCyan.withOpacity(0.7),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Dot indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_characters.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _selectedIndex ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: i == _selectedIndex ? AppColors.neonCyan : context.cqTextMuted,
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            // Select button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: GestureDetector(
                onTap: _selectCharacter,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: AppColors.cyberpunkGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonCyan.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'SELECT CHARACTER',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.bgDark,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final Map<String, String> character;
  final bool isSelected;
  final int index;

  const _CharacterCard({
    required this.character,
    required this.isSelected,
    required this.index,
  });

  static const List<List<Color>> _gradients = [
    [Color(0xFFBF00FF), Color(0xFF00F5FF)],
    [Color(0xFFFF6B00), Color(0xFFFF006E)],
    [Color(0xFF00B09B), Color(0xFF39FF14)],
    [Color(0xFF7B2FBE), Color(0xFF00B4DB)],
    [Color(0xFFFF006E), Color(0xFFBF00FF)],
    [Color(0xFF39FF14), Color(0xFF00F5FF)],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = _gradients[index % _gradients.length];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: isSelected ? colors : [context.cqCard, context.cqCardSecondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isSelected ? colors.first.withOpacity(0.6) : context.cqSurface,
          width: 2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colors.first.withOpacity(0.3),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Glow effect for selected
            if (isSelected)
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.last.withOpacity(0.15),
                  ),
                ),
              ),

            // Character content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Character placeholder (emoji avatar)
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _getCharEmoji(character['id']!),
                        style: const TextStyle(fontSize: 56),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: const Text(
                        'SELECTED',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 10,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCharEmoji(String id) {
    const emojis = {
      'cyber_ninja': '🥷',
      'code_warrior': '⚔️',
      'data_mage': '🧙',
      'algo_hunter': '🏹',
      'dev_phantom': '👻',
      'bug_slayer': '🐉',
    };
    return emojis[id] ?? '👾';
  }
}

// ─── Info Row helper ──────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String icon;
  final String label;
  final String body;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 9,
                  color: context.cqTextMuted,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 14,
                  color: context.cqTextSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';
import 'package:go_router/go_router.dart';

class WorldsScreen extends ConsumerWidget {
  const WorldsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('LEARNING WORLDS'),
            actions: [
              IconButton(
                icon: Icon(Icons.filter_list, color: context.cqTextSecondary),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Choose your path. Master the code.',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 16,
                  color: context.cqTextSecondary,
                ),
              ).animate().fadeIn(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.82,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final lang = AppConstants.languages[i];
                  // Read specialty — works even if still loading (defaults null)
                  final specialtyAsync = ref.watch(specialtyLanguageProvider);
                  final specialtyId = specialtyAsync.value;
                  final isSpecialty = specialtyId == lang['id'];
                  return _WorldCard(
                    language: lang,
                    index: i,
                    isSpecialty: isSpecialty,
                  )
                      .animate(delay: Duration(milliseconds: i * 80))
                      .fadeIn()
                      .scale(begin: const Offset(0.9, 0.9));
                },
                childCount: AppConstants.languages.length,
              ),
            ),
          ),
          // ── Special Modes ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Text(
                'SPECIAL MODES',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.cqTextMuted,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SpecialModeCard(
                  icon: '🐛',
                  title: 'Bug Hunt',
                  description: 'Find and fix bugs in broken code — builds real review skills',
                  gradient: const [Color(0xFFFF006E), Color(0xFF7B2FBE)],
                  tag: 'UNIQUE',
                  onTap: () => context.push(AppRoutes.bugHunt),
                ),
                const SizedBox(height: 10),
                _SpecialModeCard(
                  icon: '🌉',
                  title: 'Language Bridge',
                  description: 'Already know Python? Map your concepts to JS in hours, not weeks',
                  gradient: const [Color(0xFF00B09B), Color(0xFF00F5FF)],
                  tag: 'SMART',
                  onTap: () => context.push(AppRoutes.languageBridge),
                ),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _SpecialModeCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final List<Color> gradient;
  final String tag;
  final VoidCallback onTap;

  const _SpecialModeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [gradient[0].withOpacity(0.15), context.cqCard],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(color: gradient[0].withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(colors: gradient),
              ),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: context.cqTextPrimary,
                          )),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: gradient[0].withOpacity(0.2),
                        ),
                        child: Text(tag,
                            style: TextStyle(
                              fontFamily: 'Share Tech Mono',
                              fontSize: 8,
                              color: gradient[0],
                              letterSpacing: 1,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(description,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 13,
                        color: context.cqTextSecondary,
                      )),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: context.cqTextMuted, size: 16),
          ],
        ),
      ),
    );
  }
}

class _WorldCard extends StatelessWidget {
  final Map<String, dynamic> language;
  final int index;
  final bool isSpecialty;

  const _WorldCard({
    required this.language,
    required this.index,
    this.isSpecialty = false,
  });

  static const List<List<Color>> _gradients = [
    [Color(0xFF3572A5), Color(0xFF1A3A5C)],
    [Color(0xFFF7DF1E), Color(0xFF8B7D00)],
    [Color(0xFF00B4AB), Color(0xFF006B66)],
    [Color(0xFFB07219), Color(0xFF6B4200)],
    [Color(0xFFF34B7D), Color(0xFF8B0030)],
    [Color(0xFF555555), Color(0xFF222222)],
  ];

  @override
  Widget build(BuildContext context) {
    final color = Color(language['color'] as int);
    final gradient = _gradients[index % _gradients.length];

    return GestureDetector(
      onTap: () => context.push('/worlds/${language['id']}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isSpecialty
                ? [Color(0xFFBF00FF).withOpacity(0.2), context.cqCard]
                : [gradient[0].withOpacity(0.3), context.cqCard],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isSpecialty
                ? const Color(0xFFBF00FF).withOpacity(0.7)
                : color.withOpacity(0.3),
            width: isSpecialty ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSpecialty
                  ? const Color(0xFFBF00FF).withOpacity(0.3)
                  : color.withOpacity(0.15),
              blurRadius: isSpecialty ? 24 : 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background emoji glow
            Positioned(
              top: -10,
              right: -10,
              child: Text(
                language['icon'] as String,
                style: TextStyle(fontSize: 70, color: color.withOpacity(0.08)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Text(language['icon'] as String, style: const TextStyle(fontSize: 38)),

                  const SizedBox(height: 10),

                  // Name
                  Text(
                    language['name'] as String,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: context.cqTextPrimary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Difficulty badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: color.withOpacity(0.15),
                    ),
                    child: Text(
                      language['difficulty'] as String,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  Spacer(),

                  // Progress bar
                  Text(
                    '${language['levels']} Levels',
                    style: TextStyle(
                      fontFamily: 'Share Tech Mono',
                      fontSize: 10,
                      color: context.cqTextMuted,
                    ),
                  ),
                  SizedBox(height: 6),
                  LinearPercentIndicator(
                    lineHeight: 5,
                    percent: 0.0, // Will come from user progress
                    backgroundColor: context.cqSurface,
                    progressColor: color,
                    barRadius: const Radius.circular(3),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            // ── Specialty badge ──────────────────────────────────────────
            if (isSpecialty)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFBF00FF), Color(0xFF00F5FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFBF00FF).withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Text(
                    '⚡ YOURS',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true))
                    .shimmer(duration: 1800.ms, color: Colors.white.withOpacity(0.3)),
              )
            // ── Lock overlay for advanced langs ─────────────────────────
            else if (index > 1)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: context.cqBg.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: context.cqTextMuted,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

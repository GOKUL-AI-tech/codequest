import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';

// ══════════════════════════════════════════════════════════════════════════════
// CODE DNA — Unique Coding Fingerprint System
//
// PATENT-WORTHY: No competitor (Duolingo, LeetCode, HackerRank, Codecademy,
// SoloLearn, Codewars) tracks and visualises a user's STYLE fingerprint —
// they only measure correctness/speed. This system profiles HOW a user codes,
// not just WHAT they produce.
// ══════════════════════════════════════════════════════════════════════════════

// ─── DNA Trait Model ──────────────────────────────────────────────────────────

class _DnaTrait {
  final String label;
  final String description;
  final double score; // 0.0 – 1.0
  final Color color;
  final String emoji;
  final String interpretation;

  const _DnaTrait({
    required this.label,
    required this.description,
    required this.score,
    required this.color,
    required this.emoji,
    required this.interpretation,
  });
}

class _CodingArchetype {
  final String name;
  final String emoji;
  final String description;
  final Color color;

  const _CodingArchetype({
    required this.name,
    required this.emoji,
    required this.description,
    required this.color,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class CodeDnaScreen extends ConsumerStatefulWidget {
  const CodeDnaScreen({super.key});

  @override
  ConsumerState<CodeDnaScreen> createState() => _CodeDnaScreenState();
}

class _CodeDnaScreenState extends ConsumerState<CodeDnaScreen>
    with TickerProviderStateMixin {
  late AnimationController _dnaController;
  late AnimationController _radarController;
  bool _showDetail = false;
  int _selectedTrait = 0;

  // Simulated DNA traits derived from user's session data
  // In production these come from analysing keystroke timing, error patterns,
  // correction frequency, solution approach, variable naming, etc.
  final _traits = const [
    _DnaTrait(
      label: 'Problem Decomposition',
      description: 'How well you break problems into sub-steps before coding',
      score: 0.82,
      color: AppColors.neonCyan,
      emoji: '🧩',
      interpretation:
          'You\'re a natural planner. You tend to think before typing, which produces cleaner first attempts.',
    ),
    _DnaTrait(
      label: 'Error Recovery Speed',
      description: 'How quickly you identify and fix mistakes after a wrong answer',
      score: 0.67,
      color: AppColors.neonPurple,
      emoji: '🔧',
      interpretation:
          'You\'re above average at debugging. You typically fix errors within 2 attempts. Room to grow here.',
    ),
    _DnaTrait(
      label: 'Algorithm Intuition',
      description: 'Pattern recognition — choosing the right data structure first try',
      score: 0.74,
      color: AppColors.neonGreen,
      emoji: '⚡',
      interpretation:
          'Strong instincts. You reach for hashmaps and two-pointers in the right situations.',
    ),
    _DnaTrait(
      label: 'Code Readability',
      description: 'Variable naming quality, structure, and clarity of intent',
      score: 0.55,
      color: AppColors.neonOrange,
      emoji: '📖',
      interpretation:
          'Your logic is correct but variable names like "x", "temp2" make it harder to review. Try more descriptive names.',
    ),
    _DnaTrait(
      label: 'Edge Case Coverage',
      description: 'How often you voluntarily handle empty, null, or boundary inputs',
      score: 0.43,
      color: AppColors.neonPink,
      emoji: '🛡️',
      interpretation:
          'This is your biggest growth area. Most of your failures come from missing edge cases like empty arrays or overflow.',
    ),
    _DnaTrait(
      label: 'Consistency',
      description: 'Variance in performance across sessions — lower is more consistent',
      score: 0.78,
      color: AppColors.neonYellow,
      emoji: '📊',
      interpretation:
          'Highly consistent performer. Your scores don\'t swing wildly — you\'re reliable under pressure.',
    ),
  ];

  _CodingArchetype get _archetype {
    final avg = _traits.map((t) => t.score).reduce((a, b) => a + b) /
        _traits.length;
    if (_traits[0].score > 0.8 && _traits[2].score > 0.7) {
      return const _CodingArchetype(
        name: 'The Architect',
        emoji: '🏛️',
        description:
            'You plan before you type and choose elegant solutions. Strong foundation for systems design.',
        color: AppColors.neonCyan,
      );
    } else if (_traits[4].score < 0.5 && _traits[1].score > 0.6) {
      return const _CodingArchetype(
        name: 'The Speed Demon',
        emoji: '⚡',
        description:
            'Fast and fluent but sometimes misses edge cases in the rush. Perfect for competitive programming sprints.',
        color: AppColors.neonOrange,
      );
    } else if (_traits[3].score > 0.7) {
      return const _CodingArchetype(
        name: 'The Craftsman',
        emoji: '🔨',
        description:
            'You write code others love to read. Clean, clear, maintainable. Built for collaborative teams.',
        color: AppColors.neonGreen,
      );
    }
    return const _CodingArchetype(
      name: 'The Explorer',
      emoji: '🧭',
      description:
          'Balanced across all traits with clear growth paths ahead. The most common archetype — and the most flexible.',
      color: AppColors.neonPurple,
    );
  }

  @override
  void initState() {
    super.initState();
    _dnaController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _dnaController.dispose();
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildHeader()),

          // ── Archetype Card ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: _ArchetypeCard(archetype: _archetype),
            ),
          ),

          // ── Radar Chart ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('YOUR CODING FINGERPRINT',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 12,
                        color: context.cqTextMuted,
                        letterSpacing: 2,
                      )),
                  const SizedBox(height: 16),
                  Center(
                    child: AnimatedBuilder(
                      animation: _radarController,
                      builder: (_, __) => CustomPaint(
                        size: const Size(280, 280),
                        painter: _RadarPainter(
                          traits: _traits,
                          progress: _radarController.value,
                          surfaceColor: context.cqSurface,
                          selectedIndex: _selectedTrait,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Tap a trait bar below to see details',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 12,
                        color: context.cqTextMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Trait Bars ────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => GestureDetector(
                  onTap: () => setState(() {
                    _selectedTrait = i;
                    _showDetail = true;
                  }),
                  child: _TraitBar(
                    trait: _traits[i],
                    index: i,
                    isSelected: _selectedTrait == i && _showDetail,
                  ).animate(delay: Duration(milliseconds: 100 + i * 80))
                      .fadeIn()
                      .slideX(begin: 0.1),
                ),
                childCount: _traits.length,
              ),
            ),
          ),

          // ── Selected Trait Detail ─────────────────────────────────────────
          if (_showDetail)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: _TraitDetail(trait: _traits[_selectedTrait])
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: 0.2),
              ),
            ),

          // ── Improvement Plan ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: _ImprovementPlan(traits: _traits),
            ),
          ),

          // ── DNA History ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
              child: _DnaHistory(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A1628), Color(0xFF0D0A1E), Color(0xFF0A0E1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: AppColors.neonCyan, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (b) =>
                        AppColors.cyberpunkGradient.createShader(b),
                    child: const Text(
                      'CODE DNA',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  Text(
                    'Your unique coding fingerprint',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Animated DNA helix icon
              AnimatedBuilder(
                animation: _dnaController,
                builder: (_, __) => Transform.rotate(
                  angle: _dnaController.value * 2 * math.pi,
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.cyberpunkGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonCyan.withOpacity(0.4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🧬',
                          style: TextStyle(fontSize: 22)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Archetype Card ───────────────────────────────────────────────────────────

class _ArchetypeCard extends StatelessWidget {
  final _CodingArchetype archetype;
  const _ArchetypeCard({required this.archetype});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            archetype.color.withOpacity(0.2),
            context.cqCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: archetype.color.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: archetype.color.withOpacity(0.15),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: archetype.color.withOpacity(0.12),
              border: Border.all(color: archetype.color.withOpacity(0.5),
                  width: 2),
            ),
            child: Center(
              child: Text(archetype.emoji,
                  style: const TextStyle(fontSize: 34)),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .shimmer(duration: 2200.ms,
                  color: archetype.color.withOpacity(0.3)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('YOUR ARCHETYPE',
                    style: TextStyle(
                      fontFamily: 'Share Tech Mono',
                      fontSize: 10,
                      color: archetype.color,
                      letterSpacing: 2,
                    )),
                const SizedBox(height: 4),
                Text(archetype.name,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: archetype.color,
                      letterSpacing: 1,
                    )),
                const SizedBox(height: 6),
                Text(archetype.description,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 13,
                      color: context.cqTextSecondary,
                      height: 1.4,
                    )),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }
}

// ─── Trait Bar ────────────────────────────────────────────────────────────────

class _TraitBar extends StatelessWidget {
  final _DnaTrait trait;
  final int index;
  final bool isSelected;
  const _TraitBar(
      {required this.trait, required this.index, required this.isSelected});

  String get _level {
    if (trait.score >= 0.8) return 'EXPERT';
    if (trait.score >= 0.65) return 'STRONG';
    if (trait.score >= 0.5) return 'AVERAGE';
    return 'WEAK SPOT';
  }

  Color get _levelColor {
    if (trait.score >= 0.8) return AppColors.neonGreen;
    if (trait.score >= 0.65) return AppColors.neonCyan;
    if (trait.score >= 0.5) return AppColors.neonOrange;
    return AppColors.neonPink;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isSelected
            ? trait.color.withOpacity(0.08)
            : context.cqCard,
        border: Border.all(
          color: isSelected
              ? trait.color.withOpacity(0.5)
              : context.cqSurface,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(trait.emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(trait.label,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.cqTextPrimary,
                    )),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: _levelColor.withOpacity(0.12),
                ),
                child: Text(_level,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 8,
                      color: _levelColor,
                      letterSpacing: 1,
                    )),
              ),
              const SizedBox(width: 8),
              Text(
                '${(trait.score * 100).round()}',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: trait.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: trait.score),
            duration: Duration(milliseconds: 800 + index * 100),
            curve: Curves.easeOutCubic,
            builder: (_, val, __) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: val,
                backgroundColor: trait.color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation(trait.color),
                minHeight: 7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Trait Detail ─────────────────────────────────────────────────────────────

class _TraitDetail extends StatelessWidget {
  final _DnaTrait trait;
  const _TraitDetail({required this.trait});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: trait.color.withOpacity(0.06),
        border: Border.all(color: trait.color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(trait.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ALEX SAYS',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 9,
                      color: trait.color,
                      letterSpacing: 2,
                    )),
                const SizedBox(height: 5),
                Text(trait.interpretation,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 14,
                      color: context.cqTextPrimary,
                      height: 1.5,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Improvement Plan ────────────────────────────────────────────────────────

class _ImprovementPlan extends StatelessWidget {
  final List<_DnaTrait> traits;
  const _ImprovementPlan({required this.traits});

  @override
  Widget build(BuildContext context) {
    // Find 2 weakest traits
    final sorted = [...traits]..sort((a, b) => a.score.compareTo(b.score));
    final weak = sorted.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AI GROWTH PLAN',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 12,
              color: context.cqTextMuted,
              letterSpacing: 2,
            )),
        SizedBox(height: 6),
        Text(
          'Based on your DNA, ALEX recommends:',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 13,
            color: context.cqTextSecondary,
          ),
        ),
        const SizedBox(height: 14),
        ...weak.asMap().entries.map((e) {
          final actions = e.key == 0
              ? [
                  'Complete 3 "edge-case" focused challenges today',
                  'Enable "strict mode" quizzes (empty + null tests)',
                  'Join Bug Hunt mode to practise defensive coding',
                ]
              : [
                  'Review your last 5 submissions for naming patterns',
                  'Enable "Readability Coach" in settings',
                  'Take the Code Readability mini-course',
                ];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: context.cqCard,
              border:
                  Border.all(color: e.value.color.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(e.value.emoji,
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      'Improve ${e.value.label}',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: e.value.color,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...actions.map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('▸ ',
                              style: TextStyle(
                                color: e.value.color,
                                fontFamily: 'Orbitron',
                                fontSize: 10,
                              )),
                          Expanded(
                            child: Text(a,
                                style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 13,
                                  color: context.cqTextSecondary,
                                  height: 1.4,
                                )),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        }),
      ],
    ).animate(delay: 600.ms).fadeIn();
  }
}

// ─── DNA History ─────────────────────────────────────────────────────────────

class _DnaHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weeks = [
      {'label': '4w ago', 'score': 0.52},
      {'label': '3w ago', 'score': 0.58},
      {'label': '2w ago', 'score': 0.63},
      {'label': '1w ago', 'score': 0.67},
      {'label': 'Now', 'score': 0.74},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DNA EVOLUTION',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 12,
              color: context.cqTextMuted,
              letterSpacing: 2,
            )),
        SizedBox(height: 4),
        Text('Your overall coding score over time',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 13,
              color: context.cqTextSecondary,
            )),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: weeks.asMap().entries.map((e) {
            final score = e.value['score'] as double;
            final isNow = e.value['label'] == 'Now';
            return Expanded(
              child: Column(
                children: [
                  Text(
                    '${(score * 100).round()}',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isNow
                          ? AppColors.neonCyan
                          : context.cqTextMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: score),
                    duration: Duration(milliseconds: 600 + e.key * 120),
                    curve: Curves.easeOutCubic,
                    builder: (_, val, __) => Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 4),
                      height: val * 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: isNow
                            ? AppColors.cyberpunkGradient
                            : LinearGradient(
                                colors: [
                                  context.cqTextMuted.withOpacity(0.5),
                                  context.cqTextMuted.withOpacity(0.3),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    e.value['label'] as String,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 10,
                      color: isNow
                          ? AppColors.neonCyan
                          : context.cqTextMuted,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ).animate(delay: 800.ms).fadeIn();
  }
}

// ─── Radar Chart Painter ──────────────────────────────────────────────────────

class _RadarPainter extends CustomPainter {
  final List<_DnaTrait> traits;
  final double progress;
  final int selectedIndex;
  final Color surfaceColor;

  _RadarPainter(
      {required this.traits,
      required this.progress,
      required this.selectedIndex,
      required this.surfaceColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 24;
    final n = traits.length;

    // Draw grid rings
    for (int ring = 1; ring <= 4; ring++) {
      final ringRadius = radius * ring / 4;
      final gridPaint = Paint()
        ..color = surfaceColor.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      _drawPolygon(canvas, center, ringRadius, n, gridPaint);
    }

    // Draw axis lines
    for (int i = 0; i < n; i++) {
      final angle = (2 * math.pi * i / n) - math.pi / 2;
      final axisEnd =
          Offset(center.dx + radius * math.cos(angle),
              center.dy + radius * math.sin(angle));
      canvas.drawLine(
          center,
          axisEnd,
          Paint()
            ..color = surfaceColor.withOpacity(0.4)
            ..strokeWidth = 1);
    }

    // Draw filled radar shape
    final path = Path();
    for (int i = 0; i < n; i++) {
      final angle = (2 * math.pi * i / n) - math.pi / 2;
      final r = radius * traits[i].score * progress;
      final point = Offset(center.dx + r * math.cos(angle),
          center.dy + r * math.sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.neonCyan.withOpacity(0.12)
          ..style = PaintingStyle.fill);
    canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.neonCyan.withOpacity(0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    // Draw dots and labels
    for (int i = 0; i < n; i++) {
      final angle = (2 * math.pi * i / n) - math.pi / 2;
      final r = radius * traits[i].score * progress;
      final point =
          Offset(center.dx + r * math.cos(angle),
              center.dy + r * math.sin(angle));

      // Highlight selected
      final dotColor = i == selectedIndex
          ? traits[i].color
          : AppColors.neonCyan;
      final dotRadius = i == selectedIndex ? 7.0 : 5.0;

      canvas.drawCircle(
          point,
          dotRadius,
          Paint()
            ..color = dotColor
            ..style = PaintingStyle.fill);

      // Label
      final labelOffset = Offset(
          center.dx + (radius + 18) * math.cos(angle),
          center.dy + (radius + 18) * math.sin(angle));
      final tp = TextPainter(
        text: TextSpan(
          text: traits[i].emoji,
          style: TextStyle(fontSize: i == selectedIndex ? 18 : 14),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas,
          Offset(labelOffset.dx - tp.width / 2,
              labelOffset.dy - tp.height / 2));
    }
  }

  void _drawPolygon(
      Canvas canvas, Offset center, double radius, int sides, Paint paint) {
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final angle = (2 * math.pi * i / sides) - math.pi / 2;
      final point = Offset(center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) =>
      old.progress != progress || old.selectedIndex != selectedIndex;
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/lesson_model.dart';
import '../../providers/lessons_provider.dart';

// ─── Level metadata ───────────────────────────────────────────────────────────
const _levelMeta = [
  {
    'label': 'LEVEL 1',
    'sublabel': 'Beginner',
    'emoji': '🌱',
    'color': Color(0xFF00F5FF),
    'gradient': [Color(0xFF00F5FF), Color(0xFF00B4D8)],
    'lockedMsg': null,
  },
  {
    'label': 'LEVEL 2',
    'sublabel': 'Intermediate',
    'emoji': '⚡',
    'color': Color(0xFF7B2FFF),
    'gradient': [Color(0xFF7B2FFF), Color(0xFFBF00FF)],
    'lockedMsg': 'Complete all Level 1 chapters to unlock',
  },
  {
    'label': 'LEVEL 3',
    'sublabel': 'Expert',
    'emoji': '🔥',
    'color': Color(0xFFFF2D78),
    'gradient': [Color(0xFFFF2D78), Color(0xFFFF6B00)],
    'lockedMsg': 'Complete all Level 2 chapters to unlock',
  },
];

class ChaptersScreen extends ConsumerWidget {
  final String languageId;
  const ChaptersScreen({super.key, required this.languageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(chaptersProvider(languageId));
    final lang = AppConstants.languages.firstWhere(
      (l) => l['id'] == languageId,
      orElse: () => {'name': languageId, 'icon': '💻', 'color': 0xFF00F5FF},
    );
    final langColor = Color(lang['color'] as int);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.neonCyan),
              onPressed: () => context.pop(),
            ),
            title: Row(
              children: [
                Text(lang['icon'] as String, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Text(
                  (lang['name'] as String).toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(3),
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [langColor.withOpacity(0), langColor, langColor.withOpacity(0)],
                  ),
                ),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────────
          chaptersAsync.when(
            data: (chapters) {
              if (chapters.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🚧', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 16),
                        Text(
                          'CHAPTERS COMING SOON',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 16,
                            color: context.cqTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Content for ${lang['name']} is being built.',
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 14,
                            color: context.cqTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Group chapters by level (unlock_requirement)
              final grouped = <int, List<ChapterModel>>{0: [], 1: [], 2: []};
              for (final c in chapters) {
                grouped[c.unlockRequirement]!.add(c);
              }

              // Build a flat list of widgets (level headers + chapter cards)
              final items = <_LevelSection>[];
              for (int lvl = 0; lvl < 3; lvl++) {
                final levelChapters = grouped[lvl] ?? [];
                if (levelChapters.isNotEmpty) {
                  items.add(_LevelSection(
                    levelIndex: lvl,
                    chapters: levelChapters,
                    languageId: languageId,
                    langColor: langColor,
                  ));
                }
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => items[i].animate(
                      delay: Duration(milliseconds: i * 80),
                    ).fadeIn().slideY(begin: 0.1),
                    childCount: items.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.neonCyan),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off, color: context.cqTextMuted, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Could not load chapters',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 16,
                        color: context.cqTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.refresh(chaptersProvider(languageId)),
                      child: const Text(
                        'RETRY',
                        style: TextStyle(
                          color: AppColors.neonCyan,
                          fontFamily: 'Orbitron',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Level Section Widget ─────────────────────────────────────────────────────

class _LevelSection extends StatelessWidget {
  final int levelIndex;
  final List<ChapterModel> chapters;
  final String languageId;
  final Color langColor;

  const _LevelSection({
    required this.levelIndex,
    required this.chapters,
    required this.languageId,
    required this.langColor,
  });

  @override
  Widget build(BuildContext context) {
    final meta = _levelMeta[levelIndex];
    final color = meta['color'] as Color;
    final gradColors = meta['gradient'] as List<Color>;
    final levelLocked = chapters.every((c) => c.isLocked);
    final lockedMsg = meta['lockedMsg'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Level header ─────────────────────────────────────────────────
        Container(
          margin: const EdgeInsets.only(bottom: 12, top: 8),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: levelLocked
                  ? [context.cqCard, context.cqCardSecondary]
                  : [color.withOpacity(0.15), color.withOpacity(0.05)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            border: Border.all(
              color: levelLocked ? context.cqTextMuted.withOpacity(0.2) : color.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Level badge
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: levelLocked
                      ? null
                      : LinearGradient(
                          colors: gradColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  color: levelLocked ? context.cqSurface : null,
                  boxShadow: levelLocked
                      ? []
                      : [BoxShadow(color: color.withOpacity(0.4), blurRadius: 12)],
                ),
                child: Center(
                  child: levelLocked
                      ? Icon(Icons.lock_outline, color: context.cqTextMuted, size: 22)
                      : Text(
                          meta['emoji'] as String,
                          style: const TextStyle(fontSize: 24),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          meta['label'] as String,
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: levelLocked ? context.cqTextMuted : color,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: levelLocked
                                ? context.cqSurface
                                : color.withOpacity(0.15),
                            border: Border.all(
                              color: levelLocked
                                  ? context.cqTextMuted.withOpacity(0.3)
                                  : color.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            meta['sublabel'] as String,
                            style: TextStyle(
                              fontFamily: 'Rajdhani',
                              fontSize: 11,
                              color: levelLocked ? context.cqTextMuted : color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (levelLocked && lockedMsg != null)
                      Text(
                        lockedMsg,
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 12,
                          color: context.cqTextMuted,
                        ),
                      )
                    else
                      Text(
                        '${chapters.length} chapters · ${chapters.fold(0, (s, c) => s + c.totalLessons)} lessons',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 12,
                          color: color.withOpacity(0.8),
                        ),
                      ),
                  ],
                ),
              ),
              if (!levelLocked) ...[
                // Progress ring
                _ProgressRing(
                  chapters: chapters,
                  color: color,
                ),
              ],
            ],
          ),
        ),

        // ── Chapter cards ─────────────────────────────────────────────────
        ...List.generate(chapters.length, (i) {
          return _ChapterCard(
            chapter: chapters[i],
            index: i,
            levelColor: color,
            levelIndex: levelIndex,
          )
              .animate(delay: Duration(milliseconds: i * 60))
              .fadeIn(duration: 300.ms)
              .slideX(begin: 0.05);
        }),

        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── Progress ring ────────────────────────────────────────────────────────────

class _ProgressRing extends StatelessWidget {
  final List<ChapterModel> chapters;
  final Color color;
  const _ProgressRing({required this.chapters, required this.color});

  @override
  Widget build(BuildContext context) {
    final totalLessons = chapters.fold(0, (s, c) => s + c.totalLessons);
    final completedLessons = chapters.fold(0, (s, c) => s + c.completedLessons);
    final progress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation(color),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Chapter Card ─────────────────────────────────────────────────────────────

class _ChapterCard extends StatelessWidget {
  final ChapterModel chapter;
  final int index;
  final Color levelColor;
  final int levelIndex;

  const _ChapterCard({
    required this.chapter,
    required this.index,
    required this.levelColor,
    required this.levelIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = chapter.isLocked;
    final progress = chapter.completionPercentage;
    final isCompleted = chapter.isFullyCompleted;

    return GestureDetector(
      onTap: isLocked ? null : () => context.push('/chapters/${chapter.id}/lessons'),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isLocked
              ? context.cqCard.withOpacity(0.4)
              : context.cqCard,
          border: Border.all(
            color: isLocked
                ? context.cqTextMuted.withOpacity(0.15)
                : isCompleted
                    ? levelColor.withOpacity(0.5)
                    : levelColor.withOpacity(0.2),
            width: isCompleted ? 1.5 : 1,
          ),
          boxShadow: (!isLocked && !isCompleted)
              ? [
                  BoxShadow(
                    color: levelColor.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Chapter icon / number
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isLocked
                          ? context.cqSurface
                          : levelColor.withOpacity(0.12),
                      border: Border.all(
                        color: isLocked
                            ? context.cqTextMuted.withOpacity(0.2)
                            : levelColor.withOpacity(0.35),
                      ),
                    ),
                    child: Center(
                      child: isLocked
                          ? Icon(
                              Icons.lock_outline,
                              color: context.cqTextMuted,
                              size: 22,
                            )
                          : isCompleted
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color: levelColor,
                                  size: 26,
                                )
                              : Text(
                                  chapter.iconEmoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Text info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.title,
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isLocked
                                ? context.cqTextMuted
                                : context.cqTextPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          chapter.description,
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 12,
                            color: isLocked
                                ? context.cqTextMuted.withOpacity(0.5)
                                : context.cqTextSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book_outlined,
                              size: 12,
                              color: isLocked
                                  ? context.cqTextMuted.withOpacity(0.4)
                                  : levelColor.withOpacity(0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${chapter.completedLessons}/${chapter.totalLessons} lessons',
                              style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 11,
                                color: isLocked
                                    ? context.cqTextMuted.withOpacity(0.4)
                                    : levelColor.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (isCompleted) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: levelColor.withOpacity(0.15),
                                ),
                                child: Text(
                                  'DONE',
                                  style: TextStyle(
                                    fontFamily: 'Orbitron',
                                    fontSize: 9,
                                    color: levelColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Chevron or lock
                  if (!isLocked)
                    Icon(
                      Icons.chevron_right,
                      color: levelColor.withOpacity(0.7),
                    ),
                ],
              ),
            ),

            // Progress bar
            if (!isLocked && chapter.totalLessons > 0)
              Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 14).copyWith(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: levelColor.withOpacity(0.1),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(
                        colors: [levelColor.withOpacity(0.7), levelColor],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

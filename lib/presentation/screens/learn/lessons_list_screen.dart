import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/lesson_model.dart';
import '../../../domain/entities/lesson_entity.dart';
import '../../providers/lessons_provider.dart';

class LessonsListScreen extends ConsumerWidget {
  final String chapterId;
  const LessonsListScreen({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsProvider(chapterId));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.neonCyan),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'LESSONS',
              style: TextStyle(fontFamily: 'Orbitron', fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          lessonsAsync.when(
            data: (lessons) {
              if (lessons.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🚧', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 16),
                        Text('LESSONS COMING SOON',
                            style: TextStyle(fontFamily: 'Orbitron', fontSize: 16, color: context.cqTextSecondary)),
                        const SizedBox(height: 8),
                        Text('This chapter is being built.',
                            style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14, color: context.cqTextMuted)),
                      ],
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final lesson = lessons[i];
                      return _LessonCard(lesson: lesson, index: i)
                          .animate(delay: Duration(milliseconds: i * 60))
                          .fadeIn()
                          .slideX(begin: 0.1);
                    },
                    childCount: lessons.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: AppColors.neonCyan)),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off, color: context.cqTextMuted, size: 48),
                    const SizedBox(height: 12),
                    Text('Could not load lessons',
                        style: TextStyle(fontFamily: 'Rajdhani', fontSize: 16, color: context.cqTextSecondary)),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.refresh(lessonsProvider(chapterId)),
                      child: const Text('RETRY',
                          style: TextStyle(color: AppColors.neonCyan, fontFamily: 'Orbitron')),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final int index;
  const _LessonCard({required this.lesson, required this.index});

  IconData get _typeIcon {
    switch (lesson.type) {
      case LessonType.quiz: return Icons.quiz_outlined;
      case LessonType.coding: return Icons.code;
      case LessonType.bossBattle: return Icons.whatshot;
      default: return Icons.menu_book_outlined;
    }
  }

  Color get _typeColor {
    switch (lesson.type) {
      case LessonType.quiz: return AppColors.neonYellow;
      case LessonType.coding: return AppColors.neonGreen;
      case LessonType.bossBattle: return AppColors.neonPink;
      default: return AppColors.neonCyan;
    }
  }

  /// Route each lesson to the screen matching its type.
  /// Previously every lesson (quiz, coding, boss) opened the theory
  /// LessonScreen, which made different lessons look identical.
  void _open(BuildContext context) {
    switch (lesson.type) {
      case LessonType.quiz:
        context.push('/quiz/${lesson.id}');
        break;
      case LessonType.coding:
        context.push('/challenge/${lesson.id}');
        break;
      case LessonType.bossBattle:
        context.push('/boss-battle/${lesson.id}');
        break;
      default:
        context.push(
          '/lesson/${lesson.id}?lang=${lesson.languageId}&order=${lesson.order}',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLocked = lesson.isLocked;
    return GestureDetector(
      onTap: isLocked ? null : () => _open(context),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isLocked ? context.cqCard.withOpacity(0.4) : context.cqCard,
          border: Border.all(
            color: isLocked ? context.cqTextMuted.withOpacity(0.15) : _typeColor.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Number / lock
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLocked ? context.cqSurface : _typeColor.withOpacity(0.12),
                border: Border.all(color: isLocked ? context.cqTextMuted.withOpacity(0.2) : _typeColor.withOpacity(0.4)),
              ),
              child: Center(
                child: isLocked
                    ? Icon(Icons.lock_outline, color: context.cqTextMuted, size: 18)
                    : Icon(_typeIcon, color: _typeColor, size: 18),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isLocked ? context.cqTextMuted : context.cqTextPrimary,
                    ),
                  ),
                  if (lesson.description.isNotEmpty) ...[
                    SizedBox(height: 3),
                    Text(
                      lesson.description,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 12,
                        color: isLocked ? context.cqTextMuted.withOpacity(0.5) : context.cqTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Badge(label: '+${lesson.xpReward} XP', color: AppColors.neonGreen),
                      const SizedBox(width: 6),
                      _Badge(label: '+${lesson.coinReward} 🪙', color: AppColors.neonYellow),
                    ],
                  ),
                ],
              ),
            ),
            if (!isLocked)
              const Icon(Icons.play_circle_outline, color: AppColors.neonCyan, size: 26),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color.withOpacity(0.12),
      ),
      child: Text(label,
          style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }
}

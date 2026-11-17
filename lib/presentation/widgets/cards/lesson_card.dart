import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/lesson_model.dart';
import '../../../domain/entities/lesson_entity.dart';

class LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onTap;
  final bool isCompleted;
  final bool isLocked;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
    this.isCompleted = false,
    this.isLocked = false,
  });

  Color get _accentColor {
    switch (lesson.type) {
      case LessonType.quiz:
        return AppColors.neonPurple;
      case LessonType.coding:
        return AppColors.neonGreen;
      case LessonType.bossBattle:
        return AppColors.neonPink;
      default:
        return AppColors.neonCyan;
    }
  }

  String get _typeLabel {
    switch (lesson.type) {
      case LessonType.quiz:
        return 'QUIZ';
      case LessonType.coding:
        return 'CODE';
      case LessonType.bossBattle:
        return 'BOSS';
      default:
        return 'READ';
    }
  }

  String get _typeEmoji {
    switch (lesson.type) {
      case LessonType.quiz:
        return '❓';
      case LessonType.coding:
        return '💻';
      case LessonType.bossBattle:
        return '👾';
      default:
        return '📖';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Opacity(
        opacity: isLocked ? 0.5 : 1.0,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.neonGreen.withOpacity(0.05)
                : context.cqCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isCompleted
                  ? AppColors.neonGreen.withOpacity(0.3)
                  : context.cqSurface,
              width: 1,
            ),
            // Left accent bar via box shadow
          ),
          child: Row(
            children: [
              // Left accent bar
              Container(
                width: 3,
                height: 44,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.neonGreen : _accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),

              // Type emoji
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    isCompleted ? '✅' : _typeEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title & meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isCompleted
                            ? context.cqTextSecondary
                            : context.cqTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        // Type chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _typeLabel,
                            style: TextStyle(
                              fontFamily: 'Share Tech Mono',
                              fontSize: 9,
                              color: _accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.star, size: 10, color: AppColors.neonGold),
                        const SizedBox(width: 3),
                        Text(
                          '+${lesson.xpReward} XP',
                          style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 10,
                            color: AppColors.neonGold,
                          ),
                        ),
                        if (lesson.estimatedTime != null) ...[
                          SizedBox(width: 8),
                          Icon(Icons.timer,
                              size: 10, color: context.cqTextMuted),
                          const SizedBox(width: 3),
                          Text(
                            '${lesson.estimatedTime!.inMinutes}m',
                            style: TextStyle(
                              fontFamily: 'Share Tech Mono',
                              fontSize: 10,
                              color: context.cqTextMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Lock / chevron
              if (isLocked)
                Icon(Icons.lock, size: 18, color: context.cqTextMuted)
              else if (isCompleted)
                Icon(Icons.check_circle, size: 22, color: AppColors.neonGreen)
              else
                Icon(Icons.play_circle_outline,
                    size: 22, color: _accentColor),
            ],
          ),
        ),
      ),
    );
  }
}

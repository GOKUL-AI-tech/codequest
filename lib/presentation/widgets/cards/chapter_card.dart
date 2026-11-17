import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/lesson_model.dart';

class ChapterCard extends StatelessWidget {
  final ChapterModel chapter;
  final VoidCallback onTap;
  final bool isLocked;

  const ChapterCard({
    super.key,
    required this.chapter,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = chapter.completionPercentage;
    final isComplete = progress >= 1.0;

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isLocked ? context.cqBg : context.cqCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isComplete
                ? AppColors.neonGreen.withOpacity(0.5)
                : isLocked
                    ? context.cqSurface
                    : context.cqSurface,
            width: isComplete ? 1.5 : 1,
          ),
          boxShadow: isComplete
              ? [
                  BoxShadow(
                    color: AppColors.neonGreen.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Chapter icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: isLocked
                          ? LinearGradient(
                              colors: [context.cqSurface, context.cqSurface],
                            )
                          : AppColors.cyberpunkGradient,
                    ),
                    child: Center(
                      child: isLocked
                          ? Icon(Icons.lock, color: context.cqTextMuted, size: 22)
                          : Text(
                              chapter.iconEmoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Chapter title & meta
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.title,
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isLocked
                                ? context.cqTextMuted
                                : context.cqTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.bolt,
                                size: 12, color: AppColors.neonCyan),
                            const SizedBox(width: 4),
                            Text(
                              '${chapter.totalLessons} lessons',
                              style: TextStyle(
                                fontFamily: 'Share Tech Mono',
                                fontSize: 10,
                                color: context.cqTextMuted,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(Icons.star,
                                size: 12, color: AppColors.neonGold),
                            const SizedBox(width: 4),
                            Text(
                              '${chapter.totalLessons * 50} XP',
                              style: TextStyle(
                                fontFamily: 'Share Tech Mono',
                                fontSize: 10,
                                color: AppColors.neonGold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Completion badge / chevron
                  if (isComplete)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.neonGreen.withOpacity(0.2),
                        border: Border.all(
                          color: AppColors.neonGreen.withOpacity(0.6),
                        ),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.neonGreen,
                      ),
                    )
                  else
                    Icon(
                      Icons.chevron_right,
                      color: isLocked
                          ? context.cqSurface
                          : context.cqTextMuted,
                    ),
                ],
              ),

              if (!isLocked && chapter.totalLessons > 0) ...[
                const SizedBox(height: 12),
                // Progress bar
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        percent: progress.clamp(0.0, 1.0),
                        lineHeight: 6,
                        backgroundColor: context.cqSurface,
                        progressColor: isComplete
                            ? AppColors.neonGreen
                            : AppColors.neonCyan,
                        barRadius: const Radius.circular(4),
                        padding: EdgeInsets.zero,
                        animation: true,
                        animationDuration: 800,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontFamily: 'Share Tech Mono',
                        fontSize: 10,
                        color: isComplete
                            ? AppColors.neonGreen
                            : AppColors.neonCyan,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/achievement_entity.dart';

class MissionCard extends StatelessWidget {
  final DailyMission mission;
  const MissionCard({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final progress = mission.progressPercent;
    final isComplete = mission.isCompleted;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cqCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isComplete
              ? AppColors.neonGreen.withOpacity(0.4)
              : context.cqSurface,
        ),
        boxShadow: isComplete
            ? [
                BoxShadow(
                  color: AppColors.neonGreen.withOpacity(0.1),
                  blurRadius: 10,
                )
              ]
            : [],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isComplete
                  ? AppColors.neonGreen.withOpacity(0.15)
                  : context.cqCardSecondary,
            ),
            child: Center(
              child: Text(mission.iconEmoji, style: const TextStyle(fontSize: 22)),
            ),
          ),

          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        mission.title,
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isComplete ? AppColors.neonGreen : context.cqTextPrimary,
                        ),
                      ),
                    ),
                    if (isComplete)
                      const Icon(Icons.check_circle, color: AppColors.neonGreen, size: 20)
                    else
                      Text(
                        '${mission.currentCount}/${mission.requiredCount}',
                        style: TextStyle(
                          fontFamily: 'Share Tech Mono',
                          fontSize: 12,
                          color: context.cqTextMuted,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  mission.description,
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 13,
                    color: context.cqTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 6,
                        percent: isComplete ? 1.0 : progress,
                        backgroundColor: context.cqSurface,
                        linearGradient: LinearGradient(
                          colors: isComplete
                              ? [AppColors.neonGreen, AppColors.neonGreen]
                              : [AppColors.neonPurple, AppColors.neonCyan],
                        ),
                        barRadius: const Radius.circular(3),
                        padding: EdgeInsets.zero,
                        animation: true,
                        animationDuration: 600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Rewards
                    Text('⭐${mission.xpReward}', style: _rewardStyle(context)),
                    const SizedBox(width: 6),
                    Text('🪙${mission.coinReward}', style: _rewardStyle(context)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _rewardStyle(BuildContext context) {
    return TextStyle(
      fontFamily: 'Rajdhani',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: context.cqTextSecondary,
    );
  }
}

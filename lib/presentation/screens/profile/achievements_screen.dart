import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/missions_provider.dart';
import '../../../domain/entities/achievement_entity.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ACHIEVEMENTS')),
      body: achievementsAsync.when(
        data: (achievements) => _AchievementsList(achievements: achievements),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _AchievementsList extends StatelessWidget {
  final List<AchievementEntity> achievements;
  const _AchievementsList({required this.achievements});

  @override
  Widget build(BuildContext context) {
    final categories = AchievementCategory.values;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: categories.length,
      itemBuilder: (context, ci) {
        final cat = categories[ci];
        final catAch = achievements.where((a) => a.category == cat).toList();
        if (catAch.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cat.name.toUpperCase(), style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 11, color: context.cqTextMuted, letterSpacing: 2)),
            const SizedBox(height: 12),
            ...catAch.asMap().entries.map((e) {
              final a = e.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: context.cqCard,
                  border: Border.all(color: a.isUnlocked ? AppColors.neonYellow.withOpacity(0.3) : context.cqSurface),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: a.isUnlocked ? AppColors.neonYellow.withOpacity(0.15) : context.cqCardSecondary,
                      ),
                      child: Center(child: Text(
                        a.isUnlocked ? a.iconEmoji : '🔒',
                        style: const TextStyle(fontSize: 26),
                      )),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.title, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 15, fontWeight: FontWeight.bold, color: a.isUnlocked ? context.cqTextPrimary : context.cqTextMuted)),
                          Text(a.description, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12, color: context.cqTextMuted)),
                          if (!a.isUnlocked) ...[
                            SizedBox(height: 6),
                            LinearProgressIndicator(value: a.progress, backgroundColor: context.cqSurface, valueColor: AlwaysStoppedAnimation(AppColors.neonYellow), minHeight: 4),
                          ],
                        ],
                      ),
                    ),
                    if (a.isUnlocked) Column(children: [
                      Text('+${a.xpReward}', style: TextStyle(fontFamily: 'Orbitron', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.neonYellow)),
                      Text('XP', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 10, color: context.cqTextMuted)),
                    ]),
                  ],
                ),
              ).animate(delay: Duration(milliseconds: e.key * 40)).fadeIn().slideX(begin: 0.1);
            }).toList(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

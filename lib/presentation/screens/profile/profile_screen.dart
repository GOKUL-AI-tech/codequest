import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/missions_provider.dart';
import '../../widgets/game/activity_heatmap.dart';
import '../../../core/services/share_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileProvider);
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      body: userAsync.when(
        data: (user) => user != null
            ? CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _ProfileHeader(user: user)),
                  SliverToBoxAdapter(child: _StatsGrid(user: user)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: const ActivityHeatmap(),
                    ),
                  ),
                  SliverToBoxAdapter(child: _LanguageProgress()),
                  SliverToBoxAdapter(
                    child: achievementsAsync.when(
                      data: (achievements) => _AchievementsSection(
                        achievements: achievements.where((a) => a.isUnlocked).toList(),
                      ),
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                      child: Column(
                        children: [
                          _ProfileAction(
                            icon: Icons.biotech_outlined,
                            label: 'Code DNA',
                            sublabel: 'Your unique coding fingerprint',
                            color: AppColors.neonCyan,
                            onTap: () => context.push(AppRoutes.codeDna),
                          ),
                          const SizedBox(height: 8),
                          _ProfileAction(
                            icon: Icons.workspace_premium_outlined,
                            label: 'Certificates',
                            sublabel: 'View & share completion certificates',
                            color: AppColors.neonYellow,
                            onTap: () {
                              final favLang = userAsync.value?.favoriteLanguage ?? 'python';
                              context.push('/certificate/$favLang');
                            },
                          ),
                          const SizedBox(height: 8),
                          _ProfileAction(
                            icon: Icons.share_outlined,
                            label: 'Share My Streak',
                            sublabel: 'Show off your coding streak',
                            color: AppColors.neonOrange,
                            onTap: () {
                              userAsync.whenOrNull(data: (user) {
                                if (user != null) {
                                  ShareService.instance.shareStreak(streak: user.streak);
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          _ProfileAction(
                            icon: Icons.emoji_events_outlined,
                            label: 'Achievements',
                            sublabel: 'View all badges',
                            onTap: () => context.push(AppRoutes.achievements),
                          ),
                          const SizedBox(height: 8),
                          _ProfileAction(
                            icon: Icons.work_outline_rounded,
                            label: 'Opportunities',
                            sublabel: 'Interviews & projects unlocked by rank',
                            color: AppColors.neonYellow,
                            onTap: () => context.push(AppRoutes.opportunities),
                          ),
                          const SizedBox(height: 8),
                          _ProfileAction(
                            icon: Icons.shopping_bag_outlined,
                            label: 'Shop',
                            sublabel: 'Skins, themes, powerups',
                            onTap: () => context.push(AppRoutes.shop),
                          ),
                          const SizedBox(height: 8),
                          _ProfileAction(
                            icon: Icons.smart_toy_outlined,
                            label: 'AI Mentor',
                            sublabel: 'Chat with your coding guide',
                            onTap: () => context.push(AppRoutes.mentor),
                            color: AppColors.neonGreen,
                          ),
                          const SizedBox(height: 8),
                          _ProfileAction(
                            icon: Icons.settings_outlined,
                            label: 'Settings',
                            sublabel: 'Customize your experience',
                            onTap: () => context.push(AppRoutes.settings),
                          ),
                          const SizedBox(height: 8),
                          _ProfileAction(
                            icon: Icons.logout,
                            label: 'Sign Out',
                            sublabel: 'See you next time!',
                            color: AppColors.error,
                            onTap: () async {
                              await ref.read(authProvider.notifier).signOut();
                              if (context.mounted) context.go(AppRoutes.login);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Setting up your profile…',
                        style: TextStyle(color: context.cqTextSecondary)),
                  ],
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: AppColors.error))),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic user;
  const _ProfileHeader({required this.user});

  String _getCharEmoji(String id) {
    const emojis = {
      'cyber_ninja': '🥷', 'code_warrior': '⚔️',
      'data_mage': '🧙', 'algo_hunter': '🏹',
      'dev_phantom': '👻', 'bug_slayer': '🐉',
    };
    return emojis[id] ?? '👾';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 24),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        children: [
          // Avatar with level ring
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.cyberpunkGradient,
                  boxShadow: [BoxShadow(color: AppColors.neonCyan.withOpacity(0.4), blurRadius: 20)],
                ),
                child: Center(
                  child: Text(_getCharEmoji(user.characterId), style: const TextStyle(fontSize: 44)),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.neonCyan,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: context.cqBg, width: 2),
                  ),
                  child: Text(
                    'LVL ${user.level}',
                    style: TextStyle(fontFamily: 'Orbitron', fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.bgDark),
                  ),
                ),
              ),
            ],
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

          const SizedBox(height: 16),

          // Username
          Text(
            user.username.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ).animate(delay: 100.ms).fadeIn(),

          const SizedBox(height: 4),

          // Rank
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.15),
            ),
            child: Text(
              user.rank,
              style: const TextStyle(fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ).animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 16),

          // XP progress
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${user.xp} XP', style: const TextStyle(fontFamily: 'Share Tech Mono', fontSize: 12, color: Colors.white70)),
                  Text('${user.xpToNextLevel} to LVL ${user.level + 1}', style: const TextStyle(fontFamily: 'Share Tech Mono', fontSize: 12, color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 6),
              LinearPercentIndicator(
                lineHeight: 8,
                percent: user.levelProgress.clamp(0.0, 1.0),
                backgroundColor: Colors.white.withOpacity(0.2),
                linearGradient: const LinearGradient(colors: [AppColors.neonGreen, AppColors.neonCyan]),
                barRadius: const Radius.circular(4),
                padding: EdgeInsets.zero,
                animation: true,
                animationDuration: 800,
              ),
            ],
          ).animate(delay: 300.ms).fadeIn(),

          const SizedBox(height: 16),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _QuickStat(value: '${user.streak}', label: 'Streak', icon: '🔥'),
              _QuickStat(value: '${user.coins}', label: 'Coins', icon: '🪙'),
              _QuickStat(value: '${user.totalLessonsCompleted}', label: 'Lessons', icon: '📖'),
              _QuickStat(value: '${user.totalChallengesCompleted}', label: 'Solved', icon: '💻'),
            ],
          ).animate(delay: 400.ms).fadeIn(),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String value;
  final String label;
  final String icon;

  const _QuickStat({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontFamily: 'Orbitron', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(label, style: const TextStyle(fontFamily: 'Rajdhani', fontSize: 11, color: Colors.white70)),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final dynamic user;
  const _StatsGrid({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('STATS', style: TextStyle(fontFamily: 'Orbitron', fontSize: 13, fontWeight: FontWeight.bold, color: context.cqTextMuted, letterSpacing: 2)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: [
              _StatCard(label: 'Total XP', value: '${user.xp}', icon: '⭐', color: AppColors.neonYellow),
              _StatCard(label: 'Max Streak', value: '${user.streak}', icon: '🔥', color: AppColors.neonOrange),
              _StatCard(label: 'Battles Won', value: '24', icon: '⚔️', color: AppColors.neonPink),
              _StatCard(label: 'Rank Position', value: '#142', icon: '🏆', color: AppColors.neonCyan),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.cqCard,
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: TextStyle(fontFamily: 'Orbitron', fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                Text(label, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 11, color: context.cqTextMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const defaultProgress = <String, double>{
      'python': 0.75,
      'javascript': 0.40,
      'dart': 0.25,
      'html': 0.50,
      'css': 0.35,
      'sql': 0.15,
      'typescript': 0.20,
      'java': 0.10,
      'cpp': 0.05,
      'c': 0.05,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('LANGUAGE MASTERY', style: TextStyle(fontFamily: 'Orbitron', fontSize: 13, fontWeight: FontWeight.bold, color: context.cqTextMuted, letterSpacing: 2)),
          const SizedBox(height: 12),
          ...AppConstants.languages.map((lang) {
            final langId = (lang['id'] as String?) ?? '';
            final progress = (defaultProgress[langId] ?? 0.0).clamp(0.0, 1.0);
            final color = Color(lang['color'] as int);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Text(lang['icon'] as String, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(lang['name'] as String, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.w600, color: context.cqTextPrimary)),
                      ]),
                      Text('${(progress * 100).toInt()}%', style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 12, color: color)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearPercentIndicator(
                    lineHeight: 7,
                    percent: progress,
                    backgroundColor: context.cqSurface,
                    progressColor: color,
                    barRadius: const Radius.circular(4),
                    padding: EdgeInsets.zero,
                    animation: true,
                    animationDuration: 800,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AchievementsSection extends StatelessWidget {
  final List<dynamic> achievements;
  const _AchievementsSection({required this.achievements});

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ACHIEVEMENTS', style: TextStyle(fontFamily: 'Orbitron', fontSize: 13, fontWeight: FontWeight.bold, color: context.cqTextMuted, letterSpacing: 2)),
              TextButton(
                onPressed: () => context.push(AppRoutes.achievements),
                child: Text('SEE ALL →', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13, color: AppColors.neonCyan, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: achievements.take(8).map((a) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: context.cqCard,
                border: Border.all(color: AppColors.neonYellow.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(a.iconEmoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(a.title, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13, fontWeight: FontWeight.w600, color: context.cqTextPrimary)),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final VoidCallback onTap;
  final Color? color;

  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.cqTextSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: context.cqCard,
          border: Border.all(color: c.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: c.withOpacity(0.1),
              ),
              child: Icon(icon, color: c, size: 20),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 15, fontWeight: FontWeight.bold, color: c == context.cqTextSecondary ? context.cqTextPrimary : c)),
                  Text(sublabel, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12, color: context.cqTextMuted)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: context.cqTextMuted, size: 14),
          ],
        ),
      ),
    );
  }
}

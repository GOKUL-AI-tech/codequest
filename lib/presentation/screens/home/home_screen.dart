import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/missions_provider.dart';
import '../../widgets/game/xp_bar_widget.dart';
import '../../widgets/cards/mission_card.dart';
import '../../widgets/cards/language_card.dart';
import '../learn/daily_drop_screen.dart';
import '../../../core/utils/responsive.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileProvider);
    final missionsAsync = ref.watch(dailyMissionsProvider);

    // Tablet: two-column layout
    if (isTablet(context)) {
      return _TabletHomeLayout(userAsync: userAsync, missionsAsync: missionsAsync);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar / header
          SliverToBoxAdapter(
            child: _HomeHeader(userAsync: userAsync),
          ),

          // XP Progress section
          SliverToBoxAdapter(
            child: userAsync.when(
              data: (user) => user != null
                  ? _XpSection(user: user).animate().fadeIn(delay: 200.ms)
                  : const SizedBox(),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
          ),

          // Lives section
          SliverToBoxAdapter(
            child: userAsync.when(
              data: (user) => user != null
                  ? _LivesSection(lives: user.lives).animate().fadeIn(delay: 300.ms)
                  : const SizedBox(),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
          ),

          // Daily missions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DAILY MISSIONS',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: context.cqTextPrimary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.neonOrange.withOpacity(0.15),
                      border: Border.all(color: AppColors.neonOrange.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_outlined, color: AppColors.neonOrange, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'RESETS IN 6H',
                          style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 10,
                            color: AppColors.neonOrange,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate(delay: 400.ms).fadeIn(),
            ),
          ),

          // Missions list
          missionsAsync.when(
            data: (missions) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => Padding(
                  padding: EdgeInsets.fromLTRB(20, i == 0 ? 12 : 8, 20, 0),
                  child: MissionCard(mission: missions[i])
                      .animate(delay: Duration(milliseconds: 450 + i * 80))
                      .fadeIn()
                      .slideX(begin: 0.2),
                ),
                childCount: missions.length,
              ),
            ),
            loading: () => SliverToBoxAdapter(
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (e, s) => const SliverToBoxAdapter(child: SizedBox()),
          ),

          // Languages section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LEARNING PATHS',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: context.cqTextPrimary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.worlds),
                    child: Text(
                      'SEE ALL →',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 13,
                        color: AppColors.neonCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ).animate(delay: 700.ms).fadeIn(),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: AppConstants.languages.length,
                itemBuilder: (context, i) {
                  final lang = AppConstants.languages[i];
                  return Padding(
                    padding: EdgeInsets.only(right: 12, left: i == 0 ? 0 : 0),
                    child: LanguageCard(language: lang)
                        .animate(delay: Duration(milliseconds: 750 + i * 60))
                        .fadeIn()
                        .scale(begin: const Offset(0.9, 0.9)),
                  );
                },
              ),
            ),
          ),

          // Daily Code Drop card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: DailyDropHomeCard(
                onTap: () => context.push(AppRoutes.dailyDrop),
              ).animate(delay: 1050.ms).fadeIn().slideY(begin: 0.2),
            ),
          ),

          // Typing Race entry
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.typingRace),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0A1A2E), Color(0xFF0A1628)],
                    ),
                    border: Border.all(color: AppColors.neonGreen.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.neonGreen.withOpacity(0.12),
                          border: Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
                        ),
                        child: const Center(child: Text('⌨️', style: TextStyle(fontSize: 26))),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TYPING RACE',
                              style: TextStyle(
                                fontFamily: 'Orbitron',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.neonGreen,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'How fast can you type code?',
                              style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: context.cqTextPrimary,
                              ),
                            ),
                            Text(
                              'Earn your WPM rank badge',
                              style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 12,
                                color: context.cqTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: context.cqTextMuted, size: 16),
                    ],
                  ),
                ),
              ).animate(delay: 1100.ms).fadeIn().slideY(begin: 0.2),
            ),
          ),

          // Quick action row — Playground, Interview, Roadmap
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  _QuickAction(emoji: '▶️', label: 'Playground', onTap: () => context.push(AppRoutes.codePlayground)),
                  const SizedBox(width: 10),
                  _QuickAction(emoji: '🎯', label: 'Interview', onTap: () => context.push(AppRoutes.interviewPrep)),
                  const SizedBox(width: 10),
                  _QuickAction(emoji: '🗺️', label: 'Roadmap', onTap: () => context.push(AppRoutes.roadmap)),
                ],
              ).animate(delay: 1150.ms).fadeIn(),
            ),
          ),

          // AI Mentor banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: _AiMentorBanner()
                  .animate(delay: 1200.ms)
                  .fadeIn()
                  .slideY(begin: 0.2),
            ),
          ),

          // Leaderboard preview
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              child: _LeaderboardPreview()
                  .animate(delay: 1300.ms)
                  .fadeIn(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends ConsumerWidget {
  final AsyncValue userAsync;
  const _HomeHeader({required this.userAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [context.cqBgSecondary, context.cqBg],
        ),
      ),
      child: Row(
        children: [
          // Avatar
          userAsync.maybeWhen(
            data: (user) => user != null
                ? _Avatar(characterId: user.characterId, level: user.level)
                : const _Avatar(characterId: 'cyber_ninja', level: 1),
            orElse: () => const _Avatar(characterId: 'cyber_ninja', level: 1),
          ),

          const SizedBox(width: 16),

          // User info
          Expanded(
            child: userAsync.maybeWhen(
              data: (user) => user != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WELCOME BACK,',
                          style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 11,
                            color: context.cqTextMuted,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          user.username.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.cqTextPrimary,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                gradient: AppColors.goldGradient,
                              ),
                              child: Text(
                                user.rank,
                                style: const TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
              orElse: () => const SizedBox(),
            ),
          ),

          // Right icons
          Row(
            children: [
              // Coins
              userAsync.maybeWhen(
                data: (user) => user != null
                    ? _CoinChip(coins: user.coins)
                    : const SizedBox(),
                orElse: () => const SizedBox(),
              ),
              const SizedBox(width: 8),
              // Notifications
              IconButton(
                icon: Stack(
                  children: [
                    Icon(Icons.notifications_outlined, color: context.cqTextSecondary),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.neonPink,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  final granted = await NotificationService.instance.isPermissionGranted;
                  if (context.mounted) {
                    if (!granted) {
                      context.push(AppRoutes.notificationSettings);
                    } else {
                      context.push(AppRoutes.notificationSettings);
                    }
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.settings_outlined, color: context.cqTextSecondary),
                onPressed: () => context.push(AppRoutes.settings),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 600.ms),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String characterId;
  final int level;

  const _Avatar({required this.characterId, required this.level});

  String _getEmoji(String id) {
    const emojis = {
      'cyber_ninja': '🥷', 'code_warrior': '⚔️',
      'data_mage': '🧙', 'algo_hunter': '🏹',
      'dev_phantom': '👻', 'bug_slayer': '🐉',
    };
    return emojis[id] ?? '👾';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.cyberpunkGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.neonCyan.withOpacity(0.3),
                blurRadius: 12,
              ),
            ],
          ),
          child: Center(
            child: Text(_getEmoji(characterId), style: const TextStyle(fontSize: 28)),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.neonCyan,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$level',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.bgDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CoinChip extends StatelessWidget {
  final int coins;
  const _CoinChip({required this.coins});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.cqCardSecondary,
        border: Border.all(color: AppColors.neonYellow.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🪙', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            coins > 9999 ? '${(coins / 1000).toStringAsFixed(1)}K' : '$coins',
            style: const TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.neonYellow,
            ),
          ),
        ],
      ),
    );
  }
}

class _XpSection extends StatelessWidget {
  final dynamic user;
  const _XpSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.neonCard(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('⭐', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LEVEL ${user.level}',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        '${user.xp} XP',
                        style: TextStyle(
                          fontFamily: 'Share Tech Mono',
                          fontSize: 11,
                          color: AppColors.neonCyan,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text('🔥', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 4),
                  Text(
                    '${user.streak}',
                    style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonOrange,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'STREAK',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 12,
                      color: AppColors.textMuted,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          // XP Progress bar
          LinearPercentIndicator(
            lineHeight: 10,
            percent: user.levelProgress.clamp(0.0, 1.0),
            backgroundColor: AppColors.bgSurface,
            linearGradient: const LinearGradient(
              colors: [AppColors.neonPurple, AppColors.neonCyan],
            ),
            barRadius: const Radius.circular(5),
            padding: EdgeInsets.zero,
            animation: true,
            animationDuration: 800,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(user.levelProgress * 100).toInt()}% to Level ${user.level + 1}',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${user.xpToNextLevel} XP to go',
                style: TextStyle(
                  fontFamily: 'Share Tech Mono',
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LivesSection extends StatelessWidget {
  final int lives;
  const _LivesSection({required this.lives});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.neonCard(glowColor: AppColors.neonPink),
      child: Row(
        children: [
          const Text('❤️', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LIVES',
                style: TextStyle(
                  fontFamily: 'Share Tech Mono',
                  fontSize: 11,
                  color: AppColors.textMuted,
                  letterSpacing: 2,
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      i < lives ? '❤️' : '🖤',
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }),
              ),
            ],
          ),
          const Spacer(),
          if (lives < 5)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: AppColors.fireGradient,
              ),
              child: const Text(
                'REFILL',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.emoji, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: context.cqCard,
            border: Border.all(color: context.cqSurface),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: context.cqTextMuted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiMentorBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.mentor),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF00B09B), Color(0xFF1A1A2E)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(color: const Color(0xFF00B09B).withOpacity(0.4)),
        ),
        child: Row(
          children: [
            const Text('🤖', style: TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI MENTOR',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stuck? Ask your personal AI coding guide anything',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardPreview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.neonCard(glowColor: AppColors.neonYellow),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🏆 LEADERBOARD',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 1,
                ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.leaderboard),
                child: Text(
                  'VIEW ALL →',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 13,
                    color: AppColors.neonYellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFF2A3550)),
          ...List.generate(3, (i) {
            final medals = ['🥇', '🥈', '🥉'];
            final names = ['cyber_ninja_007', 'code_wizard', 'algo_master'];
            final xps = [45200, 38100, 31500];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(medals[i], style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Text(
                    names[i],
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${xps[i]} XP',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonYellow,
                    ),
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

// ─── Tablet two-column home layout ────────────────────────────────────────────

class _TabletHomeLayout extends ConsumerWidget {
  final AsyncValue userAsync;
  final AsyncValue missionsAsync;
  const _TabletHomeLayout({required this.userAsync, required this.missionsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left column: header + missions + daily drop ──────────────────
          Expanded(
            flex: 5,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _HomeHeader(userAsync: userAsync)),
                SliverToBoxAdapter(
                  child: userAsync.when(
                    data: (user) => user != null
                        ? _XpSection(user: user).animate().fadeIn(delay: 200.ms)
                        : const SizedBox(),
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: userAsync.when(
                    data: (user) => user != null
                        ? _LivesSection(lives: user.lives).animate().fadeIn(delay: 300.ms)
                        : const SizedBox(),
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Text(
                      'DAILY MISSIONS',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: context.cqTextPrimary,
                        letterSpacing: 1.5,
                      ),
                    ).animate(delay: 400.ms).fadeIn(),
                  ),
                ),
                missionsAsync.when(
                  data: (missions) => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => Padding(
                        padding: EdgeInsets.fromLTRB(20, i == 0 ? 12 : 8, 20, 0),
                        child: MissionCard(mission: missions[i])
                            .animate(delay: Duration(milliseconds: 450 + i * 80))
                            .fadeIn(),
                      ),
                      childCount: missions.length,
                    ),
                  ),
                  loading: () => const SliverToBoxAdapter(child: SizedBox()),
                  error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: DailyDropHomeCard(
                      onTap: () => context.push(AppRoutes.dailyDrop),
                    ).animate(delay: 700.ms).fadeIn(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),

          // Divider
          Container(width: 1, color: const Color(0xFF1E2A3F)),

          // ── Right column: languages + leaderboard + quick actions ─────────
          Expanded(
            flex: 4,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'LEARNING PATHS',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: context.cqTextPrimary,
                    letterSpacing: 1.5,
                  ),
                ).animate(delay: 500.ms).fadeIn(),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: AppConstants.languages.length,
                  itemBuilder: (context, i) {
                    final lang = AppConstants.languages[i];
                    return LanguageCard(language: lang)
                        .animate(delay: Duration(milliseconds: 550 + i * 50))
                        .fadeIn()
                        .scale(begin: const Offset(0.95, 0.95));
                  },
                ),
                const SizedBox(height: 24),
                // Quick actions
                Row(
                  children: [
                    _QuickAction(emoji: '▶️', label: 'Playground',
                        onTap: () => context.push(AppRoutes.codePlayground)),
                    const SizedBox(width: 10),
                    _QuickAction(emoji: '🎯', label: 'Interview',
                        onTap: () => context.push(AppRoutes.interviewPrep)),
                    const SizedBox(width: 10),
                    _QuickAction(emoji: '🗺️', label: 'Roadmap',
                        onTap: () => context.push(AppRoutes.roadmap)),
                  ],
                ).animate(delay: 800.ms).fadeIn(),
                const SizedBox(height: 24),
                _LeaderboardPreview().animate(delay: 900.ms).fadeIn(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

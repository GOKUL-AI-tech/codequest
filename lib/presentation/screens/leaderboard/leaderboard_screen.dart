import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() => setState(() => _selectedTab = _tabController.index));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Mock leaderboard data
  final List<Map<String, dynamic>> _entries = [
    {'rank': 1, 'username': 'cyber_ninja_007', 'xp': 45200, 'level': 18, 'streak': 42, 'char': '🥷', 'rank_title': 'Code Legend'},
    {'rank': 2, 'username': 'code_wizard', 'xp': 38100, 'level': 16, 'streak': 28, 'char': '🧙', 'rank_title': 'Cyber Warrior'},
    {'rank': 3, 'username': 'algo_master', 'xp': 31500, 'level': 14, 'streak': 15, 'char': '⚔️', 'rank_title': 'Cyber Warrior'},
    {'rank': 4, 'username': 'dart_hero', 'xp': 28000, 'level': 13, 'streak': 20, 'char': '🏹', 'rank_title': 'Syntax Samurai'},
    {'rank': 5, 'username': 'python_snake', 'xp': 22000, 'level': 12, 'streak': 7, 'char': '🐍', 'rank_title': 'Syntax Samurai'},
    {'rank': 6, 'username': 'dev_phantom', 'xp': 19500, 'level': 11, 'streak': 12, 'char': '👻', 'rank_title': 'Algorithm Adept'},
    {'rank': 7, 'username': 'bug_hunter_x', 'xp': 16800, 'level': 10, 'streak': 5, 'char': '🐛', 'rank_title': 'Algorithm Adept'},
    {'rank': 8, 'username': 'YOU (me)', 'xp': 12500, 'level': 9, 'streak': 3, 'char': '🥷', 'rank_title': 'Algorithm Adept', 'isMe': true},
    {'rank': 9, 'username': 'js_wizard', 'xp': 10200, 'level': 8, 'streak': 8, 'char': '⚡', 'rank_title': 'Bug Hunter'},
    {'rank': 10, 'username': 'code_knight', 'xp': 8900, 'level': 7, 'streak': 2, 'char': '🛡️', 'rank_title': 'Bug Hunter'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),
          SliverToBoxAdapter(
            child: _buildTabs(),
          ),
        ],
        body: _buildLeaderboardList(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A0A2E), Color(0xFF2D1B69), Color(0xFF0A0E1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🏆 LEADERBOARD',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withOpacity(0.1),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.white70, size: 16),
                    SizedBox(width: 4),
                    Text('LIVE', style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 11, color: Colors.white70, letterSpacing: 1)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Top 3 podium
          _Podium(entries: _entries.take(3).toList()),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['GLOBAL', 'WEEKLY', 'FRIENDS'];
    return Container(
      color: context.cqBgSecondary,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = i == _selectedTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: isActive ? AppColors.cyberpunkGradient : null,
                  color: isActive ? null : context.cqCard,
                ),
                child: Center(
                  child: Text(
                    tabs[i],
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isActive ? AppColors.bgDark : context.cqTextMuted,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLeaderboardList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: _entries.length,
      itemBuilder: (context, i) {
        if (i < 3) return const SizedBox(); // Skip top 3 (shown in podium)
        final entry = _entries[i];
        final isMe = entry['isMe'] == true;
        return _LeaderboardRow(entry: entry, isMe: isMe)
            .animate(delay: Duration(milliseconds: i * 40))
            .fadeIn()
            .slideX(begin: 0.1);
      },
    );
  }
}

class _Podium extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  const _Podium({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 2nd place
        _PodiumItem(entry: entries[1], height: 90, medal: '🥈', color: const Color(0xFFC0C0C0)),
        const SizedBox(width: 8),
        // 1st place
        _PodiumItem(entry: entries[0], height: 120, medal: '🥇', color: const Color(0xFFFFD700)),
        const SizedBox(width: 8),
        // 3rd place
        _PodiumItem(entry: entries[2], height: 70, medal: '🥉', color: const Color(0xFFCD7F32)),
      ],
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final Map<String, dynamic> entry;
  final double height;
  final String medal;
  final Color color;

  const _PodiumItem({required this.entry, required this.height, required this.medal, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(entry['char'] as String, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 4),
        Text(
          entry['username'] as String,
          style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          '${(entry['xp'] as int) ~/ 1000}K XP',
          style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 10, color: color),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          width: 80,
          height: height,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            color: color.withOpacity(0.15),
            border: Border.all(color: color.withOpacity(0.5), width: 1.5),
          ),
          child: Center(child: Text(medal, style: const TextStyle(fontSize: 28))),
        ),
      ],
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final Map<String, dynamic> entry;
  final bool isMe;

  const _LeaderboardRow({required this.entry, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isMe ? AppColors.neonCyan.withOpacity(0.08) : context.cqCard,
        border: Border.all(
          color: isMe ? AppColors.neonCyan.withOpacity(0.4) : context.cqSurface,
          width: isMe ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 32,
            child: Text(
              '#${entry['rank']}',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isMe ? AppColors.neonCyan : context.cqTextMuted,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Avatar
          Text(entry['char'] as String, style: const TextStyle(fontSize: 24)),

          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry['username'] as String,
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isMe ? AppColors.neonCyan : context.cqTextPrimary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      entry['rank_title'] as String,
                      style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12, color: context.cqTextMuted),
                    ),
                    SizedBox(width: 8),
                    Text('🔥${entry['streak']}', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12, color: context.cqTextMuted)),
                  ],
                ),
              ],
            ),
          ),

          // XP
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(entry['xp'] as int) ~/ 1000}K XP',
                style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 13, color: AppColors.neonCyan, fontWeight: FontWeight.bold),
              ),
              Text(
                'LVL ${entry['level']}',
                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 11, color: context.cqTextMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/notification_model.dart';
import '../../providers/app_providers.dart';
import '../../providers/auth_provider.dart';
import '../../providers/leaderboard_provider.dart';
import '../../widgets/common/neon_button.dart';

class GuildDetailScreen extends ConsumerStatefulWidget {
  final GuildModel guild;
  const GuildDetailScreen({super.key, required this.guild});

  @override
  ConsumerState<GuildDetailScreen> createState() => _GuildDetailScreenState();
}

class _GuildDetailScreenState extends ConsumerState<GuildDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isJoining = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _joinGuild() async {
    final userId = ref.read(currentUserProvider)?.id;
    if (userId == null) return;
    setState(() => _isJoining = true);
    try {
      final ds = ref.read(supabaseDatasourceProvider);
      await ds.joinGuild(userId, widget.guild.id);
      ref.invalidate(userGuildProvider);
      ref.invalidate(publicGuildsProvider);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Joined ${widget.guild.name}!'),
            backgroundColor: AppColors.neonGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join: $e'),
            backgroundColor: AppColors.neonPink,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final guild = widget.guild;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.neonPurple.withOpacity(0.4),
                          context.cqBgSecondary,
                        ],
                      ),
                    ),
                  ),
                  // Grid lines decoration
                  Opacity(
                    opacity: 0.08,
                    child: CustomPaint(
                      painter: _GridLinePainter(color: AppColors.neonPurple),
                    ),
                  ),
                  // Guild info
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        // Emblem
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: context.cqCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.neonPurple,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonPurple.withOpacity(0.4),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              guild.emblem ?? '⚔️',
                              style: const TextStyle(fontSize: 36),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    guild.name,
                                    style: const TextStyle(
                                      fontFamily: 'Orbitron',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.neonPurple.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '[${guild.tag}]',
                                      style: TextStyle(
                                        fontFamily: 'Share Tech Mono',
                                        fontSize: 10,
                                        color: AppColors.neonPurple,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                guild.description ?? 'A legendary guild',
                                style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 12,
                                  color: context.cqTextMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _StatChip(
                                    icon: Icons.people,
                                    value: '${guild.memberCount}',
                                    label: 'members',
                                  ),
                                  const SizedBox(width: 12),
                                  _StatChip(
                                    icon: Icons.stars,
                                    value: '${guild.totalXp}',
                                    label: 'XP',
                                    color: AppColors.neonPurple,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.neonPurple,
              labelColor: AppColors.neonPurple,
              unselectedLabelColor: context.cqTextMuted,
              labelStyle: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: 'OVERVIEW'),
                Tab(text: 'MEMBERS'),
                Tab(text: 'BATTLES'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _OverviewTab(guild: guild),
            _MembersTab(guildId: guild.id),
            _BattlesTab(guildId: guild.id),
          ],
        ),
      ),
      bottomNavigationBar: guild.isMember
          ? null
          : Container(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 28),
              color: context.cqBgSecondary,
              child: NeonButton(
                label: _isJoining ? 'JOINING...' : 'JOIN GUILD',
                onTap: _isJoining ? () {} : _joinGuild,
                gradient: const LinearGradient(
                  colors: [AppColors.neonPurple, AppColors.neonCyan],
                ),
                glowColor: AppColors.neonPurple,
              ),
            ),
    );
  }
}

// ─── TABS ─────────────────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  final GuildModel guild;
  const _OverviewTab({required this.guild});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          if (guild.description != null) ...[
            _SectionHeader(title: 'ABOUT'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cqCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.cqSurface),
              ),
              child: Text(
                guild.description!,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 14,
                  color: context.cqTextSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Stats grid
          _SectionHeader(title: 'STATS'),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.2,
            children: [
              _StatCard(
                  label: 'MEMBERS',
                  value: '${guild.memberCount}',
                  icon: '👥'),
              _StatCard(
                  label: 'TOTAL XP',
                  value: '${guild.totalXp}',
                  icon: '⚡'),
              _StatCard(label: 'BATTLES WON', value: '—', icon: '🏆'),
              _StatCard(label: 'RANK', value: '#—', icon: '🏅'),
            ],
          ),

          const SizedBox(height: 20),

          // Guild XP Progress
          _SectionHeader(title: 'GUILD LEVEL PROGRESS'),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cqCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.cqSurface),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level 5',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 14,
                        color: AppColors.neonPurple,
                      ),
                    ),
                    Text(
                      '${guild.totalXp} / 50000 XP',
                      style: TextStyle(
                        fontFamily: 'Share Tech Mono',
                        fontSize: 11,
                        color: context.cqTextMuted,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (guild.totalXp % 10000) / 10000,
                  backgroundColor: context.cqSurface,
                  valueColor:
                      AlwaysStoppedAnimation(AppColors.neonPurple),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MembersTab extends StatelessWidget {
  final String guildId;
  const _MembersTab({required this.guildId});

  @override
  Widget build(BuildContext context) {
    // Mock members for now — would be a FutureProvider in production
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 10,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.neonPurple, AppColors.neonCyan],
              ),
            ),
            child: Center(
              child: Text(
                '${String.fromCharCode(65 + i)}',
                style: const TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            'Player ${i + 1}',
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'Level ${20 - i} • ${(i + 1) * 2500} XP',
            style: TextStyle(
              fontFamily: 'Share Tech Mono',
              fontSize: 10,
              color: context.cqTextMuted,
            ),
          ),
          trailing: i == 0
              ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.neonGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.neonGold.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    'LEADER',
                    style: TextStyle(
                      fontFamily: 'Share Tech Mono',
                      fontSize: 9,
                      color: AppColors.neonGold,
                    ),
                  ),
                )
              : null,
        ).animate(delay: Duration(milliseconds: i * 40)).fadeIn().slideX(begin: 0.05);
      },
    );
  }
}

class _BattlesTab extends StatelessWidget {
  final String guildId;
  const _BattlesTab({required this.guildId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⚔️', style: TextStyle(fontSize: 56))
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut),
          SizedBox(height: 16),
          Text(
            'NO BATTLES YET',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 14,
              color: context.cqTextSecondary,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Guild battles coming soon!',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 13,
              color: context.cqTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── HELPERS ─────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Orbitron',
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: AppColors.neonCyan,
        letterSpacing: 2,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: context.cqCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.cqSurface),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Share Tech Mono',
                  fontSize: 9,
                  color: context.cqTextMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? color;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color ?? context.cqTextMuted),
        SizedBox(width: 4),
        Text(
          '$value $label',
          style: TextStyle(
            fontFamily: 'Share Tech Mono',
            fontSize: 10,
            color: color ?? context.cqTextMuted,
          ),
        ),
      ],
    );
  }
}

class _GridLinePainter extends CustomPainter {
  final Color color;
  const _GridLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.8;
    const spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/notification_model.dart';
import '../../providers/leaderboard_provider.dart';
import '../../widgets/common/loading_skeleton.dart';
import '../../widgets/common/neon_button.dart';
import 'guild_detail_screen.dart';

class GuildsScreen extends ConsumerWidget {
  const GuildsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publicGuildsAsync = ref.watch(publicGuildsProvider);
    final userGuildAsync = ref.watch(userGuildProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 20, bottom: 16),
              title: ShaderMask(
                shaderCallback: (bounds) =>
                    AppColors.cyberpunkGradient.createShader(bounds),
                child: const Text(
                  'GUILDS',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.neonPurple.withOpacity(0.3),
                          context.cqBgSecondary,
                        ],
                      ),
                    ),
                  ),
                  // Decorative grid lines
                  Positioned.fill(
                    child: CustomPaint(painter: _GridPainter()),
                  ),
                  // Floating emoji
                  const Positioned(
                    right: 30,
                    top: 30,
                    child: Text('⚔️', style: TextStyle(fontSize: 60)),
                  ),
                ],
              ),
            ),
          ),

          // ── My Guild Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'MY GUILD',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonCyan,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: userGuildAsync.when(
                loading: () => LoadingCardSkeleton(height: 100),
                error: (_, __) => const SizedBox.shrink(),
                data: (guild) => guild == null
                    ? _NoGuildCard(
                        onCreateGuild: () =>
                            _showCreateGuildDialog(context, ref),
                      )
                    : _MyGuildCard(guild: guild as GuildModel),
              ),
            ),
          ),

          // ── Public Guilds section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Row(
                children: [
                  Text(
                    'DISCOVER GUILDS',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonCyan,
                      letterSpacing: 2,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.search,
                      color: context.cqTextMuted, size: 20),
                ],
              ),
            ),
          ),

          publicGuildsAsync.when(
            loading: () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: SkeletonListTile(),
                ),
                childCount: 6,
              ),
            ),
            error: (_, __) => const SliverToBoxAdapter(
              child: Center(
                child: Text('Could not load guilds'),
              ),
            ),
            data: (guilds) => SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final guild = guilds[i] as GuildModel;
                    return _GuildListTile(
                      guild: guild,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GuildDetailScreen(guild: guild),
                        ),
                      ),
                    ).animate(delay: Duration(milliseconds: i * 40))
                        .fadeIn()
                        .slideY(begin: 0.1);
                  },
                  childCount: guilds.length,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _showCreateGuildDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final tagController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.cqSurface,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'CREATE GUILD',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),
              _GuildTextField(
                controller: nameController,
                label: 'Guild Name',
                hint: 'e.g., Cyber Wolves',
              ),
              const SizedBox(height: 12),
              _GuildTextField(
                controller: tagController,
                label: 'Tag (3-5 chars)',
                hint: 'CW',
                maxLength: 5,
              ),
              const SizedBox(height: 12),
              _GuildTextField(
                controller: descController,
                label: 'Description',
                hint: 'Describe your guild...',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: NeonButton(
                  label: 'CREATE GUILD',
                  onTap: () async {
                    // TODO: call ds.createGuild(...) with nameController etc.
                    Navigator.pop(ctx);
                  },
                  gradient: const LinearGradient(
                    colors: [AppColors.neonPurple, AppColors.neonCyan],
                  ),
                  glowColor: AppColors.neonPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── CARDS & TILES ────────────────────────────────────────────────────────────

class _NoGuildCard extends StatelessWidget {
  final VoidCallback onCreateGuild;
  const _NoGuildCard({required this.onCreateGuild});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cqCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neonPurple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text('⚔️', style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'No Guild Yet',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Join or create a guild to battle together',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 13,
                    color: context.cqTextMuted,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onCreateGuild,
            child: Text(
              'CREATE',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.neonPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyGuildCard extends StatelessWidget {
  final GuildModel guild;
  const _MyGuildCard({required this.guild});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.neonPurple.withOpacity(0.2),
            context.cqCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neonPurple.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPurple.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.neonPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  guild.emblem ?? '⚔️',
                  style: const TextStyle(fontSize: 28),
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
                          guild.name,
                          style: const TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 14,
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
                    SizedBox(height: 2),
                    Text(
                      '${guild.memberCount} members',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 12,
                        color: context.cqTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.neonGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.neonGreen.withOpacity(0.5),
                  ),
                ),
                child: Text(
                  'MEMBER',
                  style: TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 9,
                    color: AppColors.neonGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Guild XP bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GUILD XP',
                    style: TextStyle(
                      fontFamily: 'Share Tech Mono',
                      fontSize: 9,
                      color: context.cqTextMuted,
                    ),
                  ),
                  Text(
                    '${guild.totalXp} XP',
                    style: TextStyle(
                      fontFamily: 'Share Tech Mono',
                      fontSize: 9,
                      color: AppColors.neonPurple,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              LinearProgressIndicator(
                value: 0.6,
                backgroundColor: context.cqSurface,
                valueColor:
                    AlwaysStoppedAnimation(AppColors.neonPurple),
                borderRadius: BorderRadius.circular(4),
                minHeight: 6,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuildListTile extends StatelessWidget {
  final GuildModel guild;
  final VoidCallback onTap;

  const _GuildListTile({required this.guild, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.cqCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.cqSurface, width: 1),
        ),
        child: Row(
          children: [
            // Emblem
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.cqSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  guild.emblem ?? '⚔️',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        guild.name,
                        style: const TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '[${guild.tag}]',
                        style: TextStyle(
                          fontFamily: 'Share Tech Mono',
                          fontSize: 10,
                          color: AppColors.neonPurple,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.people,
                          size: 12, color: context.cqTextMuted),
                      SizedBox(width: 4),
                      Text(
                        '${guild.memberCount} members',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 12,
                          color: context.cqTextMuted,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.stars,
                          size: 12, color: context.cqTextMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${guild.totalXp} XP',
                        style: TextStyle(
                          fontFamily: 'Share Tech Mono',
                          fontSize: 11,
                          color: AppColors.neonPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Join button
            if (!guild.isMember)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.neonPurple.withOpacity(0.6),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'JOIN',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neonPurple,
                  ),
                ),
              )
            else
              Icon(Icons.check_circle,
                  color: AppColors.neonGreen, size: 22),
          ],
        ),
      ),
    );
  }
}

// ─── INPUT WIDGET ─────────────────────────────────────────────────────────────

class _GuildTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final int? maxLength;

  const _GuildTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Share Tech Mono',
            fontSize: 10,
            color: context.cqTextMuted,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 14,
            color: context.cqTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: context.cqTextMuted),
            filled: true,
            fillColor: context.cqCard,
            counterStyle: TextStyle(
              fontFamily: 'Share Tech Mono',
              fontSize: 9,
              color: context.cqTextMuted,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.neonPurple),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}

// ─── GRID PAINTER ─────────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonPurple.withOpacity(0.06)
      ..strokeWidth = 1;

    const spacing = 40.0;
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

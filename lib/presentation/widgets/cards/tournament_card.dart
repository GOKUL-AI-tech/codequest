import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';

enum TournamentStatus { upcoming, live, ended }

class TournamentCard extends StatelessWidget {
  final String title;
  final String description;
  final TournamentStatus status;
  final int participants;
  final int maxParticipants;
  final DateTime? startTime;
  final int prizeXp;
  final int prizeCoins;
  final String? languageEmoji;
  final VoidCallback onTap;

  const TournamentCard({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.participants,
    required this.maxParticipants,
    required this.prizeXp,
    required this.prizeCoins,
    required this.onTap,
    this.startTime,
    this.languageEmoji,
  });

  Color _statusColor(BuildContext context) {
    switch (status) {
      case TournamentStatus.live:
        return AppColors.neonGreen;
      case TournamentStatus.upcoming:
        return AppColors.neonCyan;
      case TournamentStatus.ended:
        return context.cqTextMuted;
    }
  }

  String get _statusLabel {
    switch (status) {
      case TournamentStatus.live:
        return 'LIVE';
      case TournamentStatus.upcoming:
        return 'UPCOMING';
      case TournamentStatus.ended:
        return 'ENDED';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFull = participants >= maxParticipants;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.cqCard,
              status == TournamentStatus.live
                  ? AppColors.neonGreen.withOpacity(0.06)
                  : context.cqCard,
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: status == TournamentStatus.live
                ? AppColors.neonGreen.withOpacity(0.4)
                : context.cqSurface,
            width: status == TournamentStatus.live ? 1.5 : 1,
          ),
          boxShadow: status == TournamentStatus.live
              ? [
                  BoxShadow(
                    color: AppColors.neonGreen.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Row(
                children: [
                  // Tournament icon
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.neonPink,
                          AppColors.neonPurple,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        languageEmoji ?? '🏆',
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontFamily: 'Orbitron',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Status badge
                            _StatusBadge(
                              label: _statusLabel,
                              color: _statusColor(context),
                              isLive: status == TournamentStatus.live,
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 12,
                            color: context.cqTextMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: context.cqSurface, height: 1),

            // ── Stats row ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Row(
                children: [
                  // Participants
                  _MetaChip(
                    icon: Icons.people,
                    value: '$participants/$maxParticipants',
                    color: isFull ? AppColors.neonPink : context.cqTextMuted,
                  ),

                  const SizedBox(width: 14),

                  // Prize XP
                  _MetaChip(
                    icon: Icons.flash_on,
                    value: '+$prizeXp XP',
                    color: AppColors.neonCyan,
                  ),

                  const SizedBox(width: 14),

                  // Prize coins
                  _MetaChip(
                    emoji: '🪙',
                    value: '+$prizeCoins',
                    color: AppColors.neonGold,
                  ),

                  const Spacer(),

                  // Start time or CTA
                  if (status == TournamentStatus.upcoming && startTime != null)
                    _CountdownChip(startTime: startTime!)
                  else if (status == TournamentStatus.live)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.neonPink, AppColors.neonPurple],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonPink.withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Text(
                        'JOIN NOW',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Participant fill bar ───────────────────────────────────────
            if (status != TournamentStatus.ended)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                child: LinearProgressIndicator(
                  value: (participants / maxParticipants).clamp(0.0, 1.0),
                  backgroundColor: context.cqSurface,
                  valueColor: AlwaysStoppedAnimation(
                    isFull ? AppColors.neonPink : _statusColor(context),
                  ),
                  minHeight: 4,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool isLive;

  const _StatusBadge({
    required this.label,
    required this.color,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLive) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ).animate(onPlay: (c) => c.repeat())
                .fade(duration: 800.ms, begin: 1, end: 0.2),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Share Tech Mono',
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData? icon;
  final String? emoji;
  final String value;
  final Color color;

  const _MetaChip({
    this.icon,
    this.emoji,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (emoji != null)
          Text(emoji!, style: const TextStyle(fontSize: 12))
        else if (icon != null)
          Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Share Tech Mono',
            fontSize: 10,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _CountdownChip extends StatelessWidget {
  final DateTime startTime;
  const _CountdownChip({required this.startTime});

  String get _countdown {
    final diff = startTime.difference(DateTime.now());
    if (diff.isNegative) return 'Starting...';
    if (diff.inDays > 0) return 'In ${diff.inDays}d ${diff.inHours % 24}h';
    if (diff.inHours > 0) return 'In ${diff.inHours}h ${diff.inMinutes % 60}m';
    return 'In ${diff.inMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.neonCyan.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neonCyan.withOpacity(0.3)),
      ),
      child: Text(
        _countdown,
        style: TextStyle(
          fontFamily: 'Share Tech Mono',
          fontSize: 10,
          color: AppColors.neonCyan,
        ),
      ),
    );
  }
}

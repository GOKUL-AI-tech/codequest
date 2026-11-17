import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../core/theme/app_theme.dart';

class XpBarWidget extends StatelessWidget {
  final int currentXp;
  final int maxXp;
  final int level;
  final bool animate;

  const XpBarWidget({
    super.key,
    required this.currentXp,
    required this.maxXp,
    required this.level,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentXp / maxXp).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('LVL $level', style: const TextStyle(fontFamily: 'Orbitron', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.neonCyan, letterSpacing: 1)),
            Text('$currentXp / $maxXp XP', style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 10, color: context.cqTextMuted)),
          ],
        ),
        SizedBox(height: 6),
        LinearPercentIndicator(
          lineHeight: 10,
          percent: progress,
          backgroundColor: context.cqSurface,
          linearGradient: const LinearGradient(colors: [AppColors.neonPurple, AppColors.neonCyan]),
          barRadius: const Radius.circular(5),
          padding: EdgeInsets.zero,
          animation: animate,
          animationDuration: 800,
        ),
      ],
    );
  }
}

class XpGainOverlay extends StatelessWidget {
  final int xp;
  final Offset position;

  const XpGainOverlay({super.key, required this.xp, required this.position});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Text(
        '+$xp XP',
        style: const TextStyle(fontFamily: 'Orbitron', fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.neonYellow),
      )
          .animate()
          .slideY(begin: 0, end: -2, duration: 1200.ms, curve: Curves.easeOut)
          .fadeOut(delay: 700.ms, duration: 500.ms),
    );
  }
}

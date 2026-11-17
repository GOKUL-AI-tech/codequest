import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

// ─── Reward model ─────────────────────────────────────────────────────────────

class RouletteReward {
  final String label;
  final String emoji;
  final Color color;
  final int xpBonus;
  final int coinBonus;
  final int livesBonus;
  final double weight; // higher = more likely

  const RouletteReward({
    required this.label,
    required this.emoji,
    required this.color,
    required this.weight,
    this.xpBonus = 0,
    this.coinBonus = 0,
    this.livesBonus = 0,
  });
}

const _rewards = [
  RouletteReward(label: '+50 XP', emoji: '⭐', color: Color(0xFFFFD700), xpBonus: 50, weight: 25),
  RouletteReward(label: '+100 XP', emoji: '🌟', color: Color(0xFFFF8C00), xpBonus: 100, weight: 15),
  RouletteReward(label: '+25 Coins', emoji: '🪙', color: Color(0xFF00F5FF), coinBonus: 25, weight: 20),
  RouletteReward(label: '+50 Coins', emoji: '💰', color: Color(0xFF39FF14), coinBonus: 50, weight: 12),
  RouletteReward(label: '+1 Life', emoji: '❤️', color: Color(0xFFFF1744), livesBonus: 1, weight: 10),
  RouletteReward(label: '2× XP', emoji: '⚡', color: Color(0xFFBF00FF), xpBonus: 0, weight: 5),
  RouletteReward(label: 'Nothing', emoji: '💨', color: Color(0xFF4A5568), weight: 13),
];

// ─── Wheel painter ────────────────────────────────────────────────────────────

class _WheelPainter extends CustomPainter {
  final double rotation;
  final List<RouletteReward> segments;

  _WheelPainter({required this.rotation, required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = (math.pi * 2) / segments.length;

    for (int i = 0; i < segments.length; i++) {
      final startAngle = rotation + i * segmentAngle;
      final paint = Paint()
        ..color = segments[i].color.withOpacity(0.85)
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        paint,
      );

      // Segment border
      final borderPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        borderPaint,
      );

      // Label
      final midAngle = startAngle + segmentAngle / 2;
      final labelRadius = radius * 0.62;
      final labelPos = Offset(
        center.dx + labelRadius * math.cos(midAngle),
        center.dy + labelRadius * math.sin(midAngle),
      );

      final tp = TextPainter(
        text: TextSpan(
          text: segments[i].emoji,
          style: const TextStyle(fontSize: 18),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(labelPos.dx, labelPos.dy);
      canvas.rotate(midAngle + math.pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    // Center circle
    canvas.drawCircle(
      center,
      radius * 0.14,
      Paint()..color = AppColors.bgDark,
    );
    canvas.drawCircle(
      center,
      radius * 0.14,
      Paint()
        ..color = AppColors.neonCyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_WheelPainter old) => old.rotation != rotation;
}

// ─── Main widget ──────────────────────────────────────────────────────────────

class XpRouletteDialog extends StatefulWidget {
  final int baseXp;
  final int baseCoins;

  const XpRouletteDialog({
    super.key,
    required this.baseXp,
    required this.baseCoins,
  });

  static Future<RouletteReward?> show(
    BuildContext context, {
    required int baseXp,
    required int baseCoins,
  }) {
    return showDialog<RouletteReward>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (_) => XpRouletteDialog(baseXp: baseXp, baseCoins: baseCoins),
    );
  }

  @override
  State<XpRouletteDialog> createState() => _XpRouletteDialogState();
}

class _XpRouletteDialogState extends State<XpRouletteDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _rotationAnim;

  bool _spinning = false;
  bool _done = false;
  RouletteReward? _result;
  double _finalRotation = 0;

  RouletteReward _pickWeightedReward() {
    final totalWeight = _rewards.fold<double>(0, (s, r) => s + r.weight);
    double rand = math.Random().nextDouble() * totalWeight;
    for (final r in _rewards) {
      rand -= r.weight;
      if (rand <= 0) return r;
    }
    return _rewards.first;
  }

  int _rewardIndex(RouletteReward reward) => _rewards.indexOf(reward);

  void _spin() {
    if (_spinning) return;
    setState(() => _spinning = true);

    final reward = _pickWeightedReward();
    final rewardIdx = _rewardIndex(reward);
    final segmentAngle = (math.pi * 2) / _rewards.length;

    // Target: pointer (at top = -π/2) lands in the middle of the reward segment
    final targetAngle = -(rewardIdx * segmentAngle + segmentAngle / 2) - math.pi / 2;
    final spins = 5 + math.Random().nextDouble() * 3;
    final totalRotation = spins * math.pi * 2 + targetAngle - (_finalRotation % (math.pi * 2));

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _rotationAnim = Tween<double>(
      begin: _finalRotation,
      end: _finalRotation + totalRotation,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOutCubic,
    ));

    _ctrl.forward().then((_) {
      _finalRotation = _rotationAnim.value;
      setState(() {
        _spinning = false;
        _done = true;
        _result = reward;
      });
    });
  }

  @override
  void dispose() {
    if (_spinning) _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: context.cqCard,
          border: Border.all(color: AppColors.neonPurple.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonPurple.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎰', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Text(
                  'BONUS SPIN!',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.cqTextPrimary,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ).animate().fadeIn(),

            const SizedBox(height: 6),
            Text(
              'Base reward: ${widget.baseXp} XP + ${widget.baseCoins} coins',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 13,
                color: context.cqTextMuted,
              ),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: 20),

            // Wheel
            Stack(
              alignment: Alignment.topCenter,
              children: [
                // Pointer
                Positioned(
                  top: 0,
                  child: Container(
                    width: 0,
                    height: 0,
                    decoration: const BoxDecoration(),
                    child: CustomPaint(
                      painter: _PointerPainter(),
                      size: const Size(20, 20),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _spinning || _done
                      ? AnimatedBuilder(
                          animation: _spinning ? _rotationAnim : AlwaysStoppedAnimation(_finalRotation),
                          builder: (_, __) => CustomPaint(
                            painter: _WheelPainter(
                              rotation: _spinning ? _rotationAnim.value : _finalRotation,
                              segments: _rewards,
                            ),
                            size: const Size(240, 240),
                          ),
                        )
                      : CustomPaint(
                          painter: _WheelPainter(rotation: 0, segments: _rewards),
                          size: const Size(240, 240),
                        ),
                ),

                // Pointer triangle on top
                const Positioned(
                  top: 2,
                  child: _PointerWidget(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Segment legend
            Wrap(
              spacing: 8,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: _rewards.map((r) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: r.color.withOpacity(0.12),
                  border: Border.all(color: r.color.withOpacity(0.3)),
                ),
                child: Text(
                  '${r.emoji} ${r.label}',
                  style: TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 10,
                    color: r.color,
                  ),
                ),
              )).toList(),
            ),

            const SizedBox(height: 20),

            // Result or spin button
            if (_done && _result != null)
              _buildResult()
            else
              GestureDetector(
                onTap: _spinning ? null : _spin,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: _spinning ? null : AppColors.cyberpunkGradient,
                    color: _spinning ? context.cqCardSecondary : null,
                  ),
                  child: _spinning
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.neonCyan,
                          ),
                        )
                      : const Text(
                          'SPIN!',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                ),
              ).animate(delay: 200.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    final r = _result!;
    return Column(
      children: [
        Text(r.emoji, style: const TextStyle(fontSize: 48))
            .animate()
            .scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 8),
        Text(
          r.label,
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: r.color,
            letterSpacing: 1,
          ),
        ).animate(delay: 200.ms).fadeIn(),
        const SizedBox(height: 4),
        Text(
          r.xpBonus > 0
              ? 'Bonus added to your XP!'
              : r.coinBonus > 0
                  ? 'Coins added to your wallet!'
                  : r.livesBonus > 0
                      ? 'Extra life added!'
                      : 'Better luck next time!',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 14,
            color: context.cqTextMuted,
          ),
        ).animate(delay: 300.ms).fadeIn(),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(r),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: AppColors.primaryGradient,
            ),
            child: const Text(
              'COLLECT & CONTINUE',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
        ).animate(delay: 400.ms).fadeIn(),
      ],
    );
  }
}

class _PointerWidget extends StatelessWidget {
  const _PointerWidget();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PointerPainter(),
      size: const Size(20, 24),
    );
  }
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = AppColors.neonCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

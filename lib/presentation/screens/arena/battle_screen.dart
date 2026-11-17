import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../learn/coding_challenge_screen.dart';
import '../../widgets/common/neon_button.dart';

class BattleScreen extends StatefulWidget {
  final String battleId;
  const BattleScreen({super.key, required this.battleId});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> with TickerProviderStateMixin {
  late AnimationController _countdownController;
  late AnimationController _timerController;
  int _countdown = 3;
  bool _battleStarted = false;
  bool _submitted = false;
  final TextEditingController _codeController = TextEditingController(text: 'def solve(nums):\n    pass\n');

  @override
  void initState() {
    super.initState();
    _countdownController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _timerController = AnimationController(vsync: this, duration: const Duration(minutes: 5));
    _startCountdown();
  }

  void _startCountdown() async {
    for (int i = 3; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _countdown = i);
    }
    setState(() => _battleStarted = true);
    _timerController.forward();
  }

  @override
  void dispose() {
    _countdownController.dispose();
    _timerController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_battleStarted ? _CountdownOverlay(count: _countdown) : _buildBattleUI(context),
    );
  }

  Widget _buildBattleUI(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            color: context.cqBgSecondary,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('YOU', style: TextStyle(fontFamily: 'Orbitron', fontSize: 12, color: AppColors.neonCyan)),
                      LinearProgressIndicator(value: 0.0, backgroundColor: context.cqSurface, valueColor: AlwaysStoppedAnimation(AppColors.neonCyan), minHeight: 8),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnimatedBuilder(
                    animation: _timerController,
                    builder: (_, __) {
                      final remaining = (1 - _timerController.value) * 300;
                      final mins = (remaining ~/ 60).toString().padLeft(2, '0');
                      final secs = (remaining % 60).toInt().toString().padLeft(2, '0');
                      return Text('$mins:$secs', style: const TextStyle(fontFamily: 'Orbitron', fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.neonPink));
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('OPPONENT', style: TextStyle(fontFamily: 'Orbitron', fontSize: 12, color: AppColors.neonPink)),
                      LinearProgressIndicator(value: 0.3, backgroundColor: context.cqSurface, valueColor: AlwaysStoppedAnimation(AppColors.neonPink), minHeight: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Problem
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TWO SUM', style: TextStyle(fontFamily: 'Orbitron', fontSize: 16, fontWeight: FontWeight.bold, color: context.cqTextPrimary)),
                SizedBox(height: 8),
                Text('Given an array of integers, return indices of the two numbers that add up to target.', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14, color: context.cqTextSecondary, height: 1.5)),
                _ExampleBox(input: 'nums=[2,7,11,15], target=9', output: '[0,1]'),
              ],
            ),
          ),

          // Code editor
          Expanded(
            child: Container(
              color: context.cqCardSecondary,
              child: TextField(
                controller: _codeController,
                maxLines: null,
                expands: true,
                style: const TextStyle(fontFamily: 'Share Tech Mono', fontSize: 13, color: AppColors.neonGreen, height: 1.6),
                decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
              ),
            ),
          ),

          // Submit
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
            color: context.cqBgSecondary,
            child: NeonButton(
              label: 'SUBMIT SOLUTION ⚡',
              onTap: () {
                setState(() => _submitted = true);
                showDialog(context: context, builder: (_) => AlertDialog(
                  backgroundColor: context.cqCard,
                  title: const Text('⚡ SUBMITTED!', style: TextStyle(fontFamily: 'Orbitron', color: AppColors.neonGreen)),
                  content: Text('Waiting for opponent...', style: TextStyle(fontFamily: 'Rajdhani', color: context.cqTextSecondary)),
                  actions: [TextButton(onPressed: () { Navigator.pop(context); context.pop(); }, child: Text('LEAVE BATTLE', style: TextStyle(color: AppColors.neonCyan)))],
                ));
              },
              gradient: AppColors.fireGradient,
              glowColor: AppColors.neonPink,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleBox extends StatelessWidget {
  final String input;
  final String output;
  const _ExampleBox({required this.input, required this.output});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.cqCardSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neonCyan.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Input: $input',
              style: TextStyle(
                  fontFamily: 'Share Tech Mono',
                  fontSize: 12,
                  color: context.cqTextSecondary)),
          const SizedBox(height: 4),
          Text('Output: $output',
              style: const TextStyle(
                  fontFamily: 'Share Tech Mono',
                  fontSize: 12,
                  color: AppColors.neonGreen)),
        ],
      ),
    );
  }
}

class _CountdownOverlay extends StatelessWidget {
  final int count;
  const _CountdownOverlay({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.cqBg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(count == 0 ? 'GO!' : '$count',
                style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 100,
                    fontWeight: FontWeight.w900,
                    color: count == 0 ? AppColors.neonGreen : AppColors.neonPink,
                    letterSpacing: -2))
                .animate(key: ValueKey(count))
                .scale(duration: 400.ms, curve: Curves.elasticOut, begin: const Offset(0.5, 0.5)),
            const SizedBox(height: 20),
            Text('BATTLE BEGINS',
                style: TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 16,
                    color: context.cqTextSecondary,
                    letterSpacing: 3)),
          ],
        ),
      ),
    );
  }
}

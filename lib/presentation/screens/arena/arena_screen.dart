import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

class ArenaScreen extends ConsumerStatefulWidget {
  const ArenaScreen({super.key});

  @override
  ConsumerState<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends ConsumerState<ArenaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _ArenaHeader()),

          // ── Battle Modes ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BATTLE MODES',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: context.cqTextMuted,
                      letterSpacing: 2,
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(height: 16),

                  _BattleMode(
                    icon: '⚡',
                    title: 'Quick Battle',
                    description: 'Get matched instantly with a random opponent',
                    gradientColors: const [Color(0xFFFF6B00), Color(0xFFFF006E)],
                    tag: 'POPULAR',
                    onTap: () => _showQuickBattle(context),
                  ).animate(delay: 100.ms).fadeIn().slideX(begin: 0.2),

                  const SizedBox(height: 12),

                  _BattleMode(
                    icon: '👥',
                    title: 'Friend Battle',
                    description: 'Challenge a specific friend to a duel',
                    gradientColors: const [Color(0xFF7B2FBE), Color(0xFF00B4DB)],
                    onTap: () => _showFriendBattle(context),
                  ).animate(delay: 200.ms).fadeIn().slideX(begin: 0.2),

                  const SizedBox(height: 12),

                  _BattleMode(
                    icon: '🏆',
                    title: 'Tournament',
                    description: 'Compete in structured tournaments for big rewards',
                    gradientColors: const [Color(0xFFFFD700), Color(0xFFFF8C00)],
                    tag: 'LIVE',
                    onTap: () => _showTournament(context),
                  ).animate(delay: 300.ms).fadeIn().slideX(begin: 0.2),

                  const SizedBox(height: 12),

                  _BattleMode(
                    icon: '👁️',
                    title: 'Spectate',
                    description: 'Watch live battles happening right now',
                    gradientColors: const [Color(0xFF00B09B), Color(0xFF39FF14)],
                    onTap: () => _showSpectate(context),
                  ).animate(delay: 400.ms).fadeIn().slideX(begin: 0.2),

                  const SizedBox(height: 24),

                  Text(
                    'EXCLUSIVE MODES',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: context.cqTextMuted,
                      letterSpacing: 2,
                    ),
                  ).animate(delay: 450.ms).fadeIn(),
                  const SizedBox(height: 16),

                  _BattleMode(
                    icon: '👥',
                    title: 'Team Ladder',
                    description: 'Code as Coder, Tester or Reviewer — team collaboration scored',
                    gradientColors: const [Color(0xFF00F5FF), Color(0xFF7B2FBE)],
                    tag: 'NEW',
                    onTap: () => context.push(AppRoutes.teamLadder),
                  ).animate(delay: 500.ms).fadeIn().slideX(begin: 0.2),

                  const SizedBox(height: 12),

                  _BattleMode(
                    icon: '⚖️',
                    title: 'Mentor Referee',
                    description: 'Score live battles with a rubric — mentors outweigh speed 3×',
                    gradientColors: const [Color(0xFFFF6B00), Color(0xFFFF006E)],
                    tag: 'MENTOR',
                    onTap: () => context.push(AppRoutes.mentorReferee),
                  ).animate(delay: 580.ms).fadeIn().slideX(begin: 0.2),

                  const SizedBox(height: 12),

                  _BattleMode(
                    icon: '🏢',
                    title: 'Opportunities',
                    description: 'Rank up to unlock real interviews & projects with recruiters',
                    gradientColors: const [Color(0xFFFFD700), Color(0xFF7B2FBE)],
                    tag: 'RANKED',
                    onTap: () => context.push(AppRoutes.opportunities),
                  ).animate(delay: 660.ms).fadeIn().slideX(begin: 0.2),
                ],
              ),
            ),
          ),

          // ── Live Battles ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.neonGreen,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.neonGreen, blurRadius: 6)],
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true))
                          .fade(begin: 0.3, end: 1.0, duration: 800.ms),
                      const SizedBox(width: 8),
                      Text(
                        'LIVE BATTLES',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: context.cqTextPrimary,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(),
                  const SizedBox(height: 12),
                  ..._liveBattles().animate(interval: 100.ms).fadeIn().slideY(begin: 0.1),
                ],
              ),
            ),
          ),

          // ── Battle History ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MY BATTLE HISTORY',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: context.cqTextMuted,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._history(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Mode handlers ──────────────────────────────────────────────────────────

  void _showQuickBattle(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => _MatchmakingDialog(
        onFound: () {
          // Pop the dialog using its own context, then navigate
          Navigator.of(dialogCtx).pop();
          context.push('/battle/quick_${DateTime.now().millisecondsSinceEpoch}');
        },
        onCancel: () => Navigator.of(dialogCtx).pop(),
      ),
    );
  }

  void _showFriendBattle(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _FriendBattleSheet(),
    );
  }

  void _showTournament(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _TournamentSheet(),
    );
  }

  void _showSpectate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _SpectateSheet(),
    );
  }

  // ── Mock data ──────────────────────────────────────────────────────────────

  List<Widget> _liveBattles() => [
        _LiveBattleCard(
          player1: 'code_master', player2: 'algo_ninja',
          challenge: 'Reverse a linked list',
          language: 'Python', duration: '2:34',
          onSpectate: () => _showSpectate(context),
        ),
        const SizedBox(height: 8),
        _LiveBattleCard(
          player1: 'dart_hero', player2: 'js_wizard',
          challenge: 'Binary Search',
          language: 'JavaScript', duration: '0:58',
          onSpectate: () => _showSpectate(context),
        ),
        const SizedBox(height: 8),
        _LiveBattleCard(
          player1: 'byte_slayer', player2: 'null_ptr',
          challenge: 'FizzBuzz with twist',
          language: 'C++', duration: '4:12',
          onSpectate: () => _showSpectate(context),
        ),
      ];

  List<Widget> _history() => [
        _HistoryCard(won: true,  opponent: 'js_wizard',     challenge: 'FizzBuzz',       xp: 200),
        const SizedBox(height: 8),
        _HistoryCard(won: false, opponent: 'code_master',   challenge: 'Fibonacci',      xp: 50),
        const SizedBox(height: 8),
        _HistoryCard(won: true,  opponent: 'bug_slayer_99', challenge: 'Palindrome Check', xp: 200),
      ];
}

// ══════════════════════════════════════════════════════════════════════════════
// ARENA HEADER
// ══════════════════════════════════════════════════════════════════════════════

class _ArenaHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A0A2E), Color(0xFF2D1B69), Color(0xFF0A0E1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          ...List.generate(8, (i) => Positioned(
            left: i * 47.0,
            top: 40.0 + (i * 18.0) % 120,
            child: Text('⚡',
                style: TextStyle(fontSize: 10 + i * 2.0, color: Colors.white.withOpacity(0.04))),
          )),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('BATTLE ARENA',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 3,
                      )),
                  const SizedBox(height: 6),
                  Text("Prove you're the fastest coder",
                      style: TextStyle(fontFamily: 'Rajdhani', fontSize: 16,
                          color: Colors.white.withOpacity(0.7))),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _StatChip(icon: '⚔️', value: '24', label: 'Wins'),
                      const SizedBox(width: 12),
                      _StatChip(icon: '💀', value: '8',  label: 'Losses'),
                      const SizedBox(width: 12),
                      _StatChip(icon: '🏆', value: '#142', label: 'Rank'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String icon, value, label;
  const _StatChip({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(
                  fontFamily: 'Orbitron', fontSize: 14,
                  fontWeight: FontWeight.bold, color: Colors.white)),
              Text(label, style: TextStyle(
                  fontFamily: 'Rajdhani', fontSize: 10,
                  color: Colors.white.withOpacity(0.6))),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// BATTLE MODE CARD
// ══════════════════════════════════════════════════════════════════════════════

class _BattleMode extends StatelessWidget {
  final String icon, title, description;
  final List<Color> gradientColors;
  final String? tag;
  final VoidCallback onTap;

  const _BattleMode({
    required this.icon, required this.title, required this.description,
    required this.gradientColors, this.tag, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [gradientColors[0].withOpacity(0.15), context.cqCard],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(color: gradientColors[0].withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(colors: gradientColors),
              ),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: TextStyle(fontFamily: 'Orbitron', fontSize: 14,
                              fontWeight: FontWeight.bold, color: context.cqTextPrimary)),
                      if (tag != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColors.neonPink.withOpacity(0.2),
                          ),
                          child: Text(tag!,
                              style: const TextStyle(fontFamily: 'Share Tech Mono',
                                  fontSize: 8, color: AppColors.neonPink, letterSpacing: 1)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(description,
                      style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13,
                          color: context.cqTextSecondary)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: context.cqTextMuted, size: 16),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// LIVE BATTLE CARD
// ══════════════════════════════════════════════════════════════════════════════

class _LiveBattleCard extends StatelessWidget {
  final String player1, player2, challenge, language, duration;
  final VoidCallback onSpectate;

  const _LiveBattleCard({
    required this.player1, required this.player2, required this.challenge,
    required this.language, required this.duration, required this.onSpectate,
  });

  static const _langEmoji = {
    'Python': '🐍', 'JavaScript': '⚡', 'Dart': '🎯',
    'Java': '☕', 'C++': '⚙️', 'C': '🔧',
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSpectate,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: context.cqCard,
          border: Border.all(color: AppColors.neonGreen.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(player1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: 'Rajdhani', fontSize: 14,
                          fontWeight: FontWeight.bold, color: AppColors.neonCyan)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: AppColors.fireGradient,
                  ),
                  child: const Text('VS',
                      style: TextStyle(fontFamily: 'Orbitron', fontSize: 12,
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                Expanded(
                  child: Text(player2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: 'Rajdhani', fontSize: 14,
                          fontWeight: FontWeight.bold, color: AppColors.neonPink)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('⏱ $duration  •  ${_langEmoji[language] ?? '💻'} $language  •  $challenge',
                    style: TextStyle(fontFamily: 'Rajdhani', fontSize: 11,
                        color: context.cqTextMuted)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.neonGreen.withOpacity(0.15),
                    border: Border.all(color: AppColors.neonGreen.withOpacity(0.4)),
                  ),
                  child: const Text('SPECTATE',
                      style: TextStyle(fontFamily: 'Orbitron', fontSize: 8,
                          color: AppColors.neonGreen, letterSpacing: 1)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HISTORY CARD
// ══════════════════════════════════════════════════════════════════════════════

class _HistoryCard extends StatelessWidget {
  final bool won;
  final String opponent, challenge;
  final int xp;
  const _HistoryCard({required this.won, required this.opponent,
      required this.challenge, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.cqCard,
        border: Border.all(
            color: won ? AppColors.neonGreen.withOpacity(0.2) : AppColors.error.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(won ? '🏆' : '💀', style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${won ? 'WON' : 'LOST'} vs $opponent',
                    style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: won ? AppColors.neonGreen : AppColors.error)),
                Text(challenge,
                    style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12,
                        color: context.cqTextMuted)),
              ],
            ),
          ),
          Text('${won ? '+' : '-'}$xp XP',
              style: TextStyle(fontFamily: 'Orbitron', fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: won ? AppColors.neonYellow : AppColors.error)),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MODE 1 — QUICK BATTLE: Matchmaking Dialog
// ══════════════════════════════════════════════════════════════════════════════

class _MatchmakingDialog extends StatefulWidget {
  final VoidCallback onFound, onCancel;
  const _MatchmakingDialog({required this.onFound, required this.onCancel});

  @override
  State<_MatchmakingDialog> createState() => _MatchmakingDialogState();
}

class _MatchmakingDialogState extends State<_MatchmakingDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  int _playersSearching = 247;
  String _status = 'Searching for opponent...';
  bool _cancelled = false; // guard against async leak after cancel

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _startMatchmaking();
  }

  void _startMatchmaking() async {
    await Future.delayed(const Duration(seconds: 1));
    if (_cancelled || !mounted) return;
    setState(() { _status = 'Analysing skill level...'; _playersSearching = 189; });

    await Future.delayed(const Duration(seconds: 1));
    if (_cancelled || !mounted) return;
    setState(() { _status = 'Finding best match...'; _playersSearching = 43; });

    await Future.delayed(const Duration(seconds: 1));
    if (_cancelled || !mounted) return;
    setState(() { _status = 'Opponent found! 🎯'; });

    await Future.delayed(const Duration(milliseconds: 600));
    if (_cancelled || !mounted) return; // ← key guard: don't call onFound after cancel
    widget.onFound();
  }

  void _cancel() {
    _cancelled = true;
    widget.onCancel();
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.cqCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) => Transform.scale(
                scale: 0.9 + 0.1 * _pulse.value,
                child: Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.fireGradient,
                    boxShadow: [BoxShadow(color: AppColors.neonPink.withOpacity(0.5), blurRadius: 24)],
                  ),
                  child: const Center(child: Text('⚔️', style: TextStyle(fontSize: 40))),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('QUICK BATTLE',
                style: TextStyle(fontFamily: 'Orbitron', fontSize: 18,
                    fontWeight: FontWeight.bold, color: context.cqTextPrimary, letterSpacing: 2)),
            const SizedBox(height: 8),
            Text(_status,
                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14,
                    color: context.cqTextSecondary)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 8, height: 8,
                    decoration: const BoxDecoration(
                        color: AppColors.neonGreen, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text('$_playersSearching players online',
                    style: const TextStyle(fontFamily: 'Rajdhani', fontSize: 12,
                        color: AppColors.neonGreen)),
              ],
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.neonCyan), strokeWidth: 3),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _cancel,
              child: const Text('CANCEL',
                  style: TextStyle(fontFamily: 'Orbitron', fontSize: 12,
                      color: AppColors.error, letterSpacing: 1)),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MODE 2 — FRIEND BATTLE
// ══════════════════════════════════════════════════════════════════════════════

class _FriendBattleSheet extends StatefulWidget {
  const _FriendBattleSheet();

  @override
  State<_FriendBattleSheet> createState() => _FriendBattleSheetState();
}

class _FriendBattleSheetState extends State<_FriendBattleSheet> {
  final _search = TextEditingController();
  String? _challenged;

  final _friends = [
    {'name': 'algo_ninja',   'level': '24', 'lang': 'Python',     'status': 'online',  'wins': '47'},
    {'name': 'dart_hero',    'level': '18', 'lang': 'Dart',       'status': 'online',  'wins': '32'},
    {'name': 'js_wizard',    'level': '31', 'lang': 'JavaScript', 'status': 'in_game', 'wins': '89'},
    {'name': 'byte_slayer',  'level': '12', 'lang': 'C++',        'status': 'online',  'wins': '21'},
    {'name': 'null_pointer', 'level': '9',  'lang': 'Java',       'status': 'offline', 'wins': '14'},
    {'name': 'loop_legend',  'level': '42', 'lang': 'Python',     'status': 'online',  'wins': '120'},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _friends.where((f) =>
        f['name']!.contains(_search.text.toLowerCase())).toList();

    if (_challenged != null) {
      return _ChallengesentSheet(name: _challenged!, onClose: () => Navigator.pop(context));
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: context.cqCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ── Sheet header with back arrow ─────────────────────────────────
          _SheetHeader(
            icon: '👥',
            title: 'FRIEND BATTLE',
            subtitle: 'Challenge a friend to a duel',
            gradientColors: const [Color(0xFF7B2FBE), Color(0xFF00B4DB)],
            onBack: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: 4),

          // Search
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.cqBg,
                border: Border.all(color: const Color(0xFF7B2FBE).withOpacity(0.4)),
              ),
              child: TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14,
                    color: context.cqTextPrimary),
                decoration: InputDecoration(
                  hintText: '🔍  Search friends...',
                  hintStyle: TextStyle(color: context.cqTextMuted, fontFamily: 'Rajdhani'),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Friend list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final f = filtered[i];
                final isOnline = f['status'] == 'online';
                final inGame  = f['status'] == 'in_game';
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: context.cqBg,
                    border: Border.all(
                      color: isOnline
                          ? AppColors.neonGreen.withOpacity(0.2)
                          : context.cqTextMuted.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      Stack(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.cqCard,
                              border: Border.all(
                                color: isOnline
                                    ? AppColors.neonGreen
                                    : context.cqTextMuted.withOpacity(0.3),
                              ),
                            ),
                            child: Center(child: Text(
                              f['name']![0].toUpperCase(),
                              style: TextStyle(fontFamily: 'Orbitron',
                                  fontSize: 18, color: context.cqTextPrimary),
                            )),
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              width: 12, height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isOnline
                                    ? AppColors.neonGreen
                                    : inGame
                                        ? AppColors.neonOrange
                                        : context.cqTextMuted,
                                border: Border.all(color: context.cqBg, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f['name']!,
                                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 15,
                                    fontWeight: FontWeight.bold, color: context.cqTextPrimary)),
                            Row(
                              children: [
                                Text('Lv.${f['level']}  •  ${f['lang']}  •  ${f['wins']} wins',
                                    style: TextStyle(fontFamily: 'Rajdhani', fontSize: 11,
                                        color: context.cqTextMuted)),
                              ],
                            ),
                            Text(
                              inGame ? '⚔️ In battle' : isOnline ? '🟢 Online' : '⚫ Offline',
                              style: TextStyle(
                                fontFamily: 'Rajdhani', fontSize: 11,
                                color: inGame
                                    ? AppColors.neonOrange
                                    : isOnline
                                        ? AppColors.neonGreen
                                        : context.cqTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Challenge button
                      if (isOnline)
                        GestureDetector(
                          onTap: () => setState(() => _challenged = f['name']),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                  colors: [Color(0xFF7B2FBE), Color(0xFF00B4DB)]),
                            ),
                            child: const Text('CHALLENGE',
                                style: TextStyle(fontFamily: 'Orbitron', fontSize: 9,
                                    fontWeight: FontWeight.bold, color: Colors.white,
                                    letterSpacing: 1)),
                          ),
                        )
                      else
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: context.cqSurface,
                          ),
                          child: Text(inGame ? 'IN GAME' : 'OFFLINE',
                              style: TextStyle(fontFamily: 'Orbitron', fontSize: 9,
                                  color: context.cqTextMuted, letterSpacing: 1)),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }
}

class _ChallengesentSheet extends StatelessWidget {
  final String name;
  final VoidCallback onClose;
  const _ChallengesentSheet({required this.name, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      decoration: BoxDecoration(
        color: context.cqCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('⚔️', style: TextStyle(fontSize: 64))
              .animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 16),
          const Text('CHALLENGE SENT!',
              style: TextStyle(fontFamily: 'Orbitron', fontSize: 20,
                  fontWeight: FontWeight.bold, color: AppColors.neonCyan, letterSpacing: 2)),
          const SizedBox(height: 8),
          Text('Waiting for $name to accept...',
              style: TextStyle(fontFamily: 'Rajdhani', fontSize: 15,
                  color: context.cqTextSecondary)),
          const SizedBox(height: 24),
          const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF7B2FBE)), strokeWidth: 3),
          const SizedBox(height: 24),
          TextButton(
            onPressed: onClose,
            child: const Text('CANCEL CHALLENGE',
                style: TextStyle(fontFamily: 'Orbitron', fontSize: 12,
                    color: AppColors.error, letterSpacing: 1)),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MODE 3 — TOURNAMENT
// ══════════════════════════════════════════════════════════════════════════════

class _TournamentSheet extends StatefulWidget {
  const _TournamentSheet();

  @override
  State<_TournamentSheet> createState() => _TournamentSheetState();
}

class _TournamentSheetState extends State<_TournamentSheet> {
  final _tournaments = [
    {
      'name': 'Python Championship',
      'prize': '5000 XP + 🏆',
      'players': '64',
      'joined': '58',
      'time': 'Starts in 2h 14m',
      'status': 'open',
      'difficulty': 'Intermediate',
      'color': 0xFF3572A5,
      'icon': '🐍',
    },
    {
      'name': 'Speed Code Cup',
      'prize': '3000 XP + 💎',
      'players': '32',
      'joined': '32',
      'time': '🔴 LIVE NOW',
      'status': 'live',
      'difficulty': 'All levels',
      'color': 0xFFFF006E,
      'icon': '⚡',
    },
    {
      'name': 'Algorithm Masters',
      'prize': '10000 XP + 👑',
      'players': '128',
      'joined': '112',
      'time': 'Starts in 6h 30m',
      'status': 'open',
      'difficulty': 'Advanced',
      'color': 0xFFFFD700,
      'icon': '🧠',
    },
    {
      'name': 'Beginner Bash',
      'prize': '1000 XP + 🎖️',
      'players': '32',
      'joined': '11',
      'time': 'Starts in 30m',
      'status': 'open',
      'difficulty': 'Beginner',
      'color': 0xFF00B09B,
      'icon': '🌱',
    },
  ];

  String? _joined;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: context.cqCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _SheetHeader(
            icon: '🏆',
            title: 'TOURNAMENTS',
            subtitle: 'Compete for glory and massive XP',
            gradientColors: const [Color(0xFFFFD700), Color(0xFFFF8C00)],
            onBack: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _tournaments.length,
              itemBuilder: (_, i) {
                final t = _tournaments[i];
                final color = Color(t['color'] as int);
                final isLive = t['status'] == 'live';
                final isFull = (t['joined'] as String) == (t['players'] as String) && !isLive;
                final isJoined = _joined == t['name'];

                return Container(
                  margin: EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: context.cqBg,
                    border: Border.all(color: color.withOpacity(0.3), width: 1.5),
                    boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 12)],
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          gradient: LinearGradient(
                              colors: [color.withOpacity(0.2), Colors.transparent],
                              begin: Alignment.centerLeft),
                        ),
                        child: Row(
                          children: [
                            Text(t['icon'] as String, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t['name'] as String,
                                      style: TextStyle(fontFamily: 'Orbitron', fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: context.cqTextPrimary)),
                                  const SizedBox(height: 2),
                                  Text('🎁 Prize: ${t['prize']}',
                                      style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12,
                                          color: color, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            if (isLive)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.neonPink.withOpacity(0.2),
                                  border: Border.all(color: AppColors.neonPink),
                                ),
                                child: const Text('● LIVE',
                                    style: TextStyle(fontFamily: 'Orbitron', fontSize: 9,
                                        color: AppColors.neonPink, letterSpacing: 1)),
                              ),
                          ],
                        ),
                      ),

                      // Details
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _TournamentStat('👥', '${t['joined']}/${t['players']}', 'Players'),
                                const SizedBox(width: 12),
                                _TournamentStat('🎯', t['difficulty'] as String, 'Level'),
                                const SizedBox(width: 12),
                                _TournamentStat('⏱️', t['time'] as String, 'Timing'),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: int.parse(t['joined'] as String) /
                                    int.parse(t['players'] as String),
                                backgroundColor: color.withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation(color),
                                minHeight: 5,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Join button
                            SizedBox(
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: isFull
                                    ? null
                                    : () => setState(() => _joined = t['name'] as String),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: isJoined
                                        ? null
                                        : isFull
                                            ? null
                                            : LinearGradient(
                                                colors: [color, color.withOpacity(0.7)]),
                                    color: isJoined
                                        ? AppColors.neonGreen.withOpacity(0.2)
                                        : isFull
                                            ? context.cqSurface
                                            : null,
                                    border: isJoined
                                        ? Border.all(color: AppColors.neonGreen)
                                        : null,
                                  ),
                                  child: Text(
                                    isJoined
                                        ? '✓ REGISTERED'
                                        : isLive
                                            ? 'SPECTATE'
                                            : isFull
                                                ? 'FULL'
                                                : 'JOIN NOW',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Orbitron',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isJoined
                                          ? AppColors.neonGreen
                                          : isFull
                                              ? context.cqTextMuted
                                              : Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED SHEET HEADER — back arrow + drag handle + title
// ══════════════════════════════════════════════════════════════════════════════

class _SheetHeader extends StatelessWidget {
  final String icon, title, subtitle;
  final List<Color> gradientColors;
  final VoidCallback onBack;

  const _SheetHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 4),
          width: 40, height: 4,
          decoration: BoxDecoration(
            color: context.cqTextMuted.withOpacity(0.35),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Header row: back ← | icon + title | close ×
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 12, 8),
          child: Row(
            children: [
              // Back / close button
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.neonCyan, size: 18),
                onPressed: onBack,
                tooltip: 'Back',
              ),
              // Icon badge
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: gradientColors),
                ),
                child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
              ),
              const SizedBox(width: 10),
              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(fontFamily: 'Orbitron', fontSize: 14,
                            fontWeight: FontWeight.bold, color: context.cqTextPrimary)),
                    Text(subtitle,
                        style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12,
                            color: context.cqTextSecondary)),
                  ],
                ),
              ),
              // Close X
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.cqSurface,
                  ),
                  child: Icon(Icons.close_rounded,
                      color: context.cqTextMuted, size: 16),
                ),
              ),
            ],
          ),
        ),
        Divider(color: context.cqSurface, height: 1, thickness: 1),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _TournamentStat extends StatelessWidget {
  final String emoji, value, label;
  const _TournamentStat(this.emoji, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.cqCard,
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 2),
            Text(value,
                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 11,
                    fontWeight: FontWeight.bold, color: context.cqTextPrimary),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(label,
                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 9,
                    color: context.cqTextMuted)),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MODE 4 — SPECTATE
// ══════════════════════════════════════════════════════════════════════════════

class _SpectateSheet extends StatefulWidget {
  const _SpectateSheet();

  @override
  State<_SpectateSheet> createState() => _SpectateSheetState();
}

class _SpectateSheetState extends State<_SpectateSheet> {
  int? _watching;

  final _battles = [
    {
      'p1': 'code_master',   'p2': 'algo_ninja',
      'challenge': 'Reverse a Linked List',
      'lang': 'Python', 'time': '2:34',
      'p1progress': 0.7, 'p2progress': 0.4,
      'viewers': '142', 'color': 0xFF3572A5,
    },
    {
      'p1': 'dart_hero',    'p2': 'js_wizard',
      'challenge': 'Binary Search',
      'lang': 'JavaScript', 'time': '0:58',
      'p1progress': 0.3, 'p2progress': 0.8,
      'viewers': '89', 'color': 0xFFF7DF1E,
    },
    {
      'p1': 'byte_slayer',  'p2': 'null_ptr',
      'challenge': 'FizzBuzz with Twist',
      'lang': 'C++', 'time': '4:12',
      'p1progress': 0.9, 'p2progress': 0.6,
      'viewers': '57', 'color': 0xFFF34B7D,
    },
    {
      'p1': 'loop_legend',  'p2': 'stack_hero',
      'challenge': 'Two Sum (O(n))',
      'lang': 'Java', 'time': '1:20',
      'p1progress': 0.5, 'p2progress': 0.5,
      'viewers': '203', 'color': 0xFFB07219,
    },
  ];

  static const _langEmoji = {
    'Python': '🐍', 'JavaScript': '⚡',
    'C++': '⚙️', 'Java': '☕',
  };

  @override
  Widget build(BuildContext context) {
    if (_watching != null) {
      return _SpectateView(
        battle: _battles[_watching!],
        onBack: () => setState(() => _watching = null),
        onLeave: () => Navigator.pop(context),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: context.cqCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _SheetHeader(
            icon: '👁️',
            title: 'SPECTATE',
            subtitle: '🟢  4 live battles right now',
            gradientColors: const [Color(0xFF00B09B), Color(0xFF39FF14)],
            onBack: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _battles.length,
              itemBuilder: (_, i) {
                final b = _battles[i];
                final color = Color(b['color'] as int);
                return GestureDetector(
                  onTap: () => setState(() => _watching = i),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: context.cqBg,
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        // Players
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(b['p1'] as String,
                                      style: const TextStyle(fontFamily: 'Rajdhani',
                                          fontSize: 14, fontWeight: FontWeight.bold,
                                          color: AppColors.neonCyan)),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: LinearProgressIndicator(
                                      value: b['p1progress'] as double,
                                      backgroundColor: context.cqSurface,
                                      valueColor: const AlwaysStoppedAnimation(AppColors.neonCyan),
                                      minHeight: 5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text('${((b['p1progress'] as double) * 100).round()}%',
                                      style: const TextStyle(fontFamily: 'Orbitron',
                                          fontSize: 10, color: AppColors.neonCyan)),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: AppColors.fireGradient,
                              ),
                              child: const Text('VS',
                                  style: TextStyle(fontFamily: 'Orbitron', fontSize: 11,
                                      fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(b['p2'] as String,
                                      style: const TextStyle(fontFamily: 'Rajdhani',
                                          fontSize: 14, fontWeight: FontWeight.bold,
                                          color: AppColors.neonPink)),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: LinearProgressIndicator(
                                      value: b['p2progress'] as double,
                                      backgroundColor: context.cqSurface,
                                      valueColor: const AlwaysStoppedAnimation(AppColors.neonPink),
                                      minHeight: 5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text('${((b['p2progress'] as double) * 100).round()}%',
                                      style: const TextStyle(fontFamily: 'Orbitron',
                                          fontSize: 10, color: AppColors.neonPink)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Meta row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${_langEmoji[b['lang']] ?? '💻'} ${b['lang']}  •  ⏱ ${b['time']}  •  ${b['challenge']}',
                                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 11,
                                    color: context.cqTextMuted)),
                            Row(
                              children: [
                                Icon(Icons.remove_red_eye_outlined,
                                    size: 12, color: context.cqTextMuted),
                                const SizedBox(width: 3),
                                Text(b['viewers'] as String,
                                    style: TextStyle(fontFamily: 'Rajdhani',
                                        fontSize: 11, color: context.cqTextMuted)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: color.withOpacity(0.12),
                            border: Border.all(color: color.withOpacity(0.4)),
                          ),
                          child: Text('👁️  WATCH LIVE',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Orbitron', fontSize: 11,
                                  fontWeight: FontWeight.bold, color: color, letterSpacing: 1)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}

// ─── Spectate live view ───────────────────────────────────────────────────────

class _SpectateView extends StatefulWidget {
  final Map<String, dynamic> battle;
  final VoidCallback onBack, onLeave;
  const _SpectateView({required this.battle, required this.onBack, required this.onLeave});

  @override
  State<_SpectateView> createState() => _SpectateViewState();
}

class _SpectateViewState extends State<_SpectateView> {
  int _viewers = 0;
  double _p1 = 0, _p2 = 0;

  @override
  void initState() {
    super.initState();
    _viewers = int.parse(widget.battle['viewers'] as String);
    _p1 = widget.battle['p1progress'] as double;
    _p2 = widget.battle['p2progress'] as double;
    _simulate();
  }

  void _simulate() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() {
        _p1 = (_p1 + 0.03).clamp(0.0, 1.0);
        _p2 = (_p2 + 0.02).clamp(0.0, 1.0);
        _viewers += (mounted ? 1 : 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.battle;
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: context.cqBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Top bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: context.cqCard,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                GestureDetector(onTap: widget.onBack,
                    child: const Icon(Icons.arrow_back_ios, color: AppColors.neonCyan, size: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b['challenge'] as String,
                          style: TextStyle(fontFamily: 'Orbitron', fontSize: 13,
                              fontWeight: FontWeight.bold, color: context.cqTextPrimary)),
                      Text('${b['lang']}  •  ⏱ ${b['time']}',
                          style: TextStyle(fontFamily: 'Rajdhani', fontSize: 11,
                              color: context.cqTextMuted)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.neonPink.withOpacity(0.2),
                      ),
                      child: const Text('● LIVE',
                          style: TextStyle(fontFamily: 'Orbitron', fontSize: 9,
                              color: AppColors.neonPink, letterSpacing: 1)),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.remove_red_eye_outlined, size: 14, color: context.cqTextMuted),
                    const SizedBox(width: 4),
                    Text('$_viewers',
                        style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12,
                            color: context.cqTextMuted)),
                  ],
                ),
              ],
            ),
          ),

          // Player headers
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: _PlayerPanel(
                    name: b['p1'] as String, progress: _p1,
                    color: AppColors.neonCyan, isLeading: _p1 >= _p2)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('VS', style: TextStyle(fontFamily: 'Orbitron',
                      fontSize: 14, fontWeight: FontWeight.bold,
                      color: context.cqTextMuted)),
                ),
                Expanded(child: _PlayerPanel(
                    name: b['p2'] as String, progress: _p2,
                    color: AppColors.neonPink, isLeading: _p2 > _p1)),
              ],
            ),
          ),

          // Mock code panes
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _CodePane(player: b['p1'] as String,
                      color: AppColors.neonCyan, progress: _p1)),
                  const SizedBox(width: 8),
                  Expanded(child: _CodePane(player: b['p2'] as String,
                      color: AppColors.neonPink, progress: _p2)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Leave button
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16,
                MediaQuery.of(context).padding.bottom + 12),
            child: GestureDetector(
              onTap: widget.onLeave,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: context.cqCard,
                  border: Border.all(color: context.cqTextMuted.withOpacity(0.2)),
                ),
                child: Center(
                  child: Text('LEAVE SPECTATE',
                      style: TextStyle(fontFamily: 'Orbitron', fontSize: 12,
                          color: context.cqTextMuted, letterSpacing: 1)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerPanel extends StatelessWidget {
  final String name;
  final double progress;
  final Color color;
  final bool isLeading;
  const _PlayerPanel({required this.name, required this.progress,
      required this.color, required this.isLeading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13,
                  fontWeight: FontWeight.bold, color: color)),
              if (isLeading) ...[
                const SizedBox(width: 4),
                const Text('🔥', style: TextStyle(fontSize: 12)),
              ],
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text('${(progress * 100).round()}%',
              style: TextStyle(fontFamily: 'Orbitron', fontSize: 10,
                  color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _CodePane extends StatelessWidget {
  final String player;
  final Color color;
  final double progress;
  const _CodePane({required this.player, required this.color, required this.progress});

  @override
  Widget build(BuildContext context) {
    // Show more lines as progress increases
    final lines = (progress * 12).round().clamp(2, 12);
    final code = [
      'def solve(nums):',
      '    result = {}',
      '    for i, n in',
      '      enumerate(nums):',
      '        comp = target - n',
      '        if comp in result:',
      '            return [result',
      '                [comp], i]',
      '        result[n] = i',
      '    return []',
      '',
      '# All tests passed ✓',
    ].take(lines).join('\n');

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF0D1117),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
              const SizedBox(width: 6),
              Text(player,
                  style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 10, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(code,
                style: const TextStyle(fontFamily: 'Share Tech Mono', fontSize: 10,
                    color: Color(0xFFE6EDF3), height: 1.6)),
          ),
        ],
      ),
    );
  }
}

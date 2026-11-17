import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

// ─── Enums & Models ───────────────────────────────────────────────────────────

enum TeamRole { coder, tester, reviewer }

enum LadderPhase { lobby, roleSelect, quest, results }

extension TeamRoleX on TeamRole {
  String get label => switch (this) {
        TeamRole.coder => 'CODER',
        TeamRole.tester => 'TESTER',
        TeamRole.reviewer => 'REVIEWER',
      };

  String get emoji => switch (this) {
        TeamRole.coder => '💻',
        TeamRole.tester => '🧪',
        TeamRole.reviewer => '🔍',
      };

  String get description => switch (this) {
        TeamRole.coder =>
          'Write the solution. Your code must pass all test cases.',
        TeamRole.tester =>
          'Write edge-case inputs. Find bugs before review.',
        TeamRole.reviewer =>
          'Review code quality, suggest improvements, check logic.',
      };

  Color get color => switch (this) {
        TeamRole.coder => AppColors.neonCyan,
        TeamRole.tester => AppColors.neonGreen,
        TeamRole.reviewer => AppColors.neonOrange,
      };

  List<String> get tasks => switch (this) {
        TeamRole.coder => [
            'Read the problem carefully',
            'Plan your approach first',
            'Write clean, readable code',
            'Handle edge cases in logic',
            'Submit when all tests pass',
          ],
        TeamRole.tester => [
            'Identify boundary conditions',
            'Test empty / null inputs',
            'Test negative numbers',
            'Test very large inputs',
            'Document each test case',
          ],
        TeamRole.reviewer => [
            'Check variable naming',
            'Look for off-by-one errors',
            'Verify time complexity',
            'Check for code duplication',
            'Give constructive feedback',
          ],
      };
}

class _TeamSlot {
  final String name;
  final TeamRole role;
  final String emoji;
  final bool isYou;
  final int score;

  const _TeamSlot({
    required this.name,
    required this.role,
    required this.emoji,
    required this.score,
    this.isYou = false,
  });
}

class _OpenTeam {
  final String id;
  final String name;
  final String quest;
  final String difficulty;
  final Color diffColor;
  final List<TeamRole> filledRoles;
  final int xpPrize;

  const _OpenTeam({
    required this.id,
    required this.name,
    required this.quest,
    required this.difficulty,
    required this.diffColor,
    required this.filledRoles,
    required this.xpPrize,
  });

  List<TeamRole> get openRoles => TeamRole.values
      .where((r) => !filledRoles.contains(r))
      .toList();
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class TeamLadderScreen extends ConsumerStatefulWidget {
  const TeamLadderScreen({super.key});

  @override
  ConsumerState<TeamLadderScreen> createState() => _TeamLadderScreenState();
}

class _TeamLadderScreenState extends ConsumerState<TeamLadderScreen>
    with TickerProviderStateMixin {
  LadderPhase _phase = LadderPhase.lobby;
  TeamRole? _myRole;
  late AnimationController _pulseController;

  // Quest timer
  Timer? _questTimer;
  int _questSecondsLeft = 600; // 10 min
  bool _questStarted = false;

  // Role task progress (0.0 – 1.0 per task)
  final Map<int, double> _taskProgress = {};

  // Collaboration scores (0–10)
  double _coderScore = 0;
  double _testerScore = 0;
  double _reviewerScore = 0;
  bool _resultsReady = false;

  // Current code in editor (coder role)
  final _codeController = TextEditingController(
    text: 'def find_pairs(nums, target):\n    # Write your solution here\n    pass\n',
  );

  // Reviewer notes
  final _reviewController = TextEditingController();

  // Tester cases
  final List<Map<String, String>> _testCases = [
    {'input': '', 'expected': ''},
  ];

  final _openTeams = const [
    _OpenTeam(
      id: 't1',
      name: 'Cyber Wolves',
      quest: 'Find All Pairs with Target Sum',
      difficulty: 'Medium',
      diffColor: AppColors.neonOrange,
      filledRoles: [TeamRole.coder],
      xpPrize: 800,
    ),
    _OpenTeam(
      id: 't2',
      name: 'Debug Squad',
      quest: 'Longest Palindromic Substring',
      difficulty: 'Hard',
      diffColor: AppColors.neonPink,
      filledRoles: [TeamRole.tester],
      xpPrize: 1200,
    ),
    _OpenTeam(
      id: 't3',
      name: 'Stack Overflow',
      quest: 'Implement LRU Cache',
      difficulty: 'Hard',
      diffColor: AppColors.neonPink,
      filledRoles: [TeamRole.reviewer, TeamRole.tester],
      xpPrize: 1500,
    ),
    _OpenTeam(
      id: 't4',
      name: 'Null Pointers',
      quest: 'Binary Tree Level Order',
      difficulty: 'Easy',
      diffColor: AppColors.neonGreen,
      filledRoles: [],
      xpPrize: 450,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _questTimer?.cancel();
    _codeController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _startQuest() {
    setState(() {
      _phase = LadderPhase.quest;
      _questStarted = true;
      _questSecondsLeft = 600;
    });
    _questTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_questSecondsLeft > 0) {
          _questSecondsLeft--;
        } else {
          t.cancel();
          _endQuest();
        }
      });
    });
  }

  void _endQuest() {
    _questTimer?.cancel();
    // Simulate scoring based on progress
    final tasksDone = _taskProgress.values.where((v) => v >= 1.0).length;
    final completionRate = tasksDone / 5;

    setState(() {
      switch (_myRole!) {
        case TeamRole.coder:
          _coderScore = (6.0 + completionRate * 4.0).clamp(0, 10);
          _testerScore = 7.2;
          _reviewerScore = 8.1;
        case TeamRole.tester:
          _testerScore = (5.5 + completionRate * 4.5).clamp(0, 10);
          _coderScore = 7.8;
          _reviewerScore = 6.9;
        case TeamRole.reviewer:
          _reviewerScore = (6.0 + completionRate * 4.0).clamp(0, 10);
          _coderScore = 8.3;
          _testerScore = 7.5;
      }
      _resultsReady = true;
      _phase = LadderPhase.results;
    });
  }

  String get _timerLabel {
    final m = (_questSecondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_questSecondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Color get _timerColor {
    if (_questSecondsLeft > 300) return AppColors.neonGreen;
    if (_questSecondsLeft > 120) return AppColors.neonOrange;
    return AppColors.error;
  }

  double get _collaborationScore {
    final weighted = (_coderScore * 0.4) + (_testerScore * 0.3) + (_reviewerScore * 0.3);
    return weighted;
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (_phase) {
        LadderPhase.lobby => _buildLobby(),
        LadderPhase.roleSelect => _buildRoleSelect(),
        LadderPhase.quest => _buildQuest(),
        LadderPhase.results => _buildResults(),
      },
    );
  }

  // ─── PHASE 1: Lobby ────────────────────────────────────────────────────────

  Widget _buildLobby() {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A1628), Color(0xFF1B2A4A), Color(0xFF0A0E1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: AppColors.neonCyan, size: 18),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 4),
                        ShaderMask(
                          shaderCallback: (b) =>
                              AppColors.cyberpunkGradient.createShader(b),
                          child: const Text(
                            'TEAM LADDER',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Code together. Score collaboration.',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Role legend chips
                    Row(
                      children: TeamRole.values.map((r) => Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: r.color.withOpacity(0.12),
                          border: Border.all(color: r.color.withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(r.emoji, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(r.label,
                                style: TextStyle(
                                  fontFamily: 'Orbitron',
                                  fontSize: 9,
                                  color: r.color,
                                  letterSpacing: 1,
                                )),
                          ],
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Create team button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: GestureDetector(
              onTap: () => setState(() => _phase = LadderPhase.roleSelect),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: AppColors.cyberpunkGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonCyan.withOpacity(0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text('⚡', style: TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CREATE NEW TEAM',
                              style: TextStyle(
                                fontFamily: 'Orbitron',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              )),
                          SizedBox(height: 4),
                          Text('Pick your role & start a quest',
                              style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 13,
                                color: Colors.white70,
                              )),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 16),
                  ],
                ),
              ),
            ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),
          ),
        ),

        // Section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (_, __) => Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.neonGreen,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonGreen
                              .withOpacity(_pulseController.value),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('OPEN TEAMS',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: context.cqTextPrimary,
                      letterSpacing: 2,
                    )),
              ],
            ),
          ),
        ),

        // Open teams list
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _OpenTeamCard(
                team: _openTeams[i],
                onJoin: (role) {
                  setState(() {
                    _myRole = role;
                    _phase = LadderPhase.quest;
                  });
                  _startQuest();
                },
              ).animate(delay: Duration(milliseconds: i * 80)).fadeIn().slideX(begin: 0.05),
              childCount: _openTeams.length,
            ),
          ),
        ),
      ],
    );
  }

  // ─── PHASE 2: Role Selection ───────────────────────────────────────────────

  Widget _buildRoleSelect() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.neonCyan, size: 18),
          onPressed: () => setState(() => _phase = LadderPhase.lobby),
        ),
        title: const Text('CHOOSE YOUR ROLE',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Each role has unique tasks.\nAll three must collaborate to win.',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 16,
                color: context.cqTextSecondary,
                height: 1.5,
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 28),

            ...TeamRole.values.asMap().entries.map((e) {
              final role = e.value;
              final isSelected = _myRole == role;
              return GestureDetector(
                onTap: () => setState(() => _myRole = role),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isSelected
                        ? role.color.withOpacity(0.12)
                        : context.cqCard,
                    border: Border.all(
                      color: isSelected
                          ? role.color
                          : context.cqSurface,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(
                            color: role.color.withOpacity(0.3),
                            blurRadius: 20)]
                        : [],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: role.color.withOpacity(0.15),
                          border: Border.all(
                            color: role.color.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(role.emoji,
                              style: const TextStyle(fontSize: 28)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(role.label,
                                style: TextStyle(
                                  fontFamily: 'Orbitron',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? role.color
                                      : context.cqTextPrimary,
                                  letterSpacing: 1.5,
                                )),
                            const SizedBox(height: 4),
                            Text(role.description,
                                style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 13,
                                  color: context.cqTextSecondary,
                                  height: 1.4,
                                )),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle_rounded,
                            color: role.color, size: 24),
                    ],
                  ),
                ).animate(delay: Duration(milliseconds: e.key * 100))
                    .fadeIn()
                    .slideX(begin: 0.1),
              );
            }),

            const Spacer(),

            if (_myRole != null)
              GestureDetector(
                onTap: _startQuest,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [_myRole!.color, _myRole!.color.withOpacity(0.6)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _myRole!.color.withOpacity(0.4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_myRole!.emoji,
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(
                        'START AS ${_myRole!.label}',
                        style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn().slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }

  // ─── PHASE 3: Active Quest ─────────────────────────────────────────────────

  Widget _buildQuest() {
    if (_myRole == null) return const SizedBox();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildQuestHeader(),
            Expanded(child: _buildRoleUI()),
            _buildQuestFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: context.cqBgSecondary,
      child: Row(
        children: [
          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _myRole!.color.withOpacity(0.15),
              border: Border.all(color: _myRole!.color.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_myRole!.emoji, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 5),
                Text(_myRole!.label,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 9,
                      color: _myRole!.color,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          const Spacer(),
          // Timer
          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _timerColor.withOpacity(0.12),
                border: Border.all(color: _timerColor.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.timer_outlined, color: _timerColor, size: 14),
                  const SizedBox(width: 5),
                  Text(_timerLabel,
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _timerColor,
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Team progress dots
          Row(
            children: [
              _TeamDot(role: TeamRole.coder, active: _myRole == TeamRole.coder),
              const SizedBox(width: 4),
              _TeamDot(role: TeamRole.tester, active: _myRole == TeamRole.tester),
              const SizedBox(width: 4),
              _TeamDot(role: TeamRole.reviewer, active: _myRole == TeamRole.reviewer),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleUI() {
    return switch (_myRole!) {
      TeamRole.coder => _buildCoderUI(),
      TeamRole.tester => _buildTesterUI(),
      TeamRole.reviewer => _buildReviewerUI(),
    };
  }

  Widget _buildCoderUI() {
    return Column(
      children: [
        // Problem statement
        Container(
          margin: const EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: context.cqCard,
            border: Border.all(color: AppColors.neonCyan.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.neonOrange.withOpacity(0.15),
                      border: Border.all(color: AppColors.neonOrange.withOpacity(0.4)),
                    ),
                    child: const Text('MEDIUM',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 8,
                          color: AppColors.neonOrange,
                          letterSpacing: 1,
                        )),
                  ),
                  const SizedBox(width: 8),
                  Text('Find All Pairs with Target Sum',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: context.cqTextPrimary,
                      )),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Given an array of integers and a target, return all unique pairs of indices [i, j] where nums[i] + nums[j] == target.',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 14,
                  color: context.cqTextSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: context.cqCardSecondary,
                ),
                child: const Text(
                  'Input: nums=[2,7,11,3,4], target=9\nOutput: [[0,1],[2,4]] → (2+7, 3+6? no... 2+7=9✓, 11+? no, 3+6? no, wait: check 3+? ... hmm just 2+7)',
                  style: TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 11,
                    color: AppColors.neonGreen,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Code editor
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF0D1117),
              border: Border.all(color: AppColors.neonCyan.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: AppColors.neonCyan.withOpacity(0.15)),
                    ),
                  ),
                  child: Row(
                    children: [
                      for (final c in [Colors.red, Colors.orange, Colors.green])
                        Container(
                          width: 8, height: 8,
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            color: c, shape: BoxShape.circle),
                        ),
                      const SizedBox(width: 8),
                      const Text('solution.py',
                          style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 10,
                            color: AppColors.neonCyan,
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(
                      fontFamily: 'Share Tech Mono',
                      fontSize: 13,
                      color: AppColors.neonGreen,
                      height: 1.6,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTesterUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checklist
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: context.cqCard,
              border: Border.all(color: AppColors.neonGreen.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('YOUR TESTING CHECKLIST',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 11,
                      color: AppColors.neonGreen,
                      letterSpacing: 2,
                    )),
                const SizedBox(height: 14),
                ...TeamRole.tester.tasks.asMap().entries.map((e) {
                  final done = (_taskProgress[e.key] ?? 0) >= 1.0;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _taskProgress[e.key] = done ? 0.0 : 1.0;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: done
                            ? AppColors.neonGreen.withOpacity(0.08)
                            : context.cqCardSecondary,
                        border: Border.all(
                          color: done
                              ? AppColors.neonGreen.withOpacity(0.4)
                              : context.cqSurface,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            done
                                ? Icons.check_circle_rounded
                                : Icons.circle_outlined,
                            color: done
                                ? AppColors.neonGreen
                                : context.cqTextMuted,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(e.value,
                                style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 14,
                                  color: done
                                      ? AppColors.neonGreen
                                      : context.cqTextSecondary,
                                  decoration: done
                                      ? TextDecoration.lineThrough
                                      : null,
                                )),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Test case builder
          const Text('BUILD TEST CASES',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 11,
                color: AppColors.neonGreen,
                letterSpacing: 2,
              )),
          const SizedBox(height: 12),

          ..._testCases.asMap().entries.map((e) => _TestCaseRow(
                index: e.key,
                input: e.value['input']!,
                expected: e.value['expected']!,
                onInputChanged: (v) =>
                    setState(() => _testCases[e.key]['input'] = v),
                onExpectedChanged: (v) =>
                    setState(() => _testCases[e.key]['expected'] = v),
              )),

          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => _testCases.add({'input': '', 'expected': ''})),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.neonGreen.withOpacity(0.08),
                border: Border.all(
                  color: AppColors.neonGreen.withOpacity(0.3),
                  style: BorderStyle.solid,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppColors.neonGreen, size: 18),
                  SizedBox(width: 6),
                  Text('ADD TEST CASE',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 10,
                        color: AppColors.neonGreen,
                        letterSpacing: 1,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewerUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Code being reviewed (read-only)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFF0D1117),
              border: Border.all(color: AppColors.neonOrange.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('CODE SUBMITTED BY CODER',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 9,
                          color: AppColors.neonOrange,
                          letterSpacing: 1.5,
                        )),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.neonGreen.withOpacity(0.15),
                      ),
                      child: const Text('READ ONLY',
                          style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 8,
                            color: AppColors.neonGreen,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'def find_pairs(nums, target):\n    result = []\n    seen = {}\n    for i, n in enumerate(nums):\n        comp = target - n\n        if comp in seen:\n            result.append([seen[comp], i])\n        seen[n] = i\n    return result',
                  style: TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 12,
                    color: Color(0xFFE6EDF3),
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Rubric checklist
          const Text('REVIEW CHECKLIST',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 11,
                color: AppColors.neonOrange,
                letterSpacing: 2,
              )),
          const SizedBox(height: 12),

          ...TeamRole.reviewer.tasks.asMap().entries.map((e) {
            final done = (_taskProgress[e.key] ?? 0) >= 1.0;
            return GestureDetector(
              onTap: () => setState(() {
                _taskProgress[e.key] = done ? 0.0 : 1.0;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: done
                      ? AppColors.neonOrange.withOpacity(0.08)
                      : context.cqCard,
                  border: Border.all(
                    color: done
                        ? AppColors.neonOrange.withOpacity(0.4)
                        : context.cqSurface,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      done
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: done
                          ? AppColors.neonOrange
                          : context.cqTextMuted,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(e.value,
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 14,
                            color: done
                                ? AppColors.neonOrange
                                : context.cqTextSecondary,
                            decoration: done
                                ? TextDecoration.lineThrough
                                : null,
                          )),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          // Notes field
          const Text('REVIEWER NOTES',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 11,
                color: AppColors.neonOrange,
                letterSpacing: 2,
              )),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: context.cqCard,
              border: Border.all(
                  color: AppColors.neonOrange.withOpacity(0.3)),
            ),
            child: TextField(
              controller: _reviewController,
              maxLines: 5,
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 14,
                color: context.cqTextPrimary,
              ),
              decoration: InputDecoration(
                hintText:
                    'e.g. "Good use of hashmap for O(n) solution, but missing null check for empty array..."',
                hintStyle: TextStyle(
                  color: context.cqTextMuted,
                  fontFamily: 'Rajdhani',
                  fontSize: 13,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestFooter() {
    final tasksDone =
        _taskProgress.values.where((v) => v >= 1.0).length;
    final progress = tasksDone / 5;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: context.cqBgSecondary,
        border:
            Border(top: BorderSide(color: context.cqSurface)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('${_myRole!.emoji} YOUR PROGRESS',
                  style: TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 10,
                    color: context.cqTextMuted,
                    letterSpacing: 1,
                  )),
              const Spacer(),
              Text('$tasksDone/5 tasks',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 10,
                    color: _myRole!.color,
                  )),
            ],
          ),
          SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: context.cqSurface,
              valueColor: AlwaysStoppedAnimation(_myRole!.color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _endQuest,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [_myRole!.color, _myRole!.color.withOpacity(0.6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _myRole!.color.withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Center(
                child: Text('SUBMIT & FINISH QUEST',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── PHASE 4: Results ──────────────────────────────────────────────────────

  Widget _buildResults() {
    final teamSlots = [
      _TeamSlot(
          name: 'YOU',
          role: _myRole!,
          emoji: _myRole!.emoji,
          isYou: true,
          score: (_myRole == TeamRole.coder
                  ? _coderScore
                  : _myRole == TeamRole.tester
                      ? _testerScore
                      : _reviewerScore)
              .round()),
      _TeamSlot(
          name: 'algo_ninja',
          role: TeamRole.values.firstWhere((r) => r != _myRole),
          emoji: '🥷',
          score: 78),
      _TeamSlot(
          name: 'byte_slayer',
          role: TeamRole.values.lastWhere((r) => r != _myRole),
          emoji: '⚔️',
          score: 81),
    ];

    final xpEarned = (_collaborationScore * 80).round();
    final collabGrade = _collaborationScore >= 8.5
        ? 'S'
        : _collaborationScore >= 7.5
            ? 'A'
            : _collaborationScore >= 6.5
                ? 'B'
                : 'C';
    final gradeColor = _collaborationScore >= 8.5
        ? AppColors.neonYellow
        : _collaborationScore >= 7.5
            ? AppColors.neonGreen
            : _collaborationScore >= 6.5
                ? AppColors.neonCyan
                : AppColors.neonOrange;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.fromLTRB(
                24, MediaQuery.of(context).padding.top + 20, 24, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A1628), Color(0xFF1A0A2E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                // Grade circle
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [gradeColor, gradeColor.withOpacity(0.4)],
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: gradeColor.withOpacity(0.5),
                          blurRadius: 30),
                    ],
                  ),
                  child: Center(
                    child: Text(collabGrade,
                        style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        )),
                  ),
                ).animate().scale(
                    duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: 16),
                const Text('TEAM QUEST COMPLETE!',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    )).animate(delay: 200.ms).fadeIn(),
                const SizedBox(height: 4),
                Text(
                  'Collaboration Score: ${_collaborationScore.toStringAsFixed(1)}/10',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 15,
                    color: gradeColor,
                  ),
                ).animate(delay: 300.ms).fadeIn(),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.neonYellow.withOpacity(0.12),
                    border: Border.all(
                        color: AppColors.neonYellow.withOpacity(0.4)),
                  ),
                  child: Text(
                    '+$xpEarned XP EARNED',
                    style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonYellow,
                    ),
                  ),
                ).animate(delay: 400.ms).fadeIn().scale(
                    begin: const Offset(0.8, 0.8)),
              ],
            ),
          ),
        ),

        // Role breakdown
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ROLE SCORES',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 11,
                      color: context.cqTextMuted,
                      letterSpacing: 2,
                    )),
                const SizedBox(height: 14),
                _RoleScoreBar(role: TeamRole.coder, score: _coderScore, weight: 0.40),
                const SizedBox(height: 10),
                _RoleScoreBar(role: TeamRole.tester, score: _testerScore, weight: 0.30),
                const SizedBox(height: 10),
                _RoleScoreBar(role: TeamRole.reviewer, score: _reviewerScore, weight: 0.30),
              ],
            ),
          ).animate(delay: 500.ms).fadeIn(),
        ),

        // Team members
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TEAM PERFORMANCE',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 11,
                      color: context.cqTextMuted,
                      letterSpacing: 2,
                    )),
                const SizedBox(height: 14),
                ...teamSlots.map((slot) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: slot.isYou
                        ? slot.role.color.withOpacity(0.08)
                        : context.cqCard,
                    border: Border.all(
                      color: slot.isYou
                          ? slot.role.color.withOpacity(0.4)
                          : context.cqSurface,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(slot.emoji,
                          style: const TextStyle(fontSize: 26)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(slot.name,
                                    style: TextStyle(
                                      fontFamily: 'Rajdhani',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: slot.isYou
                                          ? slot.role.color
                                          : context.cqTextPrimary,
                                    )),
                                if (slot.isYou) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(4),
                                      color:
                                          slot.role.color.withOpacity(0.2),
                                    ),
                                    child: Text('YOU',
                                        style: TextStyle(
                                          fontFamily: 'Orbitron',
                                          fontSize: 8,
                                          color: slot.role.color,
                                        )),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              '${slot.role.emoji} ${slot.role.label}',
                              style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 12,
                                color: slot.role.color.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${slot.score}/10',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: slot.role.color,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ).animate(delay: 600.ms).fadeIn(),
        ),

        // Actions
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 60),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => setState(() {
                    _phase = LadderPhase.lobby;
                    _myRole = null;
                    _taskProgress.clear();
                    _questTimer?.cancel();
                    _coderScore = 0;
                    _testerScore = 0;
                    _reviewerScore = 0;
                    _resultsReady = false;
                  }),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: AppColors.cyberpunkGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonCyan.withOpacity(0.3),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('PLAY AGAIN',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Back to Arena',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 15,
                        color: context.cqTextSecondary,
                      )),
                ),
              ],
            ),
          ).animate(delay: 700.ms).fadeIn(),
        ),
      ],
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _TeamDot extends StatelessWidget {
  final TeamRole role;
  final bool active;
  const _TeamDot({required this.role, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10, height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? role.color : role.color.withOpacity(0.3),
        boxShadow: active
            ? [BoxShadow(color: role.color, blurRadius: 6)]
            : [],
      ),
    );
  }
}

class _OpenTeamCard extends StatelessWidget {
  final _OpenTeam team;
  final Function(TeamRole) onJoin;
  const _OpenTeamCard({required this.team, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: context.cqCard,
        border: Border.all(color: context.cqSurface),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(team.name,
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: context.cqTextPrimary,
                        )),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: team.diffColor.withOpacity(0.12),
                        border: Border.all(
                            color: team.diffColor.withOpacity(0.3)),
                      ),
                      child: Text(team.difficulty,
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 8,
                            color: team.diffColor,
                            letterSpacing: 1,
                          )),
                    ),
                    const Spacer(),
                    Text('🎁 +${team.xpPrize} XP',
                        style: const TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 13,
                          color: AppColors.neonYellow,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                const SizedBox(height: 6),
                Text(team.quest,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 14,
                      color: context.cqTextSecondary,
                    )),
                const SizedBox(height: 12),

                // Role slots
                Row(
                  children: TeamRole.values.map((r) {
                    final filled = team.filledRoles.contains(r);
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            right: r != TeamRole.reviewer ? 8 : 0),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: filled
                              ? r.color.withOpacity(0.12)
                              : context.cqCardSecondary,
                          border: Border.all(
                            color: filled
                                ? r.color.withOpacity(0.4)
                                : context.cqSurface,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(r.emoji,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: filled
                                      ? null
                                      : Colors.white.withOpacity(0.3),
                                )),
                            const SizedBox(height: 3),
                            Text(
                              filled ? 'TAKEN' : 'OPEN',
                              style: TextStyle(
                                fontFamily: 'Orbitron',
                                fontSize: 7,
                                color: filled
                                    ? r.color
                                    : AppColors.neonGreen,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Join buttons for open roles
          if (team.openRoles.isNotEmpty)
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: context.cqSurface)),
              ),
              child: Row(
                children: [
                  Text('JOIN AS:',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 9,
                        color: context.cqTextMuted,
                        letterSpacing: 1,
                      )),
                  const SizedBox(width: 10),
                  ...team.openRoles.map((r) => GestureDetector(
                        onTap: () => onJoin(r),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [r.color, r.color.withOpacity(0.6)],
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(r.emoji,
                                  style:
                                      const TextStyle(fontSize: 12)),
                              const SizedBox(width: 5),
                              Text(r.label,
                                  style: const TextStyle(
                                    fontFamily: 'Orbitron',
                                    fontSize: 9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TestCaseRow extends StatelessWidget {
  final int index;
  final String input;
  final String expected;
  final ValueChanged<String> onInputChanged;
  final ValueChanged<String> onExpectedChanged;

  const _TestCaseRow({
    required this.index,
    required this.input,
    required this.expected,
    required this.onInputChanged,
    required this.onExpectedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.cqCard,
        border: Border.all(color: context.cqSurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Test #${index + 1}',
              style: TextStyle(
                fontFamily: 'Share Tech Mono',
                fontSize: 10,
                color: context.cqTextMuted,
              )),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onInputChanged,
                  style: const TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 12,
                    color: AppColors.neonGreen,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Input',
                    hintStyle: TextStyle(
                      color: context.cqTextMuted,
                      fontFamily: 'Share Tech Mono',
                      fontSize: 11,
                    ),
                    filled: true,
                    fillColor: context.cqCardSecondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('→',
                    style: TextStyle(
                        color: context.cqTextMuted, fontSize: 16)),
              ),
              Expanded(
                child: TextField(
                  onChanged: onExpectedChanged,
                  style: const TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 12,
                    color: AppColors.neonCyan,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Expected',
                    hintStyle: TextStyle(
                      color: context.cqTextMuted,
                      fontFamily: 'Share Tech Mono',
                      fontSize: 11,
                    ),
                    filled: true,
                    fillColor: context.cqCardSecondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleScoreBar extends StatelessWidget {
  final TeamRole role;
  final double score;
  final double weight;
  const _RoleScoreBar(
      {required this.role, required this.score, required this.weight});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Row(
            children: [
              Text(role.emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(role.label,
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 8,
                    color: role.color,
                    letterSpacing: 0.5,
                  )),
            ],
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 10,
              backgroundColor: role.color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(role.color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(score.toStringAsFixed(1),
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: role.color,
            )),
        const SizedBox(width: 6),
        Text('×${(weight * 100).round()}%',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 11,
              color: context.cqTextMuted,
            )),
      ],
    );
  }
}

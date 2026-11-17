import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';

// ─── Rubric categories ────────────────────────────────────────────────────────

class _RubricCategory {
  final String label, description, emoji;
  final double weight; // 0.0–1.0, must sum to 1.0
  double score; // 0.0–10.0

  _RubricCategory({
    required this.label, required this.description,
    required this.emoji, required this.weight, this.score = 5.0,
  });
}

// ─── Main screen ──────────────────────────────────────────────────────────────

class MentorRefereeScreen extends StatefulWidget {
  const MentorRefereeScreen({super.key});

  @override
  State<MentorRefereeScreen> createState() => _MentorRefereeScreenState();
}

class _MentorRefereeScreenState extends State<MentorRefereeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  int _selectedBattle = 0;
  bool _scoringStarted = false;
  bool _scoreSubmitted = false;
  String _mentorRole = 'observer'; // 'observer' | 'referee'
  final _noteController = TextEditingController();

  final _rubric = [
    _RubricCategory(
      label: 'Problem Understanding', emoji: '🧠',
      description: 'Did the coder correctly grasp the problem before coding?',
      weight: 0.20,
    ),
    _RubricCategory(
      label: 'Code Quality', emoji: '✨',
      description: 'Readable, clean, well-named variables and functions.',
      weight: 0.30,
    ),
    _RubricCategory(
      label: 'Algorithm Efficiency', emoji: '⚡',
      description: 'Optimal time/space complexity for the problem.',
      weight: 0.25,
    ),
    _RubricCategory(
      label: 'Edge Case Handling', emoji: '🛡️',
      description: 'Empty input, null values, boundary conditions covered.',
      weight: 0.15,
    ),
    _RubricCategory(
      label: 'Speed & Focus', emoji: '🏃',
      description: 'Efficient time use without unnecessary distractions.',
      weight: 0.10,
    ),
  ];

  final _liveBattles = [
    {
      'id': 'b1',
      'p1': 'code_master', 'p1xp': '4,200',
      'p2': 'algo_ninja',  'p2xp': '3,800',
      'challenge': 'Reverse a Linked List',
      'lang': 'Python', 'elapsed': '3:12',
      'p1progress': 0.75, 'p2progress': 0.55,
      'viewers': '142', 'mentors': '2',
      'difficulty': 'Medium',
    },
    {
      'id': 'b2',
      'p1': 'dart_hero',  'p1xp': '2,100',
      'p2': 'js_wizard',  'p2xp': '5,600',
      'challenge': 'Two Sum',
      'lang': 'JavaScript', 'elapsed': '1:20',
      'p1progress': 0.40, 'p2progress': 0.85,
      'viewers': '89', 'mentors': '1',
      'difficulty': 'Easy',
    },
    {
      'id': 'b3',
      'p1': 'byte_slayer', 'p1xp': '7,000',
      'p2': 'null_ptr',    'p2xp': '6,200',
      'challenge': 'LRU Cache',
      'lang': 'C++', 'elapsed': '5:44',
      'p1progress': 0.60, 'p2progress': 0.45,
      'viewers': '203', 'mentors': '3',
      'difficulty': 'Hard',
    },
  ];

  double get _weightedScore {
    return _rubric.fold(0.0, (sum, r) => sum + r.score * r.weight);
  }

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tabs.dispose(); _noteController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.neonCyan, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B00), Color(0xFFFF006E)]),
                boxShadow: [BoxShadow(
                    color: const Color(0xFFFF006E).withOpacity(0.4), blurRadius: 10)],
              ),
              child: const Center(child: Text('⚖️', style: TextStyle(fontSize: 16))),
            ),
            const SizedBox(width: 10),
            const Text('MENTOR REFEREE',
                style: TextStyle(fontFamily: 'Orbitron', fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: const Color(0xFFFF6B00),
          labelStyle: const TextStyle(fontFamily: 'Orbitron', fontSize: 9,
              fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'LIVE BATTLES'),
            Tab(text: 'SCORE SHEET'),
            Tab(text: 'LEADERBOARD'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildBattleList(),
          _buildScoreSheet(),
          _buildLeaderboard(),
        ],
      ),
    );
  }

  // ── Tab 1: Live battles to referee ─────────────────────────────────────────

  Widget _buildBattleList() {
    return Column(
      children: [
        // Role selector banner
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B00), Color(0xFFFF006E)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              const Text('⚖️', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MENTOR REFEREE',
                        style: TextStyle(fontFamily: 'Orbitron', fontSize: 13,
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Your scores carry 3× the weight of speed in rankings.',
                        style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12,
                            color: Colors.white70, height: 1.3)),
                  ],
                ),
              ),
              Column(
                children: [
                  const Text('WEIGHT',
                      style: TextStyle(fontFamily: 'Orbitron', fontSize: 8,
                          color: Colors.white60, letterSpacing: 1)),
                  const Text('3×',
                      style: TextStyle(fontFamily: 'Orbitron', fontSize: 28,
                          fontWeight: FontWeight.w900, color: Colors.white)),
                ],
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: -0.1),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            itemCount: _liveBattles.length,
            itemBuilder: (_, i) {
              final b = _liveBattles[i];
              final isSelected = i == _selectedBattle;
              final diffColor = switch (b['difficulty']) {
                'Easy'   => AppColors.neonGreen,
                'Medium' => AppColors.neonOrange,
                _        => AppColors.neonPink,
              };

              return GestureDetector(
                onTap: () {
                  setState(() { _selectedBattle = i; _scoringStarted = false; _scoreSubmitted = false; });
                  _tabs.animateTo(1);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: context.cqCard,
                    border: Border.all(
                      color: isSelected
                          ? Color(0xFFFF6B00).withOpacity(0.6)
                          : context.cqSurface,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            // Players row
                            Row(
                              children: [
                                Expanded(child: _MiniPlayer(
                                    name: b['p1'] as String, xp: b['p1xp'] as String,
                                    color: AppColors.neonCyan,
                                    progress: b['p1progress'] as double)),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    gradient: AppColors.fireGradient,
                                  ),
                                  child: const Text('VS',
                                      style: TextStyle(fontFamily: 'Orbitron', fontSize: 10,
                                          fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Expanded(child: _MiniPlayer(
                                    name: b['p2'] as String, xp: b['p2xp'] as String,
                                    color: AppColors.neonPink,
                                    progress: b['p2progress'] as double)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Meta
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: diffColor.withOpacity(0.15),
                                    border: Border.all(color: diffColor.withOpacity(0.4)),
                                  ),
                                  child: Text(b['difficulty'] as String,
                                      style: TextStyle(fontFamily: 'Orbitron', fontSize: 8,
                                          color: diffColor, letterSpacing: 1)),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text('${b['challenge']} • ${b['lang']} • ⏱ ${b['elapsed']}',
                                      style: TextStyle(fontFamily: 'Rajdhani',
                                          fontSize: 11, color: context.cqTextMuted),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                Row(children: [
                                  const Text('⚖️', style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 3),
                                  Text(b['mentors'] as String,
                                      style: const TextStyle(fontFamily: 'Rajdhani',
                                          fontSize: 11, color: AppColors.neonOrange)),
                                  const SizedBox(width: 8),
                                  const Text('👁️', style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 3),
                                  Text(b['viewers'] as String,
                                      style: TextStyle(fontFamily: 'Rajdhani',
                                          fontSize: 11, color: context.cqTextMuted)),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                          color: isSelected
                              ? Color(0xFFFF6B00).withOpacity(0.15)
                              : context.cqSurface.withOpacity(0.5),
                        ),
                        child: Text(
                          isSelected ? '⚖️ SELECTED — TAP SCORE SHEET TO JUDGE' : 'TAP TO REFEREE THIS BATTLE',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Orbitron', fontSize: 9,
                              color: isSelected
                                  ? Color(0xFFFF6B00)
                                  : context.cqTextMuted,
                              letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: Duration(milliseconds: i * 80)).fadeIn().slideX(begin: 0.05),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Tab 2: Score sheet ──────────────────────────────────────────────────────

  Widget _buildScoreSheet() {
    final b = _liveBattles[_selectedBattle];

    if (_scoreSubmitted) {
      return _buildSubmittedView(b);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Battle being judged
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: context.cqCard,
              border: Border.all(color: const Color(0xFFFF6B00).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Text('⚖️', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Judging: ${b['p1']} vs ${b['p2']}',
                          style: TextStyle(fontFamily: 'Orbitron', fontSize: 12,
                              fontWeight: FontWeight.bold, color: context.cqTextPrimary)),
                      Text('${b['challenge']} • ${b['lang']}',
                          style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12,
                              color: context.cqTextSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.neonGreen.withOpacity(0.15),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.fiber_manual_record, color: AppColors.neonGreen, size: 8),
                      SizedBox(width: 4),
                      Text('LIVE', style: TextStyle(fontFamily: 'Orbitron', fontSize: 9,
                          color: AppColors.neonGreen, letterSpacing: 1)),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),

          const SizedBox(height: 20),

          // Who to score
          Text('SCORING FOR',
              style: TextStyle(fontFamily: 'Orbitron', fontSize: 11,
                  color: context.cqTextMuted, letterSpacing: 2)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _PlayerToggle(
                name: b['p1'] as String, color: AppColors.neonCyan,
                isSelected: _mentorRole == 'p1',
                onTap: () => setState(() => _mentorRole = 'p1'),
              )),
              const SizedBox(width: 10),
              Expanded(child: _PlayerToggle(
                name: b['p2'] as String, color: AppColors.neonPink,
                isSelected: _mentorRole == 'p2',
                onTap: () => setState(() => _mentorRole = 'p2'),
              )),
            ],
          ),

          const SizedBox(height: 24),

          // Rubric sliders
          Text('RUBRIC SCORES',
              style: TextStyle(fontFamily: 'Orbitron', fontSize: 11,
                  color: context.cqTextMuted, letterSpacing: 2)),
          const SizedBox(height: 4),
          Text('Drag each slider to score 0–10',
              style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12,
                  color: context.cqTextMuted)),
          const SizedBox(height: 14),

          ..._rubric.asMap().entries.map((e) {
            final i = e.key;
            final r = e.value;
            return _RubricSlider(
              category: r,
              onChanged: (v) => setState(() => r.score = v),
            ).animate(delay: Duration(milliseconds: i * 60)).fadeIn().slideX(begin: 0.05);
          }),

          const SizedBox(height: 16),

          // Total weighted score
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B00), Color(0xFFFF006E)]),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WEIGHTED SCORE',
                        style: TextStyle(fontFamily: 'Orbitron', fontSize: 10,
                            color: Colors.white70, letterSpacing: 1)),
                    Text('3× impact on rankings',
                        style: TextStyle(fontFamily: 'Rajdhani', fontSize: 11,
                            color: Colors.white60)),
                  ],
                ),
                Text(_weightedScore.toStringAsFixed(1),
                    style: const TextStyle(fontFamily: 'Orbitron', fontSize: 42,
                        fontWeight: FontWeight.w900, color: Colors.white)),
                const Text('/10', style: TextStyle(fontFamily: 'Rajdhani',
                    fontSize: 18, color: Colors.white70)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Mentor notes
          Text('MENTOR NOTES (OPTIONAL)',
              style: TextStyle(fontFamily: 'Orbitron', fontSize: 11,
                  color: context.cqTextMuted, letterSpacing: 2)),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: context.cqCard,
              border: Border.all(color: const Color(0xFFFF6B00).withOpacity(0.3)),
            ),
            child: TextField(
              controller: _noteController,
              maxLines: 4,
              style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14,
                  color: context.cqTextPrimary),
              decoration: InputDecoration(
                hintText: 'e.g. "Great approach on the edge case but the loop could be optimised..."',
                hintStyle: TextStyle(color: context.cqTextMuted,
                    fontFamily: 'Rajdhani', fontSize: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Submit
          if (_mentorRole != 'observer')
            GestureDetector(
              onTap: () => setState(() => _scoreSubmitted = true),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B00), Color(0xFFFF006E)]),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFFF006E).withOpacity(0.4), blurRadius: 20)
                  ],
                ),
                child: const Center(
                  child: Text('SUBMIT SCORE  ⚖️',
                      style: TextStyle(fontFamily: 'Orbitron', fontSize: 14,
                          fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
                ),
              ),
            )
          else
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.cqCard,
                border: Border.all(color: context.cqTextMuted.withOpacity(0.2)),
              ),
              child: Text('Select a player above to start scoring',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13,
                      color: context.cqTextMuted)),
            ),
        ],
      ),
    );
  }

  Widget _buildSubmittedView(Map<String, dynamic> b) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⚖️', style: TextStyle(fontSize: 72))
                .animate().scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            const Text('SCORE SUBMITTED!',
                style: TextStyle(fontFamily: 'Orbitron', fontSize: 22,
                    fontWeight: FontWeight.bold, color: Color(0xFFFF6B00), letterSpacing: 2)),
            const SizedBox(height: 8),
            Text('Your score for ${b[_mentorRole == 'p1' ? 'p1' : 'p2']}: '
                '${_weightedScore.toStringAsFixed(1)}/10',
                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 16,
                    color: context.cqTextSecondary)),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: context.cqCard,
                border: Border.all(color: const Color(0xFFFF6B00).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text('RANKING IMPACT',
                      style: TextStyle(fontFamily: 'Orbitron', fontSize: 11,
                          color: context.cqTextMuted, letterSpacing: 2)),
                  const SizedBox(height: 12),
                  ..._rubric.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Text('${r.emoji} ${r.label}',
                            style: TextStyle(fontFamily: 'Rajdhani',
                                fontSize: 13, color: context.cqTextSecondary)),
                        const Spacer(),
                        Text('${r.score.toStringAsFixed(1)}/10',
                            style: const TextStyle(fontFamily: 'Orbitron',
                                fontSize: 11, color: Color(0xFFFF6B00),
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
                  const Divider(color: Color(0xFF1E2A3F)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Weighted Total',
                          style: TextStyle(fontFamily: 'Orbitron', fontSize: 12,
                              color: context.cqTextPrimary)),
                      Text('${_weightedScore.toStringAsFixed(1)}/10  (3× weight)',
                          style: const TextStyle(fontFamily: 'Orbitron', fontSize: 11,
                              color: Color(0xFFFF6B00), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => setState(() { _scoreSubmitted = false; _mentorRole = 'observer'; }),
              child: const Text('JUDGE ANOTHER BATTLE',
                  style: TextStyle(fontFamily: 'Orbitron', fontSize: 12,
                      color: AppColors.neonCyan, letterSpacing: 1)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab 3: Weighted leaderboard ──────────────────────────────────────────────

  Widget _buildLeaderboard() {
    final players = [
      {'rank': 1, 'name': 'code_master',   'speed': 8.2, 'mentor': 9.4, 'total': 9.1, 'badge': '👑'},
      {'rank': 2, 'name': 'loop_legend',   'speed': 9.1, 'mentor': 8.0, 'total': 8.4, 'badge': '🥈'},
      {'rank': 3, 'name': 'algo_ninja',    'speed': 7.8, 'mentor': 8.8, 'total': 8.4, 'badge': '🥉'},
      {'rank': 4, 'name': 'dart_hero',     'speed': 8.5, 'mentor': 7.2, 'total': 7.7, 'badge': ''},
      {'rank': 5, 'name': 'js_wizard',     'speed': 9.2, 'mentor': 5.8, 'total': 7.0, 'badge': ''},
      {'rank': 6, 'name': 'byte_slayer',   'speed': 7.0, 'mentor': 6.9, 'total': 6.9, 'badge': ''},
    ];

    return Column(
      children: [
        // Formula explanation
        Container(
          margin: const EdgeInsets.all(16),
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: context.cqCard,
            border: Border.all(color: const Color(0xFFFF6B00).withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RANKING FORMULA',
                  style: TextStyle(fontFamily: 'Orbitron', fontSize: 11,
                      color: context.cqTextMuted, letterSpacing: 2)),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 13, height: 1.5),
                  children: [
                    TextSpan(text: 'Total = ',
                        style: TextStyle(color: context.cqTextSecondary)),
                    TextSpan(text: '(Speed × 1)',
                        style: TextStyle(color: AppColors.neonCyan)),
                    TextSpan(text: ' + ',
                        style: TextStyle(color: context.cqTextMuted)),
                    TextSpan(text: '(Mentor Score × 3)',
                        style: TextStyle(color: Color(0xFFFF6B00))),
                    TextSpan(text: '\n÷ 4',
                        style: TextStyle(color: context.cqTextSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text('Mentor-scored quality beats raw speed 3:1',
                  style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12,
                      color: context.cqTextMuted)),
            ],
          ),
        ).animate().fadeIn(),

        // Column headers
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const SizedBox(width: 32),
              const SizedBox(width: 12),
              Expanded(child: Text('PLAYER',
                  style: TextStyle(fontFamily: 'Orbitron', fontSize: 9,
                      color: context.cqTextMuted, letterSpacing: 1))),
              SizedBox(width: 52, child: Text('SPEED',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Orbitron', fontSize: 9,
                      color: AppColors.neonCyan.withOpacity(0.7), letterSpacing: 1))),
              SizedBox(width: 52, child: Text('MENTOR',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Orbitron', fontSize: 9,
                      color: Color(0xFFFF6B00), letterSpacing: 1))),
              SizedBox(width: 52, child: Text('TOTAL',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Orbitron', fontSize: 9,
                      color: AppColors.neonYellow.withOpacity(0.9), letterSpacing: 1))),
            ],
          ),
        ),
        const SizedBox(height: 8),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            itemCount: players.length,
            itemBuilder: (_, i) {
              final p = players[i];
              final isTop = i < 3;
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: isTop ? context.cqCard : context.cqCard.withOpacity(0.7),
                  border: Border.all(
                    color: i == 0
                        ? AppColors.neonYellow.withOpacity(0.4)
                        : context.cqSurface,
                    width: i == 0 ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 32,
                        child: Text(p['badge'] != '' ? p['badge'] as String : '#${p['rank']}',
                            style: TextStyle(
                              fontFamily: p['badge'] != '' ? null : 'Orbitron',
                              fontSize: p['badge'] != '' ? 20 : 12,
                              color: context.cqTextMuted,
                              fontWeight: FontWeight.bold,
                            ))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(p['name'] as String,
                          style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14,
                              fontWeight: FontWeight.bold, color: context.cqTextPrimary)),
                    ),
                    SizedBox(width: 52,
                        child: Text((p['speed'] as double).toStringAsFixed(1),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: 'Orbitron', fontSize: 12,
                                color: AppColors.neonCyan))),
                    SizedBox(width: 52,
                        child: Text((p['mentor'] as double).toStringAsFixed(1),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: 'Orbitron', fontSize: 12,
                                color: Color(0xFFFF6B00),
                                fontWeight: FontWeight.bold))),
                    SizedBox(width: 52,
                        child: Text((p['total'] as double).toStringAsFixed(1),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: 'Orbitron', fontSize: 12,
                                color: AppColors.neonYellow,
                                fontWeight: FontWeight.w900))),
                  ],
                ),
              ).animate(delay: Duration(milliseconds: i * 60)).fadeIn().slideX(begin: 0.05);
            },
          ),
        ),
      ],
    );
  }
}

// ─── Helper widgets ────────────────────────────────────────────────────────────

class _MiniPlayer extends StatelessWidget {
  final String name, xp;
  final Color color;
  final double progress;
  const _MiniPlayer({required this.name, required this.xp,
      required this.color, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name, textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13,
                fontWeight: FontWeight.bold, color: color)),
        Text('$xp XP', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 10,
            color: context.cqTextMuted)),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}

class _PlayerToggle extends StatelessWidget {
  final String name;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  const _PlayerToggle({required this.name, required this.color,
      required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? color.withOpacity(0.15) : context.cqCard,
          border: Border.all(
            color: isSelected ? color : context.cqSurface,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(name, textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? color : context.cqTextMuted)),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text('SCORING', style: TextStyle(fontFamily: 'Orbitron', fontSize: 8,
                  color: color, letterSpacing: 1)),
            ],
          ],
        ),
      ),
    );
  }
}

class _RubricSlider extends StatelessWidget {
  final _RubricCategory category;
  final ValueChanged<double> onChanged;
  const _RubricSlider({required this.category, required this.onChanged});

  Color get _scoreColor {
    if (category.score >= 8) return AppColors.neonGreen;
    if (category.score >= 5) return AppColors.neonOrange;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: context.cqCard,
        border: Border.all(color: context.cqSurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(category.emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.label,
                        style: TextStyle(fontFamily: 'Orbitron', fontSize: 11,
                            fontWeight: FontWeight.bold, color: context.cqTextPrimary)),
                    Text(category.description,
                        style: TextStyle(fontFamily: 'Rajdhani', fontSize: 11,
                            color: context.cqTextMuted), maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(category.score.toStringAsFixed(1),
                      style: TextStyle(fontFamily: 'Orbitron', fontSize: 22,
                          fontWeight: FontWeight.w900, color: _scoreColor)),
                  Text('weight ${(category.weight * 100).round()}%',
                      style: TextStyle(fontFamily: 'Rajdhani', fontSize: 10,
                          color: context.cqTextMuted)),
                ],
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _scoreColor,
              inactiveTrackColor: _scoreColor.withOpacity(0.15),
              thumbColor: _scoreColor,
              overlayColor: _scoreColor.withOpacity(0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: category.score,
              min: 0, max: 10, divisions: 20,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['0', '2', '4', '6', '8', '10'].map((v) =>
                Text(v, style: TextStyle(fontFamily: 'Rajdhani',
                    fontSize: 10, color: context.cqTextMuted))).toList(),
          ),
        ],
      ),
    );
  }
}

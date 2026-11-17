import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';

import '../../../core/theme/app_theme.dart';
import '../../widgets/common/neon_button.dart';

// ══════════════════════════════════════════════════════════════════════════════
// BUG HUNT MODE
//
// PATENT-WORTHY: Existing apps (LeetCode, HackerRank, Codecademy, etc.) only
// ask users to WRITE code. Bug Hunt flips the model — users find and fix
// intentionally-planted bugs in existing code. This trains defensive reading,
// code review skills, and real-world debugging — absent from all competitors.
//
// The system also categorises bugs by type (logic, syntax, off-by-one, null,
// performance) and tracks which types the user struggles with — feeding Code DNA.
// ══════════════════════════════════════════════════════════════════════════════

// ─── Models ───────────────────────────────────────────────────────────────────

enum BugType { logic, syntax, offByOne, nullError, performance, security }

extension BugTypeX on BugType {
  String get label => switch (this) {
        BugType.logic => 'LOGIC',
        BugType.syntax => 'SYNTAX',
        BugType.offByOne => 'OFF-BY-ONE',
        BugType.nullError => 'NULL',
        BugType.performance => 'PERFORMANCE',
        BugType.security => 'SECURITY',
      };

  Color get color => switch (this) {
        BugType.logic => AppColors.neonPink,
        BugType.syntax => AppColors.neonOrange,
        BugType.offByOne => AppColors.neonPurple,
        BugType.nullError => AppColors.error,
        BugType.performance => AppColors.neonYellow,
        BugType.security => AppColors.neonGreen,
      };

  String get emoji => switch (this) {
        BugType.logic => '🧠',
        BugType.syntax => '📝',
        BugType.offByOne => '1️⃣',
        BugType.nullError => '💀',
        BugType.performance => '⚡',
        BugType.security => '🔒',
      };
}

class _Bug {
  final int line; // 1-indexed
  final String description;
  final BugType type;
  final String fix;
  final String explanation;
  bool found;
  bool marked;

  _Bug({
    required this.line,
    required this.description,
    required this.type,
    required this.fix,
    required this.explanation,
    this.found = false,
    this.marked = false,
  });
}

class _BugChallenge {
  final String title;
  final String language;
  final String description;
  final String buggyCode;
  final String fixedCode;
  final List<_Bug> bugs;
  final int xpReward;
  final int coinsReward;
  final String difficulty;
  final Color diffColor;

  const _BugChallenge({
    required this.title,
    required this.language,
    required this.description,
    required this.buggyCode,
    required this.fixedCode,
    required this.bugs,
    required this.xpReward,
    required this.coinsReward,
    required this.difficulty,
    required this.diffColor,
  });
}

// ─── Challenge Data ───────────────────────────────────────────────────────────

List<_BugChallenge> _buildChallenges() => [
      _BugChallenge(
        title: 'Binary Search Gone Wrong',
        language: 'Python',
        description:
            'This binary search has 3 bugs. The function should return the index of `target` in a sorted array, or -1 if not found.',
        buggyCode: '''def binary_search(arr, target):
    left = 0
    right = len(arr)          # Bug 1: should be len(arr) - 1

    while left < right:       # Bug 2: should be left <= right
        mid = (left + right) / 2  # Bug 3: should be // (integer div)
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1

    return -1''',
        fixedCode: '''def binary_search(arr, target):
    left = 0
    right = len(arr) - 1

    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1

    return -1''',
        bugs: [
          _Bug(
            line: 3,
            description: 'right = len(arr) causes index out of range',
            type: BugType.offByOne,
            fix: 'right = len(arr) - 1',
            explanation:
                'Arrays are 0-indexed. The last valid index is len-1. Using len(arr) as the right boundary means you\'ll access arr[len(arr)] which raises IndexError.',
          ),
          _Bug(
            line: 5,
            description: 'while left < right misses the case when left == right',
            type: BugType.logic,
            fix: 'while left <= right',
            explanation:
                'When left == right, there\'s still one element to check. The strict < condition causes the function to exit early and miss the target.',
          ),
          _Bug(
            line: 6,
            description: '/ gives float division, arr[float] raises TypeError',
            type: BugType.syntax,
            fix: 'mid = (left + right) // 2',
            explanation:
                'In Python 3, / always returns a float. Using a float as an array index raises TypeError. Use // for integer floor division.',
          ),
        ],
        xpReward: 120,
        coinsReward: 40,
        difficulty: 'Medium',
        diffColor: AppColors.neonOrange,
      ),
      _BugChallenge(
        title: 'The Sneaky Null',
        language: 'Python',
        description:
            'This function calculates the average of a list. It has 2 bugs — one crashes on empty input, one gives wrong results.',
        buggyCode: '''def calculate_average(numbers):
    total = 0
    for num in numbers:
        total = total + num

    average = total / len(numbers)  # Bug 1: division by zero if empty
    return round(average, 2)

def get_user_score(scores):
    filtered = [s for s in scores if s > 0]
    return calculate_average(filtered)  # Bug 2: filtered could be empty''',
        fixedCode: '''def calculate_average(numbers):
    if not numbers:            # Guard against empty list
        return 0
    total = 0
    for num in numbers:
        total = total + num

    average = total / len(numbers)
    return round(average, 2)

def get_user_score(scores):
    filtered = [s for s in scores if s > 0]
    if not filtered:           # Guard before calling
        return 0
    return calculate_average(filtered)''',
        bugs: [
          _Bug(
            line: 6,
            description: 'ZeroDivisionError when numbers is empty',
            type: BugType.nullError,
            fix: 'Add: if not numbers: return 0',
            explanation:
                'Dividing by len([]) = 0 raises ZeroDivisionError. Always guard against empty collections before division.',
          ),
          _Bug(
            line: 11,
            description: 'filtered can be empty — propagates ZeroDivisionError',
            type: BugType.nullError,
            fix: 'Add: if not filtered: return 0',
            explanation:
                'If all scores are ≤ 0, the filtered list is empty. Calling calculate_average([]) then crashes. Defensive check prevents propagation.',
          ),
        ],
        xpReward: 80,
        coinsReward: 25,
        difficulty: 'Easy',
        diffColor: AppColors.neonGreen,
      ),
    ];

// ─── Screen ───────────────────────────────────────────────────────────────────

class BugHuntScreen extends StatefulWidget {
  const BugHuntScreen({super.key});

  @override
  State<BugHuntScreen> createState() => _BugHuntScreenState();
}

class _BugHuntScreenState extends State<BugHuntScreen>
    with TickerProviderStateMixin {
  late final List<_BugChallenge> _challenges;
  int _challengeIndex = 0;
  bool _showSolution = false;
  bool _completed = false;
  int _hintsUsed = 0;
  late AnimationController _bugPulse;

  // Track which lines the user has marked as buggy
  final Set<int> _markedLines = {};

  @override
  void initState() {
    super.initState();
    _challenges = _buildChallenges();
    _bugPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bugPulse.dispose();
    super.dispose();
  }

  _BugChallenge get _current => _challenges[_challengeIndex];

  int get _bugsFound =>
      _current.bugs.where((b) => _markedLines.contains(b.line)).length;

  bool get _allBugsFound => _bugsFound == _current.bugs.length;

  void _toggleLine(int line) {
    if (_completed) return;
    setState(() {
      if (_markedLines.contains(line)) {
        _markedLines.remove(line);
      } else {
        _markedLines.add(line);
      }
    });
  }

  void _submit() {
    if (!_allBugsFound) {
      // Show hint about count
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'You found $_bugsFound / ${_current.bugs.length} bugs. Keep looking!',
          style: const TextStyle(fontFamily: 'Rajdhani', fontSize: 14),
        ),
        backgroundColor: AppColors.neonOrange,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() => _completed = true);
  }

  void _nextChallenge() {
    setState(() {
      _challengeIndex =
          (_challengeIndex + 1) % _challenges.length;
      _markedLines.clear();
      _showSolution = false;
      _completed = false;
      _hintsUsed = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _completed
                  ? _buildResults()
                  : _buildHuntUI(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: context.cqBgSecondary,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: AppColors.neonPink, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: _bugPulse,
                      builder: (_, __) => Text('🐛',
                          style: TextStyle(
                            fontSize: 16 + _bugPulse.value * 2,
                          )),
                    ),
                    const SizedBox(width: 6),
                    const Text('BUG HUNT',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neonPink,
                          letterSpacing: 2,
                        )),
                  ],
                ),
                Text(
                  _current.title,
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 12,
                    color: context.cqTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Bug counter
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.neonPink.withOpacity(0.12),
              border: Border.all(
                  color: AppColors.neonPink.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Text('🐛',
                    style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '$_bugsFound/${_current.bugs.length}',
                  style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neonPink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHuntUI() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Challenge info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _current.diffColor.withOpacity(0.15),
                        border: Border.all(
                          color:
                              _current.diffColor.withOpacity(0.4)),
                      ),
                      child: Text(_current.difficulty,
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 8,
                            color: _current.diffColor,
                            letterSpacing: 1,
                          )),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '⭐ ${_current.xpReward} XP  🪙 ${_current.coinsReward}',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 13,
                        color: context.cqTextSecondary,
                      ),
                    ),
                    const Spacer(),
                    // Hint button
                    GestureDetector(
                      onTap: _hintsUsed < _current.bugs.length
                          ? () => _showHint()
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              AppColors.neonYellow.withOpacity(0.1),
                          border: Border.all(
                            color:
                                AppColors.neonYellow.withOpacity(0.3)),
                        ),
                        child: Text(
                          '💡 HINT (${_current.bugs.length - _hintsUsed} left)',
                          style: const TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 8,
                            color: AppColors.neonYellow,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _current.description,
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 14,
                    color: context.cqTextSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.neonPink.withOpacity(0.08),
                    border: Border.all(
                        color:
                            AppColors.neonPink.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Text('👆',
                          style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap any line you think contains a bug to mark it. '
                          'Then tap Submit when ready.',
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 12,
                            color: context.cqTextSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Annotated code view
          _buildCodeView(),

          const SizedBox(height: 16),

          // Submit button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: NeonButton(
              label: 'SUBMIT — FOUND $_bugsFound BUGS',
              onTap: _submit,
              gradient: const LinearGradient(
                colors: [AppColors.neonPink, AppColors.neonPurple],
              ),
              glowColor: AppColors.neonPink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeView() {
    final lines = _current.buggyCode.split('\n');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF0D1117),
        border: Border.all(
            color: AppColors.neonPink.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Editor toolbar
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: AppColors.neonPink.withOpacity(0.15)),
              ),
            ),
            child: Row(
              children: [
                for (final c in [
                  Colors.red,
                  Colors.orange,
                  Colors.green
                ])
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        color: c, shape: BoxShape.circle),
                  ),
                const SizedBox(width: 8),
                Text(
                  'buggy_code.${_current.language.toLowerCase() == "python" ? "py" : "js"}',
                  style: const TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 10,
                    color: AppColors.neonPink,
                  ),
                ),
                const Spacer(),
                Text(
                  '← TAP A LINE',
                  style: TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 8,
                    color: context.cqTextMuted,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          // Line-by-line code
          ...lines.asMap().entries.map((e) {
            final lineNum = e.key + 1;
            final isMarked = _markedLines.contains(lineNum);
            final isBugLine = _current.bugs
                .any((b) => b.line == lineNum);

            return GestureDetector(
              onTap: () => _toggleLine(lineNum),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                color: isMarked
                    ? AppColors.neonPink.withOpacity(0.12)
                    : Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Line number
                    Container(
                      width: 36,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Text(
                        '$lineNum',
                        style: TextStyle(
                          fontFamily: 'Share Tech Mono',
                          fontSize: 11,
                          color: isMarked
                              ? AppColors.neonPink
                              : context.cqTextMuted
                                  .withOpacity(0.4),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    // Bug marker
                    SizedBox(
                      width: 16,
                      child: isMarked
                          ? const Center(
                              child: Text('🐛',
                                  style:
                                      TextStyle(fontSize: 10)))
                          : null,
                    ),
                    // Code
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 4),
                        child: Text(
                          e.value,
                          style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 12,
                            color: isMarked
                                ? AppColors.neonPink
                                : const Color(0xFFE6EDF3),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final xpEarned =
        _current.xpReward - (_hintsUsed * 15).clamp(0, 60);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Victory header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  AppColors.neonPink.withOpacity(0.2),
                  AppColors.neonPurple.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                  color: AppColors.neonPink.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Text('🐛',
                        style: TextStyle(fontSize: 64))
                    .animate()
                    .scale(
                        duration: 500.ms,
                        curve: Curves.elasticOut),
                const SizedBox(height: 12),
                const Text('ALL BUGS SQUASHED!',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonPink,
                      letterSpacing: 2,
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ResultChip(
                        label: '+$xpEarned XP',
                        color: AppColors.neonYellow),
                    const SizedBox(width: 12),
                    _ResultChip(
                        label: '+${_current.coinsReward} 🪙',
                        color: AppColors.neonOrange),
                    if (_hintsUsed == 0) ...[
                      const SizedBox(width: 12),
                      _ResultChip(
                          label: 'NO HINTS 🏆',
                          color: AppColors.neonGreen),
                    ],
                  ],
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.1),

          const SizedBox(height: 24),

          // Bug breakdown
          Align(
            alignment: Alignment.centerLeft,
            child: Text('BUG BREAKDOWN',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 11,
                  color: context.cqTextMuted,
                  letterSpacing: 2,
                )),
          ),
          const SizedBox(height: 12),

          ..._current.bugs.asMap().entries.map((e) {
            final bug = e.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: context.cqCard,
                border: Border.all(
                    color: bug.type.color.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(bug.type.emoji,
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color:
                              bug.type.color.withOpacity(0.12),
                          border: Border.all(
                              color:
                                  bug.type.color.withOpacity(0.3)),
                        ),
                        child: Text(bug.type.label,
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 8,
                              color: bug.type.color,
                              letterSpacing: 1,
                            )),
                      ),
                      const SizedBox(width: 8),
                      Text('Line ${bug.line}',
                          style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 11,
                            color: context.cqTextMuted,
                          )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(bug.description,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: context.cqTextPrimary,
                      )),
                  const SizedBox(height: 6),
                  // Fix
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.neonGreen.withOpacity(0.06),
                    ),
                    child: Text(
                      '✅ Fix: ${bug.fix}',
                      style: const TextStyle(
                        fontFamily: 'Share Tech Mono',
                        fontSize: 11,
                        color: AppColors.neonGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(bug.explanation,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 13,
                        color: context.cqTextSecondary,
                        height: 1.5,
                      )),
                ],
              ),
            ).animate(delay: Duration(milliseconds: e.key * 100))
                .fadeIn()
                .slideX(begin: 0.05);
          }),

          const SizedBox(height: 16),

          NeonButton(
            label: 'NEXT BUG HUNT →',
            onTap: _nextChallenge,
            gradient: const LinearGradient(
              colors: [AppColors.neonPink, AppColors.neonPurple],
            ),
            glowColor: AppColors.neonPink,
          ),
        ],
      ),
    );
  }

  void _showHint() {
    final unfound = _current.bugs
        .where((b) => !_markedLines.contains(b.line))
        .toList();
    if (unfound.isEmpty) return;

    setState(() => _hintsUsed++);
    final bug = unfound.first;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.cqCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColors.neonYellow.withOpacity(0.4)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('💡 HINT',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 13,
                  color: AppColors.neonYellow,
                  letterSpacing: 2,
                )),
            const SizedBox(height: 12),
            Text(
              'Look at line ${bug.line}. There\'s a ${bug.type.label.toLowerCase()} bug here.',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 15,
                color: context.cqTextPrimary,
                height: 1.4,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '(-15 XP per hint used)',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 12,
                color: context.cqTextMuted,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.neonYellow.withOpacity(0.1),
                  border: Border.all(
                      color:
                          AppColors.neonYellow.withOpacity(0.3)),
                ),
                child: const Center(
                  child: Text('GOT IT',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 12,
                        color: AppColors.neonYellow,
                        letterSpacing: 1,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultChip extends StatelessWidget {
  final String label;
  final Color color;
  const _ResultChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          )),
    );
  }
}

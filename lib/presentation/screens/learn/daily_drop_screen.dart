import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/cyber_snackbar.dart';

// ─── Daily challenge pool (seeded by day-of-year) ────────────────────────────

class _Challenge {
  final String title;
  final String language;
  final String langEmoji;
  final String story;
  final String buggyCode;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const _Challenge({
    required this.title,
    required this.language,
    required this.langEmoji,
    required this.story,
    required this.buggyCode,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

const _challenges = [
  _Challenge(
    title: 'Off-By-One Ambush',
    language: 'Python',
    langEmoji: '🐍',
    story: 'Your function should print numbers 1 through 10, but it stops at 9. Find the bug.',
    buggyCode: 'for i in range(1, 10):\n    print(i)',
    options: ['range(1, 10)', 'range(1, 11)', 'range(0, 10)', 'range(0, 11)'],
    correctIndex: 1,
    explanation: 'range(end) is exclusive — range(1, 10) stops at 9. Use range(1, 11) to include 10.',
  ),
  _Challenge(
    title: 'Null Pointer Trap',
    language: 'JavaScript',
    langEmoji: '⚡',
    story: 'This function crashes when user is null. Which fix makes it safe?',
    buggyCode: 'function greet(user) {\n  return "Hi " + user.name;\n}',
    options: [
      'return "Hi " + user?.name',
      'return "Hi " + user?.name ?? "stranger"',
      'if (!user) return "Hi stranger";\nreturn "Hi " + user.name;',
      'return user && "Hi " + user.name',
    ],
    correctIndex: 2,
    explanation: 'Option C is the clearest fix — early return when user is null, then safely access user.name.',
  ),
  _Challenge(
    title: 'Infinite Loop Snare',
    language: 'Python',
    langEmoji: '🐍',
    story: 'This while loop never terminates. What is the bug?',
    buggyCode: 'x = 0\nwhile x < 10:\n    print(x)\n    x = x',
    options: [
      'x should start at 1',
      'x = x should be x += 1',
      'condition should be x <= 10',
      'print should come after increment',
    ],
    correctIndex: 1,
    explanation: 'x = x never changes x. The fix is x += 1 to increment the counter each iteration.',
  ),
  _Challenge(
    title: 'Wrong Return Type',
    language: 'Dart',
    langEmoji: '🎯',
    story: 'This function should return the sum as a double, but always returns an int. Why?',
    buggyCode: 'double addTax(int price) {\n  return price + price * 0.18;\n}',
    options: [
      'price should be a double parameter',
      'The return type should be int',
      'Use (price.toDouble()) + price * 0.18',
      'Nothing is wrong — Dart auto-converts',
    ],
    correctIndex: 0,
    explanation: 'Dart integer arithmetic stays integer. Declaring price as double ensures the multiplication produces a double result.',
  ),
  _Challenge(
    title: 'String Comparison Fail',
    language: 'Java',
    langEmoji: '☕',
    story: 'The condition always evaluates to false even when name equals "Alex". What is wrong?',
    buggyCode: 'String name = "Alex";\nif (name == "Alex") {\n  System.out.println("Found!");\n}',
    options: [
      'Should use name.equals("Alex")',
      'Should use name.compareTo("Alex") == 0',
      'String must be char[] in Java',
      'Both A and B are correct fixes',
    ],
    correctIndex: 3,
    explanation: '== compares references in Java, not content. Both .equals() and .compareTo()==0 correctly compare string values.',
  ),
  _Challenge(
    title: 'Missing Base Case',
    language: 'Python',
    langEmoji: '🐍',
    story: 'This recursive function hits maximum recursion depth. What is missing?',
    buggyCode: 'def factorial(n):\n    return n * factorial(n - 1)',
    options: [
      'A loop instead of recursion',
      'if n == 0: return 1 at the start',
      'if n == 1: return n at the start',
      'Both B and C would work',
    ],
    correctIndex: 3,
    explanation: 'Both n==0 and n==1 base cases stop the recursion. Without one, the function recurses infinitely into negative numbers.',
  ),
  _Challenge(
    title: 'Index Out of Bounds',
    language: 'Dart',
    langEmoji: '🎯',
    story: 'This crashes with RangeError when the list has fewer than 3 items. Fix it.',
    buggyCode: 'List<int> nums = [1, 2];\nprint(nums[2]);',
    options: [
      'Use nums.last instead',
      'Check nums.length > 2 before accessing',
      'Use nums.elementAt(2)',
      'Use nums[nums.length - 1]',
    ],
    correctIndex: 1,
    explanation: 'Always guard list access with a length check. nums.elementAt still throws; nums.last returns the last item (index 1), not index 2.',
  ),
  _Challenge(
    title: 'Async Await Slip',
    language: 'JavaScript',
    langEmoji: '⚡',
    story: 'data is always a Promise object, not the resolved value. What is the fix?',
    buggyCode: 'async function load() {\n  const data = fetch("/api/user");\n  console.log(data);\n}',
    options: [
      'const data = await fetch("/api/user")',
      'const data = fetch("/api/user").then(r=>r)',
      'Remove async keyword',
      'console.log(await data)',
    ],
    correctIndex: 0,
    explanation: 'fetch() returns a Promise. Without await, data holds the Promise itself. await fetch() pauses until the response arrives.',
  ),
  _Challenge(
    title: 'Mutable Default Trap',
    language: 'Python',
    langEmoji: '🐍',
    story: 'Each call adds to the SAME list instead of a fresh one. Why?',
    buggyCode: 'def add_item(item, lst=[]):\n    lst.append(item)\n    return lst',
    options: [
      'Lists are pass-by-reference in Python',
      'Default mutable arguments are shared across calls',
      'append() modifies in place',
      'The function should return a copy',
    ],
    correctIndex: 1,
    explanation: 'Python evaluates default arguments once at definition time. The same [] object is reused every call. Fix: use lst=None and set lst = [] inside.',
  ),
  _Challenge(
    title: 'Integer Division Surprise',
    language: 'C++',
    langEmoji: '⚙️',
    story: 'result is always 0 when a < b. What is the bug?',
    buggyCode: 'int a = 3, b = 4;\ndouble result = a / b;\ncout << result;',
    options: [
      'result should be int not double',
      'a / b performs integer division — use (double)a / b',
      'Use a ÷ b operator instead',
      'Declare a and b as double',
    ],
    correctIndex: 1,
    explanation: 'When both operands are int, C++ performs integer division (3/4 = 0). Cast one to double: (double)a / b gives 0.75.',
  ),
];

// ─── Provider/helpers ─────────────────────────────────────────────────────────

_Challenge _todayChallenge() {
  final day = DateTime.now().difference(DateTime(2025, 1, 1)).inDays;
  return _challenges[day % _challenges.length];
}

String _todayKey() {
  final now = DateTime.now();
  return 'daily_drop_${now.year}_${now.month}_${now.day}';
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class DailyDropScreen extends StatefulWidget {
  const DailyDropScreen({super.key});

  @override
  State<DailyDropScreen> createState() => _DailyDropScreenState();
}

class _DailyDropScreenState extends State<DailyDropScreen>
    with TickerProviderStateMixin {
  final _challenge = _todayChallenge();
  late final Box _box;
  bool _boxReady = false;

  int? _selectedIndex;
  bool _answered = false;
  bool _correct = false;
  bool _alreadyDone = false;
  int? _previousAnswer;

  late AnimationController _shakeCtrl;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadState();
  }

  Future<void> _loadState() async {
    _box = await Hive.openBox('daily_drop');
    final saved = _box.get(_todayKey());
    if (saved != null) {
      setState(() {
        _alreadyDone = true;
        _answered = true;
        _selectedIndex = saved['answer'] as int;
        _correct = saved['correct'] as bool;
        _previousAnswer = saved['answer'] as int;
      });
    }
    setState(() => _boxReady = true);
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedIndex == null || _answered) return;

    final isCorrect = _selectedIndex == _challenge.correctIndex;
    await _box.put(_todayKey(), {
      'answer': _selectedIndex,
      'correct': isCorrect,
    });

    if (!isCorrect) _shakeCtrl.forward(from: 0);

    setState(() {
      _answered = true;
      _correct = isCorrect;
    });

    if (isCorrect) {
      CyberSnackbar.showSuccess(context, '🎯 Correct! +75 XP earned');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_boxReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.neonCyan)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('DAILY CODE DROP'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.neonGreen.withOpacity(0.12),
              border: Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  'DAILY',
                  style: const TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 10,
                    color: AppColors.neonGreen,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            _buildHeader(),
            const SizedBox(height: 20),

            // Story
            _buildStory(),
            const SizedBox(height: 20),

            // Buggy code
            _buildCodeBlock(),
            SizedBox(height: 20),

            // Question
            Text(
              'WHAT IS THE FIX?',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 12,
                color: context.cqTextMuted,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),

            // Options
            AnimatedBuilder(
              animation: _shakeCtrl,
              builder: (_, child) {
                final shake = _shakeCtrl.value < 0.5
                    ? _shakeCtrl.value * 10
                    : (1 - _shakeCtrl.value) * 10;
                return Transform.translate(
                  offset: Offset(shake * ((_shakeCtrl.value * 4).floor().isEven ? 1 : -1), 0),
                  child: child,
                );
              },
              child: Column(
                children: List.generate(_challenge.options.length, (i) {
                  return _OptionTile(
                    label: _challenge.options[i],
                    index: i,
                    selected: _selectedIndex == i,
                    answered: _answered,
                    correct: _answered && i == _challenge.correctIndex,
                    wrong: _answered && _selectedIndex == i && i != _challenge.correctIndex,
                    onTap: _answered ? null : () => setState(() => _selectedIndex = i),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Submit / result
            if (!_answered)
              GestureDetector(
                onTap: _selectedIndex == null ? null : _submit,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: _selectedIndex == null ? null : AppColors.cyberpunkGradient,
                    color: _selectedIndex == null ? context.cqCard : null,
                  ),
                  child: Center(
                    child: Text(
                      'SUBMIT ANSWER',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _selectedIndex == null ? context.cqTextMuted : Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),

            if (_answered) _buildResult(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0A2E), Color(0xFF0A1628)],
        ),
        border: Border.all(color: AppColors.neonPurple.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.neonPurple.withOpacity(0.15),
              border: Border.all(color: AppColors.neonPurple.withOpacity(0.4)),
            ),
            child: const Center(child: Text('🐛', style: TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _challenge.title,
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.cqTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(_challenge.langEmoji),
                    const SizedBox(width: 6),
                    Text(
                      _challenge.language,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 13,
                        color: context.cqTextMuted,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppColors.neonGreen.withOpacity(0.12),
                      ),
                      child: const Text(
                        '+75 XP',
                        style: TextStyle(
                          fontFamily: 'Share Tech Mono',
                          fontSize: 10,
                          color: AppColors.neonGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_alreadyDone)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (_correct ? AppColors.neonGreen : AppColors.error).withOpacity(0.15),
              ),
              child: Icon(
                _correct ? Icons.check : Icons.close,
                color: _correct ? AppColors.neonGreen : AppColors.error,
                size: 20,
              ),
            ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildStory() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.cqCard,
        border: Border.all(color: context.cqSurface),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.neonCyan, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _challenge.story,
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 15,
                color: context.cqTextSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: 100.ms).fadeIn();
  }

  Widget _buildCodeBlock() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF0D1117),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 12, height: 12, margin: const EdgeInsets.only(right: 6),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF5F57))),
              Container(width: 12, height: 12, margin: const EdgeInsets.only(right: 6),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFBD2E))),
              Container(width: 12, height: 12,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF28CA41))),
              const Spacer(),
              Text(
                _challenge.language,
                style: const TextStyle(
                  fontFamily: 'Share Tech Mono',
                  fontSize: 11,
                  color: Color(0xFF8B949E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _challenge.buggyCode,
            style: const TextStyle(
              fontFamily: 'Courier New',
              fontSize: 14,
              color: Color(0xFFE6EDF3),
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate(delay: 150.ms).fadeIn();
  }

  Widget _buildResult() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: (_correct ? AppColors.neonGreen : AppColors.error).withOpacity(0.08),
            border: Border.all(
              color: (_correct ? AppColors.neonGreen : AppColors.error).withOpacity(0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _correct ? '✅ Correct!' : '❌ Not quite',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _correct ? AppColors.neonGreen : AppColors.error,
                    ),
                  ),
                  if (_correct) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.neonGreen.withOpacity(0.15),
                      ),
                      child: const Text('+75 XP', style: TextStyle(
                        fontFamily: 'Share Tech Mono', fontSize: 12, color: AppColors.neonGreen,
                      )),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '💡 Explanation',
                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13,
                    fontWeight: FontWeight.bold, color: context.cqTextMuted),
              ),
              const SizedBox(height: 4),
              Text(
                _challenge.explanation,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 14,
                  color: context.cqTextSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, color: context.cqTextMuted, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'New challenge drops at midnight',
                    style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12, color: context.cqTextMuted),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
      ],
    );
  }
}

// ─── Option tile ──────────────────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  final String label;
  final int index;
  final bool selected;
  final bool answered;
  final bool correct;
  final bool wrong;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.label,
    required this.index,
    required this.selected,
    required this.answered,
    required this.correct,
    required this.wrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = context.cqSurface;
    Color bgColor = context.cqCard;
    Color textColor = context.cqTextPrimary;

    if (correct) {
      borderColor = AppColors.neonGreen;
      bgColor = AppColors.neonGreen.withOpacity(0.1);
      textColor = AppColors.neonGreen;
    } else if (wrong) {
      borderColor = AppColors.error;
      bgColor = AppColors.error.withOpacity(0.1);
      textColor = AppColors.error;
    } else if (selected) {
      borderColor = AppColors.neonCyan;
      bgColor = AppColors.neonCyan.withOpacity(0.08);
    }

    final letters = ['A', 'B', 'C', 'D'];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: bgColor,
          border: Border.all(color: borderColor, width: selected || correct || wrong ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: borderColor.withOpacity(0.15),
                border: Border.all(color: borderColor.withOpacity(0.5)),
              ),
              child: Center(
                child: Text(
                  letters[index],
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Share Tech Mono',
                  fontSize: 12,
                  color: textColor,
                  height: 1.4,
                ),
              ),
            ),
            if (correct)
              const Icon(Icons.check_circle, color: AppColors.neonGreen, size: 20),
            if (wrong)
              const Icon(Icons.cancel, color: AppColors.error, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Home Card (used inline on HomeScreen) ────────────────────────────────────

class DailyDropHomeCard extends StatefulWidget {
  final VoidCallback onTap;
  const DailyDropHomeCard({super.key, required this.onTap});

  @override
  State<DailyDropHomeCard> createState() => _DailyDropHomeCardState();
}

class _DailyDropHomeCardState extends State<DailyDropHomeCard> {
  bool _done = false;
  bool _correct = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox('daily_drop');
    final saved = box.get(_todayKey());
    if (saved != null && mounted) {
      setState(() {
        _done = true;
        _correct = saved['correct'] as bool;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final challenge = _todayChallenge();
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: _done
                ? [const Color(0xFF0D2B1A), const Color(0xFF0A1628)]
                : [const Color(0xFF1A0A2E), const Color(0xFF0A1628)],
          ),
          border: Border.all(
            color: _done
                ? AppColors.neonGreen.withOpacity(0.4)
                : AppColors.neonPurple.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (_done ? AppColors.neonGreen : AppColors.neonPurple)
                        .withOpacity(0.12),
                  ),
                  child: Center(
                    child: Text(
                      _done ? (_correct ? '✅' : '❌') : '🐛',
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                if (!_done)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.neonGreen,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'DAILY CODE DROP',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neonPurple,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.neonGreen.withOpacity(0.12),
                        ),
                        child: const Text(
                          '+75 XP',
                          style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 9,
                            color: AppColors.neonGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _done
                        ? (_correct ? 'Solved today! Come back tomorrow.' : 'Better luck tomorrow!')
                        : challenge.title,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.cqTextPrimary,
                    ),
                  ),
                  if (!_done)
                    Text(
                      '${challenge.langEmoji} ${challenge.language} · Fix the bug',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 12,
                        color: context.cqTextMuted,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              _done ? Icons.check_circle : Icons.arrow_forward_ios,
              color: _done ? AppColors.neonGreen : context.cqTextMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

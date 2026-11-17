import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/cyber_snackbar.dart';

// ─── Snippets ─────────────────────────────────────────────────────────────────

class _Snippet {
  final String language;
  final String emoji;
  final String code;
  final String description;

  const _Snippet({
    required this.language,
    required this.emoji,
    required this.code,
    required this.description,
  });
}

const _snippets = [
  _Snippet(
    language: 'Python',
    emoji: '🐍',
    description: 'Fibonacci sequence',
    code: 'def fib(n):\n    a, b = 0, 1\n    for _ in range(n):\n        a, b = b, a + b\n    return a',
  ),
  _Snippet(
    language: 'JavaScript',
    emoji: '⚡',
    description: 'Array filter & map',
    code: 'const evens = arr\n  .filter(n => n % 2 === 0)\n  .map(n => n * 2);',
  ),
  _Snippet(
    language: 'Dart',
    emoji: '🎯',
    description: 'Async data fetch',
    code: 'Future<List<User>> getUsers() async {\n  final res = await http.get(uri);\n  return parseUsers(res.body);\n}',
  ),
  _Snippet(
    language: 'Python',
    emoji: '🐍',
    description: 'List comprehension',
    code: 'squares = [x**2 for x in range(10)\n           if x % 2 == 0]',
  ),
  _Snippet(
    language: 'JavaScript',
    emoji: '⚡',
    description: 'Promise chain',
    code: 'fetch(\'/api/data\')\n  .then(r => r.json())\n  .then(data => render(data))\n  .catch(err => console.error(err));',
  ),
  _Snippet(
    language: 'Dart',
    emoji: '🎯',
    description: 'Stream builder',
    code: 'StreamBuilder<int>(\n  stream: counterStream,\n  builder: (ctx, snap) {\n    return Text(\'\${snap.data}\');\n  },\n)',
  ),
  _Snippet(
    language: 'Java',
    emoji: '☕',
    description: 'Lambda sort',
    code: 'list.sort((a, b) ->\n    a.getName().compareTo(b.getName()));',
  ),
  _Snippet(
    language: 'C++',
    emoji: '⚙️',
    description: 'Smart pointer',
    code: 'auto ptr = std::make_unique<Node>(42);\nptr->next = std::make_shared<Node>(7);',
  ),
];

// ─── Rank thresholds ──────────────────────────────────────────────────────────

String _wpmRank(int wpm) {
  if (wpm >= 100) return '⌨️ Keyboard Legend';
  if (wpm >= 80) return '🏆 Elite Coder';
  if (wpm >= 60) return '🚀 Speed Demon';
  if (wpm >= 45) return '⚡ Fast Fingers';
  if (wpm >= 30) return '💻 Code Typist';
  if (wpm >= 15) return '🌱 Apprentice';
  return '🐢 Getting There';
}

Color _wpmColor(int wpm, BuildContext context) {
  if (wpm >= 100) return AppColors.neonGold;
  if (wpm >= 80) return AppColors.neonYellow;
  if (wpm >= 60) return AppColors.neonOrange;
  if (wpm >= 45) return AppColors.neonGreen;
  if (wpm >= 30) return AppColors.neonCyan;
  if (wpm >= 15) return AppColors.neonBlue;
  return context.cqTextMuted;
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class TypingRaceScreen extends StatefulWidget {
  const TypingRaceScreen({super.key});

  @override
  State<TypingRaceScreen> createState() => _TypingRaceScreenState();
}

class _TypingRaceScreenState extends State<TypingRaceScreen> {
  late _Snippet _snippet;
  late List<String> _targetChars;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();
  final ScrollController _scrollCtrl = ScrollController();

  int _currentIndex = 0;
  int _errors = 0;
  bool _started = false;
  bool _finished = false;
  DateTime? _startTime;
  Timer? _timer;
  int _elapsedSeconds = 0;

  int get _wpm {
    if (_elapsedSeconds == 0) return 0;
    final words = _targetChars.length / 5;
    return ((words / _elapsedSeconds) * 60).round();
  }

  double get _accuracy {
    final total = _currentIndex + _errors;
    if (total == 0) return 100;
    return ((_currentIndex / total) * 100).clamp(0, 100);
  }

  @override
  void initState() {
    super.initState();
    _loadSnippet();
  }

  void _loadSnippet() {
    _snippet = (_snippets.toList()..shuffle()).first;
    _targetChars = _snippet.code.split('');
    _currentIndex = 0;
    _errors = 0;
    _started = false;
    _finished = false;
    _startTime = null;
    _elapsedSeconds = 0;
    _timer?.cancel();
    _controller.clear();
    setState(() {});
  }

  void _onTextChanged(String value) {
    if (_finished) return;
    if (value.isEmpty) return;

    // Use last character typed
    final typed = value.characters.last;
    final expected = _targetChars[_currentIndex];

    if (!_started) {
      _started = true;
      _startTime = DateTime.now();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _elapsedSeconds++);
      });
    }

    // Clear controller to reset (we track manually)
    _controller.clear();

    if (typed == expected) {
      setState(() => _currentIndex++);
    } else {
      setState(() {
        _errors++;
        HapticFeedback.lightImpact();
      });
    }

    if (_currentIndex >= _targetChars.length) {
      _timer?.cancel();
      setState(() => _finished = true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focus.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('TYPING RACE'),
        actions: [
          if (_started && !_finished)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_elapsedSeconds}s',
                  style: const TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 16,
                    color: AppColors.neonCyan,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _finished ? _buildResults() : _buildRace(),
    );
  }

  Widget _buildRace() {
    return GestureDetector(
      onTap: () => _focus.requestFocus(),
      child: SingleChildScrollView(
        controller: _scrollCtrl,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info header
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.cqCard,
                border: Border.all(color: context.cqSurface),
              ),
              child: Row(
                children: [
                  Text(_snippet.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _snippet.description,
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: context.cqTextPrimary,
                          ),
                        ),
                        Text(
                          _snippet.language,
                          style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 12,
                            color: context.cqTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_started)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$_wpm WPM',
                          style: const TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neonCyan,
                          ),
                        ),
                        Text(
                          '${_accuracy.toStringAsFixed(0)}% acc',
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 12,
                            color: context.cqTextMuted,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ).animate().fadeIn(),

            SizedBox(height: 16),

            // Progress bar
            LinearProgressIndicator(
              value: _targetChars.isEmpty ? 0 : _currentIndex / _targetChars.length,
              backgroundColor: context.cqSurface,
              valueColor: const AlwaysStoppedAnimation(AppColors.neonCyan),
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),

            const SizedBox(height: 20),

            if (!_started)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.neonCyan.withOpacity(0.08),
                  border: Border.all(color: AppColors.neonCyan.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.keyboard, color: AppColors.neonCyan, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Tap here and start typing to begin',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 14,
                        color: AppColors.neonCyan,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(),

            const SizedBox(height: 16),

            // Code display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFF0D1117),
                border: Border.all(color: const Color(0xFF30363D)),
              ),
              child: RichText(
                text: TextSpan(
                  children: List.generate(_targetChars.length, (i) {
                    final char = _targetChars[i];
                    Color color;
                    Color? bg;

                    if (i < _currentIndex) {
                      color = AppColors.neonGreen;
                      bg = null;
                    } else if (i == _currentIndex) {
                      color = Colors.white;
                      bg = AppColors.neonCyan.withOpacity(0.3);
                    } else {
                      color = const Color(0xFF8B949E);
                      bg = null;
                    }

                    return TextSpan(
                      text: char,
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 15,
                        color: color,
                        backgroundColor: bg,
                        height: 1.7,
                        letterSpacing: 0.5,
                      ),
                    );
                  }),
                ),
              ),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: 16),

            // Error counter
            if (_errors > 0)
              Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '$_errors error${_errors == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 14,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),

            // Hidden text field
            SizedBox(
              height: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                onChanged: _onTextChanged,
                enableSuggestions: false,
                autocorrect: false,
                style: const TextStyle(fontSize: 1, color: Colors.transparent),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),

            const SizedBox(height: 30),

            // New snippet button
            GestureDetector(
              onTap: _loadSnippet,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.cqSurface),
                  color: context.cqCard,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, color: context.cqTextMuted, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'SHUFFLE SNIPPET',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 11,
                        color: context.cqTextMuted,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final rank = _wpmRank(_wpm);
    final rankColor = _wpmColor(_wpm, context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Trophy
          Text(
            _wpm >= 60 ? '🏆' : _wpm >= 30 ? '⭐' : '🎯',
            style: const TextStyle(fontSize: 64),
          ).animate().scale(duration: 700.ms, curve: Curves.elasticOut),

          const SizedBox(height: 16),

          Text(
            'RACE COMPLETE!',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.cqTextPrimary,
              letterSpacing: 2,
            ),
          ).animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 24),

          // WPM big number
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: context.cqCard,
              border: Border.all(color: rankColor.withOpacity(0.4), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: rankColor.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '$_wpm',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 64,
                    fontWeight: FontWeight.w800,
                    color: rankColor,
                  ),
                ),
                Text(
                  'WORDS PER MINUTE',
                  style: TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 12,
                    color: context.cqTextMuted,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: rankColor.withOpacity(0.12),
                    border: Border.all(color: rankColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    rank,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: rankColor,
                    ),
                  ),
                ),
              ],
            ),
          ).animate(delay: 300.ms).fadeIn().scale(begin: const Offset(0.8, 0.8)),

          const SizedBox(height: 20),

          // Stats grid
          Row(
            children: [
              Expanded(child: _ResultStat(
                label: 'Accuracy',
                value: '${_accuracy.toStringAsFixed(1)}%',
                icon: Icons.check_circle_outline,
                color: _accuracy >= 95 ? AppColors.neonGreen : AppColors.neonYellow,
              )),
              const SizedBox(width: 12),
              Expanded(child: _ResultStat(
                label: 'Time',
                value: '${_elapsedSeconds}s',
                icon: Icons.timer_outlined,
                color: AppColors.neonCyan,
              )),
              const SizedBox(width: 12),
              Expanded(child: _ResultStat(
                label: 'Errors',
                value: '$_errors',
                icon: Icons.close,
                color: _errors == 0 ? AppColors.neonGreen : AppColors.error,
              )),
            ],
          ).animate(delay: 400.ms).fadeIn(),

          const SizedBox(height: 16),

          // WPM scale
          _WpmScale(wpm: _wpm),

          const SizedBox(height: 28),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _loadSnippet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: AppColors.cyberpunkGradient,
                    ),
                    child: const Center(
                      child: Text(
                        'TRY AGAIN',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: context.cqCard,
                    border: Border.all(color: context.cqSurface),
                  ),
                  child: Icon(Icons.home_outlined,
                      color: context.cqTextMuted, size: 22),
                ),
              ),
            ],
          ).animate(delay: 500.ms).fadeIn(),
        ],
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ResultStat(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: context.cqCard,
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 11,
              color: context.cqTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _WpmScale extends StatelessWidget {
  final int wpm;
  const _WpmScale({required this.wpm});

  @override
  Widget build(BuildContext context) {
    const milestones = [
      (0, '🐢', 'Beginner'),
      (15, '🌱', 'Apprentice'),
      (30, '💻', 'Typist'),
      (45, '⚡', 'Fast'),
      (60, '🚀', 'Speed'),
      (80, '🏆', 'Elite'),
      (100, '⌨️', 'Legend'),
    ];

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: context.cqCard,
        border: Border.all(color: context.cqSurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TYPING RANKS',
            style: TextStyle(
              fontFamily: 'Share Tech Mono',
              fontSize: 11,
              color: context.cqTextMuted,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: milestones.asMap().entries.map((e) {
              final (threshold, emoji, label) = e.value;
              final reached = wpm >= threshold;
              final isCurrent = wpm >= threshold &&
                  (e.key == milestones.length - 1 ||
                      wpm < milestones[e.key + 1].$1);

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: reached
                            ? _wpmColor(threshold, context).withOpacity(0.15)
                            : context.cqBg,
                        border: Border.all(
                          color: isCurrent
                              ? _wpmColor(threshold, context)
                              : reached
                                  ? _wpmColor(threshold, context).withOpacity(0.4)
                                  : context.cqSurface,
                          width: isCurrent ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: TextStyle(
                            fontSize: 14,
                            color: reached ? null : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$threshold+',
                      style: TextStyle(
                        fontFamily: 'Share Tech Mono',
                        fontSize: 8,
                        color: reached ? _wpmColor(threshold, context) : context.cqTextMuted,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
